import 'package:flutter/material.dart';

/// 説明画像 (幅いっぱい・最大高さ180)。読み込めない/未登録なら何も表示しない。
class ExplainImage extends StatelessWidget {
  final String? assetPath;
  const ExplainImage({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    final p = assetPath;
    if (p == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 180),
          child: Image.asset(
            p,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
