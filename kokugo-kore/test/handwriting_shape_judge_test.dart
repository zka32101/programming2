import 'dart:math';
import 'dart:ui' show Offset;

import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/services/handwriting_shape_judge.dart';

const double _w = 280, _h = 280;

List<List<Offset>> _scaled(List<List<Offset>> ref, {double jitter = 0, int seed = 1}) {
  final rnd = Random(seed);
  var minX = 1e9, minY = 1e9, maxX = -1e9, maxY = -1e9;
  for (final p in ref.expand((s) => s)) {
    minX = min(minX, p.dx);
    maxX = max(maxX, p.dx);
    minY = min(minY, p.dy);
    maxY = max(maxY, p.dy);
  }
  final k = 180 / max(maxX - minX, maxY - minY);
  return [
    for (final s in ref)
      [
        for (var i = 0; i < s.length; i += 4)
          Offset(50 + (s[i].dx - minX) * k + (rnd.nextDouble() - .5) * jitter,
              50 + (s[i].dy - minY) * k + (rnd.nextDouble() - .5) * jitter),
      ]
  ];
}

int _score(String ch, List<List<Offset>> user) => HandwritingShapeJudge.score(
    userStrokes: user,
    referenceStrokes: HandwritingShapeJudge.referenceStrokes(ch),
    canvasW: _w,
    canvasH: _h);

void main() {
  test('correct strokes pass (kana/kanji, with jitter)', () {
    for (final ch in ['あ', 'い', 'ア', 'き', '山', '校']) {
      final ref = HandwritingShapeJudge.referenceStrokes(ch)!;
      final clean = _score(ch, _scaled(ref));
      final shaky = _score(ch, _scaled(ref, jitter: 10));
      // ignore: avoid_print
      print('$ch clean=$clean shaky=$shaky');
      expect(clean, greaterThanOrEqualTo(80), reason: ch);
      expect(shaky, greaterThanOrEqualTo(80), reason: '$ch shaky');
    }
  });

  test('garbage fails', () {
    final line = [
      [for (var x = 40.0; x <= 240; x += 5) Offset(x, 140)]
    ];
    final asterisk = [
      [for (var t = 0.0; t <= 1; t += .05) Offset(50 + 180 * t, 50 + 180 * t)],
      [for (var t = 0.0; t <= 1; t += .05) Offset(230 - 180 * t, 50 + 180 * t)],
      [for (var t = 0.0; t <= 1; t += .05) Offset(140, 50 + 180 * t)],
    ];
    final scribble = [
      [for (var t = 0.0; t <= 1; t += .02) Offset(140 + 90 * cos(t * 40), 140 + 90 * sin(t * 37))]
    ];
    final dot = [
      [const Offset(140, 140), const Offset(142, 141)]
    ];
    for (final ch in ['あ', 'ア', '山', '校']) {
      for (final e in {'line': line, 'asterisk': asterisk, 'scribble': scribble, 'dot': dot}.entries) {
        final s = _score(ch, e.value);
        // ignore: avoid_print
        print('$ch ${e.key}=$s');
        expect(s, lessThan(40), reason: '$ch ${e.key}');
      }
      expect(_score(ch, []), 0);
    }
  });

  test('deterministic', () {
    final ref = HandwritingShapeJudge.referenceStrokes('あ')!;
    final u = _scaled(ref, jitter: 8, seed: 3);
    expect(_score('あ', u), _score('あ', u));
  });

  test('no reference: low fixed score', () {
    final u = [
      [for (var x = 40.0; x <= 240; x += 5) Offset(x, 140)]
    ];
    expect(
        HandwritingShapeJudge.score(userStrokes: u, referenceStrokes: null, canvasW: _w, canvasH: _h),
        lessThan(50));
  });

  test('raster-style reference (alphabet)', () {
    final ref = [
      for (var y = 0.0; y <= 1; y += .02) [Offset(0.5, y)]
    ];
    final good = [
      [for (var y = 40.0; y <= 240; y += 5) Offset(140, y)]
    ];
    final bad = [
      [for (var x = 40.0; x <= 240; x += 5) Offset(x, 140)]
    ];
    int sc(List<List<Offset>> u) => HandwritingShapeJudge.score(
        userStrokes: u, referenceStrokes: ref, canvasW: _w, canvasH: _h, strokeCountKnown: false);
    expect(sc(good), greaterThanOrEqualTo(90));
    expect(sc(bad), lessThan(40));
  });
}
