import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/design_system.dart';

/// 「保護者ゲート」。外部（Google Play）を開く前など、子どもが誤って進むと
/// 困る操作の前に出す軽量な年齢確認（2桁の四則演算）。
///
/// shared_core（zka32101/shared_core）の ParentalGateDialog と同じ仕様。
/// eigo-kore の packages/shared_core は古い同梱コピーで含まれていないため、
/// 自己完結した最小実装をここに置いている。正解した場合のみ true を返す。
Future<bool> requireParentalGate(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const ParentalGateDialog(),
  );
  return result ?? false;
}

class ParentalGateDialog extends StatefulWidget {
  const ParentalGateDialog({super.key});

  @override
  State<ParentalGateDialog> createState() => _ParentalGateDialogState();
}

class _ParentalGateDialogState extends State<ParentalGateDialog> {
  late final int _a;
  late final int _b;
  late final bool _isAddition;
  late final int _correctAnswer;
  final _controller = TextEditingController();
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    _isAddition = random.nextBool();
    final x = 10 + random.nextInt(21);
    final y = 10 + random.nextInt(21);
    if (_isAddition) {
      _a = x;
      _b = y;
      _correctAnswer = x + y;
    } else {
      // 引いた結果が必ず正の数になるよう大きい方を _a にする
      _a = math.max(x, y);
      _b = math.min(x, y);
      _correctAnswer = _a - _b;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final input = int.tryParse(_controller.text.trim());
    if (input == _correctAnswer) {
      Navigator.pop(context, true);
    } else {
      setState(() => _showError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final op = _isAddition ? '+' : '-';
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔒', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 16),
            const Text(
              '保護者の方へ確認',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'これは大人の方が行う操作です。\n下の計算の答えを入力してください。',
              style: TextStyle(
                  fontSize: 14, height: 1.6, color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '$_a $op $_b = ?',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: '答えを入力',
                errorText: _showError ? '答えが違います' : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('やめる'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('つぎへ'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
