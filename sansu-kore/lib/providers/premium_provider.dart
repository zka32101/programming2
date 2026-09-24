import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/sansu_purchase_service.dart';

final premiumProvider = StateNotifierProvider<PremiumNotifier, PremiumStatus>((ref) {
  return PremiumNotifier();
});

class PremiumNotifier extends StateNotifier<PremiumStatus> {
  PremiumNotifier() : super(const PremiumStatus(
    isPremium: false,
    expiryDate: null,
    features: [],
    isTrialActive: false,
    trialDaysLeft: 0,
  ));

  void activatePremium(DateTime expiryDate) {
    state = PremiumStatus(
      isPremium: true,
      expiryDate: expiryDate,
      features: ['unlimited_stages', 'no_ads', 'exclusive_content'],
      isTrialActive: false,
      trialDaysLeft: 0,
    );
  }

  void deactivatePremium() {
    state = const PremiumStatus(
      isPremium: false,
      expiryDate: null,
      features: [],
      isTrialActive: false,
      trialDaysLeft: 0,
    );
  }

  bool hasFeature(String feature) {
    return state.features.contains(feature);
  }

  Future<void> load() async {
    await _sync(await _guard(() => SansuPurchaseService.instance.premiumExpiry()));
  }

  Future<bool> restorePurchases() async {
    return _sync(await _guard(() => SansuPurchaseService.instance.restore()));
  }

  Future<bool> purchaseMonthly() async {
    return _sync(await _guard(
        () => SansuPurchaseService.instance.purchase(monthly: true)));
  }

  Future<bool> purchaseYearly() async {
    return _sync(await _guard(
        () => SansuPurchaseService.instance.purchase(monthly: false)));
  }

  Future<DateTime?> _guard(Future<DateTime?> Function() action) async {
    if (!SansuPurchaseService.instance.isConfigured) {
      // REVENUE_CAT_GOOGLE_KEY が --dart-define で渡されていないビルドでは
      // RevenueCat が初期化されず、購入は常に失敗する。
      if (kDebugMode) {
        debugPrint(
            '⚠️ RevenueCat is not configured (REVENUE_CAT_GOOGLE_KEY missing). '
            'Purchases will always fail until the key is supplied at build time.');
      }
    }
    try {
      return await action();
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('❌ Purchase error: $e\n$st');
      }
      return null;
    }
  }

  bool _sync(DateTime? expiry) {
    if (expiry == null) return false;
    activatePremium(expiry);
    return true;
  }
}

class PremiumStatus {
  final bool isPremium;
  final DateTime? expiryDate;
  final List<String> features;
  final bool isTrialActive;
  final int trialDaysLeft;

  const PremiumStatus({
    required this.isPremium,
    required this.expiryDate,
    required this.features,
    required this.isTrialActive,
    required this.trialDaysLeft,
  });
}
