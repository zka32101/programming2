// lib/services/handwriting_raster_reference.dart
// 書き順データが無い文字（アルファベット・一部の漢字）の見本を、端末フォントで描画して
// 墨のある画素の点群にする。

import 'dart:ui' as ui;

import 'package:flutter/painting.dart';

Future<List<ui.Offset>?> rasterReferencePoints(String text, {int size = 160}) async {
  if (text.trim().isEmpty) return null;
  final tp = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(fontSize: size * 0.8, color: const Color(0xFF000000), fontWeight: FontWeight.w500),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final rec = ui.PictureRecorder();
  final canvas = ui.Canvas(rec);
  tp.paint(canvas, ui.Offset((size - tp.width) / 2, (size - tp.height) / 2));
  final img = await rec.endRecording().toImage(size, size);
  final data = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
  if (data == null) return null;
  final pts = <ui.Offset>[];
  const step = 3;
  for (var y = 0; y < size; y += step) {
    for (var x = 0; x < size; x += step) {
      if (data.getUint8((y * size + x) * 4 + 3) > 128) pts.add(ui.Offset(x.toDouble(), y.toDouble()));
    }
  }
  return pts.length < 5 ? null : pts;
}
