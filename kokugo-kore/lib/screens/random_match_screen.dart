import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RandomMatchScreen extends StatefulWidget {
  const RandomMatchScreen({super.key});

  @override
  State<RandomMatchScreen> createState() => _RandomMatchScreenState();
}

class _RandomMatchScreenState extends State<RandomMatchScreen> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ランダムマッチ'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Center(
        child: _isSearching ? _buildSearching() : _buildSearchButton(),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.person_add, size: 64, color: kPrimaryColor),
        const SizedBox(height: 24),
        const Text(
          '練習相手を探す',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'あなたのレベルに合わせたAI練習相手が見つかります\n（実際のユーザーとのオンライン対戦ではありません）',
          style: TextStyle(fontSize: 14, color: kTextMuted),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            setState(() => _isSearching = true);
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('練習相手が見つかりました！'),
                    content: const Text(
                      'AI（練習相手）が見つかりました。対戦を開始しますか？\n'
                      '※ これはオフラインの練習対戦です。実在のユーザーとの対戦ではありません。',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() => _isSearching = false);
                        },
                        child: const Text('キャンセル'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('対戦を開始しました！')),
                          );
                        },
                        child: const Text('対戦開始'),
                      ),
                    ],
                  ),
                );
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          child: const Text('探す', style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildSearching() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: kPrimaryColor),
        const SizedBox(height: 24),
        const Text(
          '相手を探しています...',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => setState(() => _isSearching = false),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          child: const Text('キャンセル', style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ],
    );
  }
}
