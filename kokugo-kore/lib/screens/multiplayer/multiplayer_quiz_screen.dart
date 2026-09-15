import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart'
    show currentMatchProvider, watchMatchProvider, MatchState, QuizQuestion, Stage;

import '../../data/quiz_data.dart';
import '../../providers/multiplayer_provider.dart';
import '../../services/kokugo_matchmaking_service.dart';
import '../../theme/app_theme.dart';

class MultiplayerQuizScreen extends ConsumerStatefulWidget {
  final String matchId;

  const MultiplayerQuizScreen({required this.matchId, super.key});

  @override
  ConsumerState<MultiplayerQuizScreen> createState() => _MultiplayerQuizScreenState();
}

class _MultiplayerQuizScreenState extends ConsumerState<MultiplayerQuizScreen> {
  static const int totalQuestions = 10;

  List<QuizQuestion> _questions = const [];
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _answered = false;
  int _myScore = 0;
  bool _ratingUpdateTriggered = false;

  @override
  void initState() {
    super.initState();
    final identity = ref.read(kokugoPlayerIdentityProvider);
    _questions = _buildQuestionSet(grade: identity?.grade ?? 1, matchId: widget.matchId);
  }

  /// `matchId` をシードにした乱数で問題を選ぶことで、両プレイヤーに
  /// まったく同じ10問セット・同じ出題順を保証する。
  List<QuizQuestion> _buildQuestionSet({required int grade, required String matchId}) {
    final pool = <QuizQuestion>[
      for (final Stage stage in getStagesForGrade(grade)) ...stage.questions,
    ];
    final seed = matchId.hashCode;
    pool.shuffle(Random(seed));
    return pool.take(totalQuestions).toList();
  }

  void _selectAnswer(int index, MatchState match) {
    if (_answered || _questions.isEmpty) return;

    final identity = ref.read(kokugoPlayerIdentityProvider);
    if (identity == null) return;

    final question = _questions[_currentIndex];
    final isCorrect = index == question.correctIndex;

    setState(() {
      _selectedIndex = index;
      _answered = true;
      if (isCorrect) _myScore++;
    });

    final isLastQuestion = _currentIndex >= _questions.length - 1;
    final newScores = Map<String, int>.from(match.scores)..[identity.userId] = _myScore;

    ref.read(currentMatchProvider.notifier).updateMatchState(
          matchId: widget.matchId,
          scores: newScores,
          shouldComplete: isLastQuestion,
        );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (isLastQuestion) return;
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
        _answered = false;
      });
    });
  }

  /// マッチ終了を検知したら1回だけレーティングを更新する。
  ///
  /// 両プレイヤーが同時に呼ぶと二重にレートが動いてしまうため、
  /// `playerIds` の先頭（＝マッチ作成時に確定した先着側）のクライアントだけが
  /// 更新処理を担当する簡易的な排他制御。
  void _maybeUpdateRatings(MatchState match, String myUserId) {
    if (_ratingUpdateTriggered) return;
    if (!match.isFinished) return;
    if (match.playerIds.isEmpty || match.playerIds.first != myUserId) return;
    _ratingUpdateTriggered = true;
    KokugoMatchmakingService.updateRatingsAfterMatch(match);
  }

  @override
  Widget build(BuildContext context) {
    final identity = ref.watch(kokugoPlayerIdentityProvider);
    final matchAsync = ref.watch(watchMatchProvider(widget.matchId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('対戦クイズ'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: identity == null
          ? const Center(child: Text('プロフィールが見つかりません'))
          : matchAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('エラーが発生しました: $err')),
              data: (match) {
                if (match == null) {
                  return const Center(child: Text('対戦が見つかりませんでした'));
                }
                _maybeUpdateRatings(match, identity.userId);
                return _buildBody(match, identity.userId);
              },
            ),
    );
  }

  Widget _buildBody(MatchState match, String myUserId) {
    final myScore = match.scoreFor(myUserId);
    final opponentId = match.opponentOf(myUserId);
    final opponentScore = opponentId == null ? 0 : match.scoreFor(opponentId);

    return Column(
      children: [
        _buildScoreBoard(myScore: myScore, opponentScore: opponentScore),
        const SizedBox(height: 8),
        Expanded(
          child: match.isFinished ? _buildResultView(match, myUserId) : _buildQuizView(match),
        ),
      ],
    );
  }

  Widget _buildScoreBoard({required int myScore, required int opponentScore}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryColor, kPrimaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScoreCard('あなた', myScore, Colors.white),
          Column(
            children: [
              const Text('vs', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                '問題 ${min(_currentIndex + 1, _questions.length)}/${_questions.length}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          _buildScoreCard('相手', opponentScore, Colors.white70),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String label, int score, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('$score', style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildQuizView(MatchState match) {
    if (_questions.isEmpty) {
      return const Center(child: Text('問題が見つかりませんでした'));
    }
    final question = _questions[_currentIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              minHeight: 6,
              color: kPrimaryColor,
              backgroundColor: Colors.grey.shade200,
            ),
          ),
          const SizedBox(height: 20),
          if (question.context != null) ...[
            Text(question.context!, style: const TextStyle(fontSize: 14, color: kTextMuted)),
            const SizedBox(height: 8),
          ],
          Text(
            question.question,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ...List.generate(question.choices.length, (index) {
            final isSelected = _selectedIndex == index;
            final isCorrect = index == question.correctIndex;

            Color background = Colors.white;
            Color border = Colors.grey.shade300;
            if (_answered) {
              if (isCorrect) {
                background = kAccentGreen.withAlpha(30);
                border = kAccentGreen;
              } else if (isSelected) {
                background = kAccentRed.withAlpha(30);
                border = kAccentRed;
              }
            } else if (isSelected) {
              background = kPrimaryColor.withAlpha(30);
              border = kPrimaryColor;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: _answered ? null : () => _selectAnswer(index, match),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: background,
                    border: Border.all(color: border, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(question.choices[index], style: const TextStyle(fontSize: 16)),
                      ),
                      if (_answered && isCorrect)
                        const Icon(Icons.check_circle, color: kAccentGreen),
                      if (_answered && isSelected && !isCorrect)
                        const Icon(Icons.cancel, color: kAccentRed),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (_answered)
            Center(
              child: Text(
                _selectedIndex == question.correctIndex ? '✓ 正解！' : '✗ 不正解',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _selectedIndex == question.correctIndex ? kAccentGreen : kAccentRed,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultView(MatchState match, String myUserId) {
    final result = match.resultFor(myUserId);
    final myScore = match.scoreFor(myUserId);
    final opponentId = match.opponentOf(myUserId);
    final opponentScore = opponentId == null ? 0 : match.scoreFor(opponentId);

    final (label, color) = switch (result) {
      'win' => ('🎉 勝利！', kAccentGreen),
      'lose' => ('残念…敗北', kAccentRed),
      'draw' => ('引き分け', kAccentOrange),
      _ => ('🏁 終了', kTextMuted),
    };

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 16),
          Text('$myScore - $opponentScore', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.settings.name == '/multiplayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('マルチプレイに戻る', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
