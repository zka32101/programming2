import 'dart:math';

import 'package:flutter/material.dart';

/// 購入の前に、保護者(大人)であることを確認する簡単な計算ゲート。
/// 子どもが誤って課金しないための確認で、通れたら true を返す。
Future<bool> requireParentalGate(BuildContext context) async {
  final passed = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _ParentalGateDialog(),
  );
  return passed ?? false;
}

class _ParentalGateDialog extends StatefulWidget {
  const _ParentalGateDialog();

  @override
  State<_ParentalGateDialog> createState() => _ParentalGateDialogState();
}

class _ParentalGateDialogState extends State<_ParentalGateDialog> {
  late final int _a;
  late final int _b;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final rnd = Random();
    _a = 11 + rnd.nextInt(9); // 11〜19
    _b = 11 + rnd.nextInt(9);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('🔒 保護者の方へ確認'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('これは大人の方が行う操作です。\n下の計算の答えを入力してください。'),
          const SizedBox(height: 12),
          Text('$_a + $_b = ?',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('やめる'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context)
              .pop(int.tryParse(_controller.text.trim()) == _a + _b),
          child: const Text('つぎへ'),
        ),
      ],
    );
  }
}
