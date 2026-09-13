library shared_core;

// Models
export 'models/user_profile.dart';
export 'models/quest_model.dart';
export 'models/badge_model.dart';
export 'models/avatar_model.dart';
export 'models/character_data.dart'; // BaseCharacter, CharacterState, AppShopItem, kLevelUpCost
export 'models/friend_request_model.dart';
export 'models/global_ranking_model.dart';
export 'models/mission_model.dart';
export 'models/daily_mission_model.dart';
export 'models/retention_model.dart';
export 'models/adaptive_difficulty_model.dart';
export 'models/premium_model.dart';

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

// Widgets
export 'widgets/generic_quiz_widget.dart';
export 'widgets/daily_bonus_dialog.dart';
export 'widgets/daily_mission_card.dart';
export 'widgets/timer_chip_widget.dart';
export 'widgets/coin_balance_widget.dart';         // CoinBalanceWidget
export 'widgets/avatar_widget.dart';               // AvatarWidget, LockedAvatarWidget
export 'widgets/character_collection_page.dart';   // CharacterCollectionPage
export 'widgets/coin_shop_page.dart';              // CoinShopPage, ShopItemTile
export 'widgets/analytics_dashboard_widget.dart';  // AnalyticsDashboard, DailyActivityData, AccuracyTrendData

// Services
export 'services/firebase_service.dart';
export 'services/parental_gate_service.dart';  // ParentalGateService

// Theme
export 'theme/app_theme_base.dart';
export 'theme/app_theme.dart';

// クロスプロモーション（他アプリ紹介）— 実装待ち
// export 'package:cross_promo_kit/cross_promo_kit.dart';
