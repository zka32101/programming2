import 'package:flutter/material.dart';
import '../data/quiz_data.dart';

import '../models/quest_model.dart';
import '../providers/adaptive_provider.dart';
import '../providers/progress_provider.dart';
import '../theme/app_theme.dart';

class DailyMissionCard extends StatelessWidget {
  final int streakDays;
  final LearningProgress progress;
  final AdaptiveState adaptive;
  final VoidCallback onStart;
  final void Function(Stage)? onStartStage;

  const DailyMissionCard({
    super.key,
    required this.streakDays,
    required this.progress,
    required this.adaptive,
    required this.onStart,
    this.onStartStage,
  });

  /// クリア済みステージの中から最も苦手なステージを返す
  Stage? _getWeakStage() {
    final allStages = [
      for (var g = 1; g <= 6; g++) ...getStagesForGrade(g),
    ];
    // クリア済みかつ復習が必要なステージを優先
    final cleared = allStages
        .where((s) => progress.isCleared(s.grade, s.stageNumber))
        .toList();
    return adaptive.getWeakStage(cleared);
  }

  /// クリアしていない最初のステージ（次の挑戦先）
  Stage? _getNextStage() {
    for (var g = 1; g <= 6; g++) {
      for (final stage in getStagesForGrade(g)) {
        if (!progress.isCleared(stage.grade, stage.stageNumber)) {
          return stage;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final weakStage = _getWeakStage();
    final nextStage = _getNextStage();
    final isAllClear = nextStage == null && weakStage == null;

    // 苦手ステージがある場合は復習ミッションを優先表示
    if (weakStage != null) {
      return _ReviewMissionCard(
        stage: weakStage,
        streakDays: streakDays,
        accuracy: adaptive.accuracyFor('g${weakStage.grade}_s${weakStage.stageNumber}'),
        onStart: () {
          if (onStartStage != null) {
            onStartStage!(weakStage);
          } else {
            onStart();
          }
        },
      );
    }

    return _NormalMissionCard(
      stage: nextStage,
      streakDays: streakDays,
      isAllClear: isAllClear,
      onStart: onStart,
    );
  }
}

// ─── 復習ミッションカード ─────────────────────────────────────
class _ReviewMissionCard extends StatelessWidget {
  final Stage stage;
  final int streakDays;
  final double accuracy;
  final VoidCallback onStart;

  const _ReviewMissionCard({
    required this.stage,
    required this.streakDays,
    required this.accuracy,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (accuracy * 100).round();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kAccentPurple, Color(0xFF6C3483)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kAccentPurple.withAlpha(80),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.replay_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  '復習ミッション',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (streakDays > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          '$streakDays日連続',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${stage.grade}年生 ステージ${stage.stageNumber}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    stage.quizType == QuizType.primary ? 'かんじ' : 'よむ',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '前回の正答率：$pct%',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF6C3483),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  '復習する！📖',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 通常ミッションカード ─────────────────────────────────────
class _NormalMissionCard extends StatelessWidget {
  final Stage? stage;
  final int streakDays;
  final bool isAllClear;
  final VoidCallback onStart;

  const _NormalMissionCard({
    required this.stage,
    required this.streakDays,
    required this.isAllClear,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isAllClear
              ? [const Color(0xFF27AE60), const Color(0xFF1E8449)]
              : [const Color(0xFFD68910), const Color(0xFFBA4A00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withAlpha(80),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isAllClear ? Icons.emoji_events : Icons.auto_awesome,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  'おまかせ',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (streakDays > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          '$streakDays日連続',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (isAllClear) ...[
              Text(
                '🎉 全ステージクリア！',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text('すごい！全部クリアしたよ！', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ] else if (stage != null) ...[
              Text(
                '${stage!.grade}年生 ステージ${stage!.stageNumber}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      stage!.quizType == QuizType.primary ? 'かんじ' : 'よむ',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    stage!.title,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isAllClear ? null : onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: kPrimaryDark,
                  disabledBackgroundColor: Colors.white38,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  isAllClear ? '全クリア！' : 'はじめる！',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
