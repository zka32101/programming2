import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'word_card_data.dart';

/// えいたんご カード画面。表=絵+日本語、タップで裏=英単語。
class WordCardsScreen extends StatefulWidget {
  final List<WordCard>? cards;
  final bool enableTts;
  const WordCardsScreen({super.key, this.cards, this.enableTts = true});

  @override
  State<WordCardsScreen> createState() => _WordCardsScreenState();
}

class _WordCardsScreenState extends State<WordCardsScreen> {
  FlutterTts? _tts;
  int _index = 0;
  bool _flipped = false;
  bool _done = false;

  List<WordCard> get _cards => widget.cards ?? animalWordCards;

  @override
  void initState() {
    super.initState();
    if (widget.enableTts) {
      try {
        _tts = FlutterTts();
        _tts!.setLanguage('en-US');
        _tts!.setSpeechRate(0.5);
      } catch (_) {
        _tts = null;
      }
    }
  }

  @override
  void dispose() {
    try {
      _tts?.stop();
    } catch (_) {}
    super.dispose();
  }

  void _speak() {
    try {
      _tts?.speak(_cards[_index].english);
    } catch (_) {}
  }

  void _go(int delta) {
    setState(() {
      final n = _index + delta;
      if (n < 0) return;
      if (n >= _cards.length) {
        _done = true;
        return;
      }
      _index = n;
      _flipped = false;
    });
  }

  void _restart() => setState(() {
        _index = 0;
        _flipped = false;
        _done = false;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('えいたんご カード')),
      body: SafeArea(child: _done ? _buildDone() : _buildCard()),
    );
  }

  Widget _buildDone() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉 ぜんぶ みたよ！',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Image.asset(wordCardRewardSticker,
                width: 140, height: 140, key: const Key('rewardSticker')),
            const SizedBox(height: 8),
            const Text('ごほうびシールをゲット！'),
            const SizedBox(height: 20),
            FilledButton(onPressed: _restart, child: const Text('もういちど')),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    final c = _cards[_index];
    final isLast = _index == _cards.length - 1;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text('${_index + 1}/${_cards.length}',
              key: const Key('progress'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: GestureDetector(
              key: const Key('flipCard'),
              onTap: () => setState(() => _flipped = !_flipped),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: _flipped
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(c.english,
                                key: const Key('backText'),
                                style: const TextStyle(
                                    fontSize: 56, fontWeight: FontWeight.bold)),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.asset(c.image, fit: BoxFit.contain),
                              ),
                              const SizedBox(height: 8),
                              Text(c.japanese,
                                  key: const Key('frontText'),
                                  style: const TextStyle(
                                      fontSize: 28, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              const Text('タップして めくろう',
                                  style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (widget.enableTts)
            OutlinedButton.icon(
              key: const Key('listenBtn'),
              onPressed: _speak,
              icon: const Icon(Icons.volume_up),
              label: const Text('きく'),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  key: const Key('prevBtn'),
                  onPressed: _index > 0 ? () => _go(-1) : null,
                  child: const Text('◀ まえへ'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  key: const Key('nextBtn'),
                  onPressed: () => _go(1),
                  child: Text(isLast ? 'おわり ✓' : 'つぎへ ▶'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
