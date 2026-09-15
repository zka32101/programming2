import 'package:flutter/material.dart';
import '../data/reading_passages_data.dart';

import '../models/reading_passage_model.dart';
import '../theme/app_theme.dart';
import 'reading_passage_screen.dart';

class ReadingMenuScreen extends StatefulWidget {
  const ReadingMenuScreen({super.key});

  @override
  State<ReadingMenuScreen> createState() => _ReadingMenuScreenState();
}

class _ReadingMenuScreenState extends State<ReadingMenuScreen> {
  String _selectedDifficulty = 'all'; // all, basic, standard, advanced

  List<ReadingPassage> get _filteredPassages {
    if (_selectedDifficulty == 'all') return readingPassages;
    return readingPassages.where((p) => p.difficulty == _selectedDifficulty).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('読解力トレーニング'),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            _buildDifficultySelector(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '記事を選択',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildArticlesList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimaryColor, kPrimaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📚 読解力を強化しよう',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '記事を読んで、理解度クイズ・要約・表現・構造トレーニングに挑戦しましょう',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('難易度を選択', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDifficultyButton('すべて', 'all'),
                const SizedBox(width: 8),
                _buildDifficultyButton('初級', 'basic'),
                const SizedBox(width: 8),
                _buildDifficultyButton('中級', 'standard'),
                const SizedBox(width: 8),
                _buildDifficultyButton('上級', 'advanced'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyButton(String label, String value) {
    final isSelected = _selectedDifficulty == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedDifficulty = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildArticlesList() {
    final passages = _filteredPassages;
    if (passages.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text('この難易度の記事はまだありません', style: TextStyle(color: kTextMuted))),
      );
    }
    return Column(
      children: passages.map((p) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ArticleCard(
            passage: p,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ReadingPassageScreen(passageId: p.passageId, title: p.title),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final ReadingPassage passage;
  final VoidCallback onTap;

  const _ArticleCard({required this.passage, required this.onTap});

  String get _difficultyLabel => switch (passage.difficulty) {
        'basic' => '初級',
        'standard' => '中級',
        _ => '上級',
      };

  Color get _difficultyColor => switch (passage.difficulty) {
        'basic' => Colors.green,
        'standard' => Colors.orange,
        _ => Colors.red,
      };

  String get _preview {
    final lines = passage.content.trim().split('\n').where((l) => l.trim().isNotEmpty).toList();
    // 1行目はタイトルの繰り返しなので2行目以降から抜粋
    final body = lines.length > 1 ? lines[1].trim() : (lines.isNotEmpty ? lines[0].trim() : '');
    return body.length > 46 ? '${body.substring(0, 46)}…' : body;
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (passage.estimatedReadingTimeSeconds / 60).round();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    passage.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _difficultyColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _difficultyLabel,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _difficultyColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _preview,
              style: const TextStyle(fontSize: 12, color: kTextMuted, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(passage.genre, style: const TextStyle(fontSize: 10)),
                  side: BorderSide(color: Colors.grey.shade300),
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('$minutes分', style: const TextStyle(fontSize: 11, color: kTextMuted)),
                    const SizedBox(width: 12),
                    const Icon(Icons.school, size: 14, color: kAccentGreen),
                    const SizedBox(width: 4),
                    Text('小${passage.grade}年生〜', style: const TextStyle(fontSize: 11, color: kAccentGreen)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
