import 'package:cross_promo_kit/cross_promo_kit.dart'
    show CrossPromoSection;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/models/avatar_model.dart';
import 'package:shared_core/widgets/avatar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_coaching_dashboard_screen.dart';
import '../data/quiz_data.dart';

import '../data/kokugo_characters.dart';
import '../widgets/app_intro_dialog.dart';
import '../providers/adaptive_provider.dart';
import '../providers/daily_bonus_provider.dart';
import '../providers/badge_provider.dart';
import '../providers/coin_provider.dart';
import '../providers/learning_timer_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/profile_avatar_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/profile_provider.dart';
import '../providers/purchased_items_provider.dart';
import '../theme/app_theme.dart';
import 'package:shared_core/shared_core.dart'
    show
        characterStateProvider,
        equippedItemsProvider,
        kCommonShopItems,
        AppShopItem,
        requireParentalGate,
        FriendsListPage,
        DailyMissionPage,
        weeklyBonusProvider,
        coinProvider,
        WeeklyBonusWidget,
        NotificationBadge,
        notificationProvider;
import '../widgets/daily_bonus_dialog.dart';
import '../widgets/daily_mission_card.dart';
import '../widgets/timer_chip_widget.dart';
import '../widgets/badge_progress_tracker.dart';

AppShopItem? _findCommonShopItem(String? id) {
  if (id == null) return null;
  for (final item in kCommonShopItems) {
    if (item.id == id) return item;
  }
  return null;
}

/// 保護者向けレポート画面を開く前に、保護者ゲートで確認する。
Future<void> _openParentReport(BuildContext context) async {
  final passedGate = await requireParentalGate(
    context,
    title: 'ほごしゃかくにん',
    description: '保護者向けレポートの閲覧には、ほごしゃの確認が必要です。',
  );
  if (!passedGate || !context.mounted) return;
  Navigator.pushNamed(context, '/parent-report');
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _timerEndHandled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runStartupDialogs());
  }

  /// 初回起動時に表示しうる複数のダイアログ（デイリーボーナス・アプリ紹介・
  /// アップデート通知）が同時に積み重なって出ないよう、1つずつ順番に
  /// 表示して閉じられるのを待ってから次を出す。
  Future<void> _runStartupDialogs() async {
    await _checkDailyBonus();
    if (!mounted) return;
    await _checkFirstLaunchIntro();
    if (!mounted) return;
    await _checkForUpdate();
  }

  /// 初回インストール後、最初にホーム画面に来たときだけアプリの使い方を説明する。
  /// 同じ内容は設定画面の「このアプリの使い方」からいつでも再表示できる。
  Future<void> _checkFirstLaunchIntro() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenIntro = prefs.getBool('has_seen_app_intro') ?? false;
    if (hasSeenIntro) return;
    await prefs.setBool('has_seen_app_intro', true);
    if (!mounted) return;
    await showAppIntroDialog(context);
  }

  Future<void> _checkForUpdate() async {
    const currentVersion = '1.4.0';
    final prefs = await SharedPreferences.getInstance();
    final lastSeen = prefs.getString('last_seen_version');
    if (lastSeen != currentVersion) {
      await prefs.setString('last_seen_version', currentVersion);
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Text('🎉', style: TextStyle(fontSize: 28)),
              SizedBox(width: 8),
              Flexible(
                child: Text('v1.4.0 にアップデート！',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('✨ 新機能',
                    style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor)),
                SizedBox(height: 6),
                Text('• 読解力強化トレーニングを追加'),
                Text('• アバターアイコンを一新'),
                Text('• 書き順アニメーション表示を追加'),
                SizedBox(height: 12),
                Text('🔧 改善',
                    style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor)),
                SizedBox(height: 6),
                Text('• アプリ内課金の価格表示・エラー表示を改善'),
                Text('• キャラクターのレベル別イラスト表示に対応'),
                Text('• アプリ名を「小学コレ！国語」に変更'),
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // タイマー終了検知（ref.listen はbuildの外でできないのでdidChangeDependenciesで監視）
  }

  Future<void> _checkDailyBonus() {
    final bonus = ref.read(dailyBonusProvider);
    if (bonus.claimedToday || bonus.todayBonus <= 0) return Future.value();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DailyBonusDialog(
        streak: bonus.bonusStreak + 1,
        bonusCoins: bonus.todayBonus,
        onClaim: () async {
          final coins = await ref.read(dailyBonusProvider.notifier).claim();
          await ref.read(coinProvider.notifier).addCoins(coins);
          if (mounted) Navigator.of(context).pop();
        },
      ),
    );
  }

  void _handleTimerExpired() {
    if (_timerEndHandled) return;
    _timerEndHandled = true;
    showTimerEndDialog(context).then((_) {
      ref.read(learningTimerProvider.notifier).stop();
      _timerEndHandled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressProvider);
    final adaptive = ref.watch(adaptiveProvider);
    final badges = ref.watch(badgeProvider);
    final coins = ref.watch(coinProvider);
    final profileState = ref.watch(profileProvider);
    final currentProfile = profileState.currentProfile;
    final timer = ref.watch(learningTimerProvider);
    final charStates = ref.watch(characterStateProvider);
    final purchased = ref.watch(purchasedItemsProvider);
    final profileAvatarState = ref.watch(profileAvatarProvider);
    final profileAvatar = currentProfile != null
        ? allAvatars.firstWhere(
            (a) => a.id == profileAvatarState.getSelectedAvatar(currentProfile.id),
            orElse: () => allAvatars.first,
          )
        : null;
    final equipped = ref.watch(equippedItemsProvider).equippedByCategory;
    final weeklyBonus = ref.watch(weeklyBonusProvider);

    // ショップで装着中の背景テーマ（shared_core の共通テーマ）があれば優先。
    final equippedThemeId = equipped['背景'];
    final equippedTheme = _findCommonShopItem(equippedThemeId);
    final equippedThemeColors =
        (equippedTheme?.themeData?['colors'] as List?)?.cast<String>();

    // ショップで装着中のプロフィールフレーム（shared_core の共通フレーム）。
    final equippedFrameId = equipped['フレーム'];
    final equippedFrame = _findCommonShopItem(equippedFrameId);

    // テーマ背景色（装着中の共通テーマ > 旧来の購入済み背景 の順で優先）
    final bgColors = equippedThemeColors == null
        ? (purchased.selectedBgId != null ? bgThemeColors[purchased.selectedBgId] : null)
        : null;
    final topColor = equippedThemeColors != null
        ? Color(int.parse(equippedThemeColors[0].replaceFirst('#', '0xFF')))
        : (bgColors != null ? Color(bgColors[0]) : kPrimaryColor);
    final bottomColor = equippedThemeColors != null
        ? Color(int.parse(equippedThemeColors[1].replaceFirst('#', '0xFF')))
        : (bgColors != null ? Color(bgColors[1]) : kPrimaryDark);

    // タイマー終了を検知
    if (timer.isExpired && !_timerEndHandled) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _handleTimerExpired());
    }

    final hasBg = bgColors != null;
    final bgImagePath = hasBg ? 'assets/backgrounds/${purchased.selectedBgId}.jpg' : null;

    return Container(
      decoration: hasBg
          ? BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bgImagePath!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withAlpha(20),
                  BlendMode.darken,
                ),
              ),
            )
          : null,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 110,
            pinned: true,
            backgroundColor: topColor,
            forceElevated: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [topColor, bottomColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 56, bottom: 14, right: 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '📚 小学コレ！国語',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (currentProfile != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        profileAvatar != null
                            ? _FramedAvatar(avatar: profileAvatar, frame: equippedFrame, size: 16)
                            : const Text('😊', style: TextStyle(fontSize: 13)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${currentProfile.name}（${currentProfile.grade}年生）',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            actions: [
              // デイリーミッションボタン（Phase 4.5）
              IconButton(
                icon: const Icon(Icons.assignment, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DailyMissionPage(
                        primaryColor: topColor,
                        appTitle: '小学コレ！国語',
                        filterSubject: 'japanese',
                      ),
                    ),
                  );
                },
                tooltip: 'デイリーミッション',
              ),
              // フレンドボタン（Phase 4.4 フレンド機能）
              IconButton(
                icon: const Icon(Icons.people, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FriendsListPage()),
                  );
                },
                tooltip: 'フレンド',
              ),
              // タイマーチップ（動作中のみ表示）
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: TimerChip(
                  onTap: () => Navigator.pushNamed(context, '/smart-menu'),
                ),
              ),
              // Phase 4.23: ローカル通知・リマインダーシステム
              Builder(
                builder: (context) {
                  final notifications = ref.watch(notificationProvider);
                  return NotificationBadge(
                    notificationCount: notifications.length,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('通知: ${notifications.length}件'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('プロフィール変更'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/profile-selection');
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('保護者レポート'),
                    onTap: () => _openParentReport(context),
                  ),
                ],
              ),
            ],
          ),

          // セーフティネットバナー
          if (adaptive.strugglingCount >= 2)
            SliverToBoxAdapter(
              child: _SafetyNetBanner(
                count: adaptive.strugglingCount,
                onTap: () => _openParentReport(context),
              ),
            ),

          SliverToBoxAdapter(
            child: DailyMissionCard(
              streakDays: progress.streakDays,
              progress: progress,
              adaptive: adaptive,
              onStart: () {
                for (var g = 1; g <= 6; g++) {
                  for (final stage in getStagesForGrade(g)) {
                    if (!progress.isCleared(stage.grade, stage.stageNumber)) {
                      Navigator.of(context).pushNamed('/quest', arguments: stage);
                      return;
                    }
                  }
                }
              },
              onStartStage: (stage) {
                Navigator.of(context).pushNamed('/quest', arguments: stage);
              },
            ),
          ),
          // Phase 4.20: 週次ボーナスシステム
          SliverToBoxAdapter(
            child: WeeklyBonusWidget(
              onBonusClaimed: (coins) {
                ref.read(coinProvider.notifier).addCoins(coins);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ボーナス $coins コイン獲得しました！🎉'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
          // ── お任せメニューバナー ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/smart-menu'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [kAccentPurple, Color(0xFF6C3483)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: kAccentPurple.withAlpha(60),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text('⭐', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'おまかせ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              timer.isActive
                                  ? 'タイマー残り ${timer.displayTime} ・ AIがステージを提案中'
                                  : '難易度を選ぶだけ！AIが今日のステージを提案',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.white70),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // ── 学ぶ（解説メニュー）カード ────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/lesson'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: kAccentTeal.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kAccentTeal.withAlpha(60)),
                  ),
                  child: Row(
                    children: [
                      const Text('📖', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '学ぶ',
                              style: TextStyle(
                                color: kAccentTeal,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Text(
                              '国語の仕組みを解説記事で読んでみよう',
                              style: TextStyle(color: kTextMuted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: kAccentTeal.withAlpha(150)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // ── マルチプレイ対戦カード ────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/multiplayer'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: kAccentPurple.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kAccentPurple.withAlpha(60)),
                  ),
                  child: Row(
                    children: [
                      const Text('⚔️', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'マルチプレイ対戦',
                              style: TextStyle(
                                color: kAccentPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Text(
                              'レートが近い相手と国語でリアルタイム対戦しよう',
                              style: TextStyle(color: kTextMuted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: kAccentPurple.withAlpha(150)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _StatsRow(
              progress: progress,
              badgeCount: badges.earnedBadges.length,
              coinCount: coins.totalCoins,
              onBadgeTap: () => Navigator.pushNamed(context, '/badges'),
            ),
          ),
          // バッジ進捗トラッカー
          SliverToBoxAdapter(
            child: BadgeProgressTracker(
              onViewMore: () => Navigator.pushNamed(context, '/badges'),
            ),
          ),
          const SliverToBoxAdapter(
            child: _RecentCharactersSection(),
          ),
          // AI コーチング機能
          SliverToBoxAdapter(
            child: _AiCoachingCard(),
          ),
          // クロスプロモーション（他アプリ紹介）
          SliverToBoxAdapter(
            child: CrossPromoSection(
              currentAppId: 'com.example.kokugo_kore',
              currentCategory: '小学コレ',
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
      ),
    );
  }
}

// ─── セーフティネットバナー ───────────────────────────────────
class _SafetyNetBanner extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _SafetyNetBanner({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3CD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFC107)),
        ),
        child: Row(
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '苦手なステージが$count個あります。保護者レポートを確認してみよう！',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF856404),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF856404), size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final LearningProgress progress;
  final int badgeCount;
  final int coinCount;
  final VoidCallback? onBadgeTap;
  const _StatsRow({required this.progress, required this.badgeCount, required this.coinCount, this.onBadgeTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _StatCard(label: 'れんぞく', value: '${progress.streakDays}日',
              emoji: '🔥', color: const Color(0xFFE74C3C)),
          const SizedBox(width: 10),
          _StatCard(label: 'コイン', value: '$coinCount枚',
              emoji: '🪙', color: const Color(0xFFFFB81C)),
          const SizedBox(width: 10),
          _StatCard(label: 'バッジ', value: '$badgeCount個',
              emoji: '🏅', color: kAccentGreen, onTap: onBadgeTap),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;
  final Color color;
  final VoidCallback? onTap;
  const _StatCard({required this.label, required this.value, required this.emoji, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Recent Characters (unlocked) ────────────────────────────
class _RecentCharactersSection extends ConsumerWidget {
  const _RecentCharactersSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charStates = ref.watch(characterStateProvider);
    final unlocked = kKokugoCharacters
        .where((c) => charStates[c.id]?.isUnlocked ?? false)
        .take(4)
        .toList();
    if (unlocked.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('キャラクター', style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/characters'),
                child: const Text('すべて見る'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: unlocked.map((c) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/characters'),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kPrimaryColor.withAlpha(60)),
                    ),
                    child: Column(
                      children: [
                        c.imageAsset != null
                            ? SizedBox(
                                width: 36,
                                height: 36,
                                child: Image.asset(c.imageAsset!, fit: BoxFit.contain),
                              )
                            : Text(c.emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 4),
                        Text(c.name,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

/// プロフィールアイコンに、ショップで装着中のフレームを縁取りとして
/// 重ねて表示する小さなウィジェット。フレーム未装着時は通常表示のまま。
class _FramedAvatar extends StatelessWidget {
  final AvatarModel avatar;
  final AppShopItem? frame;
  final double size;

  const _FramedAvatar({required this.avatar, required this.frame, required this.size});

  @override
  Widget build(BuildContext context) {
    final avatarImage = AvatarImage(avatar: avatar, size: size);
    final framePath = frame?.assetPath;
    if (framePath == null) return avatarImage;

    return SizedBox(
      width: size * 1.4,
      height: size * 1.4,
      child: Stack(
        alignment: Alignment.center,
        children: [
          avatarImage,
          IgnorePointer(
            child: SvgPicture.asset(
              framePath,
              width: size * 1.4,
              height: size * 1.4,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

/// AI コーチングダッシュボード ナビゲーションカード（Phase 4.24 統合）
class _AiCoachingCard extends ConsumerWidget {
  const _AiCoachingCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(profileProvider).currentProfile;
    final userId = currentUser?.userId;

    if (userId == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/ai-coaching'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withAlpha(100),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Row(
          children: [
            Text('🤖', style: TextStyle(fontSize: 32)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI コーチング',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'あなたの学習パターンを分析して、\nアドバイスをくれます',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
