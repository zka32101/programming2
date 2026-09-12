// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'premium_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PremiumSubscription _$PremiumSubscriptionFromJson(Map<String, dynamic> json) {
  return _PremiumSubscription.fromJson(json);
}

/// @nodoc
mixin _$PremiumSubscription {
  String get userId => throw _privateConstructorUsedError;
  bool get isSubscribed => throw _privateConstructorUsedError;
  String? get subscriptionId => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  DateTime? get purchaseDate => throw _privateConstructorUsedError;
  DateTime? get expirationDate => throw _privateConstructorUsedError;
  String get tier => throw _privateConstructorUsedError; // 'monthly', 'yearly'
  bool get autoRenew => throw _privateConstructorUsedError;
  DateTime get lastCheckedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PremiumSubscriptionCopyWith<PremiumSubscription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PremiumSubscriptionCopyWith<$Res> {
  factory $PremiumSubscriptionCopyWith(
          PremiumSubscription value, $Res Function(PremiumSubscription) then) =
      _$PremiumSubscriptionCopyWithImpl<$Res, PremiumSubscription>;
  @useResult
  $Res call(
      {String userId,
      bool isSubscribed,
      String? subscriptionId,
      String? productId,
      DateTime? purchaseDate,
      DateTime? expirationDate,
      String tier,
      bool autoRenew,
      DateTime lastCheckedAt});
}

/// @nodoc
class _$PremiumSubscriptionCopyWithImpl<$Res, $Val extends PremiumSubscription>
    implements $PremiumSubscriptionCopyWith<$Res> {
  _$PremiumSubscriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? isSubscribed = null,
    Object? subscriptionId = freezed,
    Object? productId = freezed,
    Object? purchaseDate = freezed,
    Object? expirationDate = freezed,
    Object? tier = null,
    Object? autoRenew = null,
    Object? lastCheckedAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      isSubscribed: null == isSubscribed
          ? _value.isSubscribed
          : isSubscribed // ignore: cast_nullable_to_non_nullable
              as bool,
      subscriptionId: freezed == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as String,
      autoRenew: null == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      lastCheckedAt: null == lastCheckedAt
          ? _value.lastCheckedAt
          : lastCheckedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PremiumSubscriptionImplCopyWith<$Res>
    implements $PremiumSubscriptionCopyWith<$Res> {
  factory _$$PremiumSubscriptionImplCopyWith(_$PremiumSubscriptionImpl value,
          $Res Function(_$PremiumSubscriptionImpl) then) =
      __$$PremiumSubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      bool isSubscribed,
      String? subscriptionId,
      String? productId,
      DateTime? purchaseDate,
      DateTime? expirationDate,
      String tier,
      bool autoRenew,
      DateTime lastCheckedAt});
}

/// @nodoc
class __$$PremiumSubscriptionImplCopyWithImpl<$Res>
    extends _$PremiumSubscriptionCopyWithImpl<$Res, _$PremiumSubscriptionImpl>
    implements _$$PremiumSubscriptionImplCopyWith<$Res> {
  __$$PremiumSubscriptionImplCopyWithImpl(_$PremiumSubscriptionImpl _value,
      $Res Function(_$PremiumSubscriptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? isSubscribed = null,
    Object? subscriptionId = freezed,
    Object? productId = freezed,
    Object? purchaseDate = freezed,
    Object? expirationDate = freezed,
    Object? tier = null,
    Object? autoRenew = null,
    Object? lastCheckedAt = null,
  }) {
    return _then(_$PremiumSubscriptionImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      isSubscribed: null == isSubscribed
          ? _value.isSubscribed
          : isSubscribed // ignore: cast_nullable_to_non_nullable
              as bool,
      subscriptionId: freezed == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as String,
      autoRenew: null == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      lastCheckedAt: null == lastCheckedAt
          ? _value.lastCheckedAt
          : lastCheckedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PremiumSubscriptionImpl implements _PremiumSubscription {
  const _$PremiumSubscriptionImpl(
      {required this.userId,
      this.isSubscribed = false,
      this.subscriptionId,
      this.productId,
      this.purchaseDate,
      this.expirationDate,
      this.tier = '',
      this.autoRenew = false,
      required this.lastCheckedAt});

  factory _$PremiumSubscriptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PremiumSubscriptionImplFromJson(json);

  @override
  final String userId;
  @override
  @JsonKey()
  final bool isSubscribed;
  @override
  final String? subscriptionId;
  @override
  final String? productId;
  @override
  final DateTime? purchaseDate;
  @override
  final DateTime? expirationDate;
  @override
  @JsonKey()
  final String tier;
// 'monthly', 'yearly'
  @override
  @JsonKey()
  final bool autoRenew;
  @override
  final DateTime lastCheckedAt;

  @override
  String toString() {
    return 'PremiumSubscription(userId: $userId, isSubscribed: $isSubscribed, subscriptionId: $subscriptionId, productId: $productId, purchaseDate: $purchaseDate, expirationDate: $expirationDate, tier: $tier, autoRenew: $autoRenew, lastCheckedAt: $lastCheckedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PremiumSubscriptionImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.isSubscribed, isSubscribed) ||
                other.isSubscribed == isSubscribed) &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.expirationDate, expirationDate) ||
                other.expirationDate == expirationDate) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.autoRenew, autoRenew) ||
                other.autoRenew == autoRenew) &&
            (identical(other.lastCheckedAt, lastCheckedAt) ||
                other.lastCheckedAt == lastCheckedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      isSubscribed,
      subscriptionId,
      productId,
      purchaseDate,
      expirationDate,
      tier,
      autoRenew,
      lastCheckedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PremiumSubscriptionImplCopyWith<_$PremiumSubscriptionImpl> get copyWith =>
      __$$PremiumSubscriptionImplCopyWithImpl<_$PremiumSubscriptionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PremiumSubscriptionImplToJson(
      this,
    );
  }
}

abstract class _PremiumSubscription implements PremiumSubscription {
  const factory _PremiumSubscription(
      {required final String userId,
      final bool isSubscribed,
      final String? subscriptionId,
      final String? productId,
      final DateTime? purchaseDate,
      final DateTime? expirationDate,
      final String tier,
      final bool autoRenew,
      required final DateTime lastCheckedAt}) = _$PremiumSubscriptionImpl;

  factory _PremiumSubscription.fromJson(Map<String, dynamic> json) =
      _$PremiumSubscriptionImpl.fromJson;

  @override
  String get userId;
  @override
  bool get isSubscribed;
  @override
  String? get subscriptionId;
  @override
  String? get productId;
  @override
  DateTime? get purchaseDate;
  @override
  DateTime? get expirationDate;
  @override
  String get tier;
  @override // 'monthly', 'yearly'
  bool get autoRenew;
  @override
  DateTime get lastCheckedAt;
  @override
  @JsonKey(ignore: true)
  _$$PremiumSubscriptionImplCopyWith<_$PremiumSubscriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
