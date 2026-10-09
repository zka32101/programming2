import 'package:flutter/material.dart';

import '../data/explain_images.dart';

/// 慣用句・ことわざ・四字熟語の解説イラスト。対応画像が無ければ何も表示しない。
class ExplanationImage extends StatelessWidget {
  final String text;
  const ExplanationImage(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final path = explainImageFor(text);
    if (path == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 160),
          child: Image.asset(
            path,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
