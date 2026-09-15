import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/reading_passages_data.dart';
import '../models/reading_passage_model.dart';
import '../providers/coin_provider.dart';
import '../theme/app_theme.dart';
import 'summary_training_screen.dart';

class ComprehensionQuizScreen extends ConsumerStatefulWidget {
  final String passageId;

  final String passageTitle;

  const ComprehensionQuizScreen({
    super.key,
    required this.passageId,
    required this.passageTitle,
  });

  @override
  ConsumerState<ComprehensionQuizScreen> createState() => _ComprehensionQuizScreenState();
}

String _typeLabel(String questionType) => switch (questionType) {
      'vocabulary' => '語彙問題',
      'summary' => '要約問題',
      'structure' => '構造問題',
      'expression' => '表現問題',
      _ => '読解問題',
    };

class _ComprehensionQuizScreenState extends ConsumerState<ComprehensionQuizScreen> {
  int _currentQuestion = 0;
  int _correctCount = 0;
  String? _selectedAnswer;
  bool _answered = false;
  bool _rewarded = false;

  late final List<ComprehensionQuestion> _quiz =
      comprehensionQuestionsFor(widget.passageId);

  @override
  Widget build(BuildContext context) {
    if (_quiz.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('理解度クイズ'), backgroundColor: kPrimaryColor),
        body: const Center(child: Text('クイズが見つかりませんでした', style: TextStyle(color: kTextMuted))),
      );
    }
    if (_currentQuestion >= _quiz.length) {
      return _buildResultScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('理解度クイズ'),
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(child: _buildQuizContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '問題 ${_currentQuestion + 1}/${_quiz.length}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                '${((_currentQuestion / _quiz.length) * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 12, color: kTextMuted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _currentQuestion / _quiz.length,
              minHeight: 6,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizContent() {
    final current = _quiz[_currentQuestion];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: kPrimaryColor.withAlpha(25),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _typeLabel(current.questionType),
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kPrimaryColor),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            current.questionText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.6),
          ),
          const SizedBox(height: 24),
          if (!_answered) ...[
            ...current.choices.map((choice) => _buildChoiceButton(choice)),
          ] else ...[
            _buildAnswerResult(current),
          ],
          const SizedBox(height: 24),
          if (_answered)
            ElevatedButton(
              onPressed: _goToNextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                _currentQuestion == _quiz.length - 1 ? '結果を見る' : '次の問題へ',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            )
          else
            ElevatedButton(
              onPressed: _selectedAnswer != null ? _submitAnswer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('答える', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
        ],
      ),
    );
  }

  Widget _buildChoiceButton(String choice) {
    final index = _quiz[_currentQuestion].choices.indexOf(choice);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => setState(() => _selectedAnswer = choice),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _selectedAnswer == choice ? Colors.blue.shade50 : Colors.white,
            border: Border.all(
              color: _selectedAnswer == choice ? kPrimaryColor : Colors.grey.shade300,
              width: _selectedAnswer == choice ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _selectedAnswer == choice ? kPrimaryColor : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(choice, style: const TextStyle(fontSize: 13))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerResult(ComprehensionQuestion current) {
    final isCorrect = _selectedAnswer == current.correctAnswer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
            border: Border.all(color: isCorrect ? Colors.green : Colors.red, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Text(
                isCorrect ? '✓' : '✗',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isCorrect ? Colors.green : Colors.red),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCorrect ? '正解です！' : '不正解です',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isCorrect ? Colors.green : Colors.red),
                    ),
                    if (!isCorrect) ...[
                      const SizedBox(height: 4),
                      Text('正解: ${current.correctAnswer}', style: const TextStyle(fontSize: 12, color: Colors.red)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            current.explanation,
            style: const TextStyle(fontSize: 12, height: 1.6, color: kTextMuted),
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    final accuracy = ((_correctCount / _quiz.length) * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('クイズ結果'),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accuracy >= 70 ? Colors.green.shade50 : Colors.orange.shade50,
                  border: Border.all(color: accuracy >= 70 ? Colors.green : Colors.orange, width: 2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$accuracy%',
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: accuracy >= 70 ? Colors.green : Colors.orange),
                      ),
                      const SizedBox(height: 4),
                      Text('正答率', style: TextStyle(fontSize: 12, color: accuracy >= 70 ? Colors.green : Colors.orange)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                accuracy >= 90 ? '素晴らしい！' : accuracy >= 70 ? 'よくできました！' : 'もう一度読んでみましょう',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text('$_correctCount問中${_quiz.length}問正解しました', style: const TextStyle(fontSize: 14, color: kTextMuted)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    _buildResultRow('正答数', '$_correctCount/${_quiz.length}'),
                    const Divider(),
                    _buildResultRow('正答率', '$accuracy%'),
                    const Divider(),
                    _buildResultRow('獲得コイン', '${_correctCount * 10}コイン'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SummaryTrainingScreen(
                        passageId: widget.passageId,
                        passageTitle: widget.passageTitle,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('要約・表現トレーニングへ', style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst || r.settings.name == '/reading'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('メニューに戻る'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kPrimaryColor)),
        ],
      ),
    );
  }

  void _submitAnswer() {
    final current = _quiz[_currentQuestion];
    if (_selectedAnswer == current.correctAnswer) {
      _correctCount++;
    }
    setState(() => _answered = true);
  }

  void _goToNextQuestion() {
    setState(() {
      _currentQuestion++;
      _selectedAnswer = null;
      _answered = false;
    });
    // 「獲得ポイント」表示は以前、実際のコイン残高には一切反映されない
    // 見せかけの数字だった。ここでクイズ完了の瞬間（一度だけ）に本当に
    // コインを付与する。
    if (_currentQuestion >= _quiz.length && !_rewarded) {
      _rewarded = true;
      ref.read(coinProvider.notifier).addCoins(_correctCount * 10);
    }
  }
}
