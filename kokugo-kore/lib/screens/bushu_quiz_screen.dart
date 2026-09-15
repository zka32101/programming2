import 'package:flutter/material.dart';
import '../data/bushu_haiku_data.dart';

import '../theme/app_theme.dart';
import '../widgets/generic_quiz_widget.dart';

class BushuQuizScreen extends StatelessWidget {
  const BushuQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericQuizScreen(
      title: '部首クイズ',
      emoji: '🔑',
      themeColor: kAccentDarkRed,
      allItems: bushuItems,
      questionsPerRound: 10,
    );
  }
}
