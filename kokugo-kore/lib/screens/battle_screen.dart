import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/battle_provider.dart';
import '../providers/badge_provider.dart';
import '../providers/badge_metrics_provider.dart';
import '../models/quest_model.dart';
import '../theme/app_theme.dart';
import '../data/quiz_data.dart';

/// このバトル画面は実際の対人・対サーバー通信を行わない、
/// オフラインの「AI（練習相手）」との自己ベスト挑戦モードです。
/// 相手のスコアは通信結果ではなく、練習相手を模したランダム加算です。
class BattleScreen extends ConsumerStatefulWidget {
  final String opponentId;
  final String opponentName;

  /// 出題対象の学年（未指定の場合はランダムな学年から出題）
  final int? grade;

  const BattleScreen({
    super.key,
    required this.opponentId,
    required this.opponentName,
    this.grade,
  });

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  int _currentRound = 1;
  final int _totalRounds = 5;
  int _playerScore = 0;
  int _opponentScore = 0;
  String? _selectedAnswer;
  bool _answered = false;

  late final List<QuizQuestion> _questions;

  QuizQuestion get _currentQuestion => _questions[_currentRound - 1];
  List<String> get _choices => _currentQuestion.choices;
  int get _correctAnswerIndex => _currentQuestion.correctIndex;

  @override
  void initState() {
    super.initState();
    _questions = _pickRandomQuestions(_totalRounds);
  }

  /// 既存のクイズデータ（漢字・語彙など）からランダムに出題を選ぶ
  List<QuizQuestion> _pickRandomQuestions(int count) {
    final grade = widget.grade ?? (Random().nextInt(6) + 1);
    final pool = <QuizQuestion>[
      for (final stage in getStagesForGrade(grade)) ...stage.questions,
    ];
    pool.shuffle();
    if (pool.length >= count) {
      return pool.take(count).toList();
    }
    // 問題数が不足する場合は他の学年からも補充する
    final fallback = <QuizQuestion>[
      for (var g = 1; g <= 6; g++)
        for (final stage in getStagesForGrade(g)) ...stage.questions,
    ]..shuffle();
    return fallback.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI（練習相手）と対戦中...'),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // スコアボード
            _buildScoreboard(),

            // ラウンドプログレス
            _buildRoundProgress(),

            // クイズコンテンツ
            Expanded(
              child: _buildQuizContent(),
            ),
          ],
        ),
      ),
    );
  }

  /// スコアボード
  Widget _buildScoreboard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimaryColor, kPrimaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // プレイヤー1（自分）
          _buildScoreColumn('あなた', _playerScore, true),

          // VS
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'VS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // プレイヤー2（AI練習相手）
          _buildScoreColumn('AI（${widget.opponentName}）', _opponentScore, false),
        ],
      ),
    );
  }

  Widget _buildScoreColumn(String name, int score, bool isPlayer) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(score.toString(), style: const TextStyle(fontSize: 24, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// ラウンドプログレス
  Widget _buildRoundProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ラウンド $_currentRound / $_totalRounds',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                '${((_currentRound / _totalRounds) * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 12, color: kTextMuted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _currentRound / _totalRounds,
              minHeight: 6,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  /// クイズコンテンツ
  Widget _buildQuizContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 問題文
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '問題',
                  style: TextStyle(fontSize: 12, color: kTextMuted),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentQuestion.question,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 選択肢
          const Text(
            '答えを選択してください',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._buildChoices(),
          const SizedBox(height: 24),

          // 送信ボタン
          if (_answered)
            _buildAnswerResult()
          else
            ElevatedButton(
              onPressed: _selectedAnswer != null ? _submitAnswer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '答えを送信',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  /// 選択肢ボタン
  List<Widget> _buildChoices() {
    return List.generate(_choices.length, (index) {
      final choice = _choices[index];
      final isSelected = _selectedAnswer == choice;
      final isCorrect = index == _correctAnswerIndex;
      final isAnswered = _answered;

      Color borderColor = Colors.grey.shade300;
      Color? bgColor;

      if (isAnswered) {
        if (isCorrect) {
          borderColor = Colors.green;
          bgColor = Colors.green.shade50;
        } else if (isSelected && !isCorrect) {
          borderColor = Colors.red;
          bgColor = Colors.red.shade50;
        }
      } else if (isSelected) {
        borderColor = kPrimaryColor;
        bgColor = Colors.blue.shade50;
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: isAnswered ? null : () => _selectAnswer(choice),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bgColor ?? Colors.white,
              border: Border.all(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    choice,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                if (isAnswered && isCorrect) ...[
                  const Icon(Icons.check_circle, color: Colors.green),
                ] else if (isAnswered && isSelected && !isCorrect) ...[
                  const Icon(Icons.cancel, color: Colors.red),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }

  /// 答え結果表示
  Widget _buildAnswerResult() {
    final isCorrect = _selectedAnswer == _choices[_correctAnswerIndex];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.red,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                isCorrect ? '✓' : '✗',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isCorrect ? '正解です！' : '不正解です',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _currentQuestion.explanation,
            style: const TextStyle(fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _goToNextRound,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              '次へ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _selectAnswer(String choice) {
    setState(() => _selectedAnswer = choice);
  }

  void _submitAnswer() {
    final isCorrect = _selectedAnswer == _choices[_correctAnswerIndex];
    setState(() {
      _answered = true;
      if (isCorrect) {
        _playerScore += 10;
      }
      // AI練習相手のスコアは実際の対戦通信ではなく、
      // 疑似的な難易度演出としてランダムに加算している（仮実装）
      if (Random().nextBool()) {
        _opponentScore += 10;
      }
    });
  }

  void _goToNextRound() {
    if (_currentRound < _totalRounds) {
      setState(() {
        _currentRound++;
        _selectedAnswer = null;
        _answered = false;
      });
    } else {
      _showBattleResult();
    }
  }

  void _showBattleResult() async {
    final playerWon = _playerScore > _opponentScore;

    // 勝利時はマルチプレイ勝利数を増やしてバッジをチェック
    if (playerWon) {
      await ref.read(badgeMetricsProvider.notifier).incrementMultiplayerWins();

      // Phase 2+ 社交バッジチェック
      final metricsState = ref.read(badgeMetricsProvider);
      await ref.read(badgeProvider.notifier).checkSocialBadges(
        friendInviteCount: metricsState.friendInvites,
        multiplayerWins: metricsState.multiplayerWins,
        isTopTenRanker: metricsState.isTopTenRanker,
      );
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('AI（練習相手）との対戦終了'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(
              playerWon ? '🎉 勝利！' : _playerScore == _opponentScore ? '🤝 同点' : '😢 敗北',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildResultColumn('あなた', _playerScore),
                _buildResultColumn('AI（${widget.opponentName}）', _opponentScore),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '※ この対戦はオフラインの練習モードです。実際のユーザーとは対戦していません。',
              style: TextStyle(fontSize: 11, color: kTextMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('戻る'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            child: const Text('ホームに戻る', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildResultColumn(String name, int score) {
    return Column(
      children: [
        Text(name, style: const TextStyle(fontSize: 12, color: kTextMuted)),
        const SizedBox(height: 4),
        Text(
          score.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPrimaryColor),
        ),
      ],
    );
  }
}
