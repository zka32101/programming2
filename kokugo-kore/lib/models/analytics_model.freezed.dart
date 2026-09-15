// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DailyStats _$DailyStatsFromJson(Map<String, dynamic> json) {
  return _DailyStats.fromJson(json);
}

/// @nodoc
mixin _$DailyStats {
  String get date => throw _privateConstructorUsedError; // YYYY-MM-DD
  int get questsCompleted => throw _privateConstructorUsedError;
  int get correctAnswers => throw _privateConstructorUsedError;
  int get totalAnswers => throw _privateConstructorUsedError;
  int get coinsEarned => throw _privateConstructorUsedError;
  int get studyMinutes => throw _privateConstructorUsedError;
  Map<String, dynamic> get categoryStats => throw _privateConstructorUsedError;

  /// Serializes this DailyStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyStatsCopyWith<DailyStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyStatsCopyWith<$Res> {
  factory $DailyStatsCopyWith(
    DailyStats value,
    $Res Function(DailyStats) then,
  ) = _$DailyStatsCopyWithImpl<$Res, DailyStats>;
  @useResult
  $Res call({
    String date,
    int questsCompleted,
    int correctAnswers,
    int totalAnswers,
    int coinsEarned,
    int studyMinutes,
    Map<String, dynamic> categoryStats,
  });
}

/// @nodoc
class _$DailyStatsCopyWithImpl<$Res, $Val extends DailyStats>
    implements $DailyStatsCopyWith<$Res> {
  _$DailyStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? questsCompleted = null,
    Object? correctAnswers = null,
    Object? totalAnswers = null,
    Object? coinsEarned = null,
    Object? studyMinutes = null,
    Object? categoryStats = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            questsCompleted: null == questsCompleted
                ? _value.questsCompleted
                : questsCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            correctAnswers: null == correctAnswers
                ? _value.correctAnswers
                : correctAnswers // ignore: cast_nullable_to_non_nullable
                      as int,
            totalAnswers: null == totalAnswers
                ? _value.totalAnswers
                : totalAnswers // ignore: cast_nullable_to_non_nullable
                      as int,
            coinsEarned: null == coinsEarned
                ? _value.coinsEarned
                : coinsEarned // ignore: cast_nullable_to_non_nullable
                      as int,
            studyMinutes: null == studyMinutes
                ? _value.studyMinutes
                : studyMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryStats: null == categoryStats
                ? _value.categoryStats
                : categoryStats // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyStatsImplCopyWith<$Res>
    implements $DailyStatsCopyWith<$Res> {
  factory _$$DailyStatsImplCopyWith(
    _$DailyStatsImpl value,
    $Res Function(_$DailyStatsImpl) then,
  ) = __$$DailyStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String date,
    int questsCompleted,
    int correctAnswers,
    int totalAnswers,
    int coinsEarned,
    int studyMinutes,
    Map<String, dynamic> categoryStats,
  });
}

/// @nodoc
class __$$DailyStatsImplCopyWithImpl<$Res>
    extends _$DailyStatsCopyWithImpl<$Res, _$DailyStatsImpl>
    implements _$$DailyStatsImplCopyWith<$Res> {
  __$$DailyStatsImplCopyWithImpl(
    _$DailyStatsImpl _value,
    $Res Function(_$DailyStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? questsCompleted = null,
    Object? correctAnswers = null,
    Object? totalAnswers = null,
    Object? coinsEarned = null,
    Object? studyMinutes = null,
    Object? categoryStats = null,
  }) {
    return _then(
      _$DailyStatsImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        questsCompleted: null == questsCompleted
            ? _value.questsCompleted
            : questsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        correctAnswers: null == correctAnswers
            ? _value.correctAnswers
            : correctAnswers // ignore: cast_nullable_to_non_nullable
                  as int,
        totalAnswers: null == totalAnswers
            ? _value.totalAnswers
            : totalAnswers // ignore: cast_nullable_to_non_nullable
                  as int,
        coinsEarned: null == coinsEarned
            ? _value.coinsEarned
            : coinsEarned // ignore: cast_nullable_to_non_nullable
                  as int,
        studyMinutes: null == studyMinutes
            ? _value.studyMinutes
            : studyMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryStats: null == categoryStats
            ? _value._categoryStats
            : categoryStats // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyStatsImpl implements _DailyStats {
  const _$DailyStatsImpl({
    required this.date,
    required this.questsCompleted,
    required this.correctAnswers,
    required this.totalAnswers,
    required this.coinsEarned,
    required this.studyMinutes,
    required final Map<String, dynamic> categoryStats,
  }) : _categoryStats = categoryStats;

  factory _$DailyStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyStatsImplFromJson(json);

  @override
  final String date;
  // YYYY-MM-DD
  @override
  final int questsCompleted;
  @override
  final int correctAnswers;
  @override
  final int totalAnswers;
  @override
  final int coinsEarned;
  @override
  final int studyMinutes;
  final Map<String, dynamic> _categoryStats;
  @override
  Map<String, dynamic> get categoryStats {
    if (_categoryStats is EqualUnmodifiableMapView) return _categoryStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryStats);
  }

  @override
  String toString() {
    return 'DailyStats(date: $date, questsCompleted: $questsCompleted, correctAnswers: $correctAnswers, totalAnswers: $totalAnswers, coinsEarned: $coinsEarned, studyMinutes: $studyMinutes, categoryStats: $categoryStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyStatsImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.questsCompleted, questsCompleted) ||
                other.questsCompleted == questsCompleted) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.totalAnswers, totalAnswers) ||
                other.totalAnswers == totalAnswers) &&
            (identical(other.coinsEarned, coinsEarned) ||
                other.coinsEarned == coinsEarned) &&
            (identical(other.studyMinutes, studyMinutes) ||
                other.studyMinutes == studyMinutes) &&
            const DeepCollectionEquality().equals(
              other._categoryStats,
              _categoryStats,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    questsCompleted,
    correctAnswers,
    totalAnswers,
    coinsEarned,
    studyMinutes,
    const DeepCollectionEquality().hash(_categoryStats),
  );

  /// Create a copy of DailyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyStatsImplCopyWith<_$DailyStatsImpl> get copyWith =>
      __$$DailyStatsImplCopyWithImpl<_$DailyStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyStatsImplToJson(this);
  }
}

abstract class _DailyStats implements DailyStats {
  const factory _DailyStats({
    required final String date,
    required final int questsCompleted,
    required final int correctAnswers,
    required final int totalAnswers,
    required final int coinsEarned,
    required final int studyMinutes,
    required final Map<String, dynamic> categoryStats,
  }) = _$DailyStatsImpl;

  factory _DailyStats.fromJson(Map<String, dynamic> json) =
      _$DailyStatsImpl.fromJson;

  @override
  String get date; // YYYY-MM-DD
  @override
  int get questsCompleted;
  @override
  int get correctAnswers;
  @override
  int get totalAnswers;
  @override
  int get coinsEarned;
  @override
  int get studyMinutes;
  @override
  Map<String, dynamic> get categoryStats;

  /// Create a copy of DailyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyStatsImplCopyWith<_$DailyStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeeklyStats _$WeeklyStatsFromJson(Map<String, dynamic> json) {
  return _WeeklyStats.fromJson(json);
}

/// @nodoc
mixin _$WeeklyStats {
  String get weekStart =>
      throw _privateConstructorUsedError; // YYYY-MM-DD (月曜日)
  int get totalStudyMinutes => throw _privateConstructorUsedError;
  int get totalQuestsCompleted => throw _privateConstructorUsedError;
  double get averageAccuracy => throw _privateConstructorUsedError;
  Map<String, int> get dailyCounts => throw _privateConstructorUsedError;

  /// Serializes this WeeklyStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeeklyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklyStatsCopyWith<WeeklyStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyStatsCopyWith<$Res> {
  factory $WeeklyStatsCopyWith(
    WeeklyStats value,
    $Res Function(WeeklyStats) then,
  ) = _$WeeklyStatsCopyWithImpl<$Res, WeeklyStats>;
  @useResult
  $Res call({
    String weekStart,
    int totalStudyMinutes,
    int totalQuestsCompleted,
    double averageAccuracy,
    Map<String, int> dailyCounts,
  });
}

/// @nodoc
class _$WeeklyStatsCopyWithImpl<$Res, $Val extends WeeklyStats>
    implements $WeeklyStatsCopyWith<$Res> {
  _$WeeklyStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekStart = null,
    Object? totalStudyMinutes = null,
    Object? totalQuestsCompleted = null,
    Object? averageAccuracy = null,
    Object? dailyCounts = null,
  }) {
    return _then(
      _value.copyWith(
            weekStart: null == weekStart
                ? _value.weekStart
                : weekStart // ignore: cast_nullable_to_non_nullable
                      as String,
            totalStudyMinutes: null == totalStudyMinutes
                ? _value.totalStudyMinutes
                : totalStudyMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            totalQuestsCompleted: null == totalQuestsCompleted
                ? _value.totalQuestsCompleted
                : totalQuestsCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            averageAccuracy: null == averageAccuracy
                ? _value.averageAccuracy
                : averageAccuracy // ignore: cast_nullable_to_non_nullable
                      as double,
            dailyCounts: null == dailyCounts
                ? _value.dailyCounts
                : dailyCounts // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeeklyStatsImplCopyWith<$Res>
    implements $WeeklyStatsCopyWith<$Res> {
  factory _$$WeeklyStatsImplCopyWith(
    _$WeeklyStatsImpl value,
    $Res Function(_$WeeklyStatsImpl) then,
  ) = __$$WeeklyStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String weekStart,
    int totalStudyMinutes,
    int totalQuestsCompleted,
    double averageAccuracy,
    Map<String, int> dailyCounts,
  });
}

/// @nodoc
class __$$WeeklyStatsImplCopyWithImpl<$Res>
    extends _$WeeklyStatsCopyWithImpl<$Res, _$WeeklyStatsImpl>
    implements _$$WeeklyStatsImplCopyWith<$Res> {
  __$$WeeklyStatsImplCopyWithImpl(
    _$WeeklyStatsImpl _value,
    $Res Function(_$WeeklyStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeeklyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekStart = null,
    Object? totalStudyMinutes = null,
    Object? totalQuestsCompleted = null,
    Object? averageAccuracy = null,
    Object? dailyCounts = null,
  }) {
    return _then(
      _$WeeklyStatsImpl(
        weekStart: null == weekStart
            ? _value.weekStart
            : weekStart // ignore: cast_nullable_to_non_nullable
                  as String,
        totalStudyMinutes: null == totalStudyMinutes
            ? _value.totalStudyMinutes
            : totalStudyMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        totalQuestsCompleted: null == totalQuestsCompleted
            ? _value.totalQuestsCompleted
            : totalQuestsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        averageAccuracy: null == averageAccuracy
            ? _value.averageAccuracy
            : averageAccuracy // ignore: cast_nullable_to_non_nullable
                  as double,
        dailyCounts: null == dailyCounts
            ? _value._dailyCounts
            : dailyCounts // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyStatsImpl implements _WeeklyStats {
  const _$WeeklyStatsImpl({
    required this.weekStart,
    required this.totalStudyMinutes,
    required this.totalQuestsCompleted,
    required this.averageAccuracy,
    required final Map<String, int> dailyCounts,
  }) : _dailyCounts = dailyCounts;

  factory _$WeeklyStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyStatsImplFromJson(json);

  @override
  final String weekStart;
  // YYYY-MM-DD (月曜日)
  @override
  final int totalStudyMinutes;
  @override
  final int totalQuestsCompleted;
  @override
  final double averageAccuracy;
  final Map<String, int> _dailyCounts;
  @override
  Map<String, int> get dailyCounts {
    if (_dailyCounts is EqualUnmodifiableMapView) return _dailyCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dailyCounts);
  }

  @override
  String toString() {
    return 'WeeklyStats(weekStart: $weekStart, totalStudyMinutes: $totalStudyMinutes, totalQuestsCompleted: $totalQuestsCompleted, averageAccuracy: $averageAccuracy, dailyCounts: $dailyCounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyStatsImpl &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            (identical(other.totalStudyMinutes, totalStudyMinutes) ||
                other.totalStudyMinutes == totalStudyMinutes) &&
            (identical(other.totalQuestsCompleted, totalQuestsCompleted) ||
                other.totalQuestsCompleted == totalQuestsCompleted) &&
            (identical(other.averageAccuracy, averageAccuracy) ||
                other.averageAccuracy == averageAccuracy) &&
            const DeepCollectionEquality().equals(
              other._dailyCounts,
              _dailyCounts,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    weekStart,
    totalStudyMinutes,
    totalQuestsCompleted,
    averageAccuracy,
    const DeepCollectionEquality().hash(_dailyCounts),
  );

  /// Create a copy of WeeklyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyStatsImplCopyWith<_$WeeklyStatsImpl> get copyWith =>
      __$$WeeklyStatsImplCopyWithImpl<_$WeeklyStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyStatsImplToJson(this);
  }
}

abstract class _WeeklyStats implements WeeklyStats {
  const factory _WeeklyStats({
    required final String weekStart,
    required final int totalStudyMinutes,
    required final int totalQuestsCompleted,
    required final double averageAccuracy,
    required final Map<String, int> dailyCounts,
  }) = _$WeeklyStatsImpl;

  factory _WeeklyStats.fromJson(Map<String, dynamic> json) =
      _$WeeklyStatsImpl.fromJson;

  @override
  String get weekStart; // YYYY-MM-DD (月曜日)
  @override
  int get totalStudyMinutes;
  @override
  int get totalQuestsCompleted;
  @override
  double get averageAccuracy;
  @override
  Map<String, int> get dailyCounts;

  /// Create a copy of WeeklyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyStatsImplCopyWith<_$WeeklyStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MonthlyStats _$MonthlyStatsFromJson(Map<String, dynamic> json) {
  return _MonthlyStats.fromJson(json);
}

/// @nodoc
mixin _$MonthlyStats {
  String get month => throw _privateConstructorUsedError; // YYYY-MM
  int get totalQuestsCompleted => throw _privateConstructorUsedError;
  int get totalCorrectAnswers => throw _privateConstructorUsedError;
  int get totalAnswers => throw _privateConstructorUsedError;
  double get accuracyRate => throw _privateConstructorUsedError; // 0.0 ~ 1.0
  int get totalStudyMinutes => throw _privateConstructorUsedError;
  int get totalCoinsEarned => throw _privateConstructorUsedError;
  int get studyDaysCount => throw _privateConstructorUsedError; // 学習した日数
  Map<String, dynamic> get categoryStats => throw _privateConstructorUsedError;

  /// Serializes this MonthlyStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyStatsCopyWith<MonthlyStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyStatsCopyWith<$Res> {
  factory $MonthlyStatsCopyWith(
    MonthlyStats value,
    $Res Function(MonthlyStats) then,
  ) = _$MonthlyStatsCopyWithImpl<$Res, MonthlyStats>;
  @useResult
  $Res call({
    String month,
    int totalQuestsCompleted,
    int totalCorrectAnswers,
    int totalAnswers,
    double accuracyRate,
    int totalStudyMinutes,
    int totalCoinsEarned,
    int studyDaysCount,
    Map<String, dynamic> categoryStats,
  });
}

/// @nodoc
class _$MonthlyStatsCopyWithImpl<$Res, $Val extends MonthlyStats>
    implements $MonthlyStatsCopyWith<$Res> {
  _$MonthlyStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? totalQuestsCompleted = null,
    Object? totalCorrectAnswers = null,
    Object? totalAnswers = null,
    Object? accuracyRate = null,
    Object? totalStudyMinutes = null,
    Object? totalCoinsEarned = null,
    Object? studyDaysCount = null,
    Object? categoryStats = null,
  }) {
    return _then(
      _value.copyWith(
            month: null == month
                ? _value.month
                : month // ignore: cast_nullable_to_non_nullable
                      as String,
            totalQuestsCompleted: null == totalQuestsCompleted
                ? _value.totalQuestsCompleted
                : totalQuestsCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCorrectAnswers: null == totalCorrectAnswers
                ? _value.totalCorrectAnswers
                : totalCorrectAnswers // ignore: cast_nullable_to_non_nullable
                      as int,
            totalAnswers: null == totalAnswers
                ? _value.totalAnswers
                : totalAnswers // ignore: cast_nullable_to_non_nullable
                      as int,
            accuracyRate: null == accuracyRate
                ? _value.accuracyRate
                : accuracyRate // ignore: cast_nullable_to_non_nullable
                      as double,
            totalStudyMinutes: null == totalStudyMinutes
                ? _value.totalStudyMinutes
                : totalStudyMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCoinsEarned: null == totalCoinsEarned
                ? _value.totalCoinsEarned
                : totalCoinsEarned // ignore: cast_nullable_to_non_nullable
                      as int,
            studyDaysCount: null == studyDaysCount
                ? _value.studyDaysCount
                : studyDaysCount // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryStats: null == categoryStats
                ? _value.categoryStats
                : categoryStats // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MonthlyStatsImplCopyWith<$Res>
    implements $MonthlyStatsCopyWith<$Res> {
  factory _$$MonthlyStatsImplCopyWith(
    _$MonthlyStatsImpl value,
    $Res Function(_$MonthlyStatsImpl) then,
  ) = __$$MonthlyStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String month,
    int totalQuestsCompleted,
    int totalCorrectAnswers,
    int totalAnswers,
    double accuracyRate,
    int totalStudyMinutes,
    int totalCoinsEarned,
    int studyDaysCount,
    Map<String, dynamic> categoryStats,
  });
}

/// @nodoc
class __$$MonthlyStatsImplCopyWithImpl<$Res>
    extends _$MonthlyStatsCopyWithImpl<$Res, _$MonthlyStatsImpl>
    implements _$$MonthlyStatsImplCopyWith<$Res> {
  __$$MonthlyStatsImplCopyWithImpl(
    _$MonthlyStatsImpl _value,
    $Res Function(_$MonthlyStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MonthlyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? totalQuestsCompleted = null,
    Object? totalCorrectAnswers = null,
    Object? totalAnswers = null,
    Object? accuracyRate = null,
    Object? totalStudyMinutes = null,
    Object? totalCoinsEarned = null,
    Object? studyDaysCount = null,
    Object? categoryStats = null,
  }) {
    return _then(
      _$MonthlyStatsImpl(
        month: null == month
            ? _value.month
            : month // ignore: cast_nullable_to_non_nullable
                  as String,
        totalQuestsCompleted: null == totalQuestsCompleted
            ? _value.totalQuestsCompleted
            : totalQuestsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCorrectAnswers: null == totalCorrectAnswers
            ? _value.totalCorrectAnswers
            : totalCorrectAnswers // ignore: cast_nullable_to_non_nullable
                  as int,
        totalAnswers: null == totalAnswers
            ? _value.totalAnswers
            : totalAnswers // ignore: cast_nullable_to_non_nullable
                  as int,
        accuracyRate: null == accuracyRate
            ? _value.accuracyRate
            : accuracyRate // ignore: cast_nullable_to_non_nullable
                  as double,
        totalStudyMinutes: null == totalStudyMinutes
            ? _value.totalStudyMinutes
            : totalStudyMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCoinsEarned: null == totalCoinsEarned
            ? _value.totalCoinsEarned
            : totalCoinsEarned // ignore: cast_nullable_to_non_nullable
                  as int,
        studyDaysCount: null == studyDaysCount
            ? _value.studyDaysCount
            : studyDaysCount // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryStats: null == categoryStats
            ? _value._categoryStats
            : categoryStats // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyStatsImpl implements _MonthlyStats {
  const _$MonthlyStatsImpl({
    required this.month,
    required this.totalQuestsCompleted,
    required this.totalCorrectAnswers,
    required this.totalAnswers,
    required this.accuracyRate,
    required this.totalStudyMinutes,
    required this.totalCoinsEarned,
    required this.studyDaysCount,
    required final Map<String, dynamic> categoryStats,
  }) : _categoryStats = categoryStats;

  factory _$MonthlyStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyStatsImplFromJson(json);

  @override
  final String month;
  // YYYY-MM
  @override
  final int totalQuestsCompleted;
  @override
  final int totalCorrectAnswers;
  @override
  final int totalAnswers;
  @override
  final double accuracyRate;
  // 0.0 ~ 1.0
  @override
  final int totalStudyMinutes;
  @override
  final int totalCoinsEarned;
  @override
  final int studyDaysCount;
  // 学習した日数
  final Map<String, dynamic> _categoryStats;
  // 学習した日数
  @override
  Map<String, dynamic> get categoryStats {
    if (_categoryStats is EqualUnmodifiableMapView) return _categoryStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryStats);
  }

  @override
  String toString() {
    return 'MonthlyStats(month: $month, totalQuestsCompleted: $totalQuestsCompleted, totalCorrectAnswers: $totalCorrectAnswers, totalAnswers: $totalAnswers, accuracyRate: $accuracyRate, totalStudyMinutes: $totalStudyMinutes, totalCoinsEarned: $totalCoinsEarned, studyDaysCount: $studyDaysCount, categoryStats: $categoryStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyStatsImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.totalQuestsCompleted, totalQuestsCompleted) ||
                other.totalQuestsCompleted == totalQuestsCompleted) &&
            (identical(other.totalCorrectAnswers, totalCorrectAnswers) ||
                other.totalCorrectAnswers == totalCorrectAnswers) &&
            (identical(other.totalAnswers, totalAnswers) ||
                other.totalAnswers == totalAnswers) &&
            (identical(other.accuracyRate, accuracyRate) ||
                other.accuracyRate == accuracyRate) &&
            (identical(other.totalStudyMinutes, totalStudyMinutes) ||
                other.totalStudyMinutes == totalStudyMinutes) &&
            (identical(other.totalCoinsEarned, totalCoinsEarned) ||
                other.totalCoinsEarned == totalCoinsEarned) &&
            (identical(other.studyDaysCount, studyDaysCount) ||
                other.studyDaysCount == studyDaysCount) &&
            const DeepCollectionEquality().equals(
              other._categoryStats,
              _categoryStats,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    month,
    totalQuestsCompleted,
    totalCorrectAnswers,
    totalAnswers,
    accuracyRate,
    totalStudyMinutes,
    totalCoinsEarned,
    studyDaysCount,
    const DeepCollectionEquality().hash(_categoryStats),
  );

  /// Create a copy of MonthlyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyStatsImplCopyWith<_$MonthlyStatsImpl> get copyWith =>
      __$$MonthlyStatsImplCopyWithImpl<_$MonthlyStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyStatsImplToJson(this);
  }
}

abstract class _MonthlyStats implements MonthlyStats {
  const factory _MonthlyStats({
    required final String month,
    required final int totalQuestsCompleted,
    required final int totalCorrectAnswers,
    required final int totalAnswers,
    required final double accuracyRate,
    required final int totalStudyMinutes,
    required final int totalCoinsEarned,
    required final int studyDaysCount,
    required final Map<String, dynamic> categoryStats,
  }) = _$MonthlyStatsImpl;

  factory _MonthlyStats.fromJson(Map<String, dynamic> json) =
      _$MonthlyStatsImpl.fromJson;

  @override
  String get month; // YYYY-MM
  @override
  int get totalQuestsCompleted;
  @override
  int get totalCorrectAnswers;
  @override
  int get totalAnswers;
  @override
  double get accuracyRate; // 0.0 ~ 1.0
  @override
  int get totalStudyMinutes;
  @override
  int get totalCoinsEarned;
  @override
  int get studyDaysCount; // 学習した日数
  @override
  Map<String, dynamic> get categoryStats;

  /// Create a copy of MonthlyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyStatsImplCopyWith<_$MonthlyStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProgressAnalytics _$ProgressAnalyticsFromJson(Map<String, dynamic> json) {
  return _ProgressAnalytics.fromJson(json);
}

/// @nodoc
mixin _$ProgressAnalytics {
  String get userId => throw _privateConstructorUsedError;
  List<DailyStats> get dailyHistory => throw _privateConstructorUsedError;
  List<WeeklyStats> get weeklyHistory => throw _privateConstructorUsedError;
  double get overallAccuracy => throw _privateConstructorUsedError;
  int get totalQuestsCompleted => throw _privateConstructorUsedError;
  int get totalCoinsEarned => throw _privateConstructorUsedError;
  Map<String, CategoryMastery> get categoryMastery =>
      throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this ProgressAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProgressAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgressAnalyticsCopyWith<ProgressAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressAnalyticsCopyWith<$Res> {
  factory $ProgressAnalyticsCopyWith(
    ProgressAnalytics value,
    $Res Function(ProgressAnalytics) then,
  ) = _$ProgressAnalyticsCopyWithImpl<$Res, ProgressAnalytics>;
  @useResult
  $Res call({
    String userId,
    List<DailyStats> dailyHistory,
    List<WeeklyStats> weeklyHistory,
    double overallAccuracy,
    int totalQuestsCompleted,
    int totalCoinsEarned,
    Map<String, CategoryMastery> categoryMastery,
    DateTime lastUpdated,
  });
}

/// @nodoc
class _$ProgressAnalyticsCopyWithImpl<$Res, $Val extends ProgressAnalytics>
    implements $ProgressAnalyticsCopyWith<$Res> {
  _$ProgressAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProgressAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? dailyHistory = null,
    Object? weeklyHistory = null,
    Object? overallAccuracy = null,
    Object? totalQuestsCompleted = null,
    Object? totalCoinsEarned = null,
    Object? categoryMastery = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            dailyHistory: null == dailyHistory
                ? _value.dailyHistory
                : dailyHistory // ignore: cast_nullable_to_non_nullable
                      as List<DailyStats>,
            weeklyHistory: null == weeklyHistory
                ? _value.weeklyHistory
                : weeklyHistory // ignore: cast_nullable_to_non_nullable
                      as List<WeeklyStats>,
            overallAccuracy: null == overallAccuracy
                ? _value.overallAccuracy
                : overallAccuracy // ignore: cast_nullable_to_non_nullable
                      as double,
            totalQuestsCompleted: null == totalQuestsCompleted
                ? _value.totalQuestsCompleted
                : totalQuestsCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCoinsEarned: null == totalCoinsEarned
                ? _value.totalCoinsEarned
                : totalCoinsEarned // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryMastery: null == categoryMastery
                ? _value.categoryMastery
                : categoryMastery // ignore: cast_nullable_to_non_nullable
                      as Map<String, CategoryMastery>,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProgressAnalyticsImplCopyWith<$Res>
    implements $ProgressAnalyticsCopyWith<$Res> {
  factory _$$ProgressAnalyticsImplCopyWith(
    _$ProgressAnalyticsImpl value,
    $Res Function(_$ProgressAnalyticsImpl) then,
  ) = __$$ProgressAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    List<DailyStats> dailyHistory,
    List<WeeklyStats> weeklyHistory,
    double overallAccuracy,
    int totalQuestsCompleted,
    int totalCoinsEarned,
    Map<String, CategoryMastery> categoryMastery,
    DateTime lastUpdated,
  });
}

/// @nodoc
class __$$ProgressAnalyticsImplCopyWithImpl<$Res>
    extends _$ProgressAnalyticsCopyWithImpl<$Res, _$ProgressAnalyticsImpl>
    implements _$$ProgressAnalyticsImplCopyWith<$Res> {
  __$$ProgressAnalyticsImplCopyWithImpl(
    _$ProgressAnalyticsImpl _value,
    $Res Function(_$ProgressAnalyticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProgressAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? dailyHistory = null,
    Object? weeklyHistory = null,
    Object? overallAccuracy = null,
    Object? totalQuestsCompleted = null,
    Object? totalCoinsEarned = null,
    Object? categoryMastery = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _$ProgressAnalyticsImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        dailyHistory: null == dailyHistory
            ? _value._dailyHistory
            : dailyHistory // ignore: cast_nullable_to_non_nullable
                  as List<DailyStats>,
        weeklyHistory: null == weeklyHistory
            ? _value._weeklyHistory
            : weeklyHistory // ignore: cast_nullable_to_non_nullable
                  as List<WeeklyStats>,
        overallAccuracy: null == overallAccuracy
            ? _value.overallAccuracy
            : overallAccuracy // ignore: cast_nullable_to_non_nullable
                  as double,
        totalQuestsCompleted: null == totalQuestsCompleted
            ? _value.totalQuestsCompleted
            : totalQuestsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCoinsEarned: null == totalCoinsEarned
            ? _value.totalCoinsEarned
            : totalCoinsEarned // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryMastery: null == categoryMastery
            ? _value._categoryMastery
            : categoryMastery // ignore: cast_nullable_to_non_nullable
                  as Map<String, CategoryMastery>,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgressAnalyticsImpl implements _ProgressAnalytics {
  const _$ProgressAnalyticsImpl({
    required this.userId,
    required final List<DailyStats> dailyHistory,
    required final List<WeeklyStats> weeklyHistory,
    required this.overallAccuracy,
    required this.totalQuestsCompleted,
    required this.totalCoinsEarned,
    required final Map<String, CategoryMastery> categoryMastery,
    required this.lastUpdated,
  }) : _dailyHistory = dailyHistory,
       _weeklyHistory = weeklyHistory,
       _categoryMastery = categoryMastery;

  factory _$ProgressAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgressAnalyticsImplFromJson(json);

  @override
  final String userId;
  final List<DailyStats> _dailyHistory;
  @override
  List<DailyStats> get dailyHistory {
    if (_dailyHistory is EqualUnmodifiableListView) return _dailyHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyHistory);
  }

  final List<WeeklyStats> _weeklyHistory;
  @override
  List<WeeklyStats> get weeklyHistory {
    if (_weeklyHistory is EqualUnmodifiableListView) return _weeklyHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyHistory);
  }

  @override
  final double overallAccuracy;
  @override
  final int totalQuestsCompleted;
  @override
  final int totalCoinsEarned;
  final Map<String, CategoryMastery> _categoryMastery;
  @override
  Map<String, CategoryMastery> get categoryMastery {
    if (_categoryMastery is EqualUnmodifiableMapView) return _categoryMastery;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryMastery);
  }

  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'ProgressAnalytics(userId: $userId, dailyHistory: $dailyHistory, weeklyHistory: $weeklyHistory, overallAccuracy: $overallAccuracy, totalQuestsCompleted: $totalQuestsCompleted, totalCoinsEarned: $totalCoinsEarned, categoryMastery: $categoryMastery, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressAnalyticsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(
              other._dailyHistory,
              _dailyHistory,
            ) &&
            const DeepCollectionEquality().equals(
              other._weeklyHistory,
              _weeklyHistory,
            ) &&
            (identical(other.overallAccuracy, overallAccuracy) ||
                other.overallAccuracy == overallAccuracy) &&
            (identical(other.totalQuestsCompleted, totalQuestsCompleted) ||
                other.totalQuestsCompleted == totalQuestsCompleted) &&
            (identical(other.totalCoinsEarned, totalCoinsEarned) ||
                other.totalCoinsEarned == totalCoinsEarned) &&
            const DeepCollectionEquality().equals(
              other._categoryMastery,
              _categoryMastery,
            ) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    const DeepCollectionEquality().hash(_dailyHistory),
    const DeepCollectionEquality().hash(_weeklyHistory),
    overallAccuracy,
    totalQuestsCompleted,
    totalCoinsEarned,
    const DeepCollectionEquality().hash(_categoryMastery),
    lastUpdated,
  );

  /// Create a copy of ProgressAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressAnalyticsImplCopyWith<_$ProgressAnalyticsImpl> get copyWith =>
      __$$ProgressAnalyticsImplCopyWithImpl<_$ProgressAnalyticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgressAnalyticsImplToJson(this);
  }
}

abstract class _ProgressAnalytics implements ProgressAnalytics {
  const factory _ProgressAnalytics({
    required final String userId,
    required final List<DailyStats> dailyHistory,
    required final List<WeeklyStats> weeklyHistory,
    required final double overallAccuracy,
    required final int totalQuestsCompleted,
    required final int totalCoinsEarned,
    required final Map<String, CategoryMastery> categoryMastery,
    required final DateTime lastUpdated,
  }) = _$ProgressAnalyticsImpl;

  factory _ProgressAnalytics.fromJson(Map<String, dynamic> json) =
      _$ProgressAnalyticsImpl.fromJson;

  @override
  String get userId;
  @override
  List<DailyStats> get dailyHistory;
  @override
  List<WeeklyStats> get weeklyHistory;
  @override
  double get overallAccuracy;
  @override
  int get totalQuestsCompleted;
  @override
  int get totalCoinsEarned;
  @override
  Map<String, CategoryMastery> get categoryMastery;
  @override
  DateTime get lastUpdated;

  /// Create a copy of ProgressAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgressAnalyticsImplCopyWith<_$ProgressAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryMastery _$CategoryMasteryFromJson(Map<String, dynamic> json) {
  return _CategoryMastery.fromJson(json);
}

/// @nodoc
mixin _$CategoryMastery {
  String get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  int get correctCount => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  double get masteryLevel => throw _privateConstructorUsedError; // 0.0 ~ 1.0
  DateTime get lastPracticedDate => throw _privateConstructorUsedError;
  List<int> get recentScores => throw _privateConstructorUsedError;

  /// Serializes this CategoryMastery to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryMastery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryMasteryCopyWith<CategoryMastery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryMasteryCopyWith<$Res> {
  factory $CategoryMasteryCopyWith(
    CategoryMastery value,
    $Res Function(CategoryMastery) then,
  ) = _$CategoryMasteryCopyWithImpl<$Res, CategoryMastery>;
  @useResult
  $Res call({
    String categoryId,
    String categoryName,
    int correctCount,
    int totalCount,
    double masteryLevel,
    DateTime lastPracticedDate,
    List<int> recentScores,
  });
}

/// @nodoc
class _$CategoryMasteryCopyWithImpl<$Res, $Val extends CategoryMastery>
    implements $CategoryMasteryCopyWith<$Res> {
  _$CategoryMasteryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryMastery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? correctCount = null,
    Object? totalCount = null,
    Object? masteryLevel = null,
    Object? lastPracticedDate = null,
    Object? recentScores = null,
  }) {
    return _then(
      _value.copyWith(
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryName: null == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String,
            correctCount: null == correctCount
                ? _value.correctCount
                : correctCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCount: null == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                      as int,
            masteryLevel: null == masteryLevel
                ? _value.masteryLevel
                : masteryLevel // ignore: cast_nullable_to_non_nullable
                      as double,
            lastPracticedDate: null == lastPracticedDate
                ? _value.lastPracticedDate
                : lastPracticedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            recentScores: null == recentScores
                ? _value.recentScores
                : recentScores // ignore: cast_nullable_to_non_nullable
                      as List<int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryMasteryImplCopyWith<$Res>
    implements $CategoryMasteryCopyWith<$Res> {
  factory _$$CategoryMasteryImplCopyWith(
    _$CategoryMasteryImpl value,
    $Res Function(_$CategoryMasteryImpl) then,
  ) = __$$CategoryMasteryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String categoryId,
    String categoryName,
    int correctCount,
    int totalCount,
    double masteryLevel,
    DateTime lastPracticedDate,
    List<int> recentScores,
  });
}

/// @nodoc
class __$$CategoryMasteryImplCopyWithImpl<$Res>
    extends _$CategoryMasteryCopyWithImpl<$Res, _$CategoryMasteryImpl>
    implements _$$CategoryMasteryImplCopyWith<$Res> {
  __$$CategoryMasteryImplCopyWithImpl(
    _$CategoryMasteryImpl _value,
    $Res Function(_$CategoryMasteryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryMastery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? correctCount = null,
    Object? totalCount = null,
    Object? masteryLevel = null,
    Object? lastPracticedDate = null,
    Object? recentScores = null,
  }) {
    return _then(
      _$CategoryMasteryImpl(
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryName: null == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String,
        correctCount: null == correctCount
            ? _value.correctCount
            : correctCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCount: null == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int,
        masteryLevel: null == masteryLevel
            ? _value.masteryLevel
            : masteryLevel // ignore: cast_nullable_to_non_nullable
                  as double,
        lastPracticedDate: null == lastPracticedDate
            ? _value.lastPracticedDate
            : lastPracticedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        recentScores: null == recentScores
            ? _value._recentScores
            : recentScores // ignore: cast_nullable_to_non_nullable
                  as List<int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryMasteryImpl implements _CategoryMastery {
  const _$CategoryMasteryImpl({
    required this.categoryId,
    required this.categoryName,
    required this.correctCount,
    required this.totalCount,
    required this.masteryLevel,
    required this.lastPracticedDate,
    required final List<int> recentScores,
  }) : _recentScores = recentScores;

  factory _$CategoryMasteryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryMasteryImplFromJson(json);

  @override
  final String categoryId;
  @override
  final String categoryName;
  @override
  final int correctCount;
  @override
  final int totalCount;
  @override
  final double masteryLevel;
  // 0.0 ~ 1.0
  @override
  final DateTime lastPracticedDate;
  final List<int> _recentScores;
  @override
  List<int> get recentScores {
    if (_recentScores is EqualUnmodifiableListView) return _recentScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentScores);
  }

  @override
  String toString() {
    return 'CategoryMastery(categoryId: $categoryId, categoryName: $categoryName, correctCount: $correctCount, totalCount: $totalCount, masteryLevel: $masteryLevel, lastPracticedDate: $lastPracticedDate, recentScores: $recentScores)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryMasteryImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.correctCount, correctCount) ||
                other.correctCount == correctCount) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.masteryLevel, masteryLevel) ||
                other.masteryLevel == masteryLevel) &&
            (identical(other.lastPracticedDate, lastPracticedDate) ||
                other.lastPracticedDate == lastPracticedDate) &&
            const DeepCollectionEquality().equals(
              other._recentScores,
              _recentScores,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    categoryId,
    categoryName,
    correctCount,
    totalCount,
    masteryLevel,
    lastPracticedDate,
    const DeepCollectionEquality().hash(_recentScores),
  );

  /// Create a copy of CategoryMastery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryMasteryImplCopyWith<_$CategoryMasteryImpl> get copyWith =>
      __$$CategoryMasteryImplCopyWithImpl<_$CategoryMasteryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryMasteryImplToJson(this);
  }
}

abstract class _CategoryMastery implements CategoryMastery {
  const factory _CategoryMastery({
    required final String categoryId,
    required final String categoryName,
    required final int correctCount,
    required final int totalCount,
    required final double masteryLevel,
    required final DateTime lastPracticedDate,
    required final List<int> recentScores,
  }) = _$CategoryMasteryImpl;

  factory _CategoryMastery.fromJson(Map<String, dynamic> json) =
      _$CategoryMasteryImpl.fromJson;

  @override
  String get categoryId;
  @override
  String get categoryName;
  @override
  int get correctCount;
  @override
  int get totalCount;
  @override
  double get masteryLevel; // 0.0 ~ 1.0
  @override
  DateTime get lastPracticedDate;
  @override
  List<int> get recentScores;

  /// Create a copy of CategoryMastery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryMasteryImplCopyWith<_$CategoryMasteryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LearningPaceData _$LearningPaceDataFromJson(Map<String, dynamic> json) {
  return _LearningPaceData.fromJson(json);
}

/// @nodoc
mixin _$LearningPaceData {
  String get userId => throw _privateConstructorUsedError;
  int get recommendedQuestsPerDay => throw _privateConstructorUsedError;
  int get averageQuestsPerDay => throw _privateConstructorUsedError;
  int get inconsistencyDays =>
      throw _privateConstructorUsedError; // 学習しなかった日数（過去30日）
  double get studyConsistencyScore =>
      throw _privateConstructorUsedError; // 0.0 ~ 1.0
  DateTime get nextCheckDate => throw _privateConstructorUsedError;

  /// Serializes this LearningPaceData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LearningPaceData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LearningPaceDataCopyWith<LearningPaceData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningPaceDataCopyWith<$Res> {
  factory $LearningPaceDataCopyWith(
    LearningPaceData value,
    $Res Function(LearningPaceData) then,
  ) = _$LearningPaceDataCopyWithImpl<$Res, LearningPaceData>;
  @useResult
  $Res call({
    String userId,
    int recommendedQuestsPerDay,
    int averageQuestsPerDay,
    int inconsistencyDays,
    double studyConsistencyScore,
    DateTime nextCheckDate,
  });
}

/// @nodoc
class _$LearningPaceDataCopyWithImpl<$Res, $Val extends LearningPaceData>
    implements $LearningPaceDataCopyWith<$Res> {
  _$LearningPaceDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LearningPaceData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? recommendedQuestsPerDay = null,
    Object? averageQuestsPerDay = null,
    Object? inconsistencyDays = null,
    Object? studyConsistencyScore = null,
    Object? nextCheckDate = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            recommendedQuestsPerDay: null == recommendedQuestsPerDay
                ? _value.recommendedQuestsPerDay
                : recommendedQuestsPerDay // ignore: cast_nullable_to_non_nullable
                      as int,
            averageQuestsPerDay: null == averageQuestsPerDay
                ? _value.averageQuestsPerDay
                : averageQuestsPerDay // ignore: cast_nullable_to_non_nullable
                      as int,
            inconsistencyDays: null == inconsistencyDays
                ? _value.inconsistencyDays
                : inconsistencyDays // ignore: cast_nullable_to_non_nullable
                      as int,
            studyConsistencyScore: null == studyConsistencyScore
                ? _value.studyConsistencyScore
                : studyConsistencyScore // ignore: cast_nullable_to_non_nullable
                      as double,
            nextCheckDate: null == nextCheckDate
                ? _value.nextCheckDate
                : nextCheckDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LearningPaceDataImplCopyWith<$Res>
    implements $LearningPaceDataCopyWith<$Res> {
  factory _$$LearningPaceDataImplCopyWith(
    _$LearningPaceDataImpl value,
    $Res Function(_$LearningPaceDataImpl) then,
  ) = __$$LearningPaceDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    int recommendedQuestsPerDay,
    int averageQuestsPerDay,
    int inconsistencyDays,
    double studyConsistencyScore,
    DateTime nextCheckDate,
  });
}

/// @nodoc
class __$$LearningPaceDataImplCopyWithImpl<$Res>
    extends _$LearningPaceDataCopyWithImpl<$Res, _$LearningPaceDataImpl>
    implements _$$LearningPaceDataImplCopyWith<$Res> {
  __$$LearningPaceDataImplCopyWithImpl(
    _$LearningPaceDataImpl _value,
    $Res Function(_$LearningPaceDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LearningPaceData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? recommendedQuestsPerDay = null,
    Object? averageQuestsPerDay = null,
    Object? inconsistencyDays = null,
    Object? studyConsistencyScore = null,
    Object? nextCheckDate = null,
  }) {
    return _then(
      _$LearningPaceDataImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        recommendedQuestsPerDay: null == recommendedQuestsPerDay
            ? _value.recommendedQuestsPerDay
            : recommendedQuestsPerDay // ignore: cast_nullable_to_non_nullable
                  as int,
        averageQuestsPerDay: null == averageQuestsPerDay
            ? _value.averageQuestsPerDay
            : averageQuestsPerDay // ignore: cast_nullable_to_non_nullable
                  as int,
        inconsistencyDays: null == inconsistencyDays
            ? _value.inconsistencyDays
            : inconsistencyDays // ignore: cast_nullable_to_non_nullable
                  as int,
        studyConsistencyScore: null == studyConsistencyScore
            ? _value.studyConsistencyScore
            : studyConsistencyScore // ignore: cast_nullable_to_non_nullable
                  as double,
        nextCheckDate: null == nextCheckDate
            ? _value.nextCheckDate
            : nextCheckDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningPaceDataImpl implements _LearningPaceData {
  const _$LearningPaceDataImpl({
    required this.userId,
    required this.recommendedQuestsPerDay,
    required this.averageQuestsPerDay,
    required this.inconsistencyDays,
    required this.studyConsistencyScore,
    required this.nextCheckDate,
  });

  factory _$LearningPaceDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningPaceDataImplFromJson(json);

  @override
  final String userId;
  @override
  final int recommendedQuestsPerDay;
  @override
  final int averageQuestsPerDay;
  @override
  final int inconsistencyDays;
  // 学習しなかった日数（過去30日）
  @override
  final double studyConsistencyScore;
  // 0.0 ~ 1.0
  @override
  final DateTime nextCheckDate;

  @override
  String toString() {
    return 'LearningPaceData(userId: $userId, recommendedQuestsPerDay: $recommendedQuestsPerDay, averageQuestsPerDay: $averageQuestsPerDay, inconsistencyDays: $inconsistencyDays, studyConsistencyScore: $studyConsistencyScore, nextCheckDate: $nextCheckDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningPaceDataImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(
                  other.recommendedQuestsPerDay,
                  recommendedQuestsPerDay,
                ) ||
                other.recommendedQuestsPerDay == recommendedQuestsPerDay) &&
            (identical(other.averageQuestsPerDay, averageQuestsPerDay) ||
                other.averageQuestsPerDay == averageQuestsPerDay) &&
            (identical(other.inconsistencyDays, inconsistencyDays) ||
                other.inconsistencyDays == inconsistencyDays) &&
            (identical(other.studyConsistencyScore, studyConsistencyScore) ||
                other.studyConsistencyScore == studyConsistencyScore) &&
            (identical(other.nextCheckDate, nextCheckDate) ||
                other.nextCheckDate == nextCheckDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    recommendedQuestsPerDay,
    averageQuestsPerDay,
    inconsistencyDays,
    studyConsistencyScore,
    nextCheckDate,
  );

  /// Create a copy of LearningPaceData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningPaceDataImplCopyWith<_$LearningPaceDataImpl> get copyWith =>
      __$$LearningPaceDataImplCopyWithImpl<_$LearningPaceDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningPaceDataImplToJson(this);
  }
}

abstract class _LearningPaceData implements LearningPaceData {
  const factory _LearningPaceData({
    required final String userId,
    required final int recommendedQuestsPerDay,
    required final int averageQuestsPerDay,
    required final int inconsistencyDays,
    required final double studyConsistencyScore,
    required final DateTime nextCheckDate,
  }) = _$LearningPaceDataImpl;

  factory _LearningPaceData.fromJson(Map<String, dynamic> json) =
      _$LearningPaceDataImpl.fromJson;

  @override
  String get userId;
  @override
  int get recommendedQuestsPerDay;
  @override
  int get averageQuestsPerDay;
  @override
  int get inconsistencyDays; // 学習しなかった日数（過去30日）
  @override
  double get studyConsistencyScore; // 0.0 ~ 1.0
  @override
  DateTime get nextCheckDate;

  /// Create a copy of LearningPaceData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LearningPaceDataImplCopyWith<_$LearningPaceDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
