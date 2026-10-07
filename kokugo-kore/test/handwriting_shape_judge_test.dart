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
  deviceTests();
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

// Regression: sparse touch input measured on a 1080x2400 device (canvas ~ x120..950, y575..1390).
List<List<Offset>> _device(List<List<List<double>>> raw) => [
      for (final s in raw)
        [for (final p in s) Offset((p[0] - 120) / 830 * 280, (p[1] - 575) / 815 * 280)]
    ];

void deviceTests() {
  final iStrokes = _device([
    [[400, 700], [392, 800], [385, 900], [382, 1000], [395, 1100], [430, 1180], [500, 1190], [580, 1150]],
    [[620, 820], [650, 920], [680, 1020], [700, 1100]],
  ]);
  test('device sparse い passes', () {
    final s = _score('い', iStrokes);
    // ignore: avoid_print
    print('device い=$s');
    expect(s, greaterThanOrEqualTo(80));
  });
  test('sparse (6 points/stroke) correct glyphs pass', () {
    for (final ch in ['あ', 'い', 'ア', '山']) {
      final ref = _scaled(HandwritingShapeJudge.referenceStrokes(ch)!);
      final sparse = [
        for (final s in ref)
          [for (var i = 0; i < 6; i++) s[(i * (s.length - 1) / 5).round()]]
      ];
      expect(_score(ch, sparse), greaterThanOrEqualTo(80), reason: ch);
    }
  });
  test('device asterisk fails on い', () {
    final a = _device([
      [[300, 700], [700, 1200]],
      [[700, 700], [300, 1200]],
      [[500, 650], [500, 1250]],
    ]);
    expect(_score('い', a), lessThan(40));
  });
}
