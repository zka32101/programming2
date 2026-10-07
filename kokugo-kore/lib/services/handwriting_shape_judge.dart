// lib/services/handwriting_shape_judge.dart
// 手書き採点: 見本の字形（書き順データ or 文字のラスタ化）との形の一致度で採点する。
// 位置と大きさは正規化して無視し、形だけを見る。余計な線・書き漏れ・画数違いは減点。

import 'dart:math';
import 'dart:ui' show Offset;

import 'package:path_drawing/path_drawing.dart';

import '../data/stroke_order_data.dart';

class HandwritingShapeJudge {
  HandwritingShapeJudge._();

  /// 字として小さすぎる入力（キャンバス短辺に対する外接四角の長辺の割合）は 0 点。
  static const double minInkExtentRatio = 0.15;

  /// 見本が全く作れない場合の得点（ゴミ入力で合格しないよう低く固定）。
  static const int noReferenceScore = 30;

  /// この平均距離(正規化後)で 0 点。
  static const double _tolerance = 0.10;

  /// 見本として使える書き順データがあるか。
  static bool hasStrokeData(String text) =>
      text.isNotEmpty &&
      text.runes.every((r) => strokeOrderData.containsKey(String.fromCharCode(r)));

  /// 書き順データから各画の点列を作る。複数文字は左から右へ並べる。データが無ければ null。
  static List<List<Offset>>? referenceStrokes(String text) {
    if (!hasStrokeData(text)) return null;
    final result = <List<Offset>>[];
    var i = 0;
    for (final rune in text.runes) {
      final entry = strokeOrderData[String.fromCharCode(rune)]!;
      for (final pieces in entry.strokes) {
        final pts = <Offset>[];
        for (final d in pieces) {
          for (final m in parseSvgPathData(d).computeMetrics()) {
            final n = max(2, (m.length / 3).ceil());
            for (var k = 0; k <= n; k++) {
              final t = m.getTangentForOffset(m.length * k / n);
              if (t != null) pts.add(t.position + Offset(i * entry.viewBox, 0));
            }
          }
        }
        if (pts.isNotEmpty) result.add(pts);
      }
      i++;
    }
    return result;
  }

  /// 字形の一致度(0-100)。
  /// [referenceStrokes] は各画の点列。ラスタ化した見本は「1点だけの画」の集合として渡し、
  /// [strokeCountKnown] を false にする（画数は見ない）。
  static int score({
    required List<List<Offset>> userStrokes,
    required List<List<Offset>>? referenceStrokes,
    required double canvasW,
    required double canvasH,
    bool strokeCountKnown = true,
  }) {
    final user = [
      for (final s in userStrokes)
        if (s.isNotEmpty) s,
    ];
    if (user.isEmpty) return 0;
    final all = user.expand((s) => s);
    final xs = all.map((p) => p.dx), ys = all.map((p) => p.dy);
    final extent = max(xs.reduce(max) - xs.reduce(min), ys.reduce(max) - ys.reduce(min));
    if (extent < min(canvasW, canvasH) * minInkExtentRatio) return 0;
    if (referenceStrokes == null || referenceStrokes.isEmpty) return noReferenceScore;

    final u = _resample(_normalize(user));
    final r = referenceStrokes.every((s) => s.length == 1)
        ? _normalize(referenceStrokes).expand((s) => s).toList()
        : _resample(_normalize(referenceStrokes));
    if (u.isEmpty || r.isEmpty) return 0;

    // 書き漏れ(r→u)と余計な線(u→r)。悪い方も効かせる。
    final miss = _meanNearest(r, u), extra = _meanNearest(u, r);
    final dist = ((miss + extra) / 2) * 0.5 + max(miss, extra) * 0.5;

    var d = dist;
    var tol = _tolerance;
    if (strokeCountKnown) {
      // 画ごとの照合（弧長で等間隔に取り直して、対応する点どうしを比べる）。
      final nu = _normalize(user), nr = _normalize(referenceStrokes);
      d = 0.5 * _strokeWise(nu, nr) + 0.5 * dist * 2.0;
      tol = _strokeTolerance;
    }
    final shape = strokeCountKnown
        ? 100 / (1 + exp((d - 0.23) / 0.025))
        : (100 * (1 - pow(d / tol, 1.5))).clamp(0.0, 100.0);

    var penalty = 0.0;
    if (strokeCountKnown) {
      final diff = (user.length - referenceStrokes.length).abs();
      penalty = diff * 12.0;
    }
    return (shape - penalty).clamp(0.0, 100.0).round();
  }

  static const double _strokeTolerance = 0.45;

  static List<Offset> _arc(List<Offset> s, int n) {
    if (s.length == 1) return List.filled(n, s.first);
    final cum = <double>[0];
    for (var i = 1; i < s.length; i++) {
      cum.add(cum.last + (s[i] - s[i - 1]).distance);
    }
    final total = max(cum.last, 1e-9);
    final out = <Offset>[];
    var j = 0;
    for (var k = 0; k < n; k++) {
      final t = total * k / (n - 1);
      while (j < s.length - 2 && cum[j + 1] < t) {
        j++;
      }
      final seg = max(cum[j + 1] - cum[j], 1e-9);
      out.add(Offset.lerp(s[j], s[j + 1], ((t - cum[j]) / seg).clamp(0.0, 1.0))!);
    }
    return out;
  }

  /// 各画どうしの平均距離。ユーザーの画ごとに、最も近い見本の画（順序・向き違いは少し減点）と比べ、
  /// 見本の画が使われなかった分も不足として加える。
  static double _strokeWise(List<List<Offset>> user, List<List<Offset>> ref) {
    const n = 24;
    final us = [for (final s in user) _arc(s, n)];
    final rs = [for (final s in ref) _arc(s, n)];
    double dist(List<Offset> a, List<Offset> b) {
      var f = 0.0, r = 0.0;
      for (var i = 0; i < n; i++) {
        f += (a[i] - b[i]).distance;
        r += (a[i] - b[n - 1 - i]).distance;
      }
      return min(f / n, r / n + 0.06);
    }

    var total = 0.0;
    final used = <int>{};
    for (var i = 0; i < us.length; i++) {
      var best = double.infinity, bi = -1;
      for (var j = 0; j < rs.length; j++) {
        var d = dist(us[i], rs[j]);
        if (j != i) d += 0.04; // 順番違いは軽く減点
        if (d < best) {
          best = d;
          bi = j;
        }
      }
      used.add(bi);
      total += best;
    }
    final missing = rs.length - used.length;
    return (total + missing * 0.4) / max(us.length, rs.length);
  }

  static double _meanNearest(List<Offset> from, List<Offset> to) {
    var sum = 0.0;
    for (final a in from) {
      var best = double.infinity;
      for (final b in to) {
        final dx = a.dx - b.dx, dy = a.dy - b.dy;
        final d = dx * dx + dy * dy;
        if (d < best) best = d;
      }
      sum += sqrt(best);
    }
    return sum / from.length;
  }

  static List<List<Offset>> _normalize(List<List<Offset>> strokes) {
    final all = strokes.expand((s) => s);
    var minX = double.infinity, minY = double.infinity;
    var maxX = -double.infinity, maxY = -double.infinity;
    for (final p in all) {
      minX = min(minX, p.dx);
      maxX = max(maxX, p.dx);
      minY = min(minY, p.dy);
      maxY = max(maxY, p.dy);
    }
    // 縦横それぞれを 0..1 に伸縮（外接四角どうしを揃える）。極端に細長い線は
    // 片方の軸だけ伸びすぎないよう、短辺は長辺の 35% を下限にする。
    final w = maxX - minX, h = maxY - minY;
    final longSide = max(max(w, h), 1e-6);
    final sw = max(w, longSide * 0.35), sh = max(h, longSide * 0.35);
    final ox = (sw - w) / 2, oy = (sh - h) / 2;
    return [
      for (final s in strokes)
        [for (final p in s) Offset((p.dx - minX + ox) / sw, (p.dy - minY + oy) / sh)],
    ];
  }

  static List<Offset> _resample(List<List<Offset>> strokes, {double step = 0.02}) {
    final out = <Offset>[];
    for (final s in strokes) {
      if (s.length == 1) out.add(s.first);
      for (var i = 0; i + 1 < s.length; i++) {
        final a = s[i], b = s[i + 1];
        final len = (b - a).distance;
        final n = max(1, (len / step).ceil());
        for (var k = 0; k < n; k++) {
          out.add(Offset.lerp(a, b, k / n)!);
        }
      }
      if (s.length > 1) out.add(s.last);
    }
    return out;
  }
}
