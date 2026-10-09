import 'package:flutter/material.dart';

/// 解説用の挿絵。assetPath が null、または読み込めない場合は何も表示しない。
class ExplanationImage extends StatelessWidget {
  final String? assetPath;
  const ExplanationImage({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    final p = assetPath;
    if (p == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 160),
          child: Image.asset(
            p,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
