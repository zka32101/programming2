// Application Constants
// Phase 4.7: RevenueCat Configuration

class AppConstants {
  // RevenueCat Configuration (Phase 4.7: Moved to shared_core SubscriptionConfig)
  // - revenueCatApiKey: Use SubscriptionConfig.apiKey
  // - subscriptionProductId: Use SubscriptionConfig.monthlyProductId
  // - premiumEntitlementId: Use SubscriptionConfig.premiumEntitlementId

  // Feature Flags
  static const bool unlimitedQuizzesWithSubscription = true;

  // Pricing (for display)
  static const String monthlyPrice = '¥300';
  static const String annualPrice = '¥2,400';
  static const int trialDays = 7;

  // App info
  static const String appName = '国語コレ！';
  /// pubspec.yaml の version（+ビルド番号の前）と一致させること。
  /// test/app_version_test.dart が不一致を検出する。
  static const String appVersion = '1.5.1';

  // Firebase collections
  static const String usersCollection = 'users';
  static const String quizzesCollection = 'quizzes';
  static const String progressCollection = 'progress';
}
