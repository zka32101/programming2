import 'package:flutter/material.dart';

/// 保護者確認ゲートサービス
class ParentalGateService {
  /// 4桁PIN入力を通じた保護者確認
  static Future<bool> requireParentalGate(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const _ParentalGateDialog(),
        ) ??
        false;
  }
}

class _ParentalGateDialog extends StatefulWidget {
  const _ParentalGateDialog();

  @override
  State<_ParentalGateDialog> createState() => _ParentalGateDialogState();
}

class _ParentalGateDialogState extends State<_ParentalGateDialog> {
  String _pin = '';
  static const String _correctPin = '1234'; // デフォルト PIN
  bool _isWrong = false;

  void _addDigit(String digit) {
    setState(() {
      if (_pin.length < 4) {
        _pin += digit;
        _isWrong = false;
        if (_pin.length == 4) _checkPin();
      }
    });
  }

  void _checkPin() {
    if (_pin == _correctPin) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _isWrong = true;
        _pin = '';
      });
    }
  }

  void _backspace() {
    setState(() {
      if (_pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('保護者確認'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('4桁のPINを入力してください'),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isWrong ? Colors.red.shade100 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _pin.isEmpty ? '____' : '●' * _pin.length,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: _isWrong ? Colors.red : Colors.black,
              ),
            ),
          ),
          if (_isWrong)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'PINが正しくありません',
                style: TextStyle(color: Colors.red.shade700, fontSize: 12),
              ),
            ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            childAspectRatio: 1.5,
            children: [
              for (int i = 1; i <= 9; i++)
                _DigitButton(
                  digit: i.toString(),
                  onTap: () => _addDigit(i.toString()),
                ),
              _DigitButton(
                digit: '0',
                onTap: () => _addDigit('0'),
              ),
              _DigitButton(
                digit: '←',
                onTap: _backspace,
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('キャンセル'),
        ),
      ],
    );
  }
}

class _DigitButton extends StatelessWidget {
  final String digit;
  final VoidCallback onTap;

  const _DigitButton({required this.digit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(digit, style: const TextStyle(fontSize: 18)),
    );
  }
}
