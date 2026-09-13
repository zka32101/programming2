import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// スクリーンタイム制限ウィジェット
class ScreenTimeLimiterWidget extends ConsumerStatefulWidget {
  final String childId;
  final VoidCallback? onLimitExceeded;

  const ScreenTimeLimiterWidget({
    super.key,
    required this.childId,
    this.onLimitExceeded,
  });

  @override
  ConsumerState<ScreenTimeLimiterWidget> createState() =>
      _ScreenTimeLimiterWidgetState();
}

class _ScreenTimeLimiterWidgetState
    extends ConsumerState<ScreenTimeLimiterWidget> {
  late Duration _dailyLimit;
  late Duration _usedToday;
  late Duration _remainingTime;
  bool _isLimitExceeded = false;

  @override
  void initState() {
    super.initState();
    _dailyLimit = const Duration(hours: 2); // デフォルト: 2時間
    _usedToday = const Duration(minutes: 0);
    _updateRemainingTime();
  }

  void _updateRemainingTime() {
    setState(() {
      _remainingTime = _dailyLimit - _usedToday;
      _isLimitExceeded = _remainingTime.inSeconds <= 0;
      if (_isLimitExceeded && widget.onLimitExceeded != null) {
        widget.onLimitExceeded!();
      }
    });
  }

  void _addUsageTime(Duration duration) {
    setState(() {
      _usedToday += duration;
      _updateRemainingTime();
    });
  }

  void _resetDaily() {
    setState(() {
      _usedToday = const Duration(minutes: 0);
      _isLimitExceeded = false;
      _updateRemainingTime();
    });
  }

  void _setDailyLimit(int hours) {
    setState(() {
      _dailyLimit = Duration(hours: hours);
      _updateRemainingTime();
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final remainingPercentage =
        (_remainingTime.inSeconds / _dailyLimit.inSeconds).clamp(0.0, 1.0);
    final indicatorColor = _isLimitExceeded
        ? Colors.red
        : remainingPercentage > 0.3
            ? Colors.green
            : Colors.orange;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // タイトル
            Text(
              'スクリーンタイム制限',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 残り時間表示
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: indicatorColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: indicatorColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '本日の残り時間',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDuration(_remainingTime),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: indicatorColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  if (_isLimitExceeded)
                    Chip(
                      label: const Text('制限超過'),
                      backgroundColor: Colors.red.shade100,
                      labelStyle: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 進捗バー
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: remainingPercentage,
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '本日使用: ${_formatDuration(_usedToday)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '上限: ${_formatDuration(_dailyLimit)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // クイック追加ボタン
            Text(
              '使用時間を追加',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _QuickAddButton(
                    label: '15分',
                    onPressed: () => _addUsageTime(const Duration(minutes: 15)),
                  ),
                  _QuickAddButton(
                    label: '30分',
                    onPressed: () => _addUsageTime(const Duration(minutes: 30)),
                  ),
                  _QuickAddButton(
                    label: '1時間',
                    onPressed: () => _addUsageTime(const Duration(hours: 1)),
                  ),
                  _QuickAddButton(
                    label: 'リセット',
                    onPressed: _resetDaily,
                    variant: 'secondary',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 上限設定
            ExpansionTile(
              title: Text(
                '日替わり上限を設定',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ...[1, 2, 3, 4, 5]
                          .map((hours) => ChoiceChip(
                                label: Text('${hours}h'),
                                selected: _dailyLimit == Duration(hours: hours),
                                onSelected: (_) => _setDailyLimit(hours),
                              )),
                    ],
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

class _QuickAddButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final String variant; // 'primary' or 'secondary'

  const _QuickAddButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = 'primary',
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == 'primary';
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.blue : Colors.grey.shade200,
          foregroundColor: isPrimary ? Colors.white : Colors.black87,
        ),
        child: Text(label),
      ),
    );
  }
}
