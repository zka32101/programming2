// lib/screens/writing_screen.dart
// かく練習: 文字選択 → DrawingCanvasScreen で自動採点 (80点以上でクリア)

import 'package:flutter/material.dart';
import '../screens/drawing_canvas_screen.dart';

import '../theme/app_theme.dart';

enum _WritingMode { hiragana, katakana, kanji }

const _hiraganaChars = [
  ('あ', 'ア'), ('い', 'イ'), ('う', 'ウ'), ('え', 'エ'), ('お', 'オ'),
  ('か', 'カ'), ('き', 'キ'), ('く', 'ク'), ('け', 'ケ'), ('こ', 'コ'),
  ('さ', 'サ'), ('し', 'シ'), ('す', 'ス'), ('せ', 'セ'), ('そ', 'ソ'),
  ('た', 'タ'), ('ち', 'チ'), ('つ', 'ツ'), ('て', 'テ'), ('と', 'ト'),
];

const _katakanaChars = [
  ('ア', 'a'), ('イ', 'i'), ('ウ', 'u'), ('エ', 'e'), ('オ', 'o'),
  ('カ', 'ka'), ('キ', 'ki'), ('ク', 'ku'), ('ケ', 'ke'), ('コ', 'ko'),
  ('サ', 'sa'), ('シ', 'shi'), ('ス', 'su'), ('セ', 'se'), ('ソ', 'so'),
  ('タ', 'ta'), ('チ', 'chi'), ('ツ', 'tsu'), ('テ', 'te'), ('ト', 'to'),
];

const _highlightChars = [
  ('山', 'やま'), ('川', 'かわ'), ('火', 'ひ'), ('木', 'き'), ('日', 'ひ'),
  ('月', 'つき'), ('人', 'ひと'), ('口', 'くち'), ('田', 'た'),
];

class WritingScreen extends StatefulWidget {
  const WritingScreen({super.key});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  _WritingMode _mode = _WritingMode.hiragana;
  final Map<int, int> _scores = {};
  int _correct = 0;

  List<(String, String)> get _charList {
    switch (_mode) {
      case _WritingMode.hiragana:
        return _hiraganaChars;
      case _WritingMode.katakana:
        return _katakanaChars;
      case _WritingMode.kanji:
        return _highlightChars;
    }
  }

  void _switchMode(_WritingMode m) {
    if (_mode == m) return;
    setState(() {
      _mode = m;
      _scores.clear();
      _correct = 0;
    });
  }

  Future<void> _openCanvas(int index) async {
    final (char, reading) = _charList[index];
    final score = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => DrawingCanvasScreen(character: char, prompt: reading),
      ),
    );
    if (score != null && mounted) {
      final alreadyPassed = (_scores[index] ?? 0) >= 80;
      setState(() {
        _scores[index] = score;
        if (score >= 80 && !alreadyPassed) _correct++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chars = _charList;
    final total = chars.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'かく',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kAccentRed,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: kBgLight,
      body: Column(
        children: [
          // Mode selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ModeChip(
                  label: 'ひらがな',
                  selected: _mode == _WritingMode.hiragana,
                  onTap: () => _switchMode(_WritingMode.hiragana),
                ),
                const SizedBox(width: 8),
                _ModeChip(
                  label: 'カタカナ',
                  selected: _mode == _WritingMode.katakana,
                  onTap: () => _switchMode(_WritingMode.katakana),
                ),
                const SizedBox(width: 8),
                _ModeChip(
                  label: '漢字',
                  selected: _mode == _WritingMode.kanji,
                  onTap: () => _switchMode(_WritingMode.kanji),
                ),
              ],
            ),
          ),
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '$_correct / $total クリア',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold, color: kTextDark),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: total > 0 ? _correct / total : 0,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(kAccentRed),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Grid of character cards
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 40),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 0.85,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: chars.length,
              itemBuilder: (_, index) {
                final (char, reading) = chars[index];
                final score = _scores[index];
                final passed = score != null && score >= 80;
                final attempted = score != null;
                return GestureDetector(
                  onTap: () => _openCanvas(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: passed
                          ? kAccentGreen.withOpacity(0.08)
                          : (attempted ? kAccentRed.withOpacity(0.05) : Colors.white),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: passed
                            ? kAccentGreen
                            : (attempted ? kAccentRed : Colors.transparent),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 4,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          char,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: kTextDark),
                        ),
                        const SizedBox(height: 2),
                        if (passed)
                          const Icon(Icons.check_circle,
                              color: kAccentGreen, size: 16)
                        else if (attempted)
                          Text('$score',
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: kAccentRed,
                                  fontWeight: FontWeight.bold))
                        else
                          Text(reading,
                              style: const TextStyle(
                                  fontSize: 9, color: kTextMuted)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Bottom hint
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'もじをタップしてれんしゅうしよう！',
              style: TextStyle(fontSize: 12, color: kTextMuted),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? kAccentRed : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? kAccentRed : Colors.grey.shade300),
          boxShadow: selected
              ? [BoxShadow(color: kAccentRed.withAlpha(40), blurRadius: 6, offset: const Offset(0, 2))]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : kTextMuted,
          ),
        ),
      ),
    );
  }
}
