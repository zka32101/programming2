// lib/widgets/app_intro_dialog.dart
// アプリの使い方を紹介するダイアログ。
// 初回起動時に自動表示され、設定画面の「このアプリの使い方」からも
// いつでも再表示できる（home_screen.dart / settings_screen.dart から呼び出し）。

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
              emoji: '💡',
              title: 'わかる',
              desc: '知識を一覧で確認\nひらがな・漢字などを学べます',
            ),
            SizedBox(height: 12),
            _IntroFeature(
              emoji: '❓',
              title: 'といて',
              desc: 'クイズで練習\n10問ずつチャレンジしましょう',
            ),
            SizedBox(height: 12),
            _IntroFeature(
              emoji: '🏅',
              title: 'ためる',
              desc: 'バッジやコイン\nがくしゅうで毎日増えます',
            ),
            SizedBox(height: 12),
            _IntroFeature(
              emoji: '🔥',
              title: 'つづける',
              desc: 'れんぞく記録\n毎日つづけるとレベルアップ',
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
        Text(emoji, style: const TextStyle(fontSize: 20)),
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
