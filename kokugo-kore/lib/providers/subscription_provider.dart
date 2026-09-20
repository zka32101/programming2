import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_core/config/subscription_config.dart';

import '../services/kokugo_purchase_service.dart';

// 購読状態を表すモデル
class SubscriptionState {
  final bool isSubscribed;
  final List<Package>? availableOfferings;
  final DateTime? expirationDate;
  final bool isLoading;
  final String? errorMessage;

  const SubscriptionState({
    required this.isSubscribed,
    this.availableOfferings,
    this.expirationDate,
    this.isLoading = false,
    this.errorMessage,
  });

  SubscriptionState copyWith({
    bool? isSubscribed,
    List<Package>? availableOfferings,
    DateTime? expirationDate,
    bool? isLoading,
    String? errorMessage,
  }) =>
      SubscriptionState(
        isSubscribed: isSubscribed ?? this.isSubscribed,
        availableOfferings: availableOfferings ?? this.availableOfferings,
        expirationDate: expirationDate ?? this.expirationDate,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

bool _hasPremium(CustomerInfo info) =>
    info.entitlements.active.containsKey(SubscriptionConfig.premiumEntitlementId);

// 購読状態管理 NotifierProvider
class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  final KokugoPurchaseService _service = KokugoPurchaseService();

  SubscriptionNotifier() : super(const SubscriptionState(isSubscribed: false));

  /// 購読状態を更新
  Future<void> refreshSubscriptionStatus() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // RevenueCat は appUserID を内部管理するため userId は不要（空文字を渡す）
      final isSubscribed = await _service.isSubscribed('');
      final offerings = await _service.getOfferings();
      final expirationDate = await _service.getSubscriptionExpirationDate('');

      state = state.copyWith(
        isSubscribed: isSubscribed,
        availableOfferings: offerings?.current?.availablePackages,
        expirationDate: expirationDate,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to refresh subscription: $e',
      );
    }
  }

  /// サブスク購入
  Future<bool> purchaseSubscription(Package package) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final info = await _service.purchase(package);
      final success = info != null && _hasPremium(info);
      if (success) {
        await refreshSubscriptionStatus();
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Purchase failed',
        );
      }
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Purchase error: $e',
      );
      return false;
    }
  }

  /// 購入を復元
  Future<bool> restorePurchases() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final info = await _service.restorePurchases();
      final success = _hasPremium(info);
      if (success) {
        await refreshSubscriptionStatus();
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Restore failed',
        );
      }
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Restore error: $e',
      );
      return false;
    }
  }
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>(
  (ref) => SubscriptionNotifier(),
);

/// ペイウォール表示用の商品詳細（ストアのローカライズ済み価格）
class SubscriptionDetails {
  final String localizedPrice;
  const SubscriptionDetails({required this.localizedPrice});
}

final subscriptionDetailsProvider =
    FutureProvider<SubscriptionDetails>((ref) async {
  final offerings = await KokugoPurchaseService().getOfferings();
  final current = offerings?.current;
  final package = current?.monthly ??
      (current?.availablePackages.isNotEmpty == true
          ? current!.availablePackages.first
          : null);
  if (package == null) {
    throw Exception('商品情報を取得できません');
  }
  return SubscriptionDetails(localizedPrice: package.storeProduct.priceString);
});

// 購読ステータスストリーム（リアルタイム更新）
final subscriptionStatusStreamProvider = StreamProvider<bool>((ref) {
  return KokugoPurchaseService().customerInfoStream.map(_hasPremium);
});
