// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_ranking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GlobalRanking _$GlobalRankingFromJson(Map<String, dynamic> json) {
  return _GlobalRanking.fromJson(json);
}

/// @nodoc
mixin _$GlobalRanking {
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  int get correctCount => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  double get correctRate => throw _privateConstructorUsedError;
  String get subject =>
      throw _privateConstructorUsedError; // 'eigo', 'sansu', 'kokugo', etc.
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String get grade => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GlobalRankingCopyWith<GlobalRanking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalRankingCopyWith<$Res> {
  factory $GlobalRankingCopyWith(
          GlobalRanking value, $Res Function(GlobalRanking) then) =
      _$GlobalRankingCopyWithImpl<$Res, GlobalRanking>;
  @useResult
  $Res call(
      {String userId,
      String userName,
      int rank,
      int score,
      int correctCount,
      int totalCount,
      double correctRate,
      String subject,
      DateTime updatedAt,
      String? avatarUrl,
      String grade});
}

/// @nodoc
class _$GlobalRankingCopyWithImpl<$Res, $Val extends GlobalRanking>
    implements $GlobalRankingCopyWith<$Res> {
  _$GlobalRankingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? rank = null,
    Object? score = null,
    Object? correctCount = null,
    Object? totalCount = null,
    Object? correctRate = null,
    Object? subject = null,
    Object? updatedAt = null,
    Object? avatarUrl = freezed,
    Object? grade = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
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
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GlobalRankingImplCopyWith<$Res>
    implements $GlobalRankingCopyWith<$Res> {
  factory _$$GlobalRankingImplCopyWith(
          _$GlobalRankingImpl value, $Res Function(_$GlobalRankingImpl) then) =
      __$$GlobalRankingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String userName,
      int rank,
      int score,
      int correctCount,
      int totalCount,
      double correctRate,
      String subject,
      DateTime updatedAt,
      String? avatarUrl,
      String grade});
}

/// @nodoc
class __$$GlobalRankingImplCopyWithImpl<$Res>
    extends _$GlobalRankingCopyWithImpl<$Res, _$GlobalRankingImpl>
    implements _$$GlobalRankingImplCopyWith<$Res> {
  __$$GlobalRankingImplCopyWithImpl(
      _$GlobalRankingImpl _value, $Res Function(_$GlobalRankingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? rank = null,
    Object? score = null,
    Object? correctCount = null,
    Object? totalCount = null,
    Object? correctRate = null,
    Object? subject = null,
    Object? updatedAt = null,
    Object? avatarUrl = freezed,
    Object? grade = null,
  }) {
    return _then(_$GlobalRankingImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
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
      subject: null == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GlobalRankingImpl implements _GlobalRanking {
  const _$GlobalRankingImpl(
      {required this.userId,
      required this.userName,
      required this.rank,
      required this.score,
      required this.correctCount,
      required this.totalCount,
      this.correctRate = 0.0,
      required this.subject,
      required this.updatedAt,
      this.avatarUrl,
      this.grade = ''});

  factory _$GlobalRankingImpl.fromJson(Map<String, dynamic> json) =>
      _$$GlobalRankingImplFromJson(json);

  @override
  final String userId;
  @override
  final String userName;
  @override
  final int rank;
  @override
  final int score;
  @override
  final int correctCount;
  @override
  final int totalCount;
  @override
  @JsonKey()
  final double correctRate;
  @override
  final String subject;
// 'eigo', 'sansu', 'kokugo', etc.
  @override
  final DateTime updatedAt;
  @override
  final String? avatarUrl;
  @override
  @JsonKey()
  final String grade;

  @override
  String toString() {
    return 'GlobalRanking(userId: $userId, userName: $userName, rank: $rank, score: $score, correctCount: $correctCount, totalCount: $totalCount, correctRate: $correctRate, subject: $subject, updatedAt: $updatedAt, avatarUrl: $avatarUrl, grade: $grade)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlobalRankingImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.correctCount, correctCount) ||
                other.correctCount == correctCount) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.correctRate, correctRate) ||
                other.correctRate == correctRate) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.grade, grade) || other.grade == grade));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      userName,
      rank,
      score,
      correctCount,
      totalCount,
      correctRate,
      subject,
      updatedAt,
      avatarUrl,
      grade);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GlobalRankingImplCopyWith<_$GlobalRankingImpl> get copyWith =>
      __$$GlobalRankingImplCopyWithImpl<_$GlobalRankingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GlobalRankingImplToJson(
      this,
    );
  }
}

abstract class _GlobalRanking implements GlobalRanking {
  const factory _GlobalRanking(
      {required final String userId,
      required final String userName,
      required final int rank,
      required final int score,
      required final int correctCount,
      required final int totalCount,
      final double correctRate,
      required final String subject,
      required final DateTime updatedAt,
      final String? avatarUrl,
      final String grade}) = _$GlobalRankingImpl;

  factory _GlobalRanking.fromJson(Map<String, dynamic> json) =
      _$GlobalRankingImpl.fromJson;

  @override
  String get userId;
  @override
  String get userName;
  @override
  int get rank;
  @override
  int get score;
  @override
  int get correctCount;
  @override
  int get totalCount;
  @override
  double get correctRate;
  @override
  String get subject;
  @override // 'eigo', 'sansu', 'kokugo', etc.
  DateTime get updatedAt;
  @override
  String? get avatarUrl;
  @override
  String get grade;
  @override
  @JsonKey(ignore: true)
  _$$GlobalRankingImplCopyWith<_$GlobalRankingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
