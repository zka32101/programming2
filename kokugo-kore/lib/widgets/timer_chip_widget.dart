import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/learning_timer_provider.dart';
import '../theme/app_theme.dart';

class TimerChip extends ConsumerWidget {
  final VoidCallback? onTap;

  const TimerChip({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(learningTimerProvider);

    if (!timer.isActive) return const SizedBox.shrink();

    final isAlmost = timer.isAlmostDone;
    final bgColor = isAlmost ? Colors.orange : kPrimaryColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(50),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors.white.withAlpha(isAlmost ? 200 : 100), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isAlmost ? Icons.alarm : Icons.timer,
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 35),
              child: Text(
                timer.displayTime,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight:
                      isAlmost ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// タイマー終了ダイアログ（ホーム画面から呼び出す）
Future<void> showTimerEndDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 8),
          const Text(
            '学習時間終了！',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'お疲れ様でした！\nよく頑張りました。',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('終わる'),
        ),
        Consumer(builder: (_, ref, __) {
          return ElevatedButton(
            onPressed: () {
              ref
                  .read(learningTimerProvider.notifier)
                  .start(5); // もう5分延長
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            child: const Text('もう5分！',
                style: TextStyle(color: Colors.white)),
          );
        }),
      ],
    ),
  );
}
