// lib/widgets/stroke_order_view.dart
// Animated stroke-order playback for a hiragana/katakana/kanji character (or
// a multi-glyph kana combination like 'きゃ'), drawn from the bundled path
// data in lib/data/stroke_order_data.dart. Tap to replay.

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import '../data/stroke_order_data.dart';
import '../theme/app_theme.dart';

bool hasStrokeOrderData(String text) =>
    text.isNotEmpty && text.runes.every((r) => strokeOrderData.containsKey(String.fromCharCode(r)));

/// Total stroke count across every glyph in [text] (0 if any glyph is
/// missing data). Pure lookup — safe to call during build, unlike reading
/// [StrokeOrderView]'s internal state before it has mounted.
int totalStrokeCountFor(String text) {
  if (!hasStrokeOrderData(text)) return 0;
  return text.runes
      .map((r) => strokeOrderData[String.fromCharCode(r)]!.strokes.length)
      .fold(0, (a, b) => a + b);
}

class _GlyphPaths {
  final List<Path> strokes; // one Path per stroke
  final double viewBox;
  const _GlyphPaths({required this.strokes, required this.viewBox});
}

class StrokeOrderView extends StatefulWidget {
  final String character;

  /// Size of a single glyph's cell. Multi-glyph strings (e.g. 'きゃ') are
  /// laid out side by side, so the widget's total width is `cellSize * N`.
  final double cellSize;

  const StrokeOrderView({super.key, required this.character, this.cellSize = 140});

  @override
  State<StrokeOrderView> createState() => _StrokeOrderViewState();
}

class _StrokeOrderViewState extends State<StrokeOrderView>
    with SingleTickerProviderStateMixin {
  static const int _msPerStroke = 500;
  static const int _minTotalMs = 500;

  late final AnimationController _controller;
  List<_GlyphPaths> _glyphs = const [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: _minTotalMs));
    _load(autoplay: true);
  }

  @override
  void didUpdateWidget(covariant StrokeOrderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.character != widget.character) {
      _load(autoplay: true);
    }
  }

  int get totalStrokeCount => _glyphs.fold(0, (sum, g) => sum + g.strokes.length);

  void _load({required bool autoplay}) {
    final glyphs = <_GlyphPaths>[];
    for (final rune in widget.character.runes) {
      final entry = strokeOrderData[String.fromCharCode(rune)];
      if (entry == null) {
        glyphs.clear();
        break; // any missing glyph → no data for the whole string
      }
      final strokes = entry.strokes.map((pieces) {
        final path = Path();
        for (final d in pieces) {
          path.addPath(parseSvgPathData(d), Offset.zero);
        }
        return path;
      }).toList();
      glyphs.add(_GlyphPaths(strokes: strokes, viewBox: entry.viewBox));
    }
    _glyphs = glyphs;

    final strokeCount = totalStrokeCount == 0 ? 1 : totalStrokeCount;
    _controller.duration = Duration(milliseconds: strokeCount * _msPerStroke);
    if (autoplay && _glyphs.isNotEmpty) {
      _controller.forward(from: 0);
    } else {
      _controller.value = 0;
    }
    if (mounted) setState(() {});
  }

  /// Replays the animation from the beginning (also triggered by tapping
  /// the view itself).
  void replay() => _controller.forward(from: 0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glyphCount = widget.character.runes.length;
    final width = widget.cellSize * glyphCount;

    if (_glyphs.isEmpty) {
      // No bundled stroke data — fall back to just showing the glyph(s) so
      // the feature degrades gracefully instead of blocking the dialog.
      return SizedBox(
        width: width,
        height: widget.cellSize,
        child: Center(
          child: Text(
            widget.character,
            style: TextStyle(fontSize: widget.cellSize * 0.5, color: kTextMuted),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: replay,
      child: SizedBox(
        width: width,
        height: widget.cellSize,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => CustomPaint(
            painter: _StrokeOrderPainter(
              glyphs: _glyphs,
              cellSize: widget.cellSize,
              progress: _controller.value,
            ),
          ),
        ),
      ),
    );
  }
}

class _StrokeOrderPainter extends CustomPainter {
  final List<_GlyphPaths> glyphs;
  final double cellSize;
  final double progress; // 0..1 across every stroke of every glyph, in order

  _StrokeOrderPainter({
    required this.glyphs,
    required this.cellSize,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final totalStrokes = glyphs.fold(0, (sum, g) => sum + g.strokes.length);
    if (totalStrokes == 0) return;
    final perStroke = 1 / totalStrokes;

    int strokeIndex = 0;
    for (int g = 0; g < glyphs.length; g++) {
      final glyph = glyphs[g];
      final scale = cellSize / glyph.viewBox;
      final strokeWidth = glyph.viewBox * 0.045;

      canvas.save();
      canvas.translate(g * cellSize, 0);
      canvas.scale(scale, scale);

      // Faint guide showing the full glyph behind the animation.
      final guidePaint = Paint()
        ..color = kTextMuted.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      for (final p in glyph.strokes) {
        canvas.drawPath(p, guidePaint);
      }

      final ink = Paint()
        ..color = kPrimaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      for (int i = 0; i < glyph.strokes.length; i++) {
        final localStart = strokeIndex * perStroke;
        strokeIndex++;
        if (progress <= localStart) continue;
        final localProgress = ((progress - localStart) / perStroke).clamp(0.0, 1.0);
        if (localProgress >= 1.0) {
          canvas.drawPath(glyph.strokes[i], ink);
          continue;
        }
        for (final metric in glyph.strokes[i].computeMetrics()) {
          canvas.drawPath(metric.extractPath(0, metric.length * localProgress), ink);
        }
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_StrokeOrderPainter old) =>
      old.progress != progress || old.glyphs != glyphs || old.cellSize != cellSize;
}

/// Self-contained panel combining [StrokeOrderView] with a stroke-count
/// label and a replay button — the piece to drop into a usage dialog.
class StrokeOrderPanel extends StatefulWidget {
  final String character;
  final double cellSize;

  const StrokeOrderPanel({super.key, required this.character, this.cellSize = 140});

  @override
  State<StrokeOrderPanel> createState() => _StrokeOrderPanelState();
}

class _StrokeOrderPanelState extends State<StrokeOrderPanel> {
  final _viewKey = GlobalKey<_StrokeOrderViewState>();

  @override
  Widget build(BuildContext context) {
    final hasData = hasStrokeOrderData(widget.character);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kBgLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: StrokeOrderView(
            key: _viewKey,
            character: widget.character,
            cellSize: widget.cellSize,
          ),
        ),
        if (hasData) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${totalStrokeCountFor(widget.character)}画',
                style: const TextStyle(fontSize: 12, color: kTextMuted),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => _viewKey.currentState?.replay(),
                icon: const Icon(Icons.replay, size: 16),
                label: const Text('もう一度', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  foregroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ] else
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              '書き順データがありません',
              style: TextStyle(fontSize: 11, color: kTextMuted),
            ),
          ),
      ],
    );
  }
}
