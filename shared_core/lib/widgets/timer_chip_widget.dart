import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/learning_timer_provider.dart';

class TimerChip extends ConsumerWidget {
  final Color primaryColor;
  final VoidCallback? onTap;

  const TimerChip({
    super.key,
    required this.primaryColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(learningTimerProvider);

    if (!timer.isActive) return const SizedBox.shrink();

    final isAlmost = timer.isAlmostDone;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              timer.displayTime,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: isAlmost ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showTimerEndDialog(
    BuildContext context, Color primaryColor) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('🎉', style: TextStyle(fontSize: 52)),
          SizedBox(height: 8),
          Text(
            '学習時間終了！',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
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
              ref.read(learningTimerProvider.notifier).start(5);
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: const Text('もう5分！',
                style: TextStyle(color: Colors.white)),
          );
        }),
      ],
    ),
  );
}
