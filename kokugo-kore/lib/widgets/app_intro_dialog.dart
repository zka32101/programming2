// lib/widgets/app_intro_dialog.dart
// アプリの使い方を紹介するダイアログ。
// 初回起動時に自動表示され、設定画面の「このアプリの使い方」からも
// いつでも再表示できる（home_screen.dart / settings_screen.dart から呼び出し）。

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:kokugo_kore/widgets/ukalab_emoji.dart';

Future<void> showAppIntroDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Column(
        children: [
          Text('🎉', style: TextStyle(fontSize: 48)),
          SizedBox(height: 12),
          Text(
            'ようこそ！',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '小学コレ！国語は、\nひらがなから読解・作文までを\n楽しく学べるアプリです。',
              style: TextStyle(fontSize: 15, height: 1.6, color: kTextDark),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _IntroFeature(
              emoji: '🏠',
              title: 'ホーム',
              desc: '今日のミッションやステージから\nすぐに学習をはじめられます',
            ),
            SizedBox(height: 12),
            _IntroFeature(
              emoji: '📖',
              title: 'まなぶ',
              desc: 'ひらがな・漢字・ことば・文法など\nいろいろな学習とクイズを選べます',
            ),
            SizedBox(height: 12),
            _IntroFeature(
              emoji: '🐱',
              title: 'キャラクター',
              desc: '学習をすすめると\nなかまが増えて育てられます',
            ),
            SizedBox(height: 12),
            _IntroFeature(
              emoji: '🛍️',
              title: 'ショップ',
              desc: 'ためたコインで\nアイコンやテーマと交換できます',
            ),
            SizedBox(height: 12),
            _IntroFeature(
              emoji: '⚙️',
              title: 'せってい',
              desc: 'プロフィールや合格点の設定、\n保護者向けレポートを見られます',
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'はじめる！',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}

class _IntroFeature extends StatelessWidget {
  final String emoji;
  final String title;
  final String desc;

  const _IntroFeature({
    required this.emoji,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UkalabEmoji(emoji, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 11,
                  color: kTextMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
