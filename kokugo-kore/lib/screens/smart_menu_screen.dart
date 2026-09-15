import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/quiz_data.dart';
import '../models/quest_model.dart';
import '../providers/adaptive_provider.dart';
import '../providers/learning_timer_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/progress_provider.dart';
import '../theme/app_theme.dart';

// ─── 難易度モード ─────────────────────────────────────────────
enum _Difficulty { easy, normal, hard }

extension _DifficultyExt on _Difficulty {
  String get label {
    switch (this) {
      case _Difficulty.easy:
        return 'かんたん';

      case _Difficulty.normal:
        return 'ふつう';
      case _Difficulty.hard:
        return 'むずかしい';
    }
  }

  String get emoji {
    switch (this) {
      case _Difficulty.easy:
        return '🌱';
      case _Difficulty.normal:
        return '⭐';
      case _Difficulty.hard:
        return '🔥';
    }
  }

  String get description {
    switch (this) {
      case _Difficulty.easy:
        return '得意なことをもっと\n得意にしよう！';
      case _Difficulty.normal:
        return 'バランスよく\n学習しよう！';
      case _Difficulty.hard:
        return 'チャレンジして\n力をつけよう！';
    }
  }

  Color get color {
    switch (this) {
      case _Difficulty.easy:
        return const Color(0xFF27AE60);
      case _Difficulty.normal:
        return kPrimaryColor;
      case _Difficulty.hard:
        return const Color(0xFFE74C3C);
    }
  }
}

// ─── 推薦ステージ ─────────────────────────────────────────────
class _Recommendation {
  final Stage stage;
  final String reason;
  final Color accentColor;

  const _Recommendation({
    required this.stage,
    required this.reason,
    required this.accentColor,
  });
}

// ─── AI 推薦ロジック ──────────────────────────────────────────
List<_Recommendation> _computeRecommendations({
  required int grade,
  required _Difficulty difficulty,
  required LearningProgress progress,
  required AdaptiveState adaptive,
}) {
  // 全ステージ（学年1〜grade）
  final allStages = [
    for (var g = 1; g <= grade; g++) ...getStagesForGrade(g),
  ];

  final clearedStages =
      allStages.where((s) => progress.isCleared(s.grade, s.stageNumber)).toList();
  final uncleared =
      allStages.where((s) => !progress.isCleared(s.grade, s.stageNumber)).toList();

  final recommendations = <_Recommendation>[];

  // ① 苦手ステージ（難易度問わず最優先）
  final weakStages = clearedStages.where((s) {
    final id = 'g${s.grade}_s${s.stageNumber}';
    return adaptive.needsReview(id);
  }).toList()
    ..sort((a, b) {
      final idA = 'g${a.grade}_s${a.stageNumber}';
      final idB = 'g${b.grade}_s${b.stageNumber}';
      return adaptive.accuracyFor(idA).compareTo(adaptive.accuracyFor(idB));
    });

  if (weakStages.isNotEmpty && difficulty != _Difficulty.hard) {
    final weak = weakStages.first;
    final id = 'g${weak.grade}_s${weak.stageNumber}';
    final accPct = (adaptive.accuracyFor(id) * 100).round();
    recommendations.add(_Recommendation(
      stage: weak,
      reason: '正答率 $accPct%\n復習で確実にしよう！',
      accentColor: kAccentPurple,
    ));
  }

  switch (difficulty) {
    case _Difficulty.easy:
      // 高正答率のクリア済みステージ（練習・定着）
      final sorted = List<Stage>.from(clearedStages)
        ..sort((a, b) {
          final idA = 'g${a.grade}_s${a.stageNumber}';
          final idB = 'g${b.grade}_s${b.stageNumber}';
          return adaptive
              .accuracyFor(idB)
              .compareTo(adaptive.accuracyFor(idA));
        });
      for (final s in sorted) {
        if (recommendations.any((r) => r.stage == s)) continue;
        final id = 'g${s.grade}_s${s.stageNumber}';
        final acc = (adaptive.accuracyFor(id) * 100).round();
        recommendations.add(_Recommendation(
          stage: s,
          reason: '正答率 $acc%\n得意をさらに磨こう！',
          accentColor: const Color(0xFF27AE60),
        ));
        if (recommendations.length >= 3) break;
      }
      // 未クリアが全くないならアンクリアの最初のステージ
      if (recommendations.isEmpty && uncleared.isNotEmpty) {
        recommendations.add(_Recommendation(
          stage: uncleared.first,
          reason: '次のステージに\nチャレンジしよう！',
          accentColor: kPrimaryColor,
        ));
      }

    case _Difficulty.normal:
      // 中正答率 or 次のアンクリアステージ
      final midStages = clearedStages.where((s) {
        final id = 'g${s.grade}_s${s.stageNumber}';
        final acc = adaptive.accuracyFor(id);
        return acc >= 0.5 && acc < 0.85;
      }).toList();
      for (final s in midStages) {
        if (recommendations.any((r) => r.stage == s)) continue;
        final id = 'g${s.grade}_s${s.stageNumber}';
        final acc = (adaptive.accuracyFor(id) * 100).round();
        recommendations.add(_Recommendation(
          stage: s,
          reason: '正答率 $acc%\nバランスよく練習しよう！',
          accentColor: kPrimaryColor,
        ));
        if (recommendations.length >= 2) break;
      }
      // 次のアンクリアを追加
      if (uncleared.isNotEmpty && recommendations.length < 3) {
        final next = uncleared.first;
        if (!recommendations.any((r) => r.stage == next)) {
          recommendations.add(_Recommendation(
            stage: next,
            reason: '新しいステージに\n挑戦しよう！',
            accentColor: const Color(0xFF2980B9),
          ));
        }
      }

    case _Difficulty.hard:
      // 未クリアステージを先頭から
      for (final s in uncleared) {
        recommendations.add(_Recommendation(
          stage: s,
          reason: '新しい問題に\nチャレンジ！',
          accentColor: const Color(0xFFE74C3C),
        ));
        if (recommendations.length >= 3) break;
      }
      // アンクリアがなければ正答率の低いクリア済みステージ
      if (recommendations.isEmpty) {
        final sorted = List<Stage>.from(clearedStages)
          ..sort((a, b) {
            final idA = 'g${a.grade}_s${a.stageNumber}';
            final idB = 'g${b.grade}_s${b.stageNumber}';
            return adaptive
                .accuracyFor(idA)
                .compareTo(adaptive.accuracyFor(idB));
          });
        for (final s in sorted.take(3)) {
          final id = 'g${s.grade}_s${s.stageNumber}';
          final acc = (adaptive.accuracyFor(id) * 100).round();
          recommendations.add(_Recommendation(
            stage: s,
            reason: '正答率 $acc%\nもっと高めよう！',
            accentColor: const Color(0xFFE74C3C),
          ));
        }
      }
  }

  return recommendations.take(3).toList();
}

// ─── Screen ───────────────────────────────────────────────────
class SmartMenuScreen extends ConsumerStatefulWidget {
  const SmartMenuScreen({super.key});

  @override
  ConsumerState<SmartMenuScreen> createState() => _SmartMenuScreenState();
}

class _SmartMenuScreenState extends ConsumerState<SmartMenuScreen> {
  _Difficulty? _selectedDifficulty;
  bool _showTimer = false;
  int _timerMinutes = 30;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider).currentProfile;
    final progress = ref.watch(progressProvider);
    final adaptive = ref.watch(adaptiveProvider);
    final timer = ref.watch(learningTimerProvider);
    final grade = profile?.grade ?? 3;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '⭐ おまかせ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── タイマーセクション ──────────────────────────────
            _TimerSection(
              timer: timer,
              showTimer: _showTimer,
              timerMinutes: _timerMinutes,
              onToggle: () => setState(() => _showTimer = !_showTimer),
              onMinutesChanged: (v) => setState(() => _timerMinutes = v),
              onStart: () async {
                await ref
                    .read(learningTimerProvider.notifier)
                    .start(_timerMinutes);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '⏱ タイマー $_timerMinutes 分をスタートしました！'),
                      backgroundColor: kPrimaryColor,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              onStop: () async {
                await ref.read(learningTimerProvider.notifier).stop();
              },
            ),

            const SizedBox(height: 20),

            // ── 難易度選択 ─────────────────────────────────────
            Text('今日の気分は？',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: _Difficulty.values.map((d) {
                final selected = _selectedDifficulty == d;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _DifficultyCard(
                      difficulty: d,
                      selected: selected,
                      onTap: () =>
                          setState(() => _selectedDifficulty = d),
                    ),
                  ),
                );
              }).toList(),
            ),

            // ── 推薦ステージ ───────────────────────────────────
            if (_selectedDifficulty != null) ...[
              const SizedBox(height: 24),
              Text('今日のあなたにぴったりなステージ',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                '${grade}年生向けにAIが選びました',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              ...() {
                final recs = _computeRecommendations(
                  grade: grade,
                  difficulty: _selectedDifficulty!,
                  progress: progress,
                  adaptive: adaptive,
                );
                if (recs.isEmpty) {
                  return [
                    const _EmptyRecommendation(),
                  ];
                }
                return recs
                    .map((r) => _RecommendationCard(
                          rec: r,
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/quest', arguments: r.stage)
                                .then((_) => Navigator.of(context).pop());
                          },
                        ))
                    .toList();
              }(),
            ],

            const SizedBox(height: 32),
            // ── 自分で選ぶボタン ───────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/stages');
                },
                icon: const Icon(Icons.tune),
                label: const Text('自分でステージを選ぶ'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kPrimaryColor,
                  side: const BorderSide(color: kPrimaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

// ─── タイマーセクション ────────────────────────────────────────
class _TimerSection extends StatelessWidget {
  final LearningTimerState timer;
  final bool showTimer;
  final int timerMinutes;
  final VoidCallback onToggle;
  final ValueChanged<int> onMinutesChanged;
  final VoidCallback onStart;
  final VoidCallback onStop;

  const _TimerSection({
    required this.timer,
    required this.showTimer,
    required this.timerMinutes,
    required this.onToggle,
    required this.onMinutesChanged,
    required this.onStart,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          // ヘッダー（タップで展開/折りたたみ）
          InkWell(
            onTap: onToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Text('⏱', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '学習タイマー',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        if (timer.isActive)
                          Text(
                            '残り ${timer.displayTime}',
                            style: TextStyle(
                              color: timer.isAlmostDone
                                  ? Colors.orange
                                  : kPrimaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        else
                          Text(
                            'タイマーをセットしよう',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    showTimer ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          // タイマーが動いている時のプログレスバー
          if (timer.isActive)
            LinearProgressIndicator(
              value: timer.progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                timer.isAlmostDone ? Colors.orange : kPrimaryColor,
              ),
              minHeight: 3,
            ),

          // 展開時のコントロール
          if (showTimer)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: timer.isActive
                  ? _ActiveTimerControl(timer: timer, onStop: onStop)
                  : _SetTimerControl(
                      minutes: timerMinutes,
                      onMinutesChanged: onMinutesChanged,
                      onStart: onStart,
                    ),
            ),
        ],
      ),
    );
  }
}

class _SetTimerControl extends StatelessWidget {
  final int minutes;
  final ValueChanged<int> onMinutesChanged;
  final VoidCallback onStart;

  const _SetTimerControl({
    required this.minutes,
    required this.onMinutesChanged,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '⏰ $minutes 分',
          style: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: kPrimaryColor),
        ),
        const SizedBox(height: 8),
        Slider(
          value: minutes.toDouble(),
          min: 5,
          max: 60,
          divisions: 11,
          label: '$minutes分',
          activeColor: kPrimaryColor,
          onChanged: (v) => onMinutesChanged(v.round()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [5, 10, 15, 20, 30, 45, 60].map((m) {
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: GestureDetector(
                onTap: () => onMinutesChanged(m),
                child: Chip(
                  label: Text('$m分',
                      style: TextStyle(
                        fontSize: 11,
                        color: minutes == m ? Colors.white : Colors.grey[700],
                      )),
                  backgroundColor:
                      minutes == m ? kPrimaryColor : Colors.grey[200],
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow),
            label: Text('$minutes分のタイマーをスタート！'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActiveTimerControl extends StatelessWidget {
  final LearningTimerState timer;
  final VoidCallback onStop;

  const _ActiveTimerControl({required this.timer, required this.onStop});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          timer.displayTime,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: timer.isAlmostDone ? Colors.orange : kPrimaryColor,
          ),
        ),
        Text(
          '目標 ${timer.targetMinutes}分',
          style: TextStyle(color: Colors.grey[500], fontSize: 13),
        ),
        const SizedBox(height: 16),
        if (timer.isAlmostDone)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🔔', style: TextStyle(fontSize: 18)),
                SizedBox(width: 8),
                Text(
                  'あと5分！そろそろ終わりですね',
                  style: TextStyle(
                      color: Colors.orange, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: onStop,
          icon: const Icon(Icons.stop, color: Colors.red),
          label: const Text('タイマーを止める',
              style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

// ─── 難易度カード ──────────────────────────────────────────────
class _DifficultyCard extends StatelessWidget {
  final _Difficulty difficulty;
  final bool selected;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.difficulty,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? difficulty.color : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? difficulty.color : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: difficulty.color.withAlpha(80),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ]
              : [
                  BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 6,
                      offset: const Offset(0, 2))
                ],
        ),
        child: Column(
          children: [
            Text(difficulty.emoji,
                style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 6),
            Text(
              difficulty.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              difficulty.description,
              style: TextStyle(
                fontSize: 10,
                color: selected ? Colors.white70 : Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 推薦カード ────────────────────────────────────────────────
class _RecommendationCard extends StatelessWidget {
  final _Recommendation rec;
  final VoidCallback onTap;

  const _RecommendationCard({required this.rec, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = rec.stage;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            // カラーサイドバー
            Container(
              width: 8,
              height: 80,
              decoration: BoxDecoration(
                color: rec.accentColor,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16)),
              ),
            ),
            // コンテンツ
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: rec.accentColor.withAlpha(30),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${s.grade}年生',
                            style: TextStyle(
                              fontSize: 11,
                              color: rec.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ステージ ${s.stageNumber}',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // 理由テキスト + 矢印
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    rec.reason,
                    style: TextStyle(
                        fontSize: 10, color: Colors.grey[500]),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: rec.accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow,
                        color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyRecommendation extends StatelessWidget {
  const _EmptyRecommendation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: const Column(
        children: [
          Text('🎉', style: TextStyle(fontSize: 40)),
          SizedBox(height: 8),
          Text(
            'すべてのステージをクリアしました！',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            '「自分で選ぶ」から好きなステージを\n再挑戦してみよう。',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
