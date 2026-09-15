import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart'
    show
        AnalyticsDashboardWidget,
        AccuracyTrendData,
        AddFriendDialog,
        CrossPromoSection,
        DailyActivityData,
        FeedbackFormPage,
        NotificationSettingsPage,
        requireParentalGate,
        RetentionDashboard,
        ScreenTimeSettingsWidget;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/kana_data.dart';
import '../providers/drawing_progress_provider.dart';
import '../providers/coin_provider.dart';
import '../providers/referral_provider.dart';
import '../providers/drawing_settings_provider.dart';
import '../providers/premium_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/sound_provider.dart';
import '../providers/purchased_items_provider.dart';
import '../providers/ranking_privacy_provider.dart';
import '../providers/vocab_mastery_provider.dart';
import '../providers/profile_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_intro_dialog.dart';

const _appVersion = '1.4.0';

const _changelog = <String, List<String>>{
  '1.4.0': [
    'アプリ名を「小学コレ！国語」に変更',
    '読解力強化トレーニングを実際の記事・クイズと接続',
    'アバターアイコンを一新',
    'キャラクターのレベル別イラスト表示に対応',
    'キャラゲット・レベルアップ時の演出を追加',
    'アプリ内課金の価格表示・エラー表示を改善',
    '書き順アニメーション表示を追加（ひらがな・カタカナ・漢字）',
    '初回起動時の説明画面を追加',
  ],
  '1.3.0': [
    '親向けダッシュボード追加（学習分析・進捗グラフ・ペース推奨）',
    'マルチプレイ追加（友達バトル・リアルタイム対戦・リーダーボード）',
    '読解力強化トレーニング追加（記事読解・理解度クイズ・要約訓練）',
    'クイズコンテンツを90問から180問に拡充',
    'バッジ一覧画面を追加',
    'ショップ交換所に購入・適用機能追加',
    'せってい画面にテーマ切り替え追加',
  ],
  '1.1.0': [
    'ことわざ・慣用句クイズが各50問以上に増加',
    'ことばクイズが200語以上に増加',
    '各クイズが10問ずつのラウンド制に変更',
    '選択肢の位置がランダムになりました',
    '漢字おぼえるタブを改善（読みを見て漢字を思い出す）',
    'アップデート時にお知らせ画面を表示',
  ],
  '1.0.0': [
    '小学コレ！国語リリース',
    'ひらがな・カタカナ・漢字の学習',
    'ことわざ・慣用句・四字熟語クイズ',
    'よむ・ことばクイズ',
    'バッジ・コインシステム',
  ],
};

/// 保護者向けレポート画面を開く前に、保護者ゲートで確認する。
Future<void> _openParentReport(BuildContext context) async {
  final passedGate = await requireParentalGate(
    context,
    title: 'ほごしゃかくにん',
    description: '保護者向けレポートの閲覧には、ほごしゃの確認が必要です。',
  );
  if (!passedGate || !context.mounted) return;
  Navigator.of(context).pushNamed('/parent-report');
}

/// 利用時間制限の設定画面を開く前に、保護者ゲートで確認する。
Future<void> _openScreenTimeSettings(BuildContext context) async {
  final passedGate = await requireParentalGate(
    context,
    title: 'ほごしゃかくにん',
    description: '利用時間の設定変更には、ほごしゃの確認が必要です。',
  );
  if (!passedGate || !context.mounted) return;
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('利用時間の設定'),
          backgroundColor: kPrimaryColor,
        ),
        body: const ScreenTimeSettingsWidget(primaryColor: kPrimaryColor),
      ),
    ),
  );
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final premium = ref.watch(premiumProvider);
    final soundEnabled = ref.watch(soundProvider);
    final drawingSettings = ref.watch(drawingSettingsProvider);
    final drawingProgress = ref.watch(drawingProgressProvider);
    final vocabMastery = ref.watch(vocabMasteryProvider);
    final profileState = ref.watch(profileProvider);
    final currentProfile = profileState.currentProfile;

    // ひらがな・カタカナの文字数を取得
    final hiraganaAll = getKanaList(KanaType.hiragana);
    final katakanaAll = getKanaList(KanaType.katakana);
    final hiraganaTotal = hiraganaAll.where((e) => !e.isPlaceholder).length;
    final katakanaTotal = katakanaAll.where((e) => !e.isPlaceholder).length;
    var hiraganaCleared = 0;
    var katakanaCleared = 0;
    for (var i = 0; i < hiraganaAll.length; i++) {
      if (!hiraganaAll[i].isPlaceholder &&
          drawingProgress.isPassed('hiragana', i, drawingSettings.passingScore)) {
        hiraganaCleared++;
      }
    }
    for (var i = 0; i < katakanaAll.length; i++) {
      if (!katakanaAll[i].isPlaceholder &&
          drawingProgress.isPassed('katakana', i, drawingSettings.passingScore)) {
        katakanaCleared++;
      }
    }
    final masteredVocab =
        vocabMastery.correctCounts.entries.where((e) => e.value >= 2).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('せってい'),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '設定'),
            Tab(text: '学習分析'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView(
        children: [
          if (!premium.isPremium) _PremiumBanner(premium: premium),
          _SectionHeader(title: 'おと・サウンド'),
          SwitchListTile(
            secondary: const Text('🔊', style: TextStyle(fontSize: 20)),
            title: const Text('よみあげ'),
            subtitle: const Text('文字をタップするとよみあげます', style: TextStyle(fontSize: 11)),
            value: soundEnabled,
            activeColor: kPrimaryColor,
            onChanged: (_) => ref.read(soundProvider.notifier).toggle(),
          ),
          const Divider(),
          _SectionHeader(title: 'かく・練習'),
          ListTile(
            leading: const Text('✏️', style: TextStyle(fontSize: 20)),
            title: const Text('かく 合格点'),
            subtitle: const Text('一覧のかくでクリアとみなす点数', style: TextStyle(fontSize: 11)),
            trailing: DropdownButton<int>(
              value: drawingSettings.passingScore,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: 60, child: Text('60点')),
                DropdownMenuItem(value: 70, child: Text('70点')),
                DropdownMenuItem(value: 80, child: Text('80点')),
                DropdownMenuItem(value: 90, child: Text('90点')),
              ],
              onChanged: (v) {
                if (v != null) {
                  ref.read(drawingSettingsProvider.notifier).setPassingScore(v);
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined, color: kTextMuted),
            title: const Text('かく れんしゅうをリセット'),
            subtitle: const Text('かく練習の成績をリセットします', style: TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            onTap: () => _confirmDrawingReset(context, ref),
          ),
          const Divider(),
          _SectionHeader(title: 'がくしゅうしゃ'),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('プロフィール'),
            subtitle: Text(
              currentProfile?.name ?? 'なし',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            onTap: () => Navigator.pushReplacementNamed(context, '/profile-selection'),
          ),
          const Divider(),
          _SectionHeader(title: 'きろく'),
          ListTile(
            leading: const Text('🔥', style: TextStyle(fontSize: 20)),
            title: const Text('れんぞく'),
            trailing: Text('${progress.streakDays}日',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ListTile(
            leading: const Text('⭐', style: TextStyle(fontSize: 20)),
            title: const Text('せいかいすう'),
            trailing: Text('${progress.totalCorrect}問',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ListTile(
            leading: const Text('📖', style: TextStyle(fontSize: 20)),
            title: const Text('かんじ せいかい'),
            trailing: Text('${progress.totalKanjiCorrect}問',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ListTile(
            leading: const Text('📚', style: TextStyle(fontSize: 20)),
            title: const Text('よむ せいかい'),
            trailing: Text('${progress.totalReadingCorrect}問',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ListTile(
            leading: const Text('あ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kAccentGreen)),
            title: const Text('ひらがな かく'),
            subtitle: const Text('かく練習のクリア数', style: TextStyle(fontSize: 11)),
            trailing: Text('$hiraganaCleared / $hiraganaTotal',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ListTile(
            leading: const Text('ア', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kAccentBlue)),
            title: const Text('カタカナ かく'),
            subtitle: const Text('かく練習のクリア数', style: TextStyle(fontSize: 11)),
            trailing: Text('$katakanaCleared / $katakanaTotal',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ListTile(
            leading: const Text('💬', style: TextStyle(fontSize: 20)),
            title: const Text('ことば マスター'),
            subtitle: const Text('マスターした語数', style: TextStyle(fontSize: 11)),
            trailing: Text('$masteredVocab語',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const Divider(),
          _SectionHeader(title: '利用時間制限'),
          ListTile(
            leading: const Text('⏰', style: TextStyle(fontSize: 20)),
            title: const Text('利用時間を設定する'),
            subtitle: const Text('1日の利用時間に上限を設定できます（ほごしゃ向け）',
                style: TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            onTap: () => _openScreenTimeSettings(context),
          ),
          const Divider(),
          _SectionHeader(title: '🔔 通知設定'),
          ListTile(
            leading: const Text('🔔', style: TextStyle(fontSize: 20)),
            title: const Text('通知設定を変更'),
            subtitle: const Text('通知の受け取り設定を管理',
                style: TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            onTap: () {
              final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
              if (userId.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => NotificationSettingsPage(userId: userId),
                  ),
                );
              }
            },
          ),
          const Divider(),
          _SectionHeader(title: '📈 分析'),
          ListTile(
            leading: const Text('📊', style: TextStyle(fontSize: 20)),
            title: const Text('ユーザーリテンション分析'),
            subtitle: const Text('あなたの活動パターンと継続性を分析',
                style: TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const RetentionDashboard(),
              ),
            ),
          ),
          const Divider(),
          _SectionHeader(title: 'ソーシャル'),
          ListTile(
            leading: const Icon(Icons.person_add, color: kPrimaryColor),
            title: const Text('フレンドを探す'),
            subtitle: const Text('ユーザーを検索してフレンド申請する', style: TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            onTap: () => showDialog(
              context: context,
              builder: (context) => const AddFriendDialog(),
            ),
          ),
          const Divider(),
          _SectionHeader(title: 'テーマ'),
          const _ThemeSection(),
          const Divider(),
          _SectionHeader(title: 'ともコレ'),
          const _TomoKoreSection(),
          const Divider(),
          _SectionHeader(title: 'ランキング設定'),
          const _RankingPrivacySection(),
          const Divider(),
          _SectionHeader(title: 'バトル設定'),
          const _BattleSettingsSection(),
          const Divider(),
          _SectionHeader(title: 'アプリについて'),
          ListTile(
            leading: const Text('🏅', style: TextStyle(fontSize: 20)),
            title: const Text('バッジコレクション'),
            subtitle: const Text('獲得したバッジを確認する', style: TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            onTap: () => Navigator.of(context).pushNamed('/badges'),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart, color: kPrimaryColor),
            title: const Text('ほごしゃレポート'),
            subtitle: const Text('がくしゅうきろくを確認する',
                style: TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 14, color: kTextMuted),
            onTap: () => _openParentReport(context),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('このアプリの使い方'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            onTap: () => _showUsageGuide(context),
          ),
          ListTile(
            leading: const Icon(Icons.celebration_outlined),
            title: const Text('アプリの紹介をもう一度見る'),
            subtitle: const Text('初回起動時に表示された説明',
                style: TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            onTap: () => showAppIntroDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('バージョン'),
            trailing: const Text(_appVersion, style: TextStyle(color: kTextMuted)),
            onTap: () => _showChangelog(context),
            subtitle: const Text('タップでアップデート履歴を確認', style: TextStyle(fontSize: 10)),
          ),
          ListTile(
            leading: const Icon(Icons.library_books_outlined),
            title: const Text('小学コレ！国語'),
            subtitle: const Text('Your Wish'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('プライバシーポリシー'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            onTap: () => Navigator.of(context).pushNamed('/privacy'),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('利用規約'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            onTap: () => Navigator.of(context).pushNamed('/terms'),
          ),
          ListTile(
            leading: const Icon(Icons.copyright_outlined),
            title: const Text('オープンソースライセンス'),
            subtitle: const Text('書き順データの提供元', style: TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            onTap: () => _showOpenSourceCredits(context),
          ),
          ListTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('バグ報告・改善要望'),
            subtitle: const Text('アプリの問題や機能提案をお知らせください', style: TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const FeedbackFormPage(
                  appName: 'kokugo-kore',
                  appVersion: _appVersion,
                ),
              ),
            ),
          ),
          const CrossPromoSection(
            currentAppId: 'com.yourwish.shougakukore.kokugo',
            currentCategory: '小学コレ',
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.refresh, color: kAccentRed),
              label: const Text('がくしゅうきろくをリセット',
                  style: TextStyle(color: kAccentRed)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: kAccentRed),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _confirmReset(context, ref),
            ),
          ),
          const SizedBox(height: 80),
        ],
          // Tab 2: 学習分析
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AnalyticsDashboardWidget(
              userName: currentProfile?.name ?? 'ユーザー',
              totalQuestions: progress.totalQuestionsAnswered ?? 0,
              averageAccuracy: progress.averageAccuracy ?? 0.0,
              totalTimeSpent: progress.totalLearningSeconds ?? 0,
              dailyActivity: _generateDailyActivity(),
              accuracyTrend: _generateAccuracyTrend(),
            ),
          ),
        ],
      ),
    );
  }

  List<DailyActivityData> _generateDailyActivity() {
    return [
      DailyActivityData(day: '月', count: 0),
      DailyActivityData(day: '火', count: 0),
      DailyActivityData(day: '水', count: 0),
      DailyActivityData(day: '木', count: 0),
      DailyActivityData(day: '金', count: 0),
      DailyActivityData(day: '土', count: 0),
      DailyActivityData(day: '日', count: 0),
    ];
  }

  List<AccuracyTrendData> _generateAccuracyTrend() {
    return [
      AccuracyTrendData(week: 'W1', accuracy: 0.0),
      AccuracyTrendData(week: 'W2', accuracy: 0.0),
      AccuracyTrendData(week: 'W3', accuracy: 0.0),
      AccuracyTrendData(week: 'W4', accuracy: 0.0),
    ];
  }

  void _showUsageGuide(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Text('📚', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('このアプリの使い方', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _UsageItem(
                emoji: '💡',
                title: 'わかる',
                desc: '国語の知識（ひらがな、漢字、ことわざ、慣用句など）を一覧で確認できます。',
              ),
              _UsageItem(
                emoji: 'あ',
                title: 'ひらがな・カタカナ',
                desc: '「みる」で文字と読みを確認、「おぼえる」で読みを見て文字を当てる練習、「かく」で書き順練習ができます。',
              ),
              _UsageItem(
                emoji: '漢',
                title: 'かんじ',
                desc: '学年別に漢字を学習できます。「おぼえる」タブで読みを見て漢字を当てる練習をしましょう。',
              ),
              _UsageItem(
                emoji: '📚',
                title: 'よむ',
                desc: '文章を読んで問題に答える読解クイズです。学年別にステージをクリアしていきましょう。',
              ),
              _UsageItem(
                emoji: '💬',
                title: 'ことば',
                desc: '言葉の意味を選ぶクイズです。10問ずつチャレンジして、全部マスターしましょう。',
              ),
              _UsageItem(
                emoji: '🏮',
                title: 'ことわざ・慣用句',
                desc: 'ことわざや慣用句の意味を学べます。50問以上のクイズから毎回10問ランダムに出題されます。',
              ),
              _UsageItem(
                emoji: '🔥',
                title: 'れんぞく（ストリーク）',
                desc: '毎日アプリを使うと連続日数が増えます。できるだけ毎日続けてみましょう！',
              ),
              _UsageItem(
                emoji: '📊',
                title: '親向けダッシュボード',
                desc: '保護者が子どもの学習状況を確認できます。ホーム右上メニューの「保護者レポート」からアクセスできます。',
              ),
              _UsageItem(
                emoji: '⚔️',
                title: 'マルチプレイ',
                desc: '友達とリアルタイムで国語クイズバトルができます。招待コードを使って友達を誘おう！',
              ),
              _UsageItem(
                emoji: '📖',
                title: '読解力強化',
                desc: '文章を読んで理解度クイズや要約訓練ができます。「まなぶ」メニューから読解力強化を選ぼう！',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('とじる'),
          ),
        ],
      ),
    );
  }

  void _showOpenSourceCredits(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Text('📜', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('オープンソースライセンス', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '「かきじゅん（書き順）」機能では、以下のオープンソースデータを利用しています。',
                style: TextStyle(fontSize: 13, color: kTextDark, height: 1.4),
              ),
              SizedBox(height: 16),
              Text('漢字の書き順データ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kPrimaryColor)),
              SizedBox(height: 4),
              Text(
                'KanjiVG（© Ulrich Apel and contributors）\n'
                'ライセンス: Creative Commons 表示-継承 3.0\n'
                'https://kanjivg.tagaini.net',
                style: TextStyle(fontSize: 12, color: kTextMuted, height: 1.5),
              ),
              SizedBox(height: 16),
              Text('ひらがな・カタカナの書き順データ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kPrimaryColor)),
              SizedBox(height: 4),
              Text(
                'AnimCJK（© FM-SH）\n'
                'ライセンス: GNU Lesser General Public License v3以降\n'
                'https://github.com/parsimonhi/animCJK',
                style: TextStyle(fontSize: 12, color: kTextMuted, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('とじる'),
          ),
        ],
      ),
    );
  }

  void _showChangelog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Text('📝', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('アップデート履歴', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: _changelog.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'v${entry.key}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...entry.value.map((item) => Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(color: kPrimaryColor)),
                              Expanded(
                                child: Text(item,
                                    style: const TextStyle(fontSize: 13, color: kTextDark, height: 1.4)),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('とじる'),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('きろくをリセットしますか？'),
        content: const Text('すべての学習記録とバッジが消えます。この操作は元に戻せません。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('キャンセル')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final passedGate = await requireParentalGate(
                context,
                title: 'ほごしゃかくにん',
                description: 'がくしゅうきろくの全リセットには、ほごしゃの確認が必要です。',
              );
              if (!passedGate || !context.mounted) return;
              await ref.read(progressProvider.notifier).reset();
            },
            child: const Text('リセット', style: TextStyle(color: kAccentRed)),
          ),
        ],
      ),
    );
  }

  void _confirmDrawingReset(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('かく れんしゅうをリセットしますか？'),
        content: const Text('かく練習の成績が消えます。この操作は元に戻せません。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('キャンセル')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(drawingProgressProvider.notifier).reset();
            },
            child: const Text('リセット', style: TextStyle(color: kAccentRed)),
          ),
        ],
      ),
    );
  }

}

class _UsageItem extends StatelessWidget {
  final String emoji;
  final String title;
  final String desc;

  const _UsageItem({required this.emoji, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kTextDark)),
                const SizedBox(height: 2),
                Text(desc,
                    style: const TextStyle(fontSize: 12, color: kTextMuted, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TomoKoreSection extends ConsumerWidget {
  const _TomoKoreSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final referral = ref.watch(referralProvider);
    final currentUserId = profileState.currentProfile?.id ?? 'unknown';
    final myCode = referral.codes
        .firstWhere((c) => c.generatorId == currentUserId, orElse: () => ReferralCode(code: '', generatorId: ''))
        .code;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Text('👫', style: TextStyle(fontSize: 20)),
            title: const Text('紹介コードを発行'),
            subtitle: const Text('友達に教えるとコインをゲット', style: TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            onTap: () async {
              final newCode = await ref.read(referralProvider.notifier).generateReferralCode(currentUserId);
              if (context.mounted) {
                _showCodeDialog(context, newCode);
              }
            },
          ),
          if (myCode.isNotEmpty)
            ListTile(
              leading: const Text('🔑', style: TextStyle(fontSize: 20)),
              title: const Text('あなたのコード'),
              subtitle: Text(myCode, style: const TextStyle(fontSize: 13, color: kPrimaryColor, fontWeight: FontWeight.bold)),
              trailing: IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('コードをコピーしました'), duration: Duration(seconds: 1)),
                  );
                },
              ),
            ),
          ListTile(
            leading: const Text('📝', style: TextStyle(fontSize: 20)),
            title: const Text('友達のコード入力'),
            subtitle: const Text('友達のコードを入力するとコインをゲット', style: TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            onTap: () => _showCodeInputDialog(context, ref, currentUserId),
          ),
        ],
      ),
    );
  }

  void _showCodeDialog(BuildContext context, String code) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Text('🎉', style: TextStyle(fontSize: 28)),
            SizedBox(width: 8),
            Text('紹介コード発行', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('このコードを友達に教えてください：', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kPrimaryColor.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kPrimaryColor.withAlpha(80)),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '友達が入力するたびにコインがもらえます！\n（最大5人まで）',
              style: TextStyle(fontSize: 11, color: kTextMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('とじる'),
          ),
        ],
      ),
    );
  }

  void _showCodeInputDialog(BuildContext context, WidgetRef ref, String currentUserId) {
    final codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Text('🔐', style: TextStyle(fontSize: 28)),
            SizedBox(width: 8),
            Text('コード入力', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                hintText: 'コードを入力',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              textCapitalization: TextCapitalization.characters,
              onChanged: (val) => codeController.text = val.toUpperCase(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              final success = await ref.read(referralProvider.notifier).useReferralCode(codeController.text, currentUserId);
              if (success) {
                final coins = ref.read(referralProvider).findCodeByValue(codeController.text)?.coinsReward ?? 10;
                await ref.read(coinProvider.notifier).addCoins(coins);
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('成功！ $coins コイン取得しました'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } else {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('このコードは使用できません'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            child: const Text('入力'),
          ),
        ],
      ),
    );
  }
}

class _PremiumBanner extends StatelessWidget {
  final PremiumState premium;
  const _PremiumBanner({required this.premium});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/upgrade'),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kPrimaryColor, kPrimaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Text('⭐', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'プレミアムプランにアップグレード',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    premium.isTrialActive
                        ? '無料トライアル あと${premium.trialDaysLeft}日'
                        : '全ステージが学び放題 ¥300/月〜',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _RankingPrivacySection extends ConsumerWidget {
  const _RankingPrivacySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacy = ref.watch(rankingPrivacyProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                secondary: const Text('👤', style: TextStyle(fontSize: 20)),
                title: const Text('名前をランキングに表示'),
                subtitle: const Text(
                  'オンにするとランキングであなたの名前が表示されます',
                  style: TextStyle(fontSize: 11),
                ),
                value: privacy.isNamePublic,
                onChanged: (value) =>
                    ref.read(rankingPrivacyProvider.notifier).setNamePublic(value),
                activeColor: kPrimaryColor,
              ),
              if (!privacy.isNamePublic)
                Padding(
                  padding: const EdgeInsets.fromLTRB(56, 8, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blue.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade600, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'あなたの順位は常に見ることができます。',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BattleSettingsSection extends StatefulWidget {
  const _BattleSettingsSection();

  @override
  State<_BattleSettingsSection> createState() => _BattleSettingsSectionState();
}

class _BattleSettingsSectionState extends State<_BattleSettingsSection> {
  bool _acceptChallenges = true;
  int _difficultyLevel = 0;

  static const _acceptKey = 'battle_accept_challenges';
  static const _diffKey = 'battle_difficulty';

  static const _diffLabels = ['同じ学年', '全学年からランダム', '上の学年'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _acceptChallenges = prefs.getBool(_acceptKey) ?? true;
      _difficultyLevel = prefs.getInt(_diffKey) ?? 0;
    });
  }

  Future<void> _setAccept(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_acceptKey, val);
    setState(() => _acceptChallenges = val);
  }

  Future<void> _setDifficulty(int val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_diffKey, val);
    setState(() => _difficultyLevel = val);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          secondary: const Text('⚔️', style: TextStyle(fontSize: 20)),
          title: const Text('バトルリクエストを受け付ける'),
          subtitle: const Text('友達からの挑戦を受け付ける', style: TextStyle(fontSize: 11)),
          value: _acceptChallenges,
          onChanged: _setAccept,
          activeColor: kPrimaryColor,
        ),
        ListTile(
          leading: const Text('🎯', style: TextStyle(fontSize: 20)),
          title: const Text('対戦相手のレベル'),
          subtitle: Text(_diffLabels[_difficultyLevel],
              style: const TextStyle(fontSize: 11)),
          trailing: PopupMenuButton<int>(
            initialValue: _difficultyLevel,
            onSelected: _setDifficulty,
            itemBuilder: (_) => _diffLabels
                .asMap()
                .entries
                .map((e) => PopupMenuItem(value: e.key, child: Text(e.value)))
                .toList(),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('変更', style: TextStyle(fontSize: 12, color: kPrimaryColor)),
                Icon(Icons.arrow_drop_down, color: kPrimaryColor),
              ],
            ),
          ),
        ),
        ListTile(
          leading: const Text('🏆', style: TextStyle(fontSize: 20)),
          title: const Text('バトル履歴を見る'),
          subtitle:
              const Text('過去の対戦結果を確認する', style: TextStyle(fontSize: 11)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
          onTap: () => Navigator.of(context).pushNamed('/ranking'),
        ),
      ],
    );
  }
}

class _ThemeSection extends ConsumerWidget {
  const _ThemeSection();

  static const _bgDefs = [
    ('bg_space',    '🌌', '宇宙の背景'),
    ('bg_library',  '📖', '図書館の背景'),
    ('bg_ocean',    '🌊', '深海の背景'),
    ('bg_sakura',   '🌸', '桜の背景'),
    ('bg_fireworks','🎆', '花火の背景'),
    ('bg_leaves',   '🍁', '紅葉の背景'),
    ('bg_snow',     '❄️', '雪の背景'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchased = ref.watch(purchasedItemsProvider);
    final ownedBgs = _bgDefs
        .where((b) => purchased.ownedItemIds.contains(b.$1))
        .toList();

    if (ownedBgs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          'ショップの「交換所」で背景を購入するとここで設定できます',
          style: TextStyle(fontSize: 12, color: kTextMuted),
        ),
      );
    }

    return Column(
      children: [
        if (purchased.selectedBgId != null)
          ListTile(
            leading: const Icon(Icons.format_color_reset, color: kTextMuted),
            title: const Text('テーマをデフォルトに戻す'),
            onTap: () => ref.read(purchasedItemsProvider.notifier).selectBackground(null),
          ),
        ...ownedBgs.map((b) {
          final isSelected = purchased.selectedBgId == b.$1;
          return ListTile(
            leading: Text(b.$2, style: const TextStyle(fontSize: 24)),
            title: Text(b.$3),
            trailing: isSelected
                ? const Icon(Icons.check_circle, color: kAccentGreen)
                : null,
            onTap: () => ref.read(purchasedItemsProvider.notifier)
                .selectBackground(isSelected ? null : b.$1),
          );
        }),
      ],
    );
  }
}
