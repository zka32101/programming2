library shared_core;

// Models
export 'models/user_profile.dart';
export 'models/quest_model.dart';
export 'models/badge_model.dart';
export 'models/avatar_model.dart';
export 'models/character_data.dart'; // BaseCharacter, CharacterState, AppShopItem, kLevelUpCost
export 'models/lesson_content_model.dart'; // LessonContent, LessonSection（解説メニュー）
export 'models/feedback_model.dart'; // FeedbackType, FeedbackReport（バグ報告・改善要望）

// Providers
export 'providers/progress_provider.dart';
export 'providers/adaptive_provider.dart';
export 'providers/daily_bonus_provider.dart';
export 'providers/coin_provider.dart';
export 'providers/badge_provider.dart';
export 'providers/avatar_provider.dart';
export 'providers/profile_provider.dart';
export 'providers/learning_timer_provider.dart';
export 'providers/character_state_provider.dart'; // BaseCharacterNotifier, characterStateProvider
export 'providers/inventory_provider.dart';        // InventoryNotifier, inventoryProvider
export 'providers/lesson_provider.dart';           // LessonNotifier, lessonProvider（解説メニュー）
export 'providers/feedback_provider.dart';         // FeedbackNotifier, feedbackProvider（バグ報告・改善要望）

// Widgets
export 'widgets/generic_quiz_widget.dart';
export 'widgets/daily_bonus_dialog.dart';
export 'widgets/daily_mission_card.dart';
export 'widgets/timer_chip_widget.dart';
export 'widgets/coin_balance_widget.dart';         // CoinBalanceWidget
export 'widgets/avatar_widget.dart';               // AvatarWidget, LockedAvatarWidget
export 'widgets/character_collection_page.dart';   // CharacterCollectionPage
export 'widgets/coin_shop_page.dart';              // CoinShopPage, ShopItemTile
export 'widgets/furigana_text.dart';               // FuriganaText（{漢字|かんじ}形式のルビ表示、全アプリ共通化）
export 'widgets/lesson_menu_page.dart';            // LessonMenuPage, LessonDetailPage（解説メニュー）
export 'widgets/feedback_form_page.dart';          // FeedbackFormPage（バグ報告・改善要望）

// Services
export 'services/firebase_service.dart';

// Theme
export 'theme/app_theme_base.dart';

// クロスプロモーション（他アプリ紹介）— 実装は cross_promo_kit（ポートフォリオ全体の共通パッケージ）に一本化。
export 'package:cross_promo_kit/cross_promo_kit.dart';

// --- 定着率施策(最新の shared_core から取り込み。既存の機能には手を入れない) ---
export 'utils/date_key.dart';                       // dateKeyOf, parseDateKey, calendarDaysBetween
export 'retention/smart_notification_planner.dart'; // SmartNotificationPlanner, StudyWindow, NotificationContext, PlannedNotification, NotificationTone
export 'retention/notification_plan_provider.dart'; // notificationPlanProvider
export 'retention/smart_reminder_scheduler.dart';   // SmartReminderScheduler
export 'retention/onboarding_rewards.dart';         // onboardingProvider, kOnboardingRewards（初回7日間）
export 'retention/spaced_review.dart';              // reviewQueueProvider, reviewDueCountProvider（間違い復習）
export 'retention/collection.dart';                 // CollectionSet, collectionProvider
export 'retention/parent_report.dart';              // ParentReportBuilder, ParentReportScheduler
export 'retention/retention_kpi.dart';              // RetentionKpi, retentionTrackerProvider
export 'retention/retention_experiments.dart';      // RetentionExperiments
export 'retention/answer_streak_bonus.dart';        // AnswerStreakBonus, answerStreakProvider
export 'retention/learning_support.dart';           // ExplanationDepthSelector, AutoHintPolicy, AchievementProximityHint
export 'retention/weekly_challenge.dart';           // weeklyChallengeProvider
export 'retention/family_challenge.dart';           // FamilyChallengeSession
export 'services/weekly_report_notification_scheduler.dart'; // WeeklyReportNotificationScheduler
export 'models/screen_time_model.dart';
export 'widgets/review_today_card.dart';
export 'widgets/review_today_card.dart';
