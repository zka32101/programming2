import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart' show WeeklyBarChartWidget;
import '../providers/adaptive_provider.dart';

import '../data/quiz_data.dart';
import '../models/quest_model.dart';
import '../providers/progress_provider.dart';
import '../providers/profile_provider.dart';
import '../theme/app_theme.dart';

class ParentReportScreen extends ConsumerWidget {
  const ParentReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final adaptive = ref.watch(adaptiveProvider);
    final profileState = ref.watch(profileProvider);
    final child = profileState.currentProfile;

    final allStages = [
      for (var g = 1; g <= 6; g++) ...getStagesForGrade(g),
    ];
    final weakStages = allStages
        .where((s) => adaptive.needsReview('g${s.grade}_s${s.stageNumber}'))
        .toList();
    final strugglingStages = allStages
        .where((s) => adaptive.isStruggling('g${s.grade}_s${s.stageNumber}'))
        .toList();

    return Scaffold(
      backgroundColor: kBgLight,
      appBar: AppBar(
        title: const Text('保護者向けレポート'),
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ヘッダー
          _SectionCard(
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Text('👧', style: TextStyle(fontSize: 28))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child != null ? '${child.name}さんのレポート' : '学習レポート',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kTextDark,
                        ),
                      ),
                      if (child != null)
                        Text(
                          '${child.grade}年生',
                          style: const TextStyle(color: kTextMuted, fontSize: 13),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 学習サマリー
          _SectionTitle(title: '📊 学習サマリー'),
          _SummaryGrid(progress: progress),
          const SizedBox(height: 16),

          // 苦手エリア（セーフティネット）
          if (strugglingStages.isNotEmpty) ...[
            _AlertBanner(
              strugglingStages: strugglingStages,
              onTap: () {},
            ),
            const SizedBox(height: 16),
          ],

          // 苦手ステージ
          if (weakStages.isNotEmpty) ...[
            _SectionTitle(title: '📚 復習が必要なステージ'),
            ...weakStages.take(5).map((s) => _WeakStageCard(
                  stage: s,
                  accuracy: adaptive.accuracyFor('g${s.grade}_s${s.stageNumber}'),
                  attempts: adaptive.attemptsFor('g${s.grade}_s${s.stageNumber}'),
                )),
            const SizedBox(height: 16),
          ],

          // 正答率グラフ（学年別）
          _SectionTitle(title: '📈 学年別の正答率'),
          _AccuracyByGrade(adaptive: adaptive),
          const SizedBox(height: 16),

          // 保護者へのアドバイス
          _SectionTitle(title: '💡 今週のアドバイス'),
          _AdviceCard(
            progress: progress,
            weakCount: weakStages.length,
            strugglingCount: strugglingStages.length,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: kTextDark,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  final LearningProgress progress;
  const _SummaryGrid({required this.progress});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.4,
      children: [
        _GridCell(emoji: '🔥', label: '連続学習', value: '${progress.streakDays}日'),
        _GridCell(emoji: '✅', label: 'クリアステージ', value: '${progress.clearedStageIds.length}個'),
        _GridCell(emoji: '⭕', label: '合計正解数', value: '${progress.totalCorrect}問'),
        _GridCell(emoji: '🏆', label: '満点ステージ', value: '${progress.perfectStageCount}回'),
      ],
    );
  }
}

class _GridCell extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  const _GridCell({required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: kTextDark)),
                Text(label, style: const TextStyle(fontSize: 10, color: kTextMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final List<Stage> strugglingStages;
  final VoidCallback onTap;
  const _AlertBanner({required this.strugglingStages, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFC107)),
      ),
      child: Row(
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'サポートが必要かもしれません',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF856404)),
                ),
                const SizedBox(height: 2),
                Text(
                  '${strugglingStages.length}つのステージで正答率が低い状態が続いています。一緒に取り組んでみましょう！',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF856404)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeakStageCard extends StatelessWidget {
  final Stage stage;
  final double accuracy;
  final int attempts;
  const _WeakStageCard({required this.stage, required this.accuracy, required this.attempts});

  @override
  Widget build(BuildContext context) {
    final pct = (accuracy * 100).round();
    final color = pct < 50 ? kAccentRed : kPrimaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                stage.quizType == QuizType.primary ? '漢' : '読',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${stage.grade}年生 ステージ${stage.stageNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  stage.title,
                  style: const TextStyle(fontSize: 11, color: kTextMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$pct%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                '$attempts回挑戦',
                style: const TextStyle(fontSize: 10, color: kTextMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccuracyByGrade extends StatelessWidget {
  final AdaptiveState adaptive;
  const _AccuracyByGrade({required this.adaptive});

  /// 学年ごとの平均正答率（0〜1）。ステージ履歴がない学年は含めない。
  Map<int, double> get _accuracyByGrade {
    final result = <int, double>{};
    for (var g = 1; g <= 6; g++) {
      final stages = adaptive.stageHistory.keys
          .where((id) => id.startsWith('g${g}_'))
          .toList();
      if (stages.isEmpty) continue;
      final totalCorrect =
          stages.fold(0.0, (sum, id) => sum + adaptive.accuracyFor(id));
      result[g] = (totalCorrect / stages.length).clamp(0.0, 1.0);
    }
    return result;
  }

  Color _colorForPct(double pct) {
    if (pct >= 0.8) return kAccentGreen;
    if (pct >= 0.6) return kPrimaryColor;
    return kAccentRed;
  }

  @override
  Widget build(BuildContext context) {
    final accuracyByGrade = _accuracyByGrade;
    if (accuracyByGrade.isEmpty) {
      return const SizedBox.shrink();
    }
    final grades = accuracyByGrade.keys.toList()..sort();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: WeeklyBarChartWidget(
        values: [for (final g in grades) accuracyByGrade[g]! * 100],
        labels: [for (final g in grades) '$g年生'],
        primaryColor: kPrimaryColor,
        barColorForValue: (value) => _colorForPct(value / 100),
        maxY: 100,
        valueSuffix: '%',
      ),
    );
  }
}

class _AdviceCard extends StatelessWidget {
  final LearningProgress progress;
  final int weakCount;
  final int strugglingCount;
  const _AdviceCard({
    required this.progress,
    required this.weakCount,
    required this.strugglingCount,
  });

  String get _advice {
    if (strugglingCount >= 2) {
      return '苦手なステージが複数あります。「できないことができた！」という体験が大切です。一緒に取り組み、どんな小さな成長も言葉にしてほめてあげましょう。';
    }
    if (weakCount >= 3) {
      return '復習が必要なステージがあります。間違えたときは「なぜ間違えたか」を一緒に考えると理解が深まります。正解・不正解より「考える姿勢」をほめてあげてください。';
    }
    if (progress.streakDays >= 7) {
      return '${progress.streakDays}日連続で頑張っています！継続は力なりです。「毎日続けてすごい！」と声をかけてあげてください。習慣が力になっています。';
    }
    if (progress.perfectStageCount > 0) {
      return '満点を${progress.perfectStageCount}回取っています！「満点とれたね！どんな気持ちだった？」と聞いてみましょう。自己効力感が高まります。';
    }
    return '学習記録を確認してあげましょう。「今日どんなことを勉強したの？」と聞くことで、アウトプットの練習にもなります。学んだことを話す機会を作ってあげてください。';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kAccentGreen.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🌱', style: TextStyle(fontSize: 20)),
              SizedBox(width: 6),
              Text(
                '教育工学からのヒント',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _advice,
            style: const TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Color(0xFF1B5E20),
            ),
          ),
        ],
      ),
    );
  }
}
