import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../retention/spaced_review.dart';

/// ホーム用「今日の復習」カード。復習がなければ何も表示しない。
class ReviewTodayCard extends ConsumerWidget {
  /// 「はじめる」タップ時。`reviewQueueProvider.notifier.dueIds()` で出題する。
  final VoidCallback onStart;
  final Color color;

  const ReviewTodayCard({
    super.key,
    required this.onStart,
    this.color = const Color(0xFF3B82F6),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(reviewDueCountProvider);
    if (count == 0) return const SizedBox.shrink();
    return Card(
      child: ListTile(
        leading: Icon(Icons.replay_circle_filled, color: color, size: 36),
        title: const Text('今日の復習'),
        subtitle: Text('まちがえた問題 $count問 · 忘れる前にもう一回！'),
        trailing: FilledButton(onPressed: onStart, child: const Text('はじめる')),
      ),
    );
  }
}
