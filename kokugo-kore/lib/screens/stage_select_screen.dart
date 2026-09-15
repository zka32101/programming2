import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/quiz_data.dart';
import '../models/quest_model.dart';
import '../providers/premium_provider.dart';
import '../providers/progress_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/stage_card.dart';

class StageSelectScreen extends ConsumerStatefulWidget {
  const StageSelectScreen({super.key});

  @override
  ConsumerState<StageSelectScreen> createState() => _StageSelectScreenState();
}

class _StageSelectScreenState extends ConsumerState<StageSelectScreen> {
  int _gradeFilter = 0; // 0=全て、1〜6=学年
  QuizType? _typeFilter; // null=全て

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // まなぶ画面からの引数でフィルター設定
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      final t = args['type'] as String?;
      if (t == 'kanji') _typeFilter = QuizType.primary;
      if (t == 'reading') _typeFilter = QuizType.secondary;
    }
  }

  List<Stage> get _filteredStages {
    final allStages = <Stage>[];
    for (var g = 1; g <= 6; g++) {
      allStages.addAll(getStagesForGrade(g));
    }
    return allStages.where((s) {
      if (_gradeFilter != 0 && s.grade != _gradeFilter) return false;
      if (_typeFilter != null && s.quizType != _typeFilter) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final premium = ref.watch(premiumProvider);
    final filtered = _filteredStages;

    String title = 'ステージ選択';
    if (_typeFilter == QuizType.primary) title = 'かんじ';
    if (_typeFilter == QuizType.secondary) title = 'よむ';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: _typeFilter == QuizType.secondary ? const Color(0xFF1ABC9C) : kPrimaryColor,
        actions: [
          if (!premium.isPremium)
            TextButton.icon(
              onPressed: () => Navigator.of(context).pushNamed('/upgrade'),
              icon: const Icon(Icons.star, color: Colors.white, size: 16),
              label: premium.isTrialActive
                  ? Text('トライアル${premium.trialDaysLeft}日',
                      style: const TextStyle(color: Colors.white, fontSize: 12))
                  : const Text('PRO', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Column(
        children: [
          // 学年フィルター
          _GradeFilterBar(
            selected: _gradeFilter,
            onSelected: (g) => setState(() => _gradeFilter = g),
          ),
          // ステージリスト
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('ステージがありません'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 40),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final stage = filtered[i];
                      final isCleared = progress.isCleared(stage.grade, stage.stageNumber);
                      // 同じ学年・タイプで直前のステージがクリアされているか
                      final sameGroup = filtered
                          .where((s) => s.grade == stage.grade && s.quizType == stage.quizType)
                          .toList();
                      final idx = sameGroup.indexOf(stage);
                      final isLocked = idx > 0 &&
                          !progress.isCleared(sameGroup[idx - 1].grade, sameGroup[idx - 1].stageNumber);
                      final isPremiumLocked =
                          !premium.isPremium && !premium.isTrialActive &&
                          stage.stageNumber > kFreeStageLimit;

                      return StageCard(
                        stage: stage,
                        isCleared: isCleared,
                        isLocked: isLocked,
                        isPremiumLocked: isPremiumLocked,
                        showGradeBadge: true,
                        onTap: () => Navigator.of(context).pushNamed('/quest', arguments: stage),
                        onPremiumTap: () => Navigator.of(context).pushNamed('/upgrade'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _GradeFilterBar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelected;

  const _GradeFilterBar({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          _chip(context, 0, '全て'),
          ...List.generate(6, (i) => _chip(context, i + 1, '${i + 1}年生')),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, int grade, String label) {
    final isSelected = selected == grade;
    final color = grade == 0 ? kTextDark : gradeColor(gradeGroupOf(grade));
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => onSelected(grade),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withAlpha(20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withAlpha(isSelected ? 255 : 80)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
