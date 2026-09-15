import 'package:flutter/material.dart';
import '../data/synonym_antonym_data.dart';

import '../theme/app_theme.dart';
import '../widgets/generic_quiz_widget.dart';

class SynonymAntonymQuizScreen extends StatefulWidget {
  const SynonymAntonymQuizScreen({super.key});

  @override
  State<SynonymAntonymQuizScreen> createState() => _SynonymAntonymQuizScreenState();
}

class _SynonymAntonymQuizScreenState extends State<SynonymAntonymQuizScreen> {
  bool _isSynonym = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: kAccentTeal,
        foregroundColor: Colors.white,
        title: const Text('🔄 類義語・対義語クイズ',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // モード切替
          Container(
            color: kAccentTeal,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isSynonym = true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _isSynonym
                            ? Colors.white
                            : Colors.white.withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '🔵 類義語（同じ意味）',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isSynonym
                              ? kAccentTeal
                              : Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isSynonym = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !_isSynonym
                            ? Colors.white
                            : Colors.white.withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '🔴 対義語（反対の意味）',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: !_isSynonym
                              ? kAccentTeal
                              : Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            key: ValueKey(_isSynonym),
            child: GenericQuizScreen(
              title: _isSynonym ? '類義語クイズ' : '対義語クイズ',
              emoji: _isSynonym ? '🔵' : '🔴',
              themeColor: kAccentTeal,
              allItems: _isSynonym ? synonymItems : antonymItems,
              questionsPerRound: 10,
            ),
          ),
        ],
      ),
    );
  }
}
