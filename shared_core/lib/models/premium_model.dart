import 'package:freezed_annotation/freezed_annotation.dart';

part 'premium_model.freezed.dart';
part 'premium_model.g.dart';

@freezed
class PremiumSubscription with _$PremiumSubscription {
  const factory PremiumSubscription({
    required String userId,
    @Default(false) bool isSubscribed,
    String? subscriptionId,
    String? productId,
    DateTime? purchaseDate,
    DateTime? expirationDate,
    @Default('') String tier, // 'monthly', 'yearly'
    @Default(false) bool autoRenew,
    required DateTime lastCheckedAt,
  }) = _PremiumSubscription;

  factory PremiumSubscription.fromJson(Map<String, dynamic> json) =>
      _$PremiumSubscriptionFromJson(json);
}
