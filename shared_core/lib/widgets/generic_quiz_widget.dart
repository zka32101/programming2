import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme_base.dart';

class GenericQuizItem {
  final String question;
  final String? questionSub;
  final String? highlight;
  final List<String> choices;
  final int correctIndex;
  final String explanation;
  final int? grade;

  const GenericQuizItem({
    required this.question,
    this.questionSub,
    this.highlight,
    required this.choices,
    required this.correctIndex,
    required this.explanation,
    this.grade,
  });
}

class GenericQuizScreen extends StatefulWidget {
  final String title;
  final String emoji;
  final Color themeColor;
  final List<GenericQuizItem> allItems;
  final int questionsPerRound;

  const GenericQuizScreen({
    super.key,
    required this.title,
    required this.emoji,
    required this.themeColor,
    required this.allItems,
    this.questionsPerRound = 10,
  });

  @override
  State<GenericQuizScreen> createState() => _GenericQuizScreenState();
}

class _GenericQuizScreenState extends State<GenericQuizScreen> {
  late List<GenericQuizItem> _questions;
  int _current = 0;
  int? _selected;
  bool _answered = false;
  int _correct = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  GenericQuizItem _shuffleChoices(GenericQuizItem item) {
    final choices = List<String>.from(item.choices);
    final indexMap = List.generate(choices.length, (i) => i);

    for (var i = choices.length - 1; i > 0; i--) {
      final j = Random().nextInt(i + 1);
      final temp = choices[i];
      choices[i] = choices[j];
      choices[j] = temp;

      final tempIdx = indexMap[i];
      indexMap[i] = indexMap[j];
      indexMap[j] = tempIdx;
    }

    final newCorrectIndex = indexMap.indexOf(item.correctIndex);

    return GenericQuizItem(
      question: item.question,
      questionSub: item.questionSub,
      highlight: item.highlight,
      choices: choices,
      correctIndex: newCorrectIndex,
      explanation: item.explanation,
      grade: item.grade,
    );
  }

  void _reset() {
    final shuffled = List<GenericQuizItem>.from(widget.allItems)..shuffle(Random());
    _questions = shuffled
        .take(widget.questionsPerRound)
        .map(_shuffleChoices)
        .toList();
    _current = 0;
    _selected = null;
    _answered = false;
    _correct = 0;
    _finished = false;
  }

  void _select(int index) {
    if (_answered) return;
    setState(() {
      _selected = index;
      _answered = true;
      if (index == _questions[_current].correctIndex) _correct++;
    });
  }

  void _next() {
    if (_current + 1 >= _questions.length) {
      setState(() => _finished = true);
    } else {
      setState(() {
        _current++;
        _selected = null;
        _answered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return _buildResult();

    final q = _questions[_current];
    return Scaffold(
      backgroundColor: kBgLight,
      appBar: AppBar(
        backgroundColor: widget.themeColor,
        foregroundColor: Colors.white,
        title: Text('${widget.emoji} ${widget.title}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_current + 1) / _questions.length,
            backgroundColor: Colors.white30,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_current + 1} / ${_questions.length}問',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                Row(
                  children: [
                    const Text('⭕️', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text('$_correct',
                        style: TextStyle(
                            color: widget.themeColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withAlpha(12),
                            blurRadius: 10,
                            offset: const Offset(0, 3))
                      ],
                    ),
                    child: Column(
                      children: [
                        if (q.highlight != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: widget.themeColor.withAlpha(20),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: widget.themeColor.withAlpha(80)),
                            ),
                            child: Text(
                              q.highlight!,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: widget.themeColor,
                              ),
                            ),
                          ),
                        Text(
                          q.question,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        if (q.questionSub != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            q.questionSub!,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(q.choices.length, (i) {
                    Color? bg;
                    Color textColor = kTextDark;
                    if (_answered) {
                      if (i == q.correctIndex) {
                        bg = kAccentGreen;
                        textColor = Colors.white;
                      } else if (i == _selected) {
                        bg = kAccentRed;
                        textColor = Colors.white;
                      } else {
                        bg = Colors.grey[100];
                        textColor = Colors.grey;
                      }
                    }
                    return GestureDetector(
                      onTap: () => _select(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: bg ?? Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _answered
                                ? Colors.transparent
                                : Colors.grey.shade200,
                          ),
                          boxShadow: _answered
                              ? []
                              : [
                                  BoxShadow(
                                      color: Colors.black.withAlpha(8),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2))
                                ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _answered
                                    ? Colors.white.withAlpha(40)
                                    : widget.themeColor.withAlpha(30),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                ['①', '②', '③', '④'][i],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _answered
                                      ? textColor
                                      : widget.themeColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                q.choices[i],
                                style: TextStyle(
                                    fontSize: 15,
                                    color: textColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            if (_answered && i == q.correctIndex)
                              const Text('✓',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            if (_answered &&
                                i == _selected &&
                                i != q.correctIndex)
                              const Text('✗',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  }),
                  if (_answered) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FFF4),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: kAccentGreen.withAlpha(100)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('💡 解説',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kAccentGreen)),
                          const SizedBox(height: 6),
                          Text(q.explanation,
                              style: const TextStyle(
                                  fontSize: 13, color: kTextDark)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.themeColor,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          _current + 1 >= _questions.length
                              ? '結果を見る'
                              : '次の問題',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final pct = (_correct / _questions.length * 100).round();
    final (rank, emoji, rankColor) = pct >= 90
        ? ('S', '🏆', const Color(0xFFFFD700))
        : pct >= 70
            ? ('A', '⭐', kAccentGreen)
            : pct >= 50
                ? ('B', '👍', widget.themeColor)
                : ('C', '💪', Colors.grey as Color);

    return Scaffold(
      backgroundColor: kBgLight,
      appBar: AppBar(
        backgroundColor: widget.themeColor,
        foregroundColor: Colors.white,
        title: Text('${widget.emoji} ${widget.title}'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 72)),
              const SizedBox(height: 8),
              Text(
                rank,
                style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: rankColor),
              ),
              const SizedBox(height: 16),
              Text(
                '$_correct / ${_questions.length}問正解',
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                '正答率 $pct%',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.home),
                      label: const Text('もどる'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: widget.themeColor,
                        side: BorderSide(color: widget.themeColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => setState(_reset),
                      icon: const Icon(Icons.refresh),
                      label: const Text('もう一度'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.themeColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
