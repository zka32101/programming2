import 'package:flutter/material.dart';
import '../utils/study_dates.dart';

const _frame = 'assets/reward/calendar_frame.webp';
const _ring = 'assets/reward/stamp_ring_rainbow.webp';
const _coin = 'assets/reward/stamp_coin.webp';

/// 月カレンダー。calendar_frame を背景に、学習日へ虹リング、節目へコインを重ねる。
class StreakCalendar extends StatelessWidget {
  final Set<DateTime> studiedDays;
  final DateTime month;
  const StreakCalendar(
      {super.key, required this.studiedDays, required this.month});

  @override
  Widget build(BuildContext context) {
    final studied =
        studiedDays.map((d) => DateTime(d.year, d.month, d.day)).toSet();
    final milestones = milestoneDays(studied);
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final lead = first.weekday % 7; // 日曜始まり
    final rows = ((lead + daysInMonth) / 7).ceil();
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth.isFinite ? c.maxWidth : 280.0;
      final h = w * 188 / 140;
      final cell = w * 0.74 / 7;
      return SizedBox(
        width: w,
        height: h,
        child: Stack(children: [
          Positioned.fill(
            child: Image.asset(_frame,
                fit: BoxFit.fill,
                errorBuilder: (_, _, _) => const SizedBox.shrink()),
          ),
          Positioned(
            left: w * 0.13,
            right: w * 0.13,
            top: h * 0.15,
            height: h * 0.55,
            child: Column(children: [
              SizedBox(
                height: 22,
                child: FittedBox(
                  child: Text('${month.year}年${month.month}月',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4037))),
                ),
              ),
              SizedBox(
                height: 16,
                child: Row(children: [
                  for (final l in const ['日', '月', '火', '水', '木', '金', '土'])
                    Expanded(
                      child: Center(
                        child: Text(l,
                            style: const TextStyle(
                                fontSize: 10, color: Color(0xFF8D6E63))),
                      ),
                    ),
                ]),
              ),
              for (var r = 0; r < rows; r++)
                Expanded(
                  child: Row(children: [
                    for (var col = 0; col < 7; col++)
                      Expanded(
                          child: _cell(r * 7 + col - lead + 1, daysInMonth,
                              studied, milestones, cell)),
                  ]),
                ),
            ]),
          ),
        ]),
      );
    });
  }

  Widget _cell(int day, int daysInMonth, Set<DateTime> studied,
      Set<DateTime> milestones, double cell) {
    if (day < 1 || day > daysInMonth) return const SizedBox.shrink();
    final d = DateTime(month.year, month.month, day);
    final done = studied.contains(d);
    final ms = milestones.contains(d);
    return Center(
      key: Key('cal_day_$day'),
      child: Stack(alignment: Alignment.center, children: [
        if (done)
          Image.asset(ms ? _coin : _ring,
              key: Key(ms ? 'cal_coin_$day' : 'cal_ring_$day'),
              width: cell * 0.95,
              height: cell * 0.95,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const SizedBox.shrink()),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('$day',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: done ? FontWeight.bold : FontWeight.normal,
                  color: done
                      ? const Color(0xFF4E342E)
                      : const Color(0xFF8D6E63))),
        ),
      ]),
    );
  }
}

/// ホームの連続カードから開く月カレンダーのダイアログ。
Future<void> showStreakCalendar(BuildContext context, int days) async {
  final studied = await loadStudyDays();
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (_) => _StreakCalendarDialog(days: days, studied: studied),
  );
}

class _StreakCalendarDialog extends StatefulWidget {
  final int days;
  final Set<DateTime> studied;
  const _StreakCalendarDialog({required this.days, required this.studied});
  @override
  State<_StreakCalendarDialog> createState() => _StreakCalendarDialogState();
}

class _StreakCalendarDialogState extends State<_StreakCalendarDialog> {
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isCurrent = _month.year == now.year && _month.month == now.month;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('れんぞく ${widget.days}日',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: StreakCalendar(studiedDays: widget.studied, month: _month),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
              tooltip: '前の月',
              icon: const Icon(Icons.chevron_left),
              onPressed: () => setState(
                  () => _month = DateTime(_month.year, _month.month - 1)),
            ),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('とじる')),
            IconButton(
              tooltip: '次の月',
              icon: const Icon(Icons.chevron_right),
              onPressed: isCurrent
                  ? null
                  : () => setState(
                      () => _month = DateTime(_month.year, _month.month + 1)),
            ),
          ]),
        ]),
      ),
    );
  }
}
