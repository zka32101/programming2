// lib/screens/drawing_canvas_screen.dart
// Full-screen handwriting canvas with strict auto-scoring

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/drawing_settings_provider.dart';

import '../services/handwriting_shape_judge.dart';
import '../services/handwriting_raster_reference.dart';
import '../theme/app_theme.dart';
import '../widgets/stroke_order_view.dart';
import '../features/shop/decor/decor_scope.dart';

class DrawingCanvasScreen extends ConsumerStatefulWidget {
  final String character;   // answer character to write
  final String prompt;      // hint shown to user (romaji / reading)

  const DrawingCanvasScreen({
    super.key,
    required this.character,
    required this.prompt,
  });

  @override
  ConsumerState<DrawingCanvasScreen> createState() => _DrawingCanvasScreenState();
}

class _DrawingCanvasScreenState extends ConsumerState<DrawingCanvasScreen> {
  final List<List<Offset>> _strokes = [];
  List<Offset>? _currentStroke;
  int? _score;
  bool _showAnswer = false;
  // _strokes は同一インスタンスを add/clear で書き換えているため、
  // CustomPainter.shouldRepaint が参照比較（!=）だけでは変化を検知できない
  // （clear() 後、新しいストロークが始まるまで画面が消えずに残るバグの原因だった）。
  // 変更のたびにインクリメントし、それをペインター側の比較に使う。
  int _strokesVersion = 0;

  static const double _canvasW = 280;
  static const double _canvasH = 280;

  bool get _hasStrokes => _strokes.isNotEmpty;
  bool get _scored => _score != null;

  void _clearCanvas() => setState(() {
        _strokes.clear();
        _currentStroke = null;
        _score = null;
        _strokesVersion++;
      });

  void _onPanStart(DragStartDetails d) =>
      setState(() => _currentStroke = [d.localPosition]);

  void _onPanUpdate(DragUpdateDetails d) {
    final p = d.localPosition;
    if (p.dx >= 0 && p.dy >= 0 && p.dx <= _canvasW && p.dy <= _canvasH) {
      setState(() => _currentStroke = [...?_currentStroke, p]);
    }
  }

  void _onPanEnd(DragEndDetails _) {
    if (_currentStroke != null && _currentStroke!.isNotEmpty) {
      setState(() {
        _strokes.add(List.from(_currentStroke!));
        _currentStroke = null;
        _strokesVersion++;
      });
    }
  }

  // 見本の字形との一致度で採点する（書き順データがあれば各画、無ければ文字を描画した
  // ラスタから作った点群）。位置・大きさは正規化し、形だけを比べる。
  List<List<Offset>>? _reference;
  bool _referenceIsRaster = false;

  @override
  void initState() {
    super.initState();
    final vec = HandwritingShapeJudge.referenceStrokes(widget.character);
    if (vec != null) {
      _reference = vec;
    } else {
      _buildRasterReference();
    }
  }

  Future<void> _buildRasterReference() async {
    try {
      final pts = await rasterReferencePoints(widget.character);
      if (!mounted || pts == null) return;
      _reference = [for (final p in pts) [p]];
      _referenceIsRaster = true;
    } catch (_) {
      // 見本なし → 低得点固定
    }
  }

  int _calculateScore() {
    if (_strokes.isEmpty) return 0;
    return HandwritingShapeJudge.score(
      userStrokes: _strokes,
      referenceStrokes: _reference,
      canvasW: _canvasW,
      canvasH: _canvasH,
      strokeCountKnown: !_referenceIsRaster,
    );
  }

  void _submit() {
    final s = _calculateScore();
    final passingScore = ref.read(drawingSettingsProvider).passingScore;
    setState(() => _score = s);
    if (s >= passingScore) {
      Future.delayed(const Duration(milliseconds: 1600), () {
        if (mounted) Navigator.pop(context, s);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final passingScore = ref.watch(drawingSettingsProvider).passingScore;
    final passed = _scored && _score! >= passingScore;
    final failed = _scored && _score! < passingScore;
    final borderColor = passed
        ? kAccentGreen
        : failed
            ? kAccentRed
            : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: DecorScope.pageBg(context, kBgLight),
      appBar: AppBar(
        title: Text(
          'かく: ${widget.prompt}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kAccentRed,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton.icon(
            onPressed: () => setState(() => _showAnswer = !_showAnswer),
            icon: Icon(
              _showAnswer ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
              size: 18,
            ),
            label: Text(
              _showAnswer ? 'かくす' : 'こたえ',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Reference card – shows prompt, answer only if revealed
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.prompt,
                    style: const TextStyle(
                        fontSize: 22, color: kTextMuted, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.arrow_forward, color: kTextMuted, size: 20),
                  const SizedBox(width: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _showAnswer
                        ? (hasStrokeOrderData(widget.character)
                            ? StrokeOrderView(
                                key: const ValueKey('shown'),
                                character: widget.character,
                                cellSize: 60,
                              )
                            : Text(
                                widget.character,
                                key: const ValueKey('shown'),
                                style: const TextStyle(
                                    fontSize: 60, fontWeight: FontWeight.bold, color: kPrimaryColor),
                              ))
                        : Container(
                            key: const ValueKey('hidden'),
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: kBgLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Icon(Icons.help_outline, color: kTextMuted, size: 28),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Canvas
            Center(
              child: Container(
                width: _canvasW,
                height: _canvasH,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: borderColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    onPanStart: _scored ? null : _onPanStart,
                    onPanUpdate: _scored ? null : _onPanUpdate,
                    onPanEnd: _scored ? null : _onPanEnd,
                    child: CustomPaint(
                      size: const Size(_canvasW, _canvasH),
                      painter: _StrokePainter(
                          strokes: _strokes,
                          currentStroke: _currentStroke,
                          version: _strokesVersion),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Buttons or score
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _scored
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ScoreDisplay(score: _score!, passed: passed, passingScore: passingScore),
                        if (failed) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _clearCanvas,
                              icon: const Icon(Icons.refresh),
                              label: const Text('もう一度！'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kAccentRed,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _clearCanvas,
                            icon: const Icon(Icons.delete_outline, size: 18),
                            label: const Text('けす'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: kTextMuted,
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _hasStrokes ? _submit : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kAccentRed,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('できた！',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreDisplay extends StatelessWidget {
  final int score;
  final bool passed;
  final int passingScore;
  const _ScoreDisplay({required this.score, required this.passed, required this.passingScore});

  @override
  Widget build(BuildContext context) {
    final color = passed ? kAccentGreen : kAccentRed;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha:0.4)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(passed ? Icons.check_circle : Icons.cancel, color: color, size: 28),
              const SizedBox(width: 12),
              Text(
                '$score点  ${passed ? "クリア！🎉" : "もう一度！"}',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '合格点：$passingScore点',
            style: TextStyle(fontSize: 12, color: color.withValues(alpha:0.7)),
          ),
        ],
      ),
    );
  }
}

class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset>? currentStroke;
  final int version;

  const _StrokePainter({
    required this.strokes,
    required this.currentStroke,
    required this.version,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.grey.withAlpha(30)
      ..strokeWidth = 1;
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2, size.height), grid);
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), grid);

    final ink = Paint()
      ..color = Colors.black87
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    void drawStroke(List<Offset> pts) {
      if (pts.isEmpty) return;
      if (pts.length == 1) {
        canvas.drawCircle(pts.first, 2, ink);
        return;
      }
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (int i = 1; i < pts.length; i++) {
        path.lineTo(pts[i].dx, pts[i].dy);
      }
      canvas.drawPath(path, ink);
    }

    for (final s in strokes) { drawStroke(s); }
    if (currentStroke != null) drawStroke(currentStroke!);
  }

  @override
  bool shouldRepaint(_StrokePainter old) =>
      old.version != version || old.currentStroke != currentStroke;
}
