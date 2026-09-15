import 'package:flutter/material.dart';
import '../models/quest_model.dart';

import '../theme/app_theme.dart';

class StageCard extends StatelessWidget {
  final Stage stage;

  final bool isCleared;
  final bool isLocked;
  final bool isPremiumLocked;
  final bool showGradeBadge;
  final VoidCallback? onTap;
  final VoidCallback? onPremiumTap;

  const StageCard({
    super.key,
    required this.stage,
    required this.isCleared,
    required this.isLocked,
    this.isPremiumLocked = false,
    this.showGradeBadge = false,
    this.onTap,
    this.onPremiumTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(stage.quizType);
    final effectiveLocked = isLocked || isPremiumLocked;
    return GestureDetector(
      onTap: isLocked ? null : (isPremiumLocked ? onPremiumTap : onTap),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: effectiveLocked ? 0.6 : 1.0,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: isCleared
                ? Border.all(color: kAccentGreen, width: 2)
                : Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isLocked ? Colors.grey.shade200 : color.withAlpha(25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: isPremiumLocked
                        ? const Icon(Icons.star, color: kPrimaryColor, size: 24)
                        : isLocked
                        ? const Icon(Icons.lock, color: Colors.grey, size: 24)
                        : isCleared
                            ? const Icon(Icons.check_circle, color: kAccentGreen, size: 28)
                            : Text(
                                _typeEmoji(stage.quizType),
                                style: const TextStyle(fontSize: 26),
                              ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (showGradeBadge) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: gradeColor(gradeGroupOf(stage.grade)).withAlpha(30),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${stage.grade}年生',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: gradeColor(gradeGroupOf(stage.grade)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            'ステージ ${stage.stageNumber}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: kTextMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isLocked ? Colors.grey.shade200 : color.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _typeLabel(stage.quizType),
                              style: TextStyle(
                                fontSize: 10,
                                color: isLocked ? Colors.grey : color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stage.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isLocked ? Colors.grey : kTextDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${stage.totalQuestions}問',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (isPremiumLocked)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('PRO', style: TextStyle(fontSize: 11, color: kPrimaryColor, fontWeight: FontWeight.bold)),
                  )
                else if (!isLocked)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: isCleared ? kAccentGreen : kTextMuted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _typeColor(QuizType type) {
    return type == QuizType.primary ? kPrimaryColor : kAccentBlue;
  }

  String _typeEmoji(QuizType type) {
    return type == QuizType.primary ? '📖' : '📚';
  }

  String _typeLabel(QuizType type) {
    return type == QuizType.primary ? '漢字' : '読解';
  }
}
