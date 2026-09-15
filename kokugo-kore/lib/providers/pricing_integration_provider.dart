import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';

import 'subscription_provider.dart';

/// Phase 4.12: Dynamic Pricing Integration
///
/// shared_core の DynamicPaywallWidget を使用する際のプロバイダー統合ポイント
/// ユーザータイプ別の動的価格表示に対応

/// 現在のサブスクリプション状態を監視
final subscriptionStatusProvider = Provider((ref) {
  final subscriptionState = ref.watch(subscriptionProvider);
  return subscriptionState.isSubscribed;
});

/// 利用可能なオファリングを取得
final availableOfferingsProvider = Provider((ref) {
  final subscriptionState = ref.watch(subscriptionProvider);
  return subscriptionState.availableOfferings;
});

/// 有効期限情報を取得
final subscriptionExpirationProvider = Provider((ref) {
  final subscriptionState = ref.watch(subscriptionProvider);
  return subscriptionState.expirationDate;
});

/// ローディング状態を監視
final subscriptionLoadingProvider = Provider((ref) {
  final subscriptionState = ref.watch(subscriptionProvider);
  return subscriptionState.isLoading;
});

/// エラーメッセージを監視
final subscriptionErrorProvider = Provider((ref) {
  final subscriptionState = ref.watch(subscriptionProvider);
  return subscriptionState.errorMessage;
});

/// Paywall ウィジェット統合（shared_core）
final dynamicPaywallWidgetProvider = Provider((ref) {
  // shared_core の DynamicPaywallWidget を使用
  // 実装は shared_core/lib/widgets/dynamic_paywall_widget.dart
  return DynamicPaywallWidget();
});

/// サブスクリプション購買処理
final subscriptionPurchaseProvider = FutureProvider.family<bool, String>((ref, packageId) async {
  final subscriptionNotifier = ref.read(subscriptionProvider.notifier);
  try {
    await subscriptionNotifier.purchasePackage(packageId);
    return true;
  } catch (e) {
    return false;
  }
});
