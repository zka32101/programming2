import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart' show characterStateProvider;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import '../data/kokugo_characters.dart';
import '../models/quest_model.dart';
import '../providers/character_provider.dart';
import '../providers/premium_provider.dart';
import '../providers/progress_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_gate.dart';
import '../services/firebase_service.dart' show FirebaseService;

class QuestScreen extends ConsumerStatefulWidget {
  final Stage stage;
  const QuestScreen({super.key, required this.stage});

  @override
  ConsumerState<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends ConsumerState<QuestScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _correctCount = 0;
  bool _finishing = false;
  late DateTime _startTime;
  late AnimationController _feedbackCtrl;
  late Animation<double> _feedbackAnim;
  late Timer _timerRefresh;
  int _elapsedSeconds = 0;

  QuizQuestion get _current => widget.stage.questions[_currentIndex];
  bool get _isCorrect => _selectedAnswer == _current.correctIndex;

  // スピードラン判定：10問以上を2分以内
  bool get _isSpeedrunAchievable =>
    (_currentIndex + 1) >= 10 && _elapsedSeconds <= 120;

  bool get _isSpeedrunPossible =>
    widget.stage.questions.length >= 10 && (_elapsedSeconds + 30) <= 120;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _feedbackCtrl = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _feedbackAnim = CurvedAnimation(parent: _feedbackCtrl, curve: Curves.elasticOut);

    // タイマーを開始して毎秒経過時間を更新
    _timerRefresh = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _elapsedSeconds = DateTime.now().difference(_startTime).inSeconds;
        });
      }
    });
  }

  @override
  void dispose() {
    _timerRefresh.cancel();
    _feedbackCtrl.dispose();
    super.dispose();
  }

  void _onChoiceTap(int index) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (_isCorrect) _correctCount++;
    });
    _feedbackCtrl.forward(from: 0);
  }

  Future<void> _onNext() async {
    if (_currentIndex < widget.stage.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
      _feedbackCtrl.reset();
    } else {
      // 最後の問題の「つぎへ」を連打しても、結果画面への遷移（＝進捗保存）が
      // 二重に始まらないようにする。
      if (_finishing) return;
      _finishing = true;
      final elapsed = DateTime.now().difference(_startTime);
      final result = QuestResult(
        correctCount: _correctCount,
        totalCount: widget.stage.questions.length,
        elapsed: elapsed,
      );

      // Phase 4.12-4.14: Learning Time・ストリーク記録
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null && mounted) {
        try {
          final durationMinutes = elapsed.inSeconds ~/ 60;

          // Phase 4.12: Learning Time 記録（Dynamic Pricing 用）
          await FirebaseService().recordLearningSession(userId, durationMinutes);

          // Phase 4.13: Retention - ストリーク記録
          await FirebaseService().updateStreak(userId);
        } catch (e) {
          debugPrint('Learning session recording error: $e');
        }
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(
        '/result',
        arguments: {'result': result, 'stage': widget.stage},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 呼び出し元（おまかせミッション・スマートメニュー等）がステージのロック状態を
    // 事前にチェックしそびれていても、ここで最終的にブロックする
    // （StageCardのタップガードだけに頼らない防御的チェック）。
    final premium = ref.watch(premiumProvider);
    if (!premium.canAccessStage(widget.stage.stageNumber)) {
      return const PremiumLockedScreen(featureName: 'このステージ', featureEmoji: '📖');
    }

    final total = widget.stage.questions.length;
    final progress = (_currentIndex + (_answered ? 1 : 0)) / total;

    return Scaffold(
      appBar: AppBar(
        title: Text('ステージ ${widget.stage.stageNumber}'),
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('やめますか？'),
                content: const Text('今の進捗は保存されません。'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('続ける')),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                    child: const Text('やめる', style: TextStyle(color: kAccentRed)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
        children: [
          _ProgressBar(progress: progress, current: _currentIndex + 1, total: total),
          // スピードラン検出インジケーター
          if (widget.stage.questions.length >= 10)
            _SpeedrunIndicator(
              elapsedSeconds: _elapsedSeconds,
              isAchievable: _isSpeedrunAchievable,
              isPossible: _isSpeedrunPossible,
              questionsAnswered: _currentIndex + 1,
              totalQuestions: widget.stage.questions.length,
            ),
          const _FeaturedCharacterBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _QuestionCard(question: _current),
                  const SizedBox(height: 20),
                  ...List.generate(_current.choices.length, (i) {
                    return _ChoiceButton(
                      text: _current.choices[i],
                      index: i,
                      selected: _selectedAnswer,
                      correct: _answered ? _current.correctIndex : null,
                      onTap: () => _onChoiceTap(i),
                    );
                  }),
                  if (_answered) ...[
                    const SizedBox(height: 16),
                    ScaleTransition(
                      scale: _feedbackAnim,
                      child: _FeedbackCard(
                        isCorrect: _isCorrect,
                        explanation: _current.explanation,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCorrect ? kAccentGreen : kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        _currentIndex < total - 1 ? '次の問題へ →' : '結果を見る！',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  final int current;
  final int total;

  const _ProgressBar({required this.progress, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('問題 $current / $total', style: const TextStyle(color: kTextMuted, fontSize: 12)),
              Text('${(progress * 100).round()}%', style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

/// 育成中のキャラクター（最後にレベルアップしたキャラ）を表示するバナー。
/// 算数コレのクイズ画面での「育成中キャラ表示」に相当する。
class _FeaturedCharacterBanner extends ConsumerWidget {
  const _FeaturedCharacterBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredId = ref.watch(featuredCharacterProvider);
    final charStates = ref.watch(characterStateProvider);

    final unlockedIds = kKokugoCharacters
        .where((c) => charStates[c.id]?.isUnlocked ?? false)
        .map((c) => c.id);
    // featuredIdも解放済みキャラもまだ無ければ（例：最初のステージクリア前）、
    // 未解放キャラをあたかも育成中であるかのように表示しない。
    final characterId = featuredId ?? unlockedIds.firstOrNull;
    if (characterId == null) return const SizedBox.shrink();

    final character = kKokugoCharacters.firstWhere(
      (c) => c.id == characterId,
      orElse: () => kKokugoCharacters.first,
    );
    final state = charStates[character.id];
    final lvMaxImage = kKokugoCharactersLvMax[character.id];
    final displayImage =
        (state?.isMaxLevel ?? false) && lvMaxImage != null ? lvMaxImage : character.imageAsset;
    final level = state?.level ?? 1;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: (state?.hasSparkle ?? false)
            ? Border.all(color: Colors.amber.shade400, width: 2)
            : Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: displayImage != null
                    ? Image.asset(displayImage, fit: BoxFit.contain)
                    : const Icon(Icons.pets, size: 40, color: kTextMuted),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Lv.$level',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${character.name}といっしょにがんばろう！',
              style: const TextStyle(fontSize: 12, color: kTextDark, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final QuizQuestion question;
  const _QuestionCard({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          if (question.highlightChar != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: kPrimaryColor.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                question.highlightChar!,
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryDark,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (question.context != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kAccentBlue.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kAccentBlue.withAlpha(40)),
              ),
              child: Text(
                question.context!,
                style: const TextStyle(fontSize: 15, height: 1.7, color: kTextDark),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            question.question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kTextDark),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final String text;
  final int index;
  final int? selected;
  final int? correct;
  final VoidCallback onTap;

  const _ChoiceButton({
    required this.text,
    required this.index,
    required this.selected,
    required this.correct,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.grey.shade300;
    Color bgColor = Colors.white;
    Color textColor = kTextDark;
    Widget? trailingIcon;

    if (correct != null) {
      if (index == correct) {
        borderColor = kAccentGreen;
        bgColor = kAccentGreen.withAlpha(20);
        textColor = kAccentGreen;
        trailingIcon = const Icon(Icons.check_circle, color: kAccentGreen);
      } else if (index == selected && index != correct) {
        borderColor = kAccentRed;
        bgColor = kAccentRed.withAlpha(15);
        textColor = kAccentRed;
        trailingIcon = const Icon(Icons.cancel, color: kAccentRed);
      }
    } else if (selected == index) {
      borderColor = kPrimaryColor;
      bgColor = kPrimaryColor.withAlpha(20);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: borderColor.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: TextStyle(color: borderColor, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w500),
                ),
              ),
              ?trailingIcon,
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final bool isCorrect;
  final String explanation;

  const _FeedbackCard({required this.isCorrect, required this.explanation});

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? kAccentGreen : kAccentRed;
    final parts = explanation.split('\n\n');
    final mainText = parts.isNotEmpty ? parts[0] : explanation;
    final extraParts = parts.length > 1 ? parts.sublist(1) : <String>[];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                isCorrect ? '正解！' : '不正解',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (isCorrect) ...[
                const SizedBox(width: 6),
                Text('すごい！', style: TextStyle(color: color.withAlpha(180), fontSize: 13)),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(180),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      'かいせつ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  mainText,
                  style: const TextStyle(fontSize: 14, color: kTextDark, height: 1.6),
                ),
                for (final part in extraParts) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withAlpha(12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kPrimaryColor.withAlpha(30)),
                    ),
                    child: Text(
                      part,
                      style: const TextStyle(fontSize: 13, color: kTextDark, height: 1.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// スピードラン検出インジケーター（10問以上で利用可能）
/// 2分以内に10問クリアでスピードランバッジ獲得
class _SpeedrunIndicator extends StatelessWidget {
  final int elapsedSeconds;
  final bool isAchievable;
  final bool isPossible;
  final int questionsAnswered;
  final int totalQuestions;

  const _SpeedrunIndicator({
    required this.elapsedSeconds,
    required this.isAchievable,
    required this.isPossible,
    required this.questionsAnswered,
    required this.totalQuestions,
  });

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final timeRemaining = 120 - elapsedSeconds;
    final timeColor = isAchievable
        ? Colors.green
        : timeRemaining <= 30
            ? Colors.orange
            : Colors.blue;
    final isTimeExpired = elapsedSeconds > 120;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: timeColor.withAlpha(20),
      child: Row(
        children: [
          // タイムアイコン
          Text(
            isTimeExpired ? '⏱️' : '⚡',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 10),

          // 状態表示
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAchievable
                      ? '🎯 スピードラン達成可能！'
                      : isPossible
                          ? '⚡ スピードランの対象'
                          : isTimeExpired
                              ? '⏱️ 時間切れ'
                              : '⚡ スピードラン挑戦中',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: timeColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$questionsAnswered/$totalQuestions 問 • ${_formatTime(elapsedSeconds)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: timeColor.withAlpha(200),
                  ),
                ),
              ],
            ),
          ),

          // 時間表示（残り時間または経過時間）
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: timeColor.withAlpha(100),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isTimeExpired
                  ? '時間切れ'
                  : '残り ${_formatTime(timeRemaining)}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: timeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
