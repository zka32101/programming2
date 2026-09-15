import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/reading_passages_data.dart';
import '../theme/app_theme.dart';
import 'comprehension_quiz_screen.dart';

class ReadingPassageScreen extends ConsumerStatefulWidget {
  final String passageId;

  final String title;

  const ReadingPassageScreen({
    super.key,
    required this.passageId,
    required this.title,
  });

  @override
  ConsumerState<ReadingPassageScreen> createState() => _ReadingPassageScreenState();
}

class _ReadingPassageScreenState extends ConsumerState<ReadingPassageScreen> {
  late ScrollController _scrollController;
  int _scrollPercentage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateScrollPercentage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollPercentage() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll <= 0) return;
    setState(() {
      _scrollPercentage = ((currentScroll / maxScroll) * 100).toInt().clamp(0, 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    final passage = findPassage(widget.passageId);

    if (passage == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('記事を読む'), backgroundColor: kPrimaryColor),
        body: const Center(child: Text('記事が見つかりませんでした', style: TextStyle(color: kTextMuted))),
      );
    }

    final minutes = (passage.estimatedReadingTimeSeconds / 60).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('記事を読む'),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
        children: [
          LinearProgressIndicator(
            value: _scrollPercentage / 100,
            minHeight: 3,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    passage.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('読む時間: $minutes分', style: const TextStyle(fontSize: 11, color: kTextMuted)),
                      const SizedBox(width: 16),
                      const Icon(Icons.school, size: 14, color: Colors.green),
                      const SizedBox(width: 4),
                      Text('推奨学年: 小${passage.grade}年生〜', style: const TextStyle(fontSize: 11, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    passage.content.trim(),
                    style: const TextStyle(fontSize: 14, height: 1.8, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showCompletionDialog(passage.title),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('読み終わった', style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  void _showCompletionDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('📖 記事を読み終わりました'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'この記事について、理解度クイズに答えてください。',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '💡 クイズに答えると、理解度が記録されます。',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('戻る'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ComprehensionQuizScreen(
                    passageId: widget.passageId,
                    passageTitle: title,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            child: const Text('クイズに答える', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
