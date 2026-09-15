import 'package:flutter/material.dart';
import '../data/bushu_haiku_data.dart';

import '../theme/app_theme.dart';
import '../widgets/generic_quiz_widget.dart';

class HaikuQuizScreen extends StatelessWidget {
  const HaikuQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericQuizScreen(
      title: '俳句・短歌クイズ',
      emoji: '🌸',
      themeColor: kAccentPink,
      allItems: haikuItems,
      questionsPerRound: 10,
    );
  }
}
