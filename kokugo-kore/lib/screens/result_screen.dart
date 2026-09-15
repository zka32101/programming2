import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quest_model.dart';
import 'package:shared_core/models/badge_model.dart';
import '../providers/adaptive_provider.dart';
import 'package:shared_core/shared_core.dart' show characterStateProvider;
import '../providers/coin_provider.dart';

import '../data/kokugo_characters.dart';
import '../theme/app_theme.dart';
import '../providers/badge_metrics_provider.dart';
import '../providers/study_habit_provider.dart';
import '../providers/badge_time_definitions.dart';
import '../providers/quest_performance_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/badge_provider.dart';
import '../widgets/character_unlock_dialog.dart';
import '../widgets/badge_achievement_notification.dart';

class ResultScreen extends ConsumerStatefulWidget {
  final QuestResult result;
  final Stage stage;

  const ResultScreen({super.key, required this.result, required this.stage});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  late ConfettiController _confetti;
  List<BadgeModel> _newBadges = [];
  bool _saving = true;
  bool _saveStarted = false;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
    _saveResult();
  }

  Future<void> _saveResult() async {
    // 何らかの理由で二重に呼ばれても、進捗/コイン/バッジを二重に記録しない。
    if (_saveStarted) return;
    _saveStarted = true;

    final r = widget.result;
    final s = widget.stage;
    final isKanji = s.quizType == QuizType.primary;

    try {
      await ref.read(progressProvider.notifier).recordResult(
        grade: s.grade,
        stageNumber: s.stageNumber,
        correct: r.correctCount,
        total: r.totalCount,
        isKanji: isKanji,
        isPerfect: r.isPerfect,
      );

      // アダプティブ記録
      await ref.read(adaptiveProvider.notifier).recordAttempt(
        grade: s.grade,
        stageNumber: s.stageNumber,
        correct: r.correctCount,
        total: r.totalCount,
      );

      // Earn coins based on score
      if (r.isPassed) {
        final percentage = r.correctCount / r.totalCount;
        final coins = percentage >= 1.0 ? 30 : percentage >= 0.8 ? 20 : 10;
        await ref.read(coinProvider.notifier).addCoins(coins);
      }

      // Check if any characters unlock based on new progress
      // （checkUnlocks 自体は新規解放キャラを返さないので、前後の状態を比較して検出する）
      final beforeUnlocked = ref.read(characterStateProvider);
      final progress = ref.read(progressProvider);
      await ref
          .read(characterStateProvider.notifier)
          .checkUnlocks(progress.clearedStageIds.length);
      final afterUnlocked = ref.read(characterStateProvider);

      final newlyUnlocked = kKokugoCharacters.where((c) {
        final wasUnlocked = beforeUnlocked[c.id]?.isUnlocked ?? false;
        final isUnlocked = afterUnlocked[c.id]?.isUnlocked ?? false;
        return isUnlocked && !wasUnlocked;
      }).toList();

      final unlockedCount =
          kKokugoCharacters.where((c) => afterUnlocked[c.id]?.isUnlocked ?? false).length;
      final hasMaxLevel =
          afterUnlocked.values.any((cs) => cs.isMaxLevel);

      final newBadges = await ref.read(badgeProvider.notifier).checkAndAward(
        streakDays: progress.streakDays,
        totalKanjiCorrect: progress.totalKanjiCorrect,
        totalReadingCorrect: progress.totalReadingCorrect,
        maxStageCleared: progress.maxStageCleared,
        perfectStageCount: progress.perfectStageCount,
        justPerfect: r.isPerfect,
        totalCorrect: progress.totalCorrect,
        clearedStageCount: progress.clearedStageIds.length,
        currentPerfectStreak: progress.currentPerfectStreak,
        unlockedCharacterCount: unlockedCount,
        hasMaxLevelCharacter: hasMaxLevel,
      );

      // Phase 2+ チャレンジバッジチェック
      final updatedProgress = ref.read(progressProvider);
      final totalStages = 48; // 6年×8ステージ（全ステージ数）
      final allStageCleared = updatedProgress.clearedStageIds.length == totalStages;

      // パフォーマンストラッキング
      final questPerformance = ref.read(questPerformanceProvider.notifier);
      await questPerformance.recordSpeedrunAttempt(
        questionCount: r.totalCount,
        elapsedTime: r.elapsed,
      );

      if (r.isPerfect) {
        await questPerformance.recordPerfectDay(DateTime.now());
      }

      // チャレンジバッジチェック
      final questPerfState = ref.read(questPerformanceProvider);
      final consecutivePerfectDays = questPerformance.getConsecutivePerfectDays();

      final challengeBadges = await ref.read(badgeProvider.notifier).checkChallengeBadges(
        perfectDays: consecutivePerfectDays,
        allStageCleared: allStageCleared,
        speedrunAchieved: questPerfState.speedrunAchieved,
        nonStopAchieved: updatedProgress.currentPerfectStreak >= 20,
      );

      // Phase 2+ マイルストーンバッジチェック
      final coinState = ref.read(coinProvider);
      final metricsState = ref.read(badgeMetricsProvider);

      // 今回のセッションの学習時間を追加（経過時間を秒で記録）
      final sessionDuration = r.elapsed.inSeconds;
      await ref.read(badgeMetricsProvider.notifier).addLearningTime(sessionDuration);

      final milestoneBadges = await ref.read(badgeProvider.notifier).checkMilestoneBadges(
        learningMinutes: metricsState.learningMinutes + (sessionDuration ~/ 60),
        totalCoins: coinState.totalCoins,
      );

      // Phase 3+ 学習習慣を記録
      final habitProvider = ref.read(studyHabitProvider.notifier);
      await habitProvider.recordStudySession(
        questionCount: r.correctCount,
        studyTime: DateTime.now(),
      );

      // 週末の問題数を追跡
      if (DateTime.now().weekday == DateTime.saturday ||
          DateTime.now().weekday == DateTime.sunday) {
        await habitProvider.addWeekendQuestions(r.totalCount);
      }

      // 今日の問題数を追跡
      await habitProvider.addTodayQuestions(r.totalCount);

      // Phase 3+ 時間帯別バッジチェック
      final habitState = ref.read(studyHabitProvider);
      final timeSlotCounts = <String, int>{};
      for (final slot in TimeSlot.values) {
        timeSlotCounts[slot.name] = habitState.getTimeSlotCount(slot);
      }

      final weekendQuestionsCount = await habitProvider.getWeekendQuestionCount();
      final lastSevenDays = habitProvider.getLastSevenDays();
      final dailyQuestionCounts = await habitProvider.getLastSevenDaysCounts();

      final timeBadges = await ref.read(badgeProvider.notifier).checkTimeBadges(
        studyTime: DateTime.now(),
        questionCount: r.totalCount,
        timeSlotCounts: timeSlotCounts,
        weekendQuestions: weekendQuestionsCount,
        lastSevenDays: lastSevenDays,
        dailyQuestionCounts: dailyQuestionCounts,
      );

      final allNewBadges = [
        ...newBadges,
        ...challengeBadges,
        ...milestoneBadges,
        ...timeBadges,
      ];

      if (!mounted) return;
      setState(() {
        _newBadges = allNewBadges;
        _saving = false;
      });
      if (r.isPassed) _confetti.play();
      for (final character in newlyUnlocked) {
        if (!mounted) break;
        await showCharacterUnlockDialog(context, character);
      }

      // 新規バッジ獲得時は通知を表示
      if (allNewBadges.isNotEmpty) {
        if (!mounted) return;
        await showBadgeAchievementDialog(context, allNewBadges);
      }
    } catch (e) {
      // 保存の途中で失敗しても（例：画面が破棄された）、少なくとも
      // スピナーが永久に回り続ける状態は避ける。
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final pct = r.correctCount / r.totalCount;
    final color = pct >= 0.8 ? kAccentGreen : pct >= 0.6 ? kPrimaryColor : kAccentRed;
    final emoji = r.isPerfect ? '🏆' : pct >= 0.8 ? '⭐' : pct >= 0.6 ? '👍' : '📖';
    final message = r.isPerfect
        ? '完璧！あなたは天才です！🌟'
        : pct >= 0.8
            ? 'すばらしい成績ですね！👏'
            : pct >= 0.6
                ? 'よくできました！次も頑張ろう！💪'
                : 'もう一度やってみよう！頑張れば絶対できます！🔥';

    return Scaffold(
      appBar: AppBar(
        title: const Text('結果'),
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
      ),
      body: Stack(
        children: [
          if (!_saving)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 30,
                colors: const [kPrimaryColor, kAccentGreen, Colors.blue, Colors.pink],
              ),
            ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _saving
                    ? const CircularProgressIndicator()
                    : _ScoreDisplay(emoji: emoji, message: message, r: r, color: color),
                const SizedBox(height: 24),
                _StageInfo(stage: widget.stage, elapsed: r.elapsed),
                if (_newBadges.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _NewBadgesSection(badges: _newBadges),
                ],
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        // 保存処理が終わるまでは画面遷移させない（遷移すると
                        // このStateが破棄され、進捗/コイン/バッジ保存が
                        // 途中で止まってしまうため）。
                        onPressed: _saving
                            ? null
                            : () => Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/stages',
                                  (route) => route.settings.name == '/home',
                                ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: kPrimaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('ステージ選択'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saving
                            ? null
                            : () => Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/home',
                                  (route) => false,
                                ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('ホームへ'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreDisplay extends StatelessWidget {
  final String emoji;
  final String message;
  final QuestResult r;
  final Color color;

  const _ScoreDisplay({
    required this.emoji,
    required this.message,
    required this.r,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kTextDark)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ScoreStat(
                label: 'せいかい',
                value: '${r.correctCount}',
                suffix: '/ ${r.totalCount}問',
                color: color,
              ),
              _ScoreStat(
                label: 'スコア',
                value: '${r.score}',
                suffix: '点',
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: r.correctCount / r.totalCount,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreStat extends StatelessWidget {
  final String label;
  final String value;
  final String suffix;
  final Color color;

  const _ScoreStat({
    required this.label,
    required this.value,
    required this.suffix,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: kTextMuted, fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(width: 4),
            Text(suffix, style: const TextStyle(fontSize: 14, color: kTextMuted)),
          ],
        ),
      ],
    );
  }
}

class _StageInfo extends StatelessWidget {
  final Stage stage;
  final Duration elapsed;

  const _StageInfo({required this.stage, required this.elapsed});

  @override
  Widget build(BuildContext context) {
    final mins = elapsed.inMinutes;
    final secs = elapsed.inSeconds % 60;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _InfoItem(label: 'ステージ', value: '${stage.stageNumber}'),
          _InfoItem(label: 'タイプ', value: stage.quizType == QuizType.primary ? '漢字' : '読解'),
          _InfoItem(
            label: 'タイム',
            value: mins > 0 ? '${mins}分${secs}秒' : '${secs}秒',
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: kTextMuted, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}

class _NewBadgesSection extends StatelessWidget {
  final List<BadgeModel> badges;
  const _NewBadgesSection({required this.badges});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE082), Color(0xFFFFF9C4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFCC02)),
      ),
      child: Column(
        children: [
          const Text('🎉 新しいバッジをゲット！', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: badges.map((b) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(b.emoji, style: const TextStyle(fontSize: 36)),
                const SizedBox(height: 4),
                Text(b.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }
}
