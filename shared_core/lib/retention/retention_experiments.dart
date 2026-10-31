import 'smart_notification_planner.dart';

/// 定着率施策の A/B テスト ID と、バリアント → 実際の挙動の対応表。
///
/// バリアントの割り当て自体は ab_test_providers.dart の
/// `userTestVariantProvider(testId)` を使う（RemoteConfig の `ab_tests_config` に
/// 下記 testId を登録する）。
class RetentionExperiments {
  RetentionExperiments._();

  /// 通知の語り口（control = standard / variant_b = playful）
  static const notificationTone = 'retention_notification_tone';

  /// 初回7日間の報酬量（control = 1.0 倍 / variant_b = 1.5 倍）
  static const onboardingReward = 'retention_onboarding_reward';

  /// 通知の語り口を、バリアント名（`TestVariant.name`）から決める。
  static NotificationTone toneFor(String? variantName) =>
      variantName == 'variant_b' || variantName == 'variant_c'
          ? NotificationTone.playful
          : NotificationTone.standard;

  /// オンボーディング報酬の倍率を、バリアント名から決める。
  static double rewardMultiplierFor(String? variantName) =>
      variantName == 'variant_b' ? 1.5 : (variantName == 'variant_c' ? 2.0 : 1.0);
}
