// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PremiumSubscriptionImpl _$$PremiumSubscriptionImplFromJson(
        Map<String, dynamic> json) =>
    _$PremiumSubscriptionImpl(
      userId: json['userId'] as String,
      isSubscribed: json['isSubscribed'] as bool? ?? false,
      subscriptionId: json['subscriptionId'] as String?,
      productId: json['productId'] as String?,
      purchaseDate: json['purchaseDate'] == null
          ? null
          : DateTime.parse(json['purchaseDate'] as String),
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      tier: json['tier'] as String? ?? '',
      autoRenew: json['autoRenew'] as bool? ?? false,
      lastCheckedAt: DateTime.parse(json['lastCheckedAt'] as String),
    );

Map<String, dynamic> _$$PremiumSubscriptionImplToJson(
        _$PremiumSubscriptionImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'isSubscribed': instance.isSubscribed,
      'subscriptionId': instance.subscriptionId,
      'productId': instance.productId,
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'tier': instance.tier,
      'autoRenew': instance.autoRenew,
      'lastCheckedAt': instance.lastCheckedAt.toIso8601String(),
    };
