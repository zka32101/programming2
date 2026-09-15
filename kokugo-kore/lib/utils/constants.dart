// Application Constants
// Phase 4.7: RevenueCat Configuration

class AppConstants {
  // RevenueCat Configuration (Phase 4.7: Moved to shared_core SubscriptionConfig)
  // - revenueCatApiKey: Use SubscriptionConfig.apiKey
  // - subscriptionProductId: Use SubscriptionConfig.monthlyProductId
  // - premiumEntitlementId: Use SubscriptionConfig.premiumEntitlementId

  // Feature Flags
  static const bool adsFreeWithSubscription = true;
  static const bool unlimitedQuizzesWithSubscription = true;

  // Pricing (for display)
  static const String monthlyPrice = '¥120';
  static const int trialDays = 7;

  // App info
  static const String appName = '国語コレ！';
  static const String appVersion = '1.4.0';

  // Firebase collections
  static const String usersCollection = 'users';
  static const String quizzesCollection = 'quizzes';
  static const String progressCollection = 'progress';
}
