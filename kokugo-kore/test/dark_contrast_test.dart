import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/theme/app_theme.dart';

double _lum(Color c) {
  double f(double v) => v <= 0.03928 ? v / 12.92 : _pow((v + 0.055) / 1.055);
  return 0.2126 * f(c.r) + 0.7152 * f(c.g) + 0.0722 * f(c.b);
}

double _pow(double v) {
  // v^2.4
  return v <= 0 ? 0 : (v * v) * _sqrtPow(v);
}

double _sqrtPow(double v) {
  // v^0.4 via exp/log
  double r = 1;
  // Newton-free: use repeated approximation with dart:math-free series
  return _exp(0.4 * _ln(v)) * r;
}

double _ln(double x) {
  // ln via atanh series
  final y = (x - 1) / (x + 1);
  double sum = 0, t = y;
  for (var i = 1; i < 60; i += 2) {
    sum += t / i;
    t *= y * y;
  }
  return 2 * sum;
}

double _exp(double x) {
  double sum = 1, term = 1;
  for (var i = 1; i < 40; i++) {
    term *= x / i;
    sum += term;
  }
  return sum;
}

double contrast(Color a, Color b) {
  final la = _lum(a), lb = _lum(b);
  final hi = la > lb ? la : lb, lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  testWidgets('dark theme: strong/muted text readable on scaffold/card bg', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: Builder(builder: (c) {
        ctx = c;
        return const SizedBox();
      }),
    ));
    expect(ctx.isDarkMode, isTrue);
    expect(contrast(ctx.strongText, kBgDark), greaterThanOrEqualTo(4.5));
    expect(contrast(ctx.strongText, kBgDark2), greaterThanOrEqualTo(4.5));
    expect(contrast(ctx.mutedText, kBgDark2), greaterThanOrEqualTo(4.5));
  });

  testWidgets('light theme keeps original colors', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      home: Builder(builder: (c) {
        ctx = c;
        return const SizedBox();
      }),
    ));
    expect(ctx.strongText, kTextDark);
    expect(ctx.mutedText, kTextMuted);
    expect(ctx.trackColor, Colors.grey.shade200);
  });

  test('choice badge idle color readable on white card', () {
    expect(contrast(kChoiceBadgeIdle, Colors.white), greaterThanOrEqualTo(4.5));
  });
}
