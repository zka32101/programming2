import 'package:shared_core/config/subscription_config.dart';
import 'package:shared_core/shared_core.dart' show RevenueCatService;

/// 国語コレ！用 RevenueCat サービス。
///
/// shared_core の [RevenueCatService]（抽象）を継承し、API キーと
/// エンタイトルメント ID を共通設定 [SubscriptionConfig] から渡す。
/// キーは `--dart-define=REVENUE_CAT_GOOGLE_KEY=...` /
/// `--dart-define=REVENUE_CAT_APPLE_KEY=...` で渡す（未設定なら
/// [SubscriptionConfig.isConfigured] が false になり、初期化はスキップされる）。
class KokugoPurchaseService extends RevenueCatService {
  KokugoPurchaseService()
      : super(
          googleKey: SubscriptionConfig.apiKey,
          appleKey: SubscriptionConfig.apiKey,
          premiumEntitlementId: SubscriptionConfig.premiumEntitlementId,
        );
}
