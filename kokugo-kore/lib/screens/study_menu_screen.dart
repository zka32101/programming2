// lib/screens/study_menu_screen.dart
// Study menu: grid of learning activities

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/kana_data.dart';
import '../theme/app_theme.dart';
import '../widgets/banner_ad_widget.dart';
import '../providers/premium_provider.dart';

class _StudyItem {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final String route;
  final Object? args;
  final bool isPremium;

  const _StudyItem({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.route,
    this.args,
    this.isPremium = false,
  });
}

final List<_StudyItem> _studyItems = [
  // わかる を先頭に
  _StudyItem(
    emoji: '💡',
    title: 'わかる',
    subtitle: '国語の知識を深めよう',
    color: const Color(0xFF3498DB),
    route: '/learn',
  ),
  _StudyItem(
    emoji: 'あ',
    title: 'ひらがな',
    subtitle: 'ひらがなを おぼえよう',
    color: kAccentGreen,
    route: '/kana',
    args: KanaType.hiragana,
  ),
  _StudyItem(
    emoji: 'ア',
    title: 'カタカナ',
    subtitle: 'カタカナを おぼえよう',
    color: kAccentBlue,
    route: '/kana',
    args: KanaType.katakana,
  ),
  _StudyItem(
    emoji: 'abc',
    title: 'ローマ字',
    subtitle: 'ローマ字の読み書き',
    color: const Color(0xFF9B59B6),
    route: '/kana',
    args: KanaType.romaji,
  ),
  _StudyItem(
    emoji: 'ABC',
    title: 'アルファベット',
    subtitle: 'A〜Zを おぼえよう',
    color: kAccentPurple,
    route: '/kana',
    args: KanaType.alphabet,
  ),
  _StudyItem(
    emoji: '漢',
    title: 'かんじ',
    subtitle: '漢字を みる・おぼえる・かく',
    color: kPrimaryColor,
    route: '/kanji',
    isPremium: true,
  ),
  _StudyItem(
    emoji: '🔤',
    title: '漢字（かんじ）のよみ',
    subtitle: 'かんじのよみかたをマスターしよう',
    color: kAccentDarkRed,
    route: '/stages',
    args: {'type': 'kanji'},
  ),
  _StudyItem(
    emoji: '📚',
    title: 'よむ（読解）',
    subtitle: 'ぶんしょうをよんでもんだいにこたえよう',
    color: const Color(0xFF1ABC9C),
    route: '/stages',
    args: {'type': 'reading'},
  ),
  _StudyItem(
    emoji: '📖',
    title: '読解力強化',
    subtitle: 'きじをよんで理解度クイズ・要約・表現をきたえよう',
    color: kAccentTeal,
    route: '/reading',
  ),
  _StudyItem(
    emoji: '💬',
    title: 'ことば（語彙）',
    subtitle: 'ことばのいみをクイズでおぼえよう',
    color: kAccentOrange,
    route: '/vocabulary',
  ),
  _StudyItem(
    emoji: '🏮',
    title: 'ことわざクイズ',
    subtitle: 'ことわざのいみをまなぼう（10もんずつ）',
    color: kAccentTeal,
    route: '/proverb-quiz',
  ),
  _StudyItem(
    emoji: '🗣️',
    title: '慣用句（かんようく）クイズ',
    subtitle: 'かんようくのいみをまなぼう（10もんずつ）',
    color: const Color(0xFF2980B9),
    route: '/idiom-quiz',
  ),
  _StudyItem(
    emoji: '🎴',
    title: '四字熟語（よじじゅくご）',
    subtitle: '4つのかんじのことばをマスター',
    color: kAccentPurple,
    route: '/yojijukugo-quiz',
  ),
  _StudyItem(
    emoji: '🔄',
    title: '類義語・対義語',
    subtitle: 'はんたいのことば・にたことばをまなぼう',
    color: kAccentTeal,
    route: '/synonym-antonym-quiz',
  ),
  _StudyItem(
    emoji: '🎭',
    title: '同音異義語（どうおんいぎご）',
    subtitle: 'おなじよみでちがうかんじのことば',
    color: const Color(0xFF2980B9),
    route: '/homophone-quiz',
    isPremium: true,
  ),
  _StudyItem(
    emoji: '📖',
    title: '文法（ぶんぽう）クイズ',
    subtitle: 'じょし・ひんし・おくりがな・ローマ字',
    color: const Color(0xFF2C3E50),
    route: '/grammar-quiz',
    isPremium: true,
  ),
  _StudyItem(
    emoji: '🔑',
    title: '部首（ぶしゅ）クイズ',
    subtitle: 'かんじのなりたちをまなぼう',
    color: kAccentDarkRed,
    route: '/bushu-quiz',
    isPremium: true,
  ),
  _StudyItem(
    emoji: '🌸',
    title: '俳句・短歌（はいく・たんか）',
    subtitle: 'きご・五七五・ひゃくにんいっしゅ',
    color: kAccentPink,
    route: '/haiku-quiz',
    isPremium: true,
  ),
  _StudyItem(
    emoji: '🤖',
    title: 'AI漢字相談',
    subtitle: 'AIに漢字について質問しよう',
    color: const Color(0xFF8E44AD),
    route: '/ai-kanji-consultation',
    isPremium: true,
  ),
];

class StudyMenuScreen extends StatelessWidget {
  const StudyMenuScreen({super.key});

  void _navigate(BuildContext context, _StudyItem item) {
    Navigator.pushNamed(context, item.route, arguments: item.args);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'まなぶ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: kBgLight,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _studyItems.length,
        itemBuilder: (context, index) {
          final item = _studyItems[index];
          return _StudyCard(
            item: item,
            onTap: () => _navigate(context, item),
          );
        },
      ),
          ),
          const BannerAdWidget(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _StudyCard extends StatelessWidget {
  final _StudyItem item;
  final VoidCallback onTap;

  const _StudyCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(color: item.color, width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              item.emoji,
              style: TextStyle(
                fontSize: item.emoji.length > 2 ? 20 : 28,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.subtitle,
                    style: const TextStyle(fontSize: 11, color: kTextMuted),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (item.isPremium) ...[
              const SizedBox(width: 8),
              Tooltip(
                message: 'プレミアム機能',
                child: Icon(
                  Icons.lock_outline,
                  color: Colors.amber.shade700,
                  size: 20,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
