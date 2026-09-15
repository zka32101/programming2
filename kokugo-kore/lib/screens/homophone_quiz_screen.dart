import 'package:flutter/material.dart';
import '../data/homophone_data.dart';

import '../widgets/generic_quiz_widget.dart';

class HomophoneQuizScreen extends StatelessWidget {
  const HomophoneQuizScreen({super.key});

  static final _strippedItems = homophoneItems.map((item) {
    final strippedChoices = item.choices
        .map((c) => c.replaceAll(RegExp(r'（[^）]*）'), '').trim())
        .toList();
    return GenericQuizItem(
      question: item.question,
      questionSub: item.questionSub,
      highlight: item.highlight,
      choices: strippedChoices,
      correctIndex: item.correctIndex,
      explanation: item.explanation,
      grade: item.grade,
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    return GenericQuizScreen(
      title: '同音異義語クイズ',
      emoji: '🎭',
      themeColor: const Color(0xFF2980B9),
      allItems: _strippedItems,
      questionsPerRound: 10,
    );
  }
}
