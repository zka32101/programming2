import 'package:flutter/material.dart';
import '../data/grammar_data.dart';

import '../theme/app_theme.dart';
import '../widgets/generic_quiz_widget.dart';

enum _GrammarMode { joshi, setsuzoku, hinshi, okurigana, romaji }

extension _GrammarModeExt on _GrammarMode {
  String get label {
    switch (this) {
      case _GrammarMode.joshi: return '助詞';
      case _GrammarMode.setsuzoku: return '接続語';
      case _GrammarMode.hinshi: return '品詞';
      case _GrammarMode.okurigana: return '送りがな';
      case _GrammarMode.romaji: return 'ローマ字';
    }
  }

  String get emoji {
    switch (this) {
      case _GrammarMode.joshi: return '🔗';
      case _GrammarMode.setsuzoku: return '↔️';
      case _GrammarMode.hinshi: return '📝';
      case _GrammarMode.okurigana: return '✏️';
      case _GrammarMode.romaji: return 'abc';
    }
  }

  Color get color {
    switch (this) {
      case _GrammarMode.joshi: return const Color(0xFFE74C3C);
      case _GrammarMode.setsuzoku: return kAccentPurple;
      case _GrammarMode.hinshi: return kAccentTeal;
      case _GrammarMode.okurigana: return kAccentOrange;
      case _GrammarMode.romaji: return const Color(0xFF2980B9);
    }
  }

  List<GenericQuizItem> get items {
    switch (this) {
      case _GrammarMode.joshi: return joshiItems;
      case _GrammarMode.setsuzoku: return setsuzokulItems;
      case _GrammarMode.hinshi: return hinshiItems;
      case _GrammarMode.okurigana: return okuriganaItems;
      case _GrammarMode.romaji: return romajiItems;
    }
  }
}

class GrammarQuizScreen extends StatefulWidget {
  const GrammarQuizScreen({super.key});

  @override
  State<GrammarQuizScreen> createState() => _GrammarQuizScreenState();
}

class _GrammarQuizScreenState extends State<GrammarQuizScreen> {
  _GrammarMode? _selected;

  @override
  Widget build(BuildContext context) {
    if (_selected != null) {
      return GenericQuizScreen(
        key: ValueKey(_selected),
        title: _selected!.label,
        emoji: _selected!.emoji,
        themeColor: _selected!.color,
        allItems: _selected!.items,
        questionsPerRound: 10,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
        title: const Text('📖 文法・言葉クイズ',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'カテゴリを選ぼう',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50)),
            ),
          ),
          ..._GrammarMode.values.map((mode) => _ModeCard(
                mode: mode,
                onTap: () => setState(() => _selected = mode),
              )),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final _GrammarMode mode;
  final VoidCallback onTap;

  const _ModeCard({required this.mode, required this.onTap});

  String get _description {
    switch (mode) {
      case _GrammarMode.joshi:
        return 'は・が・を・に・で・へなど\n文の中での言葉の役割';
      case _GrammarMode.setsuzoku:
        return 'しかし・だから・そして\n文と文のつながりを学ぼう';
      case _GrammarMode.hinshi:
        return '動詞・名詞・形容詞・副詞\n言葉の種類を理解しよう';
      case _GrammarMode.okurigana:
        return '走る・明るい・終わる\n漢字の送りがなを完成させよう';
      case _GrammarMode.romaji:
        return 'a・i・u・e・o\nローマ字の読み書きをマスター';
    }
  }

  int get _questionCount {
    switch (mode) {
      case _GrammarMode.joshi: return joshiItems.length;
      case _GrammarMode.setsuzoku: return setsuzokulItems.length;
      case _GrammarMode.hinshi: return hinshiItems.length;
      case _GrammarMode.okurigana: return okuriganaItems.length;
      case _GrammarMode.romaji: return romajiItems.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: mode.color, width: 5)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: mode.color.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                mode.emoji,
                style: TextStyle(
                  fontSize: mode.emoji.length > 2 ? 18 : 24,
                  color: mode.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode.label,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _description,
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: mode.color.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_questionCount問',
                    style: TextStyle(
                        fontSize: 12,
                        color: mode.color,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
