// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'retention_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RetentionMetric _$RetentionMetricFromJson(Map<String, dynamic> json) {
  return _RetentionMetric.fromJson(json);
}

/// @nodoc
mixin _$RetentionMetric {
  String get userId => throw _privateConstructorUsedError;
  DateTime get lastActiveDate => throw _privateConstructorUsedError;
  int get daysSinceLastActive => throw _privateConstructorUsedError;
  int get totalLearningDays => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  bool get isAtRisk =>
      throw _privateConstructorUsedError; // True if no activity for 7+ days
  double get engagementScore => throw _privateConstructorUsedError; // 0.0-100.0
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RetentionMetricCopyWith<RetentionMetric> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RetentionMetricCopyWith<$Res> {
  factory $RetentionMetricCopyWith(
          RetentionMetric value, $Res Function(RetentionMetric) then) =
      _$RetentionMetricCopyWithImpl<$Res, RetentionMetric>;
  @useResult
  $Res call(
      {String userId,
      DateTime lastActiveDate,
      int daysSinceLastActive,
      int totalLearningDays,
      int currentStreak,
      bool isAtRisk,
      double engagementScore,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$RetentionMetricCopyWithImpl<$Res, $Val extends RetentionMetric>
    implements $RetentionMetricCopyWith<$Res> {
  _$RetentionMetricCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? lastActiveDate = null,
    Object? daysSinceLastActive = null,
    Object? totalLearningDays = null,
    Object? currentStreak = null,
    Object? isAtRisk = null,
    Object? engagementScore = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      lastActiveDate: null == lastActiveDate
          ? _value.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      daysSinceLastActive: null == daysSinceLastActive
          ? _value.daysSinceLastActive
          : daysSinceLastActive // ignore: cast_nullable_to_non_nullable
              as int,
      totalLearningDays: null == totalLearningDays
          ? _value.totalLearningDays
          : totalLearningDays // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      isAtRisk: null == isAtRisk
          ? _value.isAtRisk
          : isAtRisk // ignore: cast_nullable_to_non_nullable
              as bool,
      engagementScore: null == engagementScore
          ? _value.engagementScore
          : engagementScore // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RetentionMetricImplCopyWith<$Res>
    implements $RetentionMetricCopyWith<$Res> {
  factory _$$RetentionMetricImplCopyWith(_$RetentionMetricImpl value,
          $Res Function(_$RetentionMetricImpl) then) =
      __$$RetentionMetricImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      DateTime lastActiveDate,
      int daysSinceLastActive,
      int totalLearningDays,
      int currentStreak,
      bool isAtRisk,
      double engagementScore,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$RetentionMetricImplCopyWithImpl<$Res>
    extends _$RetentionMetricCopyWithImpl<$Res, _$RetentionMetricImpl>
    implements _$$RetentionMetricImplCopyWith<$Res> {
  __$$RetentionMetricImplCopyWithImpl(
      _$RetentionMetricImpl _value, $Res Function(_$RetentionMetricImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? lastActiveDate = null,
    Object? daysSinceLastActive = null,
    Object? totalLearningDays = null,
    Object? currentStreak = null,
    Object? isAtRisk = null,
    Object? engagementScore = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$RetentionMetricImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      lastActiveDate: null == lastActiveDate
          ? _value.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      daysSinceLastActive: null == daysSinceLastActive
          ? _value.daysSinceLastActive
          : daysSinceLastActive // ignore: cast_nullable_to_non_nullable
              as int,
      totalLearningDays: null == totalLearningDays
          ? _value.totalLearningDays
          : totalLearningDays // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      isAtRisk: null == isAtRisk
          ? _value.isAtRisk
          : isAtRisk // ignore: cast_nullable_to_non_nullable
              as bool,
      engagementScore: null == engagementScore
          ? _value.engagementScore
          : engagementScore // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RetentionMetricImpl implements _RetentionMetric {
  const _$RetentionMetricImpl(
      {required this.userId,
      required this.lastActiveDate,
      required this.daysSinceLastActive,
      required this.totalLearningDays,
      required this.currentStreak,
      this.isAtRisk = false,
      required this.engagementScore,
      required this.createdAt,
      required this.updatedAt});

  factory _$RetentionMetricImpl.fromJson(Map<String, dynamic> json) =>
      _$$RetentionMetricImplFromJson(json);

  @override
  final String userId;
  @override
  final DateTime lastActiveDate;
  @override
  final int daysSinceLastActive;
  @override
  final int totalLearningDays;
  @override
  final int currentStreak;
  @override
  @JsonKey()
  final bool isAtRisk;
// True if no activity for 7+ days
  @override
  final double engagementScore;
// 0.0-100.0
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'RetentionMetric(userId: $userId, lastActiveDate: $lastActiveDate, daysSinceLastActive: $daysSinceLastActive, totalLearningDays: $totalLearningDays, currentStreak: $currentStreak, isAtRisk: $isAtRisk, engagementScore: $engagementScore, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RetentionMetricImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.lastActiveDate, lastActiveDate) ||
                other.lastActiveDate == lastActiveDate) &&
            (identical(other.daysSinceLastActive, daysSinceLastActive) ||
                other.daysSinceLastActive == daysSinceLastActive) &&
            (identical(other.totalLearningDays, totalLearningDays) ||
                other.totalLearningDays == totalLearningDays) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.isAtRisk, isAtRisk) ||
                other.isAtRisk == isAtRisk) &&
            (identical(other.engagementScore, engagementScore) ||
                other.engagementScore == engagementScore) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      lastActiveDate,
      daysSinceLastActive,
      totalLearningDays,
      currentStreak,
      isAtRisk,
      engagementScore,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RetentionMetricImplCopyWith<_$RetentionMetricImpl> get copyWith =>
      __$$RetentionMetricImplCopyWithImpl<_$RetentionMetricImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RetentionMetricImplToJson(
      this,
    );
  }
}

abstract class _RetentionMetric implements RetentionMetric {
  const factory _RetentionMetric(
      {required final String userId,
      required final DateTime lastActiveDate,
      required final int daysSinceLastActive,
      required final int totalLearningDays,
      required final int currentStreak,
      final bool isAtRisk,
      required final double engagementScore,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$RetentionMetricImpl;

  factory _RetentionMetric.fromJson(Map<String, dynamic> json) =
      _$RetentionMetricImpl.fromJson;

  @override
  String get userId;
  @override
  DateTime get lastActiveDate;
  @override
  int get daysSinceLastActive;
  @override
  int get totalLearningDays;
  @override
  int get currentStreak;
  @override
  bool get isAtRisk;
  @override // True if no activity for 7+ days
  double get engagementScore;
  @override // 0.0-100.0
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$RetentionMetricImplCopyWith<_$RetentionMetricImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
