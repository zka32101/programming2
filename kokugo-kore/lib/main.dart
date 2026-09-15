import 'package:cross_promo_kit/cross_promo_kit.dart'
    show CrossPromoService;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderContainer, UncontrolledProviderScope;
import 'package:shared_core/shared_core.dart'
    show
        characterStateProvider,
        coinProvider,
        avatarProvider,
        equippedItemsProvider,
        screenTimeProvider,
        ScreenTimeLimitReachedWidget,
        badgeProvider,
        unifiedBadges,
        BadgeNotifier,
        rankingProvider,
        globalRankingProvider,
        missionProvider,
        dailyMissionProvider,
        friendProvider,
        premiumProvider,
        PremiumNotifier,
        PushNotificationService,
        adaptiveDifficultyNotifierProvider,
// Phase 4.22: Push Notifications & Retention
pushNotificationProvider,
retentionProvider,
weeklyBonusProvider;
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/progress_provider.dart';

import 'data/kana_data.dart';
import 'firebase_options.dart';
import 'models/quest_model.dart';
import 'screens/character_screen.dart';
import 'providers/badge_metrics_provider.dart';
import 'providers/study_habit_provider.dart';
import 'providers/character_provider.dart';
import 'providers/equipped_items_provider.dart';
import 'providers/multiplayer_provider.dart';
import 'providers/avatar_unlock_provider.dart';
import 'providers/purchased_items_provider.dart';
import 'providers/profile_avatar_provider.dart';
import 'providers/quest_performance_provider.dart';
import 'theme/app_theme.dart';
import 'providers/ranking_privacy_provider.dart';
import 'providers/badge_progress_provider.dart';
import 'providers/screen_time_provider.dart';
import 'providers/lesson_provider.dart' show LessonNotifier, lessonProvider;
import 'screens/bushu_quiz_screen.dart';
import 'screens/haiku_quiz_screen.dart';
import 'screens/detailed_analytics_screen.dart';
import 'screens/multiplayer/rated_match_screen.dart';
import 'screens/home_screen.dart';
import 'screens/idiom_quiz_screen.dart';
import 'screens/homophone_quiz_screen.dart';
import 'screens/grammar_quiz_screen.dart';
import 'screens/kanji_list_screen.dart';
import 'screens/kana_list_screen.dart';
import 'screens/learn_screen.dart';
import 'screens/lesson_screen.dart';
import 'screens/multiplayer/multiplayer_quiz_screen.dart';
import 'screens/multiplayer/kokugo_leaderboard_screen.dart';
import 'screens/multiplayer_menu_screen.dart';
import 'screens/friend_invitation_screen.dart';
import 'screens/parent_report_screen.dart';
import 'screens/parent_dashboard_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/proverb_quiz_screen.dart';
import 'screens/profile_selection_screen.dart';
import 'screens/quest_screen.dart';
import 'screens/random_match_screen.dart';
import 'screens/battle_stats_screen.dart';
import 'screens/ranking_screen.dart';
import 'screens/badge_screen.dart';
import 'screens/mission/mission_screen.dart';
import 'screens/reading_menu_screen.dart';
import 'screens/smart_menu_screen.dart';
import 'screens/result_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/stage_select_screen.dart';
import 'screens/study_menu_screen.dart';
import 'screens/upgrade_screen.dart';
import 'screens/vocabulary_screen.dart';
import 'screens/writing_screen.dart';
import 'screens/goal_setting_screen.dart';
import 'screens/yojijukugo_quiz_screen.dart';
import 'screens/synonym_antonym_quiz_screen.dart';
import 'screens/ai_kanji_consultation_screen.dart';
import 'screens/ai_coaching_dashboard_screen.dart';
import 'services/ad_service.dart';
import 'services/revenue_cat_service.dart';
import 'services/firestore_ranking_service.dart';
import 'services/firestore_friend_service.dart';
import 'services/firestore_mission_service.dart';
import 'services/firestore_push_notification_service.dart';
import 'services/firestore_retention_service.dart';
import 'widgets/premium_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await CrossPromoService.init();

    // Phase 4.18: プッシュ通知サービス初期化
    final pushService = PushNotificationService();
    try {
      await pushService.initialize(
        onMessageHandler: (RemoteMessage message) {
          debugPrint('Received message: ${message.notification?.title}');
        },
      );
    } catch (e) {
      // PushNotificationService initialization failed, continue anyway
    }

    // FCM トークンを取得・保存
    try {
      final fcmToken = await pushService.getFCMToken();
      if (fcmToken != null) {
        debugPrint('FCM Token obtained: ${fcmToken.substring(0, 20)}...');
        // 将来: await updateUserFCMToken(userId, fcmToken);
      }
    } catch (e) {
      // FCM token retrieval failed, continue anyway
    }

    // Phase 4.23: ローカル通知・リマインダーシステム初期化
    final reminderService = ReminderService.instance;
    // 通知コールバック設定（オプション）
    reminderService.setNotificationCallback((notification) {
      debugPrint('Reminder notification: ${notification.title}');
    });

// Phase 4.19: 適応難易度エンジン初期化
    // 注: ユーザーID取得後（プロフィール画面後）に各ユーザーごとに initializeAdaptiveDifficulty() を呼ぶこと
    debugPrint('Phase 4.19 Retention Optimization Engine: Initialized');

    // Phase 4.12-4.14: RemoteConfig 初期化（Dynamic Pricing・Retention・Multiplayer 用）
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await remoteConfig.fetchAndActivate();

    // デフォルト値を設定（Pricing・Retention・Multiplayer 設定）
    await remoteConfig.setDefaults({
      'pricing_new_user_discount': 0.2,  // 20% 割引
      'pricing_vip_threshold_minutes': 180,  // 3時間以上で VIP 価格
      'retention_streak_bonus_multiplier': 1.5,  // ストリーク 1.5 倍
      'retention_daily_mission_count': 3,  // 1日3ミッション
      'multiplayer_rating_initial': 1500,  // 初期レート
      'multiplayer_rating_change_base': 30,  // レート変動基本値
    });
  } catch (_) {}

  // RevenueCat 初期化（サブスクリプション管理）
  final revenueCatService = RevenueCatService();
  try {
    await revenueCatService.initialize();
  } catch (e) {
    debugPrint('[RevenueCat] 初期化スキップ: $e');
  }

  // AdMob 初期化
  await AdService.initialize();

  // テスト用設定: コイン初期値を999999に設定・全機能開放
  const bool isTestMode = false; // リリース版：本番機能のみ

  if (isTestMode) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_coins', 999999);
    await prefs.setBool('is_premium', true); // プレミアム有効化
    // 全ステージを開放
    await prefs.setInt('unlocked_stages', 100); // 全ステージ開放フラグ
  }

  final container = ProviderContainer(
    overrides: [
      // 国語コレのキャラクターノティファイアを注入
      characterStateProvider.overrideWith(CharacterNotifier.new),
      // 国語コレのショップアイテム装着状態ノティファイアを注入
      equippedItemsProvider.overrideWith(EquippedItemsNotifier.new),
      // 統一バッジシステム（Phase 4.1）: 国語コレ用バッジを主題タグで初期化
      badgeProvider.overrideWith(() => BadgeNotifier()),
      // 国語コレの利用時間制限（スクリーンタイム管理）ノティファイアを注入
      screenTimeProvider.overrideWith(() => ScreenTimeNotifier()),
      // 国語コレの解説記事管理（LessonProvider）ノティファイアを注入
      lessonProvider.overrideWith(LessonNotifier.new),
      // Phase 4.7: 統一サブスクリプション管理（PremiumProvider）
      premiumProvider.overrideWith(PremiumNotifier.new),
      // マルチプレイ対戦（レートマッチング）のFirestoreハンドラを注入
      ...kokugoMultiplayerProviderOverrides,
    ],
  );

  // バッジシステム初期化: 統一バッジを主題タグで初期化
  container.read(badgeProvider.notifier).setBadgeDefinitions(unifiedBadges, subject: 'kokugo');

  // Firestore ランキング・フレンド・ミッション サービスの初期化
  final rankingService = FirestoreRankingService();
  final friendService = FirestoreFriendService();
  final missionService = FirestoreMissionService();

  // Handler を shared_core provider に注入
  container.read(rankingProvider.notifier).setFetchHandler(rankingService.fetchRankings);
  container.read(globalRankingProvider.notifier).setFetchHandler(rankingService.fetchGlobalRankings);
  container.read(friendProvider.notifier)
    ..setFetchHandler(friendService.fetchFriends)
    ..setAddFriendHandler(friendService.addFriend)
    ..setRemoveFriendHandler(friendService.removeFriend);

  // Phase 4.5: デイリーミッション統一
  // ミッション Handler を shared_core provider に注入
  container.read(missionProvider.notifier)
    ..setFetchHandler(missionService.fetchMissions)
    ..setProgressHandler(missionService.updateProgress)
    ..setCompleteHandler(missionService.completeMission);

  // Phase 4.7: 統一サブスクリプション初期化
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId != null) {
    container.read(premiumProvider.notifier)
      ..setCheckHandler((userId) => revenueCatService.isSubscribed(userId))
      ..setExpiryHandler((userId) => revenueCatService.getSubscriptionExpirationDate(userId));
    unawaited(container.read(premiumProvider.notifier).checkSubscription(currentUserId));
  }

  // Phase 4.5: デイリーミッション統一
  // ミッション初期化: 現在のユーザー ID で初期化
  if (currentUserId != null) {
    unawaited(container.read(missionProvider.notifier).initializeDailyMissions(currentUserId, 'kokugo'));
  }

  // Phase 4.20: 週次ボーナスシステム統一
  // 週次ボーナス初期化とFirestoreハンドラ設定
  if (currentUserId != null) {
    // Firestore 永続化ハンドラを設定
    container.read(weeklyBonusProvider.notifier).setPersistHandler(
      (userId, bonus) async {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('bonuses')
              .doc('weekly')
              .set(bonus.toJson());
        } catch (e) {
          debugPrint('Failed to persist weekly bonus: $e');
        }
      },
    );
    // 週次ボーナス初期化
    unawaited(
      container.read(weeklyBonusProvider.notifier).initializeWeeklyBonus(currentUserId),
    );
  }

  // Phase 4.20: デイリーミッション統一実装
  // 日次ミッション初期化: 現在のユーザー ID とアプリ ID で初期化
  if (currentUserId != null) {
    unawaited(container.read(dailyMissionProvider.notifier).initializeDailyMissions(currentUserId, 'kokugo'));
  }

  // Phase 4.22: プッシュ通知・ユーザーリテンション統合
  final pushNotificationService = FirestorePushNotificationService();
  final retentionService = FirestoreRetentionService();

  // プッシュ通知ハンドラーを設定
  container.read(pushNotificationProvider.notifier).setHandlers(
    fetchHandler: (userId, limit) => pushNotificationService.fetchNotificationConfig().then((config) => config != null ? [config] : []),
    fcmTokenHandler: () async => (await pushService.getFCMToken()) ?? '',
    scheduleHandler: (schedule) async => debugPrint('Notification scheduled: ${schedule.scheduledTime}'),
    logHandler: (log) => pushNotificationService.logNotification(
      log.notificationId,
      log.type.name,
      log.title,
      log.body,
      deepLink: log.deepLink,
      customData: log.customData,
    ),
    markAsReadHandler: (notificationId) => pushNotificationService.markNotificationAsRead(notificationId),
    updateConfigHandler: (config) => pushNotificationService.updateNotificationConfig(config),
  );

  // リテンション分析ハンドラーを設定
  container.read(retentionProvider.notifier).setHandlers(
    churnHandler: (limit) => retentionService.fetchChurnPredictions(limit: limit),
    analyticsHandler: (userId) => retentionService.fetchUserRetentionAnalytics(userId),
    campaignHandler: (campaign) => retentionService.saveReengagementCampaign(campaign),
    cohortHandler: (cohortId) => retentionService.fetchCohortAnalytics(cohortId),
    statsHandler: () => retentionService.fetchPopulationStats(),
    configHandler: () => retentionService.fetchRetentionConfig(),
  );

  // FCM トークン更新時にFirestoreに保存
  if (currentUserId != null) {
    final fcmToken = await pushService.getFCMToken();
    if (fcmToken != null) {
      unawaited(pushNotificationService.updateFCMToken(fcmToken));
    }
  }

  runApp(UncontrolledProviderScope(
    container: container,
    child: const KokugoKoreApp(),
  ));
}

class KokugoKoreApp extends ConsumerWidget {
  const KokugoKoreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: '小学コレ！国語',
      theme: buildAppTheme(),
      darkTheme: buildDarkAppTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/profile-selection': (context) => const ProfileSelectionScreen(),
        '/home': (context) => const RootShell(),
        '/stages': (context) => const StageSelectScreen(),
        '/characters': (context) => const CharacterScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/upgrade': (context) => const UpgradeScreen(),
        '/parent-report': (context) => const ParentReportScreen(),
        '/smart-menu': (context) => const SmartMenuScreen(),
        '/yojijukugo-quiz': (context) => const YojijukugoQuizScreen(),
        '/synonym-antonym-quiz': (context) => const SynonymAntonymQuizScreen(),
        '/homophone-quiz': (context) => const PremiumGate(
              featureName: '同音異義語',
              featureEmoji: '🔤',
              child: HomophoneQuizScreen(),
            ),
        '/grammar-quiz': (context) => const PremiumGate(
              featureName: '文法',
              featureEmoji: '📝',
              child: GrammarQuizScreen(),
            ),
        '/bushu-quiz': (context) => const PremiumGate(
              featureName: '部首',
              featureEmoji: '🈴',
              child: BushuQuizScreen(),
            ),
        '/haiku-quiz': (context) => const PremiumGate(
              featureName: '俳句',
              featureEmoji: '🎋',
              child: HaikuQuizScreen(),
            ),
        '/ai-kanji-consultation': (context) =>
            const AIKanjiConsultationScreen(),
        '/privacy': (context) => const PrivacyPolicyScreen(),
        '/terms': (context) => const PrivacyPolicyScreen(),
        '/shop': (context) => const ShopScreen(),
        '/learn': (context) => const LearnScreen(),
        '/lesson': (context) => const LessonScreen(),
        '/ai-coaching': (context) => const AiCoachingDashboardScreen(),
        '/vocabulary': (context) => const PremiumGate(
              featureName: 'ことば',
              featureEmoji: '💬',
              child: VocabularyScreen(),
            ),
        '/writing': (context) => const PremiumGate(
              featureName: '作文',
              featureEmoji: '✏️',
              child: WritingScreen(),
            ),
        '/kanji': (context) => const PremiumGate(
              featureName: '漢字一覧',
              featureEmoji: '漢',
              child: KanjiListScreen(),
            ),
        '/proverb-quiz': (context) => const PremiumGate(
              featureName: 'ことわざ',
              featureEmoji: '🏮',
              child: ProverbQuizScreen(),
            ),
        '/idiom-quiz': (context) => const PremiumGate(
              featureName: '慣用句',
              featureEmoji: '🏮',
              child: IdiomQuizScreen(),
            ),
        '/parent-dashboard': (context) => const ParentDashboardScreen(),
        '/multiplayer': (context) => const PremiumGate(
              featureName: 'マルチプレイ',
              featureEmoji: '⚔️',
              child: MultiplayerMenuScreen(),
            ),
        '/friend-invitation': (context) => const FriendInvitationScreen(),
        '/ranking': (context) => const PremiumGate(
              featureName: 'マルチプレイ',
              featureEmoji: '⚔️',
              child: RankingScreen(),
            ),
        '/reading': (context) => const PremiumGate(
              featureName: '読解力強化',
              featureEmoji: '📖',
              child: ReadingMenuScreen(),
            ),
        '/badges': (context) => const BadgeScreen(),
        '/goal-setting': (context) => const GoalSettingScreen(),
        '/mission': (context) => const MissionScreen(),
        '/random-match': (context) => const RandomMatchScreen(),
        '/battle-stats': (context) => const BattleStatsScreen(),
        '/analytics': (context) => const DetailedAnalyticsScreen(),
        '/multiplayer/rated-match': (context) => const RatedMatchScreen(),
        '/multiplayer/leaderboard': (context) => const KokugoLeaderboardScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/multiplayer/quiz') {
          final matchId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => MultiplayerQuizScreen(matchId: matchId),
            settings: settings,
          );
        }
        if (settings.name == '/quest') {
          final stage = settings.arguments as Stage;
          return MaterialPageRoute(
            builder: (_) => QuestScreen(stage: stage),
            settings: settings,
          );
        }
        if (settings.name == '/result') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => ResultScreen(
              result: args['result'] as QuestResult,
              stage: args['stage'] as Stage,
            ),
            settings: settings,
          );
        }
        if (settings.name == '/kana') {
          final kanaType = settings.arguments as KanaType;
          return MaterialPageRoute(
            builder: (_) => PremiumGate(
              featureName: 'ひらがな・カタカナ',
              featureEmoji: 'あ',
              child: KanaListScreen(kanaType: kanaType),
            ),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}

class RootShell extends ConsumerStatefulWidget {
  const RootShell({super.key});

  @override
  ConsumerState<RootShell> createState() => _RootShellState();
}

class _RootShellState extends ConsumerState<RootShell> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Load persisted state for all stateful providers
      await ref.read(coinProvider.notifier).load();
      await ref.read(progressProvider.notifier).load();
      await ref.read(purchasedItemsProvider.notifier).load();
      await ref.read(profileAvatarProvider.notifier).load();
      await ref.read(avatarProvider.notifier).load();
      await ref.read(rankingPrivacyProvider.notifier).load();
      await ref.read(badgeProgressProvider.notifier).load();
      await ref.read(badgeMetricsProvider.notifier).load();
      await ref.read(studyHabitProvider.notifier).load();
      await ref.read(questPerformanceProvider.notifier).load();
      // Refresh avatar unlock status after purchased items are loaded
      ref.read(avatarUnlockProvider.notifier).refreshUnlockStatus();
      // Check character unlocks with loaded progress
      final progress = ref.read(progressProvider);
      await ref
          .read(characterStateProvider.notifier)
          .checkUnlocks(progress.clearedStageIds.length);
    });
  }

  static const _screens = [
    HomeScreen(),
    StudyMenuScreen(),
    CharacterScreen(),
    ShopScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    ref.watch(screenTimeProvider);
    final isLimitReached = ref.read(screenTimeProvider.notifier).isLimitReached;
    if (isLimitReached) {
      return const ScreenTimeLimitReachedWidget(primaryColor: kPrimaryColor);
    }
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        // 下部セーフエリア確保
        selectedFontSize: 11,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'まなぶ'),
          BottomNavigationBarItem(icon: Icon(Icons.face), label: 'キャラクター'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'ショップ'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'せってい'),
        ],
      ),
    );
  }
}

