// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'battle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Battle _$BattleFromJson(Map<String, dynamic> json) {
  return _Battle.fromJson(json);
}

/// @nodoc
mixin _$Battle {
  String get battleId => throw _privateConstructorUsedError;
  String get player1Id => throw _privateConstructorUsedError;
  String get player2Id => throw _privateConstructorUsedError;
  String? get player1Name => throw _privateConstructorUsedError;
  String? get player2Name => throw _privateConstructorUsedError;
  int? get player1ImageUrl => throw _privateConstructorUsedError;
  int? get player2ImageUrl => throw _privateConstructorUsedError;
  DateTime get createdDate => throw _privateConstructorUsedError;
  DateTime? get startedDate => throw _privateConstructorUsedError;
  DateTime? get endedDate => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // waiting, active, completed
  int get currentRound => throw _privateConstructorUsedError; // 1-5
  String? get winnerId => throw _privateConstructorUsedError;

  /// Serializes this Battle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Battle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BattleCopyWith<Battle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BattleCopyWith<$Res> {
  factory $BattleCopyWith(Battle value, $Res Function(Battle) then) =
      _$BattleCopyWithImpl<$Res, Battle>;
  @useResult
  $Res call({
    String battleId,
    String player1Id,
    String player2Id,
    String? player1Name,
    String? player2Name,
    int? player1ImageUrl,
    int? player2ImageUrl,
    DateTime createdDate,
    DateTime? startedDate,
    DateTime? endedDate,
    String status,
    int currentRound,
    String? winnerId,
  });
}

/// @nodoc
class _$BattleCopyWithImpl<$Res, $Val extends Battle>
    implements $BattleCopyWith<$Res> {
  _$BattleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Battle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? battleId = null,
    Object? player1Id = null,
    Object? player2Id = null,
    Object? player1Name = freezed,
    Object? player2Name = freezed,
    Object? player1ImageUrl = freezed,
    Object? player2ImageUrl = freezed,
    Object? createdDate = null,
    Object? startedDate = freezed,
    Object? endedDate = freezed,
    Object? status = null,
    Object? currentRound = null,
    Object? winnerId = freezed,
  }) {
    return _then(
      _value.copyWith(
            battleId: null == battleId
                ? _value.battleId
                : battleId // ignore: cast_nullable_to_non_nullable
                      as String,
            player1Id: null == player1Id
                ? _value.player1Id
                : player1Id // ignore: cast_nullable_to_non_nullable
                      as String,
            player2Id: null == player2Id
                ? _value.player2Id
                : player2Id // ignore: cast_nullable_to_non_nullable
                      as String,
            player1Name: freezed == player1Name
                ? _value.player1Name
                : player1Name // ignore: cast_nullable_to_non_nullable
                      as String?,
            player2Name: freezed == player2Name
                ? _value.player2Name
                : player2Name // ignore: cast_nullable_to_non_nullable
                      as String?,
            player1ImageUrl: freezed == player1ImageUrl
                ? _value.player1ImageUrl
                : player1ImageUrl // ignore: cast_nullable_to_non_nullable
                      as int?,
            player2ImageUrl: freezed == player2ImageUrl
                ? _value.player2ImageUrl
                : player2ImageUrl // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdDate: null == createdDate
                ? _value.createdDate
                : createdDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            startedDate: freezed == startedDate
                ? _value.startedDate
                : startedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endedDate: freezed == endedDate
                ? _value.endedDate
                : endedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            currentRound: null == currentRound
                ? _value.currentRound
                : currentRound // ignore: cast_nullable_to_non_nullable
                      as int,
            winnerId: freezed == winnerId
                ? _value.winnerId
                : winnerId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BattleImplCopyWith<$Res> implements $BattleCopyWith<$Res> {
  factory _$$BattleImplCopyWith(
    _$BattleImpl value,
    $Res Function(_$BattleImpl) then,
  ) = __$$BattleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String battleId,
    String player1Id,
    String player2Id,
    String? player1Name,
    String? player2Name,
    int? player1ImageUrl,
    int? player2ImageUrl,
    DateTime createdDate,
    DateTime? startedDate,
    DateTime? endedDate,
    String status,
    int currentRound,
    String? winnerId,
  });
}

/// @nodoc
class __$$BattleImplCopyWithImpl<$Res>
    extends _$BattleCopyWithImpl<$Res, _$BattleImpl>
    implements _$$BattleImplCopyWith<$Res> {
  __$$BattleImplCopyWithImpl(
    _$BattleImpl _value,
    $Res Function(_$BattleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Battle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? battleId = null,
    Object? player1Id = null,
    Object? player2Id = null,
    Object? player1Name = freezed,
    Object? player2Name = freezed,
    Object? player1ImageUrl = freezed,
    Object? player2ImageUrl = freezed,
    Object? createdDate = null,
    Object? startedDate = freezed,
    Object? endedDate = freezed,
    Object? status = null,
    Object? currentRound = null,
    Object? winnerId = freezed,
  }) {
    return _then(
      _$BattleImpl(
        battleId: null == battleId
            ? _value.battleId
            : battleId // ignore: cast_nullable_to_non_nullable
                  as String,
        player1Id: null == player1Id
            ? _value.player1Id
            : player1Id // ignore: cast_nullable_to_non_nullable
                  as String,
        player2Id: null == player2Id
            ? _value.player2Id
            : player2Id // ignore: cast_nullable_to_non_nullable
                  as String,
        player1Name: freezed == player1Name
            ? _value.player1Name
            : player1Name // ignore: cast_nullable_to_non_nullable
                  as String?,
        player2Name: freezed == player2Name
            ? _value.player2Name
            : player2Name // ignore: cast_nullable_to_non_nullable
                  as String?,
        player1ImageUrl: freezed == player1ImageUrl
            ? _value.player1ImageUrl
            : player1ImageUrl // ignore: cast_nullable_to_non_nullable
                  as int?,
        player2ImageUrl: freezed == player2ImageUrl
            ? _value.player2ImageUrl
            : player2ImageUrl // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdDate: null == createdDate
            ? _value.createdDate
            : createdDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        startedDate: freezed == startedDate
            ? _value.startedDate
            : startedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endedDate: freezed == endedDate
            ? _value.endedDate
            : endedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        currentRound: null == currentRound
            ? _value.currentRound
            : currentRound // ignore: cast_nullable_to_non_nullable
                  as int,
        winnerId: freezed == winnerId
            ? _value.winnerId
            : winnerId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BattleImpl implements _Battle {
  const _$BattleImpl({
    required this.battleId,
    required this.player1Id,
    required this.player2Id,
    required this.player1Name,
    required this.player2Name,
    required this.player1ImageUrl,
    required this.player2ImageUrl,
    required this.createdDate,
    required this.startedDate,
    required this.endedDate,
    required this.status,
    required this.currentRound,
    required this.winnerId,
  });

  factory _$BattleImpl.fromJson(Map<String, dynamic> json) =>
      _$$BattleImplFromJson(json);

  @override
  final String battleId;
  @override
  final String player1Id;
  @override
  final String player2Id;
  @override
  final String? player1Name;
  @override
  final String? player2Name;
  @override
  final int? player1ImageUrl;
  @override
  final int? player2ImageUrl;
  @override
  final DateTime createdDate;
  @override
  final DateTime? startedDate;
  @override
  final DateTime? endedDate;
  @override
  final String status;
  // waiting, active, completed
  @override
  final int currentRound;
  // 1-5
  @override
  final String? winnerId;

  @override
  String toString() {
    return 'Battle(battleId: $battleId, player1Id: $player1Id, player2Id: $player2Id, player1Name: $player1Name, player2Name: $player2Name, player1ImageUrl: $player1ImageUrl, player2ImageUrl: $player2ImageUrl, createdDate: $createdDate, startedDate: $startedDate, endedDate: $endedDate, status: $status, currentRound: $currentRound, winnerId: $winnerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BattleImpl &&
            (identical(other.battleId, battleId) ||
                other.battleId == battleId) &&
            (identical(other.player1Id, player1Id) ||
                other.player1Id == player1Id) &&
            (identical(other.player2Id, player2Id) ||
                other.player2Id == player2Id) &&
            (identical(other.player1Name, player1Name) ||
                other.player1Name == player1Name) &&
            (identical(other.player2Name, player2Name) ||
                other.player2Name == player2Name) &&
            (identical(other.player1ImageUrl, player1ImageUrl) ||
                other.player1ImageUrl == player1ImageUrl) &&
            (identical(other.player2ImageUrl, player2ImageUrl) ||
                other.player2ImageUrl == player2ImageUrl) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate) &&
            (identical(other.startedDate, startedDate) ||
                other.startedDate == startedDate) &&
            (identical(other.endedDate, endedDate) ||
                other.endedDate == endedDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentRound, currentRound) ||
                other.currentRound == currentRound) &&
            (identical(other.winnerId, winnerId) ||
                other.winnerId == winnerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    battleId,
    player1Id,
    player2Id,
    player1Name,
    player2Name,
    player1ImageUrl,
    player2ImageUrl,
    createdDate,
    startedDate,
    endedDate,
    status,
    currentRound,
    winnerId,
  );

  /// Create a copy of Battle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BattleImplCopyWith<_$BattleImpl> get copyWith =>
      __$$BattleImplCopyWithImpl<_$BattleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BattleImplToJson(this);
  }
}

abstract class _Battle implements Battle {
  const factory _Battle({
    required final String battleId,
    required final String player1Id,
    required final String player2Id,
    required final String? player1Name,
    required final String? player2Name,
    required final int? player1ImageUrl,
    required final int? player2ImageUrl,
    required final DateTime createdDate,
    required final DateTime? startedDate,
    required final DateTime? endedDate,
    required final String status,
    required final int currentRound,
    required final String? winnerId,
  }) = _$BattleImpl;

  factory _Battle.fromJson(Map<String, dynamic> json) = _$BattleImpl.fromJson;

  @override
  String get battleId;
  @override
  String get player1Id;
  @override
  String get player2Id;
  @override
  String? get player1Name;
  @override
  String? get player2Name;
  @override
  int? get player1ImageUrl;
  @override
  int? get player2ImageUrl;
  @override
  DateTime get createdDate;
  @override
  DateTime? get startedDate;
  @override
  DateTime? get endedDate;
  @override
  String get status; // waiting, active, completed
  @override
  int get currentRound; // 1-5
  @override
  String? get winnerId;

  /// Create a copy of Battle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BattleImplCopyWith<_$BattleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BattleRound _$BattleRoundFromJson(Map<String, dynamic> json) {
  return _BattleRound.fromJson(json);
}

/// @nodoc
mixin _$BattleRound {
  String get battleId => throw _privateConstructorUsedError;
  int get roundNumber => throw _privateConstructorUsedError;
  String get questionId => throw _privateConstructorUsedError;
  String get questionText => throw _privateConstructorUsedError;
  List<String> get choices => throw _privateConstructorUsedError;
  String? get correctAnswer => throw _privateConstructorUsedError;
  String? get player1Answer => throw _privateConstructorUsedError;
  String? get player2Answer => throw _privateConstructorUsedError;
  int? get player1ResponseTime => throw _privateConstructorUsedError; // ミリ秒
  int? get player2ResponseTime => throw _privateConstructorUsedError;
  bool? get player1Correct => throw _privateConstructorUsedError;
  bool? get player2Correct => throw _privateConstructorUsedError;

  /// Serializes this BattleRound to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BattleRound
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BattleRoundCopyWith<BattleRound> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BattleRoundCopyWith<$Res> {
  factory $BattleRoundCopyWith(
    BattleRound value,
    $Res Function(BattleRound) then,
  ) = _$BattleRoundCopyWithImpl<$Res, BattleRound>;
  @useResult
  $Res call({
    String battleId,
    int roundNumber,
    String questionId,
    String questionText,
    List<String> choices,
    String? correctAnswer,
    String? player1Answer,
    String? player2Answer,
    int? player1ResponseTime,
    int? player2ResponseTime,
    bool? player1Correct,
    bool? player2Correct,
  });
}

/// @nodoc
class _$BattleRoundCopyWithImpl<$Res, $Val extends BattleRound>
    implements $BattleRoundCopyWith<$Res> {
  _$BattleRoundCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BattleRound
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? battleId = null,
    Object? roundNumber = null,
    Object? questionId = null,
    Object? questionText = null,
    Object? choices = null,
    Object? correctAnswer = freezed,
    Object? player1Answer = freezed,
    Object? player2Answer = freezed,
    Object? player1ResponseTime = freezed,
    Object? player2ResponseTime = freezed,
    Object? player1Correct = freezed,
    Object? player2Correct = freezed,
  }) {
    return _then(
      _value.copyWith(
            battleId: null == battleId
                ? _value.battleId
                : battleId // ignore: cast_nullable_to_non_nullable
                      as String,
            roundNumber: null == roundNumber
                ? _value.roundNumber
                : roundNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            questionId: null == questionId
                ? _value.questionId
                : questionId // ignore: cast_nullable_to_non_nullable
                      as String,
            questionText: null == questionText
                ? _value.questionText
                : questionText // ignore: cast_nullable_to_non_nullable
                      as String,
            choices: null == choices
                ? _value.choices
                : choices // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            correctAnswer: freezed == correctAnswer
                ? _value.correctAnswer
                : correctAnswer // ignore: cast_nullable_to_non_nullable
                      as String?,
            player1Answer: freezed == player1Answer
                ? _value.player1Answer
                : player1Answer // ignore: cast_nullable_to_non_nullable
                      as String?,
            player2Answer: freezed == player2Answer
                ? _value.player2Answer
                : player2Answer // ignore: cast_nullable_to_non_nullable
                      as String?,
            player1ResponseTime: freezed == player1ResponseTime
                ? _value.player1ResponseTime
                : player1ResponseTime // ignore: cast_nullable_to_non_nullable
                      as int?,
            player2ResponseTime: freezed == player2ResponseTime
                ? _value.player2ResponseTime
                : player2ResponseTime // ignore: cast_nullable_to_non_nullable
                      as int?,
            player1Correct: freezed == player1Correct
                ? _value.player1Correct
                : player1Correct // ignore: cast_nullable_to_non_nullable
                      as bool?,
            player2Correct: freezed == player2Correct
                ? _value.player2Correct
                : player2Correct // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BattleRoundImplCopyWith<$Res>
    implements $BattleRoundCopyWith<$Res> {
  factory _$$BattleRoundImplCopyWith(
    _$BattleRoundImpl value,
    $Res Function(_$BattleRoundImpl) then,
  ) = __$$BattleRoundImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String battleId,
    int roundNumber,
    String questionId,
    String questionText,
    List<String> choices,
    String? correctAnswer,
    String? player1Answer,
    String? player2Answer,
    int? player1ResponseTime,
    int? player2ResponseTime,
    bool? player1Correct,
    bool? player2Correct,
  });
}

/// @nodoc
class __$$BattleRoundImplCopyWithImpl<$Res>
    extends _$BattleRoundCopyWithImpl<$Res, _$BattleRoundImpl>
    implements _$$BattleRoundImplCopyWith<$Res> {
  __$$BattleRoundImplCopyWithImpl(
    _$BattleRoundImpl _value,
    $Res Function(_$BattleRoundImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BattleRound
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? battleId = null,
    Object? roundNumber = null,
    Object? questionId = null,
    Object? questionText = null,
    Object? choices = null,
    Object? correctAnswer = freezed,
    Object? player1Answer = freezed,
    Object? player2Answer = freezed,
    Object? player1ResponseTime = freezed,
    Object? player2ResponseTime = freezed,
    Object? player1Correct = freezed,
    Object? player2Correct = freezed,
  }) {
    return _then(
      _$BattleRoundImpl(
        battleId: null == battleId
            ? _value.battleId
            : battleId // ignore: cast_nullable_to_non_nullable
                  as String,
        roundNumber: null == roundNumber
            ? _value.roundNumber
            : roundNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        questionId: null == questionId
            ? _value.questionId
            : questionId // ignore: cast_nullable_to_non_nullable
                  as String,
        questionText: null == questionText
            ? _value.questionText
            : questionText // ignore: cast_nullable_to_non_nullable
                  as String,
        choices: null == choices
            ? _value._choices
            : choices // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        correctAnswer: freezed == correctAnswer
            ? _value.correctAnswer
            : correctAnswer // ignore: cast_nullable_to_non_nullable
                  as String?,
        player1Answer: freezed == player1Answer
            ? _value.player1Answer
            : player1Answer // ignore: cast_nullable_to_non_nullable
                  as String?,
        player2Answer: freezed == player2Answer
            ? _value.player2Answer
            : player2Answer // ignore: cast_nullable_to_non_nullable
                  as String?,
        player1ResponseTime: freezed == player1ResponseTime
            ? _value.player1ResponseTime
            : player1ResponseTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        player2ResponseTime: freezed == player2ResponseTime
            ? _value.player2ResponseTime
            : player2ResponseTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        player1Correct: freezed == player1Correct
            ? _value.player1Correct
            : player1Correct // ignore: cast_nullable_to_non_nullable
                  as bool?,
        player2Correct: freezed == player2Correct
            ? _value.player2Correct
            : player2Correct // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BattleRoundImpl implements _BattleRound {
  const _$BattleRoundImpl({
    required this.battleId,
    required this.roundNumber,
    required this.questionId,
    required this.questionText,
    required final List<String> choices,
    required this.correctAnswer,
    required this.player1Answer,
    required this.player2Answer,
    required this.player1ResponseTime,
    required this.player2ResponseTime,
    required this.player1Correct,
    required this.player2Correct,
  }) : _choices = choices;

  factory _$BattleRoundImpl.fromJson(Map<String, dynamic> json) =>
      _$$BattleRoundImplFromJson(json);

  @override
  final String battleId;
  @override
  final int roundNumber;
  @override
  final String questionId;
  @override
  final String questionText;
  final List<String> _choices;
  @override
  List<String> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  @override
  final String? correctAnswer;
  @override
  final String? player1Answer;
  @override
  final String? player2Answer;
  @override
  final int? player1ResponseTime;
  // ミリ秒
  @override
  final int? player2ResponseTime;
  @override
  final bool? player1Correct;
  @override
  final bool? player2Correct;

  @override
  String toString() {
    return 'BattleRound(battleId: $battleId, roundNumber: $roundNumber, questionId: $questionId, questionText: $questionText, choices: $choices, correctAnswer: $correctAnswer, player1Answer: $player1Answer, player2Answer: $player2Answer, player1ResponseTime: $player1ResponseTime, player2ResponseTime: $player2ResponseTime, player1Correct: $player1Correct, player2Correct: $player2Correct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BattleRoundImpl &&
            (identical(other.battleId, battleId) ||
                other.battleId == battleId) &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            const DeepCollectionEquality().equals(other._choices, _choices) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            (identical(other.player1Answer, player1Answer) ||
                other.player1Answer == player1Answer) &&
            (identical(other.player2Answer, player2Answer) ||
                other.player2Answer == player2Answer) &&
            (identical(other.player1ResponseTime, player1ResponseTime) ||
                other.player1ResponseTime == player1ResponseTime) &&
            (identical(other.player2ResponseTime, player2ResponseTime) ||
                other.player2ResponseTime == player2ResponseTime) &&
            (identical(other.player1Correct, player1Correct) ||
                other.player1Correct == player1Correct) &&
            (identical(other.player2Correct, player2Correct) ||
                other.player2Correct == player2Correct));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    battleId,
    roundNumber,
    questionId,
    questionText,
    const DeepCollectionEquality().hash(_choices),
    correctAnswer,
    player1Answer,
    player2Answer,
    player1ResponseTime,
    player2ResponseTime,
    player1Correct,
    player2Correct,
  );

  /// Create a copy of BattleRound
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BattleRoundImplCopyWith<_$BattleRoundImpl> get copyWith =>
      __$$BattleRoundImplCopyWithImpl<_$BattleRoundImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BattleRoundImplToJson(this);
  }
}

abstract class _BattleRound implements BattleRound {
  const factory _BattleRound({
    required final String battleId,
    required final int roundNumber,
    required final String questionId,
    required final String questionText,
    required final List<String> choices,
    required final String? correctAnswer,
    required final String? player1Answer,
    required final String? player2Answer,
    required final int? player1ResponseTime,
    required final int? player2ResponseTime,
    required final bool? player1Correct,
    required final bool? player2Correct,
  }) = _$BattleRoundImpl;

  factory _BattleRound.fromJson(Map<String, dynamic> json) =
      _$BattleRoundImpl.fromJson;

  @override
  String get battleId;
  @override
  int get roundNumber;
  @override
  String get questionId;
  @override
  String get questionText;
  @override
  List<String> get choices;
  @override
  String? get correctAnswer;
  @override
  String? get player1Answer;
  @override
  String? get player2Answer;
  @override
  int? get player1ResponseTime; // ミリ秒
  @override
  int? get player2ResponseTime;
  @override
  bool? get player1Correct;
  @override
  bool? get player2Correct;

  /// Create a copy of BattleRound
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BattleRoundImplCopyWith<_$BattleRoundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BattleResult _$BattleResultFromJson(Map<String, dynamic> json) {
  return _BattleResult.fromJson(json);
}

/// @nodoc
mixin _$BattleResult {
  String get battleId => throw _privateConstructorUsedError;
  String get player1Id => throw _privateConstructorUsedError;
  String get player2Id => throw _privateConstructorUsedError;
  int get player1Score => throw _privateConstructorUsedError;
  int get player2Score => throw _privateConstructorUsedError;
  String get winnerId => throw _privateConstructorUsedError;
  DateTime get completedDate => throw _privateConstructorUsedError;
  List<BattleRound> get rounds => throw _privateConstructorUsedError;
  int get totalDurationSeconds => throw _privateConstructorUsedError;

  /// Serializes this BattleResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BattleResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BattleResultCopyWith<BattleResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BattleResultCopyWith<$Res> {
  factory $BattleResultCopyWith(
    BattleResult value,
    $Res Function(BattleResult) then,
  ) = _$BattleResultCopyWithImpl<$Res, BattleResult>;
  @useResult
  $Res call({
    String battleId,
    String player1Id,
    String player2Id,
    int player1Score,
    int player2Score,
    String winnerId,
    DateTime completedDate,
    List<BattleRound> rounds,
    int totalDurationSeconds,
  });
}

/// @nodoc
class _$BattleResultCopyWithImpl<$Res, $Val extends BattleResult>
    implements $BattleResultCopyWith<$Res> {
  _$BattleResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BattleResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? battleId = null,
    Object? player1Id = null,
    Object? player2Id = null,
    Object? player1Score = null,
    Object? player2Score = null,
    Object? winnerId = null,
    Object? completedDate = null,
    Object? rounds = null,
    Object? totalDurationSeconds = null,
  }) {
    return _then(
      _value.copyWith(
            battleId: null == battleId
                ? _value.battleId
                : battleId // ignore: cast_nullable_to_non_nullable
                      as String,
            player1Id: null == player1Id
                ? _value.player1Id
                : player1Id // ignore: cast_nullable_to_non_nullable
                      as String,
            player2Id: null == player2Id
                ? _value.player2Id
                : player2Id // ignore: cast_nullable_to_non_nullable
                      as String,
            player1Score: null == player1Score
                ? _value.player1Score
                : player1Score // ignore: cast_nullable_to_non_nullable
                      as int,
            player2Score: null == player2Score
                ? _value.player2Score
                : player2Score // ignore: cast_nullable_to_non_nullable
                      as int,
            winnerId: null == winnerId
                ? _value.winnerId
                : winnerId // ignore: cast_nullable_to_non_nullable
                      as String,
            completedDate: null == completedDate
                ? _value.completedDate
                : completedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            rounds: null == rounds
                ? _value.rounds
                : rounds // ignore: cast_nullable_to_non_nullable
                      as List<BattleRound>,
            totalDurationSeconds: null == totalDurationSeconds
                ? _value.totalDurationSeconds
                : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BattleResultImplCopyWith<$Res>
    implements $BattleResultCopyWith<$Res> {
  factory _$$BattleResultImplCopyWith(
    _$BattleResultImpl value,
    $Res Function(_$BattleResultImpl) then,
  ) = __$$BattleResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String battleId,
    String player1Id,
    String player2Id,
    int player1Score,
    int player2Score,
    String winnerId,
    DateTime completedDate,
    List<BattleRound> rounds,
    int totalDurationSeconds,
  });
}

/// @nodoc
class __$$BattleResultImplCopyWithImpl<$Res>
    extends _$BattleResultCopyWithImpl<$Res, _$BattleResultImpl>
    implements _$$BattleResultImplCopyWith<$Res> {
  __$$BattleResultImplCopyWithImpl(
    _$BattleResultImpl _value,
    $Res Function(_$BattleResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BattleResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? battleId = null,
    Object? player1Id = null,
    Object? player2Id = null,
    Object? player1Score = null,
    Object? player2Score = null,
    Object? winnerId = null,
    Object? completedDate = null,
    Object? rounds = null,
    Object? totalDurationSeconds = null,
  }) {
    return _then(
      _$BattleResultImpl(
        battleId: null == battleId
            ? _value.battleId
            : battleId // ignore: cast_nullable_to_non_nullable
                  as String,
        player1Id: null == player1Id
            ? _value.player1Id
            : player1Id // ignore: cast_nullable_to_non_nullable
                  as String,
        player2Id: null == player2Id
            ? _value.player2Id
            : player2Id // ignore: cast_nullable_to_non_nullable
                  as String,
        player1Score: null == player1Score
            ? _value.player1Score
            : player1Score // ignore: cast_nullable_to_non_nullable
                  as int,
        player2Score: null == player2Score
            ? _value.player2Score
            : player2Score // ignore: cast_nullable_to_non_nullable
                  as int,
        winnerId: null == winnerId
            ? _value.winnerId
            : winnerId // ignore: cast_nullable_to_non_nullable
                  as String,
        completedDate: null == completedDate
            ? _value.completedDate
            : completedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        rounds: null == rounds
            ? _value._rounds
            : rounds // ignore: cast_nullable_to_non_nullable
                  as List<BattleRound>,
        totalDurationSeconds: null == totalDurationSeconds
            ? _value.totalDurationSeconds
            : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BattleResultImpl implements _BattleResult {
  const _$BattleResultImpl({
    required this.battleId,
    required this.player1Id,
    required this.player2Id,
    required this.player1Score,
    required this.player2Score,
    required this.winnerId,
    required this.completedDate,
    required final List<BattleRound> rounds,
    required this.totalDurationSeconds,
  }) : _rounds = rounds;

  factory _$BattleResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$BattleResultImplFromJson(json);

  @override
  final String battleId;
  @override
  final String player1Id;
  @override
  final String player2Id;
  @override
  final int player1Score;
  @override
  final int player2Score;
  @override
  final String winnerId;
  @override
  final DateTime completedDate;
  final List<BattleRound> _rounds;
  @override
  List<BattleRound> get rounds {
    if (_rounds is EqualUnmodifiableListView) return _rounds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rounds);
  }

  @override
  final int totalDurationSeconds;

  @override
  String toString() {
    return 'BattleResult(battleId: $battleId, player1Id: $player1Id, player2Id: $player2Id, player1Score: $player1Score, player2Score: $player2Score, winnerId: $winnerId, completedDate: $completedDate, rounds: $rounds, totalDurationSeconds: $totalDurationSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BattleResultImpl &&
            (identical(other.battleId, battleId) ||
                other.battleId == battleId) &&
            (identical(other.player1Id, player1Id) ||
                other.player1Id == player1Id) &&
            (identical(other.player2Id, player2Id) ||
                other.player2Id == player2Id) &&
            (identical(other.player1Score, player1Score) ||
                other.player1Score == player1Score) &&
            (identical(other.player2Score, player2Score) ||
                other.player2Score == player2Score) &&
            (identical(other.winnerId, winnerId) ||
                other.winnerId == winnerId) &&
            (identical(other.completedDate, completedDate) ||
                other.completedDate == completedDate) &&
            const DeepCollectionEquality().equals(other._rounds, _rounds) &&
            (identical(other.totalDurationSeconds, totalDurationSeconds) ||
                other.totalDurationSeconds == totalDurationSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    battleId,
    player1Id,
    player2Id,
    player1Score,
    player2Score,
    winnerId,
    completedDate,
    const DeepCollectionEquality().hash(_rounds),
    totalDurationSeconds,
  );

  /// Create a copy of BattleResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BattleResultImplCopyWith<_$BattleResultImpl> get copyWith =>
      __$$BattleResultImplCopyWithImpl<_$BattleResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BattleResultImplToJson(this);
  }
}

abstract class _BattleResult implements BattleResult {
  const factory _BattleResult({
    required final String battleId,
    required final String player1Id,
    required final String player2Id,
    required final int player1Score,
    required final int player2Score,
    required final String winnerId,
    required final DateTime completedDate,
    required final List<BattleRound> rounds,
    required final int totalDurationSeconds,
  }) = _$BattleResultImpl;

  factory _BattleResult.fromJson(Map<String, dynamic> json) =
      _$BattleResultImpl.fromJson;

  @override
  String get battleId;
  @override
  String get player1Id;
  @override
  String get player2Id;
  @override
  int get player1Score;
  @override
  int get player2Score;
  @override
  String get winnerId;
  @override
  DateTime get completedDate;
  @override
  List<BattleRound> get rounds;
  @override
  int get totalDurationSeconds;

  /// Create a copy of BattleResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BattleResultImplCopyWith<_$BattleResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BattlePlayer _$BattlePlayerFromJson(Map<String, dynamic> json) {
  return _BattlePlayer.fromJson(json);
}

/// @nodoc
mixin _$BattlePlayer {
  String get playerId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get profileImageUrl => throw _privateConstructorUsedError;
  int get grade => throw _privateConstructorUsedError;
  double get totalBattlesPlayed => throw _privateConstructorUsedError;
  double get totalWins => throw _privateConstructorUsedError;
  double get winRate => throw _privateConstructorUsedError;
  double get averageScore => throw _privateConstructorUsedError;

  /// Serializes this BattlePlayer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BattlePlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BattlePlayerCopyWith<BattlePlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BattlePlayerCopyWith<$Res> {
  factory $BattlePlayerCopyWith(
    BattlePlayer value,
    $Res Function(BattlePlayer) then,
  ) = _$BattlePlayerCopyWithImpl<$Res, BattlePlayer>;
  @useResult
  $Res call({
    String playerId,
    String displayName,
    String profileImageUrl,
    int grade,
    double totalBattlesPlayed,
    double totalWins,
    double winRate,
    double averageScore,
  });
}

/// @nodoc
class _$BattlePlayerCopyWithImpl<$Res, $Val extends BattlePlayer>
    implements $BattlePlayerCopyWith<$Res> {
  _$BattlePlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BattlePlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? displayName = null,
    Object? profileImageUrl = null,
    Object? grade = null,
    Object? totalBattlesPlayed = null,
    Object? totalWins = null,
    Object? winRate = null,
    Object? averageScore = null,
  }) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            profileImageUrl: null == profileImageUrl
                ? _value.profileImageUrl
                : profileImageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            grade: null == grade
                ? _value.grade
                : grade // ignore: cast_nullable_to_non_nullable
                      as int,
            totalBattlesPlayed: null == totalBattlesPlayed
                ? _value.totalBattlesPlayed
                : totalBattlesPlayed // ignore: cast_nullable_to_non_nullable
                      as double,
            totalWins: null == totalWins
                ? _value.totalWins
                : totalWins // ignore: cast_nullable_to_non_nullable
                      as double,
            winRate: null == winRate
                ? _value.winRate
                : winRate // ignore: cast_nullable_to_non_nullable
                      as double,
            averageScore: null == averageScore
                ? _value.averageScore
                : averageScore // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BattlePlayerImplCopyWith<$Res>
    implements $BattlePlayerCopyWith<$Res> {
  factory _$$BattlePlayerImplCopyWith(
    _$BattlePlayerImpl value,
    $Res Function(_$BattlePlayerImpl) then,
  ) = __$$BattlePlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String playerId,
    String displayName,
    String profileImageUrl,
    int grade,
    double totalBattlesPlayed,
    double totalWins,
    double winRate,
    double averageScore,
  });
}

/// @nodoc
class __$$BattlePlayerImplCopyWithImpl<$Res>
    extends _$BattlePlayerCopyWithImpl<$Res, _$BattlePlayerImpl>
    implements _$$BattlePlayerImplCopyWith<$Res> {
  __$$BattlePlayerImplCopyWithImpl(
    _$BattlePlayerImpl _value,
    $Res Function(_$BattlePlayerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BattlePlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? displayName = null,
    Object? profileImageUrl = null,
    Object? grade = null,
    Object? totalBattlesPlayed = null,
    Object? totalWins = null,
    Object? winRate = null,
    Object? averageScore = null,
  }) {
    return _then(
      _$BattlePlayerImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        profileImageUrl: null == profileImageUrl
            ? _value.profileImageUrl
            : profileImageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        grade: null == grade
            ? _value.grade
            : grade // ignore: cast_nullable_to_non_nullable
                  as int,
        totalBattlesPlayed: null == totalBattlesPlayed
            ? _value.totalBattlesPlayed
            : totalBattlesPlayed // ignore: cast_nullable_to_non_nullable
                  as double,
        totalWins: null == totalWins
            ? _value.totalWins
            : totalWins // ignore: cast_nullable_to_non_nullable
                  as double,
        winRate: null == winRate
            ? _value.winRate
            : winRate // ignore: cast_nullable_to_non_nullable
                  as double,
        averageScore: null == averageScore
            ? _value.averageScore
            : averageScore // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BattlePlayerImpl implements _BattlePlayer {
  const _$BattlePlayerImpl({
    required this.playerId,
    required this.displayName,
    required this.profileImageUrl,
    required this.grade,
    required this.totalBattlesPlayed,
    required this.totalWins,
    required this.winRate,
    required this.averageScore,
  });

  factory _$BattlePlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$BattlePlayerImplFromJson(json);

  @override
  final String playerId;
  @override
  final String displayName;
  @override
  final String profileImageUrl;
  @override
  final int grade;
  @override
  final double totalBattlesPlayed;
  @override
  final double totalWins;
  @override
  final double winRate;
  @override
  final double averageScore;

  @override
  String toString() {
    return 'BattlePlayer(playerId: $playerId, displayName: $displayName, profileImageUrl: $profileImageUrl, grade: $grade, totalBattlesPlayed: $totalBattlesPlayed, totalWins: $totalWins, winRate: $winRate, averageScore: $averageScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BattlePlayerImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.totalBattlesPlayed, totalBattlesPlayed) ||
                other.totalBattlesPlayed == totalBattlesPlayed) &&
            (identical(other.totalWins, totalWins) ||
                other.totalWins == totalWins) &&
            (identical(other.winRate, winRate) || other.winRate == winRate) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    playerId,
    displayName,
    profileImageUrl,
    grade,
    totalBattlesPlayed,
    totalWins,
    winRate,
    averageScore,
  );

  /// Create a copy of BattlePlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BattlePlayerImplCopyWith<_$BattlePlayerImpl> get copyWith =>
      __$$BattlePlayerImplCopyWithImpl<_$BattlePlayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BattlePlayerImplToJson(this);
  }
}

abstract class _BattlePlayer implements BattlePlayer {
  const factory _BattlePlayer({
    required final String playerId,
    required final String displayName,
    required final String profileImageUrl,
    required final int grade,
    required final double totalBattlesPlayed,
    required final double totalWins,
    required final double winRate,
    required final double averageScore,
  }) = _$BattlePlayerImpl;

  factory _BattlePlayer.fromJson(Map<String, dynamic> json) =
      _$BattlePlayerImpl.fromJson;

  @override
  String get playerId;
  @override
  String get displayName;
  @override
  String get profileImageUrl;
  @override
  int get grade;
  @override
  double get totalBattlesPlayed;
  @override
  double get totalWins;
  @override
  double get winRate;
  @override
  double get averageScore;

  /// Create a copy of BattlePlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BattlePlayerImplCopyWith<_$BattlePlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
