// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adaptive_difficulty_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdaptiveDifficulty _$AdaptiveDifficultyFromJson(Map<String, dynamic> json) {
  return _AdaptiveDifficulty.fromJson(json);
}

/// @nodoc
mixin _$AdaptiveDifficulty {
  String get userId => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  String get currentLevel =>
      throw _privateConstructorUsedError; // beginner, intermediate, advanced
  double get performanceScore =>
      throw _privateConstructorUsedError; // 0.0-100.0 based on accuracy
  int get correctCount => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  double get correctRate => throw _privateConstructorUsedError;
  List<String> get recommendedTopics => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdaptiveDifficultyCopyWith<AdaptiveDifficulty> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdaptiveDifficultyCopyWith<$Res> {
  factory $AdaptiveDifficultyCopyWith(
          AdaptiveDifficulty value, $Res Function(AdaptiveDifficulty) then) =
      _$AdaptiveDifficultyCopyWithImpl<$Res, AdaptiveDifficulty>;
  @useResult
  $Res call(
      {String userId,
      String subject,
      String currentLevel,
      double performanceScore,
      int correctCount,
      int totalCount,
      double correctRate,
      List<String> recommendedTopics,
      DateTime lastUpdated});
}

/// @nodoc
class _$AdaptiveDifficultyCopyWithImpl<$Res, $Val extends AdaptiveDifficulty>
    implements $AdaptiveDifficultyCopyWith<$Res> {
  _$AdaptiveDifficultyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? subject = null,
    Object? currentLevel = null,
    Object? performanceScore = null,
    Object? correctCount = null,
    Object? totalCount = null,
    Object? correctRate = null,
    Object? recommendedTopics = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      currentLevel: null == currentLevel
          ? _value.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as String,
      performanceScore: null == performanceScore
          ? _value.performanceScore
          : performanceScore // ignore: cast_nullable_to_non_nullable
              as double,
      correctCount: null == correctCount
          ? _value.correctCount
          : correctCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      correctRate: null == correctRate
          ? _value.correctRate
          : correctRate // ignore: cast_nullable_to_non_nullable
              as double,
      recommendedTopics: null == recommendedTopics
          ? _value.recommendedTopics
          : recommendedTopics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdaptiveDifficultyImplCopyWith<$Res>
    implements $AdaptiveDifficultyCopyWith<$Res> {
  factory _$$AdaptiveDifficultyImplCopyWith(_$AdaptiveDifficultyImpl value,
          $Res Function(_$AdaptiveDifficultyImpl) then) =
      __$$AdaptiveDifficultyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String subject,
      String currentLevel,
      double performanceScore,
      int correctCount,
      int totalCount,
      double correctRate,
      List<String> recommendedTopics,
      DateTime lastUpdated});
}

/// @nodoc
class __$$AdaptiveDifficultyImplCopyWithImpl<$Res>
    extends _$AdaptiveDifficultyCopyWithImpl<$Res, _$AdaptiveDifficultyImpl>
    implements _$$AdaptiveDifficultyImplCopyWith<$Res> {
  __$$AdaptiveDifficultyImplCopyWithImpl(_$AdaptiveDifficultyImpl _value,
      $Res Function(_$AdaptiveDifficultyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? subject = null,
    Object? currentLevel = null,
    Object? performanceScore = null,
    Object? correctCount = null,
    Object? totalCount = null,
    Object? correctRate = null,
    Object? recommendedTopics = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$AdaptiveDifficultyImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      currentLevel: null == currentLevel
          ? _value.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as String,
      performanceScore: null == performanceScore
          ? _value.performanceScore
          : performanceScore // ignore: cast_nullable_to_non_nullable
              as double,
      correctCount: null == correctCount
          ? _value.correctCount
          : correctCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      correctRate: null == correctRate
          ? _value.correctRate
          : correctRate // ignore: cast_nullable_to_non_nullable
              as double,
      recommendedTopics: null == recommendedTopics
          ? _value._recommendedTopics
          : recommendedTopics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdaptiveDifficultyImpl implements _AdaptiveDifficulty {
  const _$AdaptiveDifficultyImpl(
      {required this.userId,
      required this.subject,
      this.currentLevel = 'intermediate',
      this.performanceScore = 0.0,
      this.correctCount = 0,
      this.totalCount = 0,
      this.correctRate = 0.0,
      final List<String> recommendedTopics = const [],
      required this.lastUpdated})
      : _recommendedTopics = recommendedTopics;

  factory _$AdaptiveDifficultyImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdaptiveDifficultyImplFromJson(json);

  @override
  final String userId;
  @override
  final String subject;
  @override
  @JsonKey()
  final String currentLevel;
// beginner, intermediate, advanced
  @override
  @JsonKey()
  final double performanceScore;
// 0.0-100.0 based on accuracy
  @override
  @JsonKey()
  final int correctCount;
  @override
  @JsonKey()
  final int totalCount;
  @override
  @JsonKey()
  final double correctRate;
  final List<String> _recommendedTopics;
  @override
  @JsonKey()
  List<String> get recommendedTopics {
    if (_recommendedTopics is EqualUnmodifiableListView)
      return _recommendedTopics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedTopics);
  }

  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'AdaptiveDifficulty(userId: $userId, subject: $subject, currentLevel: $currentLevel, performanceScore: $performanceScore, correctCount: $correctCount, totalCount: $totalCount, correctRate: $correctRate, recommendedTopics: $recommendedTopics, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdaptiveDifficultyImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.currentLevel, currentLevel) ||
                other.currentLevel == currentLevel) &&
            (identical(other.performanceScore, performanceScore) ||
                other.performanceScore == performanceScore) &&
            (identical(other.correctCount, correctCount) ||
                other.correctCount == correctCount) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.correctRate, correctRate) ||
                other.correctRate == correctRate) &&
            const DeepCollectionEquality()
                .equals(other._recommendedTopics, _recommendedTopics) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      subject,
      currentLevel,
      performanceScore,
      correctCount,
      totalCount,
      correctRate,
      const DeepCollectionEquality().hash(_recommendedTopics),
      lastUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdaptiveDifficultyImplCopyWith<_$AdaptiveDifficultyImpl> get copyWith =>
      __$$AdaptiveDifficultyImplCopyWithImpl<_$AdaptiveDifficultyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdaptiveDifficultyImplToJson(
      this,
    );
  }
}

abstract class _AdaptiveDifficulty implements AdaptiveDifficulty {
  const factory _AdaptiveDifficulty(
      {required final String userId,
      required final String subject,
      final String currentLevel,
      final double performanceScore,
      final int correctCount,
      final int totalCount,
      final double correctRate,
      final List<String> recommendedTopics,
      required final DateTime lastUpdated}) = _$AdaptiveDifficultyImpl;

  factory _AdaptiveDifficulty.fromJson(Map<String, dynamic> json) =
      _$AdaptiveDifficultyImpl.fromJson;

  @override
  String get userId;
  @override
  String get subject;
  @override
  String get currentLevel;
  @override // beginner, intermediate, advanced
  double get performanceScore;
  @override // 0.0-100.0 based on accuracy
  int get correctCount;
  @override
  int get totalCount;
  @override
  double get correctRate;
  @override
  List<String> get recommendedTopics;
  @override
  DateTime get lastUpdated;
  @override
  @JsonKey(ignore: true)
  _$$AdaptiveDifficultyImplCopyWith<_$AdaptiveDifficultyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
