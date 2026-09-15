// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_passage_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReadingPassage _$ReadingPassageFromJson(Map<String, dynamic> json) {
  return _ReadingPassage.fromJson(json);
}

/// @nodoc
mixin _$ReadingPassage {
  String get passageId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  int get grade => throw _privateConstructorUsedError; // 1-6
  String get difficulty =>
      throw _privateConstructorUsedError; // basic, standard, advanced
  int get estimatedReadingTimeSeconds => throw _privateConstructorUsedError;
  String get genre =>
      throw _privateConstructorUsedError; // folk_tale, modern_fiction, essay, etc.
  int get wordCount => throw _privateConstructorUsedError;
  List<String> get vocabularyList => throw _privateConstructorUsedError;

  /// Serializes this ReadingPassage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReadingPassage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadingPassageCopyWith<ReadingPassage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadingPassageCopyWith<$Res> {
  factory $ReadingPassageCopyWith(
    ReadingPassage value,
    $Res Function(ReadingPassage) then,
  ) = _$ReadingPassageCopyWithImpl<$Res, ReadingPassage>;
  @useResult
  $Res call({
    String passageId,
    String title,
    String content,
    String author,
    int grade,
    String difficulty,
    int estimatedReadingTimeSeconds,
    String genre,
    int wordCount,
    List<String> vocabularyList,
  });
}

/// @nodoc
class _$ReadingPassageCopyWithImpl<$Res, $Val extends ReadingPassage>
    implements $ReadingPassageCopyWith<$Res> {
  _$ReadingPassageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReadingPassage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? passageId = null,
    Object? title = null,
    Object? content = null,
    Object? author = null,
    Object? grade = null,
    Object? difficulty = null,
    Object? estimatedReadingTimeSeconds = null,
    Object? genre = null,
    Object? wordCount = null,
    Object? vocabularyList = null,
  }) {
    return _then(
      _value.copyWith(
            passageId: null == passageId
                ? _value.passageId
                : passageId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as String,
            grade: null == grade
                ? _value.grade
                : grade // ignore: cast_nullable_to_non_nullable
                      as int,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as String,
            estimatedReadingTimeSeconds: null == estimatedReadingTimeSeconds
                ? _value.estimatedReadingTimeSeconds
                : estimatedReadingTimeSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            genre: null == genre
                ? _value.genre
                : genre // ignore: cast_nullable_to_non_nullable
                      as String,
            wordCount: null == wordCount
                ? _value.wordCount
                : wordCount // ignore: cast_nullable_to_non_nullable
                      as int,
            vocabularyList: null == vocabularyList
                ? _value.vocabularyList
                : vocabularyList // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReadingPassageImplCopyWith<$Res>
    implements $ReadingPassageCopyWith<$Res> {
  factory _$$ReadingPassageImplCopyWith(
    _$ReadingPassageImpl value,
    $Res Function(_$ReadingPassageImpl) then,
  ) = __$$ReadingPassageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String passageId,
    String title,
    String content,
    String author,
    int grade,
    String difficulty,
    int estimatedReadingTimeSeconds,
    String genre,
    int wordCount,
    List<String> vocabularyList,
  });
}

/// @nodoc
class __$$ReadingPassageImplCopyWithImpl<$Res>
    extends _$ReadingPassageCopyWithImpl<$Res, _$ReadingPassageImpl>
    implements _$$ReadingPassageImplCopyWith<$Res> {
  __$$ReadingPassageImplCopyWithImpl(
    _$ReadingPassageImpl _value,
    $Res Function(_$ReadingPassageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReadingPassage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? passageId = null,
    Object? title = null,
    Object? content = null,
    Object? author = null,
    Object? grade = null,
    Object? difficulty = null,
    Object? estimatedReadingTimeSeconds = null,
    Object? genre = null,
    Object? wordCount = null,
    Object? vocabularyList = null,
  }) {
    return _then(
      _$ReadingPassageImpl(
        passageId: null == passageId
            ? _value.passageId
            : passageId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as String,
        grade: null == grade
            ? _value.grade
            : grade // ignore: cast_nullable_to_non_nullable
                  as int,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as String,
        estimatedReadingTimeSeconds: null == estimatedReadingTimeSeconds
            ? _value.estimatedReadingTimeSeconds
            : estimatedReadingTimeSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        genre: null == genre
            ? _value.genre
            : genre // ignore: cast_nullable_to_non_nullable
                  as String,
        wordCount: null == wordCount
            ? _value.wordCount
            : wordCount // ignore: cast_nullable_to_non_nullable
                  as int,
        vocabularyList: null == vocabularyList
            ? _value._vocabularyList
            : vocabularyList // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReadingPassageImpl implements _ReadingPassage {
  const _$ReadingPassageImpl({
    required this.passageId,
    required this.title,
    required this.content,
    required this.author,
    required this.grade,
    required this.difficulty,
    required this.estimatedReadingTimeSeconds,
    required this.genre,
    required this.wordCount,
    required final List<String> vocabularyList,
  }) : _vocabularyList = vocabularyList;

  factory _$ReadingPassageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReadingPassageImplFromJson(json);

  @override
  final String passageId;
  @override
  final String title;
  @override
  final String content;
  @override
  final String author;
  @override
  final int grade;
  // 1-6
  @override
  final String difficulty;
  // basic, standard, advanced
  @override
  final int estimatedReadingTimeSeconds;
  @override
  final String genre;
  // folk_tale, modern_fiction, essay, etc.
  @override
  final int wordCount;
  final List<String> _vocabularyList;
  @override
  List<String> get vocabularyList {
    if (_vocabularyList is EqualUnmodifiableListView) return _vocabularyList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vocabularyList);
  }

  @override
  String toString() {
    return 'ReadingPassage(passageId: $passageId, title: $title, content: $content, author: $author, grade: $grade, difficulty: $difficulty, estimatedReadingTimeSeconds: $estimatedReadingTimeSeconds, genre: $genre, wordCount: $wordCount, vocabularyList: $vocabularyList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadingPassageImpl &&
            (identical(other.passageId, passageId) ||
                other.passageId == passageId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(
                  other.estimatedReadingTimeSeconds,
                  estimatedReadingTimeSeconds,
                ) ||
                other.estimatedReadingTimeSeconds ==
                    estimatedReadingTimeSeconds) &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.wordCount, wordCount) ||
                other.wordCount == wordCount) &&
            const DeepCollectionEquality().equals(
              other._vocabularyList,
              _vocabularyList,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    passageId,
    title,
    content,
    author,
    grade,
    difficulty,
    estimatedReadingTimeSeconds,
    genre,
    wordCount,
    const DeepCollectionEquality().hash(_vocabularyList),
  );

  /// Create a copy of ReadingPassage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadingPassageImplCopyWith<_$ReadingPassageImpl> get copyWith =>
      __$$ReadingPassageImplCopyWithImpl<_$ReadingPassageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReadingPassageImplToJson(this);
  }
}

abstract class _ReadingPassage implements ReadingPassage {
  const factory _ReadingPassage({
    required final String passageId,
    required final String title,
    required final String content,
    required final String author,
    required final int grade,
    required final String difficulty,
    required final int estimatedReadingTimeSeconds,
    required final String genre,
    required final int wordCount,
    required final List<String> vocabularyList,
  }) = _$ReadingPassageImpl;

  factory _ReadingPassage.fromJson(Map<String, dynamic> json) =
      _$ReadingPassageImpl.fromJson;

  @override
  String get passageId;
  @override
  String get title;
  @override
  String get content;
  @override
  String get author;
  @override
  int get grade; // 1-6
  @override
  String get difficulty; // basic, standard, advanced
  @override
  int get estimatedReadingTimeSeconds;
  @override
  String get genre; // folk_tale, modern_fiction, essay, etc.
  @override
  int get wordCount;
  @override
  List<String> get vocabularyList;

  /// Create a copy of ReadingPassage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadingPassageImplCopyWith<_$ReadingPassageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ComprehensionQuestion _$ComprehensionQuestionFromJson(
  Map<String, dynamic> json,
) {
  return _ComprehensionQuestion.fromJson(json);
}

/// @nodoc
mixin _$ComprehensionQuestion {
  String get questionId => throw _privateConstructorUsedError;
  String get passageId => throw _privateConstructorUsedError;
  String get questionType =>
      throw _privateConstructorUsedError; // summary, vocabulary, structure, expression
  String get questionText => throw _privateConstructorUsedError;
  List<String> get choices => throw _privateConstructorUsedError;
  String get correctAnswer => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;
  int get difficultyScore => throw _privateConstructorUsedError;

  /// Serializes this ComprehensionQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ComprehensionQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ComprehensionQuestionCopyWith<ComprehensionQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComprehensionQuestionCopyWith<$Res> {
  factory $ComprehensionQuestionCopyWith(
    ComprehensionQuestion value,
    $Res Function(ComprehensionQuestion) then,
  ) = _$ComprehensionQuestionCopyWithImpl<$Res, ComprehensionQuestion>;
  @useResult
  $Res call({
    String questionId,
    String passageId,
    String questionType,
    String questionText,
    List<String> choices,
    String correctAnswer,
    String explanation,
    int difficultyScore,
  });
}

/// @nodoc
class _$ComprehensionQuestionCopyWithImpl<
  $Res,
  $Val extends ComprehensionQuestion
>
    implements $ComprehensionQuestionCopyWith<$Res> {
  _$ComprehensionQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ComprehensionQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? passageId = null,
    Object? questionType = null,
    Object? questionText = null,
    Object? choices = null,
    Object? correctAnswer = null,
    Object? explanation = null,
    Object? difficultyScore = null,
  }) {
    return _then(
      _value.copyWith(
            questionId: null == questionId
                ? _value.questionId
                : questionId // ignore: cast_nullable_to_non_nullable
                      as String,
            passageId: null == passageId
                ? _value.passageId
                : passageId // ignore: cast_nullable_to_non_nullable
                      as String,
            questionType: null == questionType
                ? _value.questionType
                : questionType // ignore: cast_nullable_to_non_nullable
                      as String,
            questionText: null == questionText
                ? _value.questionText
                : questionText // ignore: cast_nullable_to_non_nullable
                      as String,
            choices: null == choices
                ? _value.choices
                : choices // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            correctAnswer: null == correctAnswer
                ? _value.correctAnswer
                : correctAnswer // ignore: cast_nullable_to_non_nullable
                      as String,
            explanation: null == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String,
            difficultyScore: null == difficultyScore
                ? _value.difficultyScore
                : difficultyScore // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ComprehensionQuestionImplCopyWith<$Res>
    implements $ComprehensionQuestionCopyWith<$Res> {
  factory _$$ComprehensionQuestionImplCopyWith(
    _$ComprehensionQuestionImpl value,
    $Res Function(_$ComprehensionQuestionImpl) then,
  ) = __$$ComprehensionQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String questionId,
    String passageId,
    String questionType,
    String questionText,
    List<String> choices,
    String correctAnswer,
    String explanation,
    int difficultyScore,
  });
}

/// @nodoc
class __$$ComprehensionQuestionImplCopyWithImpl<$Res>
    extends
        _$ComprehensionQuestionCopyWithImpl<$Res, _$ComprehensionQuestionImpl>
    implements _$$ComprehensionQuestionImplCopyWith<$Res> {
  __$$ComprehensionQuestionImplCopyWithImpl(
    _$ComprehensionQuestionImpl _value,
    $Res Function(_$ComprehensionQuestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ComprehensionQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? passageId = null,
    Object? questionType = null,
    Object? questionText = null,
    Object? choices = null,
    Object? correctAnswer = null,
    Object? explanation = null,
    Object? difficultyScore = null,
  }) {
    return _then(
      _$ComprehensionQuestionImpl(
        questionId: null == questionId
            ? _value.questionId
            : questionId // ignore: cast_nullable_to_non_nullable
                  as String,
        passageId: null == passageId
            ? _value.passageId
            : passageId // ignore: cast_nullable_to_non_nullable
                  as String,
        questionType: null == questionType
            ? _value.questionType
            : questionType // ignore: cast_nullable_to_non_nullable
                  as String,
        questionText: null == questionText
            ? _value.questionText
            : questionText // ignore: cast_nullable_to_non_nullable
                  as String,
        choices: null == choices
            ? _value._choices
            : choices // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        correctAnswer: null == correctAnswer
            ? _value.correctAnswer
            : correctAnswer // ignore: cast_nullable_to_non_nullable
                  as String,
        explanation: null == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String,
        difficultyScore: null == difficultyScore
            ? _value.difficultyScore
            : difficultyScore // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ComprehensionQuestionImpl implements _ComprehensionQuestion {
  const _$ComprehensionQuestionImpl({
    required this.questionId,
    required this.passageId,
    required this.questionType,
    required this.questionText,
    required final List<String> choices,
    required this.correctAnswer,
    required this.explanation,
    required this.difficultyScore,
  }) : _choices = choices;

  factory _$ComprehensionQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComprehensionQuestionImplFromJson(json);

  @override
  final String questionId;
  @override
  final String passageId;
  @override
  final String questionType;
  // summary, vocabulary, structure, expression
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
  final String correctAnswer;
  @override
  final String explanation;
  @override
  final int difficultyScore;

  @override
  String toString() {
    return 'ComprehensionQuestion(questionId: $questionId, passageId: $passageId, questionType: $questionType, questionText: $questionText, choices: $choices, correctAnswer: $correctAnswer, explanation: $explanation, difficultyScore: $difficultyScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComprehensionQuestionImpl &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.passageId, passageId) ||
                other.passageId == passageId) &&
            (identical(other.questionType, questionType) ||
                other.questionType == questionType) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            const DeepCollectionEquality().equals(other._choices, _choices) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.difficultyScore, difficultyScore) ||
                other.difficultyScore == difficultyScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    questionId,
    passageId,
    questionType,
    questionText,
    const DeepCollectionEquality().hash(_choices),
    correctAnswer,
    explanation,
    difficultyScore,
  );

  /// Create a copy of ComprehensionQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ComprehensionQuestionImplCopyWith<_$ComprehensionQuestionImpl>
  get copyWith =>
      __$$ComprehensionQuestionImplCopyWithImpl<_$ComprehensionQuestionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ComprehensionQuestionImplToJson(this);
  }
}

abstract class _ComprehensionQuestion implements ComprehensionQuestion {
  const factory _ComprehensionQuestion({
    required final String questionId,
    required final String passageId,
    required final String questionType,
    required final String questionText,
    required final List<String> choices,
    required final String correctAnswer,
    required final String explanation,
    required final int difficultyScore,
  }) = _$ComprehensionQuestionImpl;

  factory _ComprehensionQuestion.fromJson(Map<String, dynamic> json) =
      _$ComprehensionQuestionImpl.fromJson;

  @override
  String get questionId;
  @override
  String get passageId;
  @override
  String get questionType; // summary, vocabulary, structure, expression
  @override
  String get questionText;
  @override
  List<String> get choices;
  @override
  String get correctAnswer;
  @override
  String get explanation;
  @override
  int get difficultyScore;

  /// Create a copy of ComprehensionQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ComprehensionQuestionImplCopyWith<_$ComprehensionQuestionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ReadingSession _$ReadingSessionFromJson(Map<String, dynamic> json) {
  return _ReadingSession.fromJson(json);
}

/// @nodoc
mixin _$ReadingSession {
  String get sessionId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get passageId => throw _privateConstructorUsedError;
  DateTime get startedDate => throw _privateConstructorUsedError;
  DateTime? get completedDate => throw _privateConstructorUsedError;
  int get readingDurationSeconds => throw _privateConstructorUsedError;
  List<String> get answeredQuestionIds => throw _privateConstructorUsedError;
  List<bool> get answerCorrectness =>
      throw _privateConstructorUsedError; // [true, false, true, ...]
  double get comprehensionScore =>
      throw _privateConstructorUsedError; // 0.0 ~ 1.0
  bool get isCompleted => throw _privateConstructorUsedError;

  /// Serializes this ReadingSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadingSessionCopyWith<ReadingSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadingSessionCopyWith<$Res> {
  factory $ReadingSessionCopyWith(
    ReadingSession value,
    $Res Function(ReadingSession) then,
  ) = _$ReadingSessionCopyWithImpl<$Res, ReadingSession>;
  @useResult
  $Res call({
    String sessionId,
    String userId,
    String passageId,
    DateTime startedDate,
    DateTime? completedDate,
    int readingDurationSeconds,
    List<String> answeredQuestionIds,
    List<bool> answerCorrectness,
    double comprehensionScore,
    bool isCompleted,
  });
}

/// @nodoc
class _$ReadingSessionCopyWithImpl<$Res, $Val extends ReadingSession>
    implements $ReadingSessionCopyWith<$Res> {
  _$ReadingSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userId = null,
    Object? passageId = null,
    Object? startedDate = null,
    Object? completedDate = freezed,
    Object? readingDurationSeconds = null,
    Object? answeredQuestionIds = null,
    Object? answerCorrectness = null,
    Object? comprehensionScore = null,
    Object? isCompleted = null,
  }) {
    return _then(
      _value.copyWith(
            sessionId: null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            passageId: null == passageId
                ? _value.passageId
                : passageId // ignore: cast_nullable_to_non_nullable
                      as String,
            startedDate: null == startedDate
                ? _value.startedDate
                : startedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedDate: freezed == completedDate
                ? _value.completedDate
                : completedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            readingDurationSeconds: null == readingDurationSeconds
                ? _value.readingDurationSeconds
                : readingDurationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            answeredQuestionIds: null == answeredQuestionIds
                ? _value.answeredQuestionIds
                : answeredQuestionIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            answerCorrectness: null == answerCorrectness
                ? _value.answerCorrectness
                : answerCorrectness // ignore: cast_nullable_to_non_nullable
                      as List<bool>,
            comprehensionScore: null == comprehensionScore
                ? _value.comprehensionScore
                : comprehensionScore // ignore: cast_nullable_to_non_nullable
                      as double,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReadingSessionImplCopyWith<$Res>
    implements $ReadingSessionCopyWith<$Res> {
  factory _$$ReadingSessionImplCopyWith(
    _$ReadingSessionImpl value,
    $Res Function(_$ReadingSessionImpl) then,
  ) = __$$ReadingSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String sessionId,
    String userId,
    String passageId,
    DateTime startedDate,
    DateTime? completedDate,
    int readingDurationSeconds,
    List<String> answeredQuestionIds,
    List<bool> answerCorrectness,
    double comprehensionScore,
    bool isCompleted,
  });
}

/// @nodoc
class __$$ReadingSessionImplCopyWithImpl<$Res>
    extends _$ReadingSessionCopyWithImpl<$Res, _$ReadingSessionImpl>
    implements _$$ReadingSessionImplCopyWith<$Res> {
  __$$ReadingSessionImplCopyWithImpl(
    _$ReadingSessionImpl _value,
    $Res Function(_$ReadingSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userId = null,
    Object? passageId = null,
    Object? startedDate = null,
    Object? completedDate = freezed,
    Object? readingDurationSeconds = null,
    Object? answeredQuestionIds = null,
    Object? answerCorrectness = null,
    Object? comprehensionScore = null,
    Object? isCompleted = null,
  }) {
    return _then(
      _$ReadingSessionImpl(
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        passageId: null == passageId
            ? _value.passageId
            : passageId // ignore: cast_nullable_to_non_nullable
                  as String,
        startedDate: null == startedDate
            ? _value.startedDate
            : startedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedDate: freezed == completedDate
            ? _value.completedDate
            : completedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        readingDurationSeconds: null == readingDurationSeconds
            ? _value.readingDurationSeconds
            : readingDurationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        answeredQuestionIds: null == answeredQuestionIds
            ? _value._answeredQuestionIds
            : answeredQuestionIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        answerCorrectness: null == answerCorrectness
            ? _value._answerCorrectness
            : answerCorrectness // ignore: cast_nullable_to_non_nullable
                  as List<bool>,
        comprehensionScore: null == comprehensionScore
            ? _value.comprehensionScore
            : comprehensionScore // ignore: cast_nullable_to_non_nullable
                  as double,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReadingSessionImpl implements _ReadingSession {
  const _$ReadingSessionImpl({
    required this.sessionId,
    required this.userId,
    required this.passageId,
    required this.startedDate,
    required this.completedDate,
    required this.readingDurationSeconds,
    required final List<String> answeredQuestionIds,
    required final List<bool> answerCorrectness,
    required this.comprehensionScore,
    required this.isCompleted,
  }) : _answeredQuestionIds = answeredQuestionIds,
       _answerCorrectness = answerCorrectness;

  factory _$ReadingSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReadingSessionImplFromJson(json);

  @override
  final String sessionId;
  @override
  final String userId;
  @override
  final String passageId;
  @override
  final DateTime startedDate;
  @override
  final DateTime? completedDate;
  @override
  final int readingDurationSeconds;
  final List<String> _answeredQuestionIds;
  @override
  List<String> get answeredQuestionIds {
    if (_answeredQuestionIds is EqualUnmodifiableListView)
      return _answeredQuestionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answeredQuestionIds);
  }

  final List<bool> _answerCorrectness;
  @override
  List<bool> get answerCorrectness {
    if (_answerCorrectness is EqualUnmodifiableListView)
      return _answerCorrectness;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answerCorrectness);
  }

  // [true, false, true, ...]
  @override
  final double comprehensionScore;
  // 0.0 ~ 1.0
  @override
  final bool isCompleted;

  @override
  String toString() {
    return 'ReadingSession(sessionId: $sessionId, userId: $userId, passageId: $passageId, startedDate: $startedDate, completedDate: $completedDate, readingDurationSeconds: $readingDurationSeconds, answeredQuestionIds: $answeredQuestionIds, answerCorrectness: $answerCorrectness, comprehensionScore: $comprehensionScore, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadingSessionImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.passageId, passageId) ||
                other.passageId == passageId) &&
            (identical(other.startedDate, startedDate) ||
                other.startedDate == startedDate) &&
            (identical(other.completedDate, completedDate) ||
                other.completedDate == completedDate) &&
            (identical(other.readingDurationSeconds, readingDurationSeconds) ||
                other.readingDurationSeconds == readingDurationSeconds) &&
            const DeepCollectionEquality().equals(
              other._answeredQuestionIds,
              _answeredQuestionIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._answerCorrectness,
              _answerCorrectness,
            ) &&
            (identical(other.comprehensionScore, comprehensionScore) ||
                other.comprehensionScore == comprehensionScore) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sessionId,
    userId,
    passageId,
    startedDate,
    completedDate,
    readingDurationSeconds,
    const DeepCollectionEquality().hash(_answeredQuestionIds),
    const DeepCollectionEquality().hash(_answerCorrectness),
    comprehensionScore,
    isCompleted,
  );

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadingSessionImplCopyWith<_$ReadingSessionImpl> get copyWith =>
      __$$ReadingSessionImplCopyWithImpl<_$ReadingSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReadingSessionImplToJson(this);
  }
}

abstract class _ReadingSession implements ReadingSession {
  const factory _ReadingSession({
    required final String sessionId,
    required final String userId,
    required final String passageId,
    required final DateTime startedDate,
    required final DateTime? completedDate,
    required final int readingDurationSeconds,
    required final List<String> answeredQuestionIds,
    required final List<bool> answerCorrectness,
    required final double comprehensionScore,
    required final bool isCompleted,
  }) = _$ReadingSessionImpl;

  factory _ReadingSession.fromJson(Map<String, dynamic> json) =
      _$ReadingSessionImpl.fromJson;

  @override
  String get sessionId;
  @override
  String get userId;
  @override
  String get passageId;
  @override
  DateTime get startedDate;
  @override
  DateTime? get completedDate;
  @override
  int get readingDurationSeconds;
  @override
  List<String> get answeredQuestionIds;
  @override
  List<bool> get answerCorrectness; // [true, false, true, ...]
  @override
  double get comprehensionScore; // 0.0 ~ 1.0
  @override
  bool get isCompleted;

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadingSessionImplCopyWith<_$ReadingSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReadingAnalytics _$ReadingAnalyticsFromJson(Map<String, dynamic> json) {
  return _ReadingAnalytics.fromJson(json);
}

/// @nodoc
mixin _$ReadingAnalytics {
  String get userId => throw _privateConstructorUsedError;
  int get totalPassagesRead => throw _privateConstructorUsedError;
  double get averageComprehensionScore => throw _privateConstructorUsedError;
  int get totalReadingMinutes => throw _privateConstructorUsedError;
  Map<String, int> get difficultyDistribution =>
      throw _privateConstructorUsedError; // {basic: 5, standard: 3, advanced: 1}
  List<String> get favoritedGenres => throw _privateConstructorUsedError;
  DateTime get lastReadingDate => throw _privateConstructorUsedError;

  /// Serializes this ReadingAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReadingAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadingAnalyticsCopyWith<ReadingAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadingAnalyticsCopyWith<$Res> {
  factory $ReadingAnalyticsCopyWith(
    ReadingAnalytics value,
    $Res Function(ReadingAnalytics) then,
  ) = _$ReadingAnalyticsCopyWithImpl<$Res, ReadingAnalytics>;
  @useResult
  $Res call({
    String userId,
    int totalPassagesRead,
    double averageComprehensionScore,
    int totalReadingMinutes,
    Map<String, int> difficultyDistribution,
    List<String> favoritedGenres,
    DateTime lastReadingDate,
  });
}

/// @nodoc
class _$ReadingAnalyticsCopyWithImpl<$Res, $Val extends ReadingAnalytics>
    implements $ReadingAnalyticsCopyWith<$Res> {
  _$ReadingAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReadingAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalPassagesRead = null,
    Object? averageComprehensionScore = null,
    Object? totalReadingMinutes = null,
    Object? difficultyDistribution = null,
    Object? favoritedGenres = null,
    Object? lastReadingDate = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            totalPassagesRead: null == totalPassagesRead
                ? _value.totalPassagesRead
                : totalPassagesRead // ignore: cast_nullable_to_non_nullable
                      as int,
            averageComprehensionScore: null == averageComprehensionScore
                ? _value.averageComprehensionScore
                : averageComprehensionScore // ignore: cast_nullable_to_non_nullable
                      as double,
            totalReadingMinutes: null == totalReadingMinutes
                ? _value.totalReadingMinutes
                : totalReadingMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            difficultyDistribution: null == difficultyDistribution
                ? _value.difficultyDistribution
                : difficultyDistribution // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            favoritedGenres: null == favoritedGenres
                ? _value.favoritedGenres
                : favoritedGenres // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            lastReadingDate: null == lastReadingDate
                ? _value.lastReadingDate
                : lastReadingDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReadingAnalyticsImplCopyWith<$Res>
    implements $ReadingAnalyticsCopyWith<$Res> {
  factory _$$ReadingAnalyticsImplCopyWith(
    _$ReadingAnalyticsImpl value,
    $Res Function(_$ReadingAnalyticsImpl) then,
  ) = __$$ReadingAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    int totalPassagesRead,
    double averageComprehensionScore,
    int totalReadingMinutes,
    Map<String, int> difficultyDistribution,
    List<String> favoritedGenres,
    DateTime lastReadingDate,
  });
}

/// @nodoc
class __$$ReadingAnalyticsImplCopyWithImpl<$Res>
    extends _$ReadingAnalyticsCopyWithImpl<$Res, _$ReadingAnalyticsImpl>
    implements _$$ReadingAnalyticsImplCopyWith<$Res> {
  __$$ReadingAnalyticsImplCopyWithImpl(
    _$ReadingAnalyticsImpl _value,
    $Res Function(_$ReadingAnalyticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReadingAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalPassagesRead = null,
    Object? averageComprehensionScore = null,
    Object? totalReadingMinutes = null,
    Object? difficultyDistribution = null,
    Object? favoritedGenres = null,
    Object? lastReadingDate = null,
  }) {
    return _then(
      _$ReadingAnalyticsImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        totalPassagesRead: null == totalPassagesRead
            ? _value.totalPassagesRead
            : totalPassagesRead // ignore: cast_nullable_to_non_nullable
                  as int,
        averageComprehensionScore: null == averageComprehensionScore
            ? _value.averageComprehensionScore
            : averageComprehensionScore // ignore: cast_nullable_to_non_nullable
                  as double,
        totalReadingMinutes: null == totalReadingMinutes
            ? _value.totalReadingMinutes
            : totalReadingMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        difficultyDistribution: null == difficultyDistribution
            ? _value._difficultyDistribution
            : difficultyDistribution // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        favoritedGenres: null == favoritedGenres
            ? _value._favoritedGenres
            : favoritedGenres // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        lastReadingDate: null == lastReadingDate
            ? _value.lastReadingDate
            : lastReadingDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReadingAnalyticsImpl implements _ReadingAnalytics {
  const _$ReadingAnalyticsImpl({
    required this.userId,
    required this.totalPassagesRead,
    required this.averageComprehensionScore,
    required this.totalReadingMinutes,
    required final Map<String, int> difficultyDistribution,
    required final List<String> favoritedGenres,
    required this.lastReadingDate,
  }) : _difficultyDistribution = difficultyDistribution,
       _favoritedGenres = favoritedGenres;

  factory _$ReadingAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReadingAnalyticsImplFromJson(json);

  @override
  final String userId;
  @override
  final int totalPassagesRead;
  @override
  final double averageComprehensionScore;
  @override
  final int totalReadingMinutes;
  final Map<String, int> _difficultyDistribution;
  @override
  Map<String, int> get difficultyDistribution {
    if (_difficultyDistribution is EqualUnmodifiableMapView)
      return _difficultyDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_difficultyDistribution);
  }

  // {basic: 5, standard: 3, advanced: 1}
  final List<String> _favoritedGenres;
  // {basic: 5, standard: 3, advanced: 1}
  @override
  List<String> get favoritedGenres {
    if (_favoritedGenres is EqualUnmodifiableListView) return _favoritedGenres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoritedGenres);
  }

  @override
  final DateTime lastReadingDate;

  @override
  String toString() {
    return 'ReadingAnalytics(userId: $userId, totalPassagesRead: $totalPassagesRead, averageComprehensionScore: $averageComprehensionScore, totalReadingMinutes: $totalReadingMinutes, difficultyDistribution: $difficultyDistribution, favoritedGenres: $favoritedGenres, lastReadingDate: $lastReadingDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadingAnalyticsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.totalPassagesRead, totalPassagesRead) ||
                other.totalPassagesRead == totalPassagesRead) &&
            (identical(
                  other.averageComprehensionScore,
                  averageComprehensionScore,
                ) ||
                other.averageComprehensionScore == averageComprehensionScore) &&
            (identical(other.totalReadingMinutes, totalReadingMinutes) ||
                other.totalReadingMinutes == totalReadingMinutes) &&
            const DeepCollectionEquality().equals(
              other._difficultyDistribution,
              _difficultyDistribution,
            ) &&
            const DeepCollectionEquality().equals(
              other._favoritedGenres,
              _favoritedGenres,
            ) &&
            (identical(other.lastReadingDate, lastReadingDate) ||
                other.lastReadingDate == lastReadingDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    totalPassagesRead,
    averageComprehensionScore,
    totalReadingMinutes,
    const DeepCollectionEquality().hash(_difficultyDistribution),
    const DeepCollectionEquality().hash(_favoritedGenres),
    lastReadingDate,
  );

  /// Create a copy of ReadingAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadingAnalyticsImplCopyWith<_$ReadingAnalyticsImpl> get copyWith =>
      __$$ReadingAnalyticsImplCopyWithImpl<_$ReadingAnalyticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReadingAnalyticsImplToJson(this);
  }
}

abstract class _ReadingAnalytics implements ReadingAnalytics {
  const factory _ReadingAnalytics({
    required final String userId,
    required final int totalPassagesRead,
    required final double averageComprehensionScore,
    required final int totalReadingMinutes,
    required final Map<String, int> difficultyDistribution,
    required final List<String> favoritedGenres,
    required final DateTime lastReadingDate,
  }) = _$ReadingAnalyticsImpl;

  factory _ReadingAnalytics.fromJson(Map<String, dynamic> json) =
      _$ReadingAnalyticsImpl.fromJson;

  @override
  String get userId;
  @override
  int get totalPassagesRead;
  @override
  double get averageComprehensionScore;
  @override
  int get totalReadingMinutes;
  @override
  Map<String, int> get difficultyDistribution; // {basic: 5, standard: 3, advanced: 1}
  @override
  List<String> get favoritedGenres;
  @override
  DateTime get lastReadingDate;

  /// Create a copy of ReadingAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadingAnalyticsImplCopyWith<_$ReadingAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SummaryQuestionSet _$SummaryQuestionSetFromJson(Map<String, dynamic> json) {
  return _SummaryQuestionSet.fromJson(json);
}

/// @nodoc
mixin _$SummaryQuestionSet {
  String get setId => throw _privateConstructorUsedError;
  String get passageId => throw _privateConstructorUsedError;
  List<String> get summaryOptions =>
      throw _privateConstructorUsedError; // 複数の要約候補
  String get correctSummary => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;

  /// Serializes this SummaryQuestionSet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SummaryQuestionSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SummaryQuestionSetCopyWith<SummaryQuestionSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SummaryQuestionSetCopyWith<$Res> {
  factory $SummaryQuestionSetCopyWith(
    SummaryQuestionSet value,
    $Res Function(SummaryQuestionSet) then,
  ) = _$SummaryQuestionSetCopyWithImpl<$Res, SummaryQuestionSet>;
  @useResult
  $Res call({
    String setId,
    String passageId,
    List<String> summaryOptions,
    String correctSummary,
    String explanation,
  });
}

/// @nodoc
class _$SummaryQuestionSetCopyWithImpl<$Res, $Val extends SummaryQuestionSet>
    implements $SummaryQuestionSetCopyWith<$Res> {
  _$SummaryQuestionSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SummaryQuestionSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setId = null,
    Object? passageId = null,
    Object? summaryOptions = null,
    Object? correctSummary = null,
    Object? explanation = null,
  }) {
    return _then(
      _value.copyWith(
            setId: null == setId
                ? _value.setId
                : setId // ignore: cast_nullable_to_non_nullable
                      as String,
            passageId: null == passageId
                ? _value.passageId
                : passageId // ignore: cast_nullable_to_non_nullable
                      as String,
            summaryOptions: null == summaryOptions
                ? _value.summaryOptions
                : summaryOptions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            correctSummary: null == correctSummary
                ? _value.correctSummary
                : correctSummary // ignore: cast_nullable_to_non_nullable
                      as String,
            explanation: null == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SummaryQuestionSetImplCopyWith<$Res>
    implements $SummaryQuestionSetCopyWith<$Res> {
  factory _$$SummaryQuestionSetImplCopyWith(
    _$SummaryQuestionSetImpl value,
    $Res Function(_$SummaryQuestionSetImpl) then,
  ) = __$$SummaryQuestionSetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String setId,
    String passageId,
    List<String> summaryOptions,
    String correctSummary,
    String explanation,
  });
}

/// @nodoc
class __$$SummaryQuestionSetImplCopyWithImpl<$Res>
    extends _$SummaryQuestionSetCopyWithImpl<$Res, _$SummaryQuestionSetImpl>
    implements _$$SummaryQuestionSetImplCopyWith<$Res> {
  __$$SummaryQuestionSetImplCopyWithImpl(
    _$SummaryQuestionSetImpl _value,
    $Res Function(_$SummaryQuestionSetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SummaryQuestionSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setId = null,
    Object? passageId = null,
    Object? summaryOptions = null,
    Object? correctSummary = null,
    Object? explanation = null,
  }) {
    return _then(
      _$SummaryQuestionSetImpl(
        setId: null == setId
            ? _value.setId
            : setId // ignore: cast_nullable_to_non_nullable
                  as String,
        passageId: null == passageId
            ? _value.passageId
            : passageId // ignore: cast_nullable_to_non_nullable
                  as String,
        summaryOptions: null == summaryOptions
            ? _value._summaryOptions
            : summaryOptions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        correctSummary: null == correctSummary
            ? _value.correctSummary
            : correctSummary // ignore: cast_nullable_to_non_nullable
                  as String,
        explanation: null == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SummaryQuestionSetImpl implements _SummaryQuestionSet {
  const _$SummaryQuestionSetImpl({
    required this.setId,
    required this.passageId,
    required final List<String> summaryOptions,
    required this.correctSummary,
    required this.explanation,
  }) : _summaryOptions = summaryOptions;

  factory _$SummaryQuestionSetImpl.fromJson(Map<String, dynamic> json) =>
      _$$SummaryQuestionSetImplFromJson(json);

  @override
  final String setId;
  @override
  final String passageId;
  final List<String> _summaryOptions;
  @override
  List<String> get summaryOptions {
    if (_summaryOptions is EqualUnmodifiableListView) return _summaryOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_summaryOptions);
  }

  // 複数の要約候補
  @override
  final String correctSummary;
  @override
  final String explanation;

  @override
  String toString() {
    return 'SummaryQuestionSet(setId: $setId, passageId: $passageId, summaryOptions: $summaryOptions, correctSummary: $correctSummary, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SummaryQuestionSetImpl &&
            (identical(other.setId, setId) || other.setId == setId) &&
            (identical(other.passageId, passageId) ||
                other.passageId == passageId) &&
            const DeepCollectionEquality().equals(
              other._summaryOptions,
              _summaryOptions,
            ) &&
            (identical(other.correctSummary, correctSummary) ||
                other.correctSummary == correctSummary) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    setId,
    passageId,
    const DeepCollectionEquality().hash(_summaryOptions),
    correctSummary,
    explanation,
  );

  /// Create a copy of SummaryQuestionSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SummaryQuestionSetImplCopyWith<_$SummaryQuestionSetImpl> get copyWith =>
      __$$SummaryQuestionSetImplCopyWithImpl<_$SummaryQuestionSetImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SummaryQuestionSetImplToJson(this);
  }
}

abstract class _SummaryQuestionSet implements SummaryQuestionSet {
  const factory _SummaryQuestionSet({
    required final String setId,
    required final String passageId,
    required final List<String> summaryOptions,
    required final String correctSummary,
    required final String explanation,
  }) = _$SummaryQuestionSetImpl;

  factory _SummaryQuestionSet.fromJson(Map<String, dynamic> json) =
      _$SummaryQuestionSetImpl.fromJson;

  @override
  String get setId;
  @override
  String get passageId;
  @override
  List<String> get summaryOptions; // 複数の要約候補
  @override
  String get correctSummary;
  @override
  String get explanation;

  /// Create a copy of SummaryQuestionSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SummaryQuestionSetImplCopyWith<_$SummaryQuestionSetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExpressionQuestion _$ExpressionQuestionFromJson(Map<String, dynamic> json) {
  return _ExpressionQuestion.fromJson(json);
}

/// @nodoc
mixin _$ExpressionQuestion {
  String get questionId => throw _privateConstructorUsedError;
  String get passageId => throw _privateConstructorUsedError;
  String get phrase => throw _privateConstructorUsedError; // 本文中の表現
  List<String> get meaningOptions => throw _privateConstructorUsedError;
  String get correctMeaning => throw _privateConstructorUsedError;
  String get contextExplanation => throw _privateConstructorUsedError;

  /// Serializes this ExpressionQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpressionQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpressionQuestionCopyWith<ExpressionQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpressionQuestionCopyWith<$Res> {
  factory $ExpressionQuestionCopyWith(
    ExpressionQuestion value,
    $Res Function(ExpressionQuestion) then,
  ) = _$ExpressionQuestionCopyWithImpl<$Res, ExpressionQuestion>;
  @useResult
  $Res call({
    String questionId,
    String passageId,
    String phrase,
    List<String> meaningOptions,
    String correctMeaning,
    String contextExplanation,
  });
}

/// @nodoc
class _$ExpressionQuestionCopyWithImpl<$Res, $Val extends ExpressionQuestion>
    implements $ExpressionQuestionCopyWith<$Res> {
  _$ExpressionQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpressionQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? passageId = null,
    Object? phrase = null,
    Object? meaningOptions = null,
    Object? correctMeaning = null,
    Object? contextExplanation = null,
  }) {
    return _then(
      _value.copyWith(
            questionId: null == questionId
                ? _value.questionId
                : questionId // ignore: cast_nullable_to_non_nullable
                      as String,
            passageId: null == passageId
                ? _value.passageId
                : passageId // ignore: cast_nullable_to_non_nullable
                      as String,
            phrase: null == phrase
                ? _value.phrase
                : phrase // ignore: cast_nullable_to_non_nullable
                      as String,
            meaningOptions: null == meaningOptions
                ? _value.meaningOptions
                : meaningOptions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            correctMeaning: null == correctMeaning
                ? _value.correctMeaning
                : correctMeaning // ignore: cast_nullable_to_non_nullable
                      as String,
            contextExplanation: null == contextExplanation
                ? _value.contextExplanation
                : contextExplanation // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExpressionQuestionImplCopyWith<$Res>
    implements $ExpressionQuestionCopyWith<$Res> {
  factory _$$ExpressionQuestionImplCopyWith(
    _$ExpressionQuestionImpl value,
    $Res Function(_$ExpressionQuestionImpl) then,
  ) = __$$ExpressionQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String questionId,
    String passageId,
    String phrase,
    List<String> meaningOptions,
    String correctMeaning,
    String contextExplanation,
  });
}

/// @nodoc
class __$$ExpressionQuestionImplCopyWithImpl<$Res>
    extends _$ExpressionQuestionCopyWithImpl<$Res, _$ExpressionQuestionImpl>
    implements _$$ExpressionQuestionImplCopyWith<$Res> {
  __$$ExpressionQuestionImplCopyWithImpl(
    _$ExpressionQuestionImpl _value,
    $Res Function(_$ExpressionQuestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExpressionQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? passageId = null,
    Object? phrase = null,
    Object? meaningOptions = null,
    Object? correctMeaning = null,
    Object? contextExplanation = null,
  }) {
    return _then(
      _$ExpressionQuestionImpl(
        questionId: null == questionId
            ? _value.questionId
            : questionId // ignore: cast_nullable_to_non_nullable
                  as String,
        passageId: null == passageId
            ? _value.passageId
            : passageId // ignore: cast_nullable_to_non_nullable
                  as String,
        phrase: null == phrase
            ? _value.phrase
            : phrase // ignore: cast_nullable_to_non_nullable
                  as String,
        meaningOptions: null == meaningOptions
            ? _value._meaningOptions
            : meaningOptions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        correctMeaning: null == correctMeaning
            ? _value.correctMeaning
            : correctMeaning // ignore: cast_nullable_to_non_nullable
                  as String,
        contextExplanation: null == contextExplanation
            ? _value.contextExplanation
            : contextExplanation // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpressionQuestionImpl implements _ExpressionQuestion {
  const _$ExpressionQuestionImpl({
    required this.questionId,
    required this.passageId,
    required this.phrase,
    required final List<String> meaningOptions,
    required this.correctMeaning,
    required this.contextExplanation,
  }) : _meaningOptions = meaningOptions;

  factory _$ExpressionQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpressionQuestionImplFromJson(json);

  @override
  final String questionId;
  @override
  final String passageId;
  @override
  final String phrase;
  // 本文中の表現
  final List<String> _meaningOptions;
  // 本文中の表現
  @override
  List<String> get meaningOptions {
    if (_meaningOptions is EqualUnmodifiableListView) return _meaningOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_meaningOptions);
  }

  @override
  final String correctMeaning;
  @override
  final String contextExplanation;

  @override
  String toString() {
    return 'ExpressionQuestion(questionId: $questionId, passageId: $passageId, phrase: $phrase, meaningOptions: $meaningOptions, correctMeaning: $correctMeaning, contextExplanation: $contextExplanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpressionQuestionImpl &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.passageId, passageId) ||
                other.passageId == passageId) &&
            (identical(other.phrase, phrase) || other.phrase == phrase) &&
            const DeepCollectionEquality().equals(
              other._meaningOptions,
              _meaningOptions,
            ) &&
            (identical(other.correctMeaning, correctMeaning) ||
                other.correctMeaning == correctMeaning) &&
            (identical(other.contextExplanation, contextExplanation) ||
                other.contextExplanation == contextExplanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    questionId,
    passageId,
    phrase,
    const DeepCollectionEquality().hash(_meaningOptions),
    correctMeaning,
    contextExplanation,
  );

  /// Create a copy of ExpressionQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpressionQuestionImplCopyWith<_$ExpressionQuestionImpl> get copyWith =>
      __$$ExpressionQuestionImplCopyWithImpl<_$ExpressionQuestionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpressionQuestionImplToJson(this);
  }
}

abstract class _ExpressionQuestion implements ExpressionQuestion {
  const factory _ExpressionQuestion({
    required final String questionId,
    required final String passageId,
    required final String phrase,
    required final List<String> meaningOptions,
    required final String correctMeaning,
    required final String contextExplanation,
  }) = _$ExpressionQuestionImpl;

  factory _ExpressionQuestion.fromJson(Map<String, dynamic> json) =
      _$ExpressionQuestionImpl.fromJson;

  @override
  String get questionId;
  @override
  String get passageId;
  @override
  String get phrase; // 本文中の表現
  @override
  List<String> get meaningOptions;
  @override
  String get correctMeaning;
  @override
  String get contextExplanation;

  /// Create a copy of ExpressionQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpressionQuestionImplCopyWith<_$ExpressionQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TextStructureAnalysis _$TextStructureAnalysisFromJson(
  Map<String, dynamic> json,
) {
  return _TextStructureAnalysis.fromJson(json);
}

/// @nodoc
mixin _$TextStructureAnalysis {
  String get analysisId => throw _privateConstructorUsedError;
  String get passageId => throw _privateConstructorUsedError;
  List<String> get paragraphs => throw _privateConstructorUsedError;
  List<String> get mainPoints => throw _privateConstructorUsedError;
  String get climax => throw _privateConstructorUsedError; // クライマックス部分
  String get resolution => throw _privateConstructorUsedError; // 解決部分
  Map<String, String> get characterDescriptions =>
      throw _privateConstructorUsedError;

  /// Serializes this TextStructureAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TextStructureAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TextStructureAnalysisCopyWith<TextStructureAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TextStructureAnalysisCopyWith<$Res> {
  factory $TextStructureAnalysisCopyWith(
    TextStructureAnalysis value,
    $Res Function(TextStructureAnalysis) then,
  ) = _$TextStructureAnalysisCopyWithImpl<$Res, TextStructureAnalysis>;
  @useResult
  $Res call({
    String analysisId,
    String passageId,
    List<String> paragraphs,
    List<String> mainPoints,
    String climax,
    String resolution,
    Map<String, String> characterDescriptions,
  });
}

/// @nodoc
class _$TextStructureAnalysisCopyWithImpl<
  $Res,
  $Val extends TextStructureAnalysis
>
    implements $TextStructureAnalysisCopyWith<$Res> {
  _$TextStructureAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TextStructureAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? analysisId = null,
    Object? passageId = null,
    Object? paragraphs = null,
    Object? mainPoints = null,
    Object? climax = null,
    Object? resolution = null,
    Object? characterDescriptions = null,
  }) {
    return _then(
      _value.copyWith(
            analysisId: null == analysisId
                ? _value.analysisId
                : analysisId // ignore: cast_nullable_to_non_nullable
                      as String,
            passageId: null == passageId
                ? _value.passageId
                : passageId // ignore: cast_nullable_to_non_nullable
                      as String,
            paragraphs: null == paragraphs
                ? _value.paragraphs
                : paragraphs // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            mainPoints: null == mainPoints
                ? _value.mainPoints
                : mainPoints // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            climax: null == climax
                ? _value.climax
                : climax // ignore: cast_nullable_to_non_nullable
                      as String,
            resolution: null == resolution
                ? _value.resolution
                : resolution // ignore: cast_nullable_to_non_nullable
                      as String,
            characterDescriptions: null == characterDescriptions
                ? _value.characterDescriptions
                : characterDescriptions // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TextStructureAnalysisImplCopyWith<$Res>
    implements $TextStructureAnalysisCopyWith<$Res> {
  factory _$$TextStructureAnalysisImplCopyWith(
    _$TextStructureAnalysisImpl value,
    $Res Function(_$TextStructureAnalysisImpl) then,
  ) = __$$TextStructureAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String analysisId,
    String passageId,
    List<String> paragraphs,
    List<String> mainPoints,
    String climax,
    String resolution,
    Map<String, String> characterDescriptions,
  });
}

/// @nodoc
class __$$TextStructureAnalysisImplCopyWithImpl<$Res>
    extends
        _$TextStructureAnalysisCopyWithImpl<$Res, _$TextStructureAnalysisImpl>
    implements _$$TextStructureAnalysisImplCopyWith<$Res> {
  __$$TextStructureAnalysisImplCopyWithImpl(
    _$TextStructureAnalysisImpl _value,
    $Res Function(_$TextStructureAnalysisImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TextStructureAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? analysisId = null,
    Object? passageId = null,
    Object? paragraphs = null,
    Object? mainPoints = null,
    Object? climax = null,
    Object? resolution = null,
    Object? characterDescriptions = null,
  }) {
    return _then(
      _$TextStructureAnalysisImpl(
        analysisId: null == analysisId
            ? _value.analysisId
            : analysisId // ignore: cast_nullable_to_non_nullable
                  as String,
        passageId: null == passageId
            ? _value.passageId
            : passageId // ignore: cast_nullable_to_non_nullable
                  as String,
        paragraphs: null == paragraphs
            ? _value._paragraphs
            : paragraphs // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        mainPoints: null == mainPoints
            ? _value._mainPoints
            : mainPoints // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        climax: null == climax
            ? _value.climax
            : climax // ignore: cast_nullable_to_non_nullable
                  as String,
        resolution: null == resolution
            ? _value.resolution
            : resolution // ignore: cast_nullable_to_non_nullable
                  as String,
        characterDescriptions: null == characterDescriptions
            ? _value._characterDescriptions
            : characterDescriptions // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TextStructureAnalysisImpl implements _TextStructureAnalysis {
  const _$TextStructureAnalysisImpl({
    required this.analysisId,
    required this.passageId,
    required final List<String> paragraphs,
    required final List<String> mainPoints,
    required this.climax,
    required this.resolution,
    required final Map<String, String> characterDescriptions,
  }) : _paragraphs = paragraphs,
       _mainPoints = mainPoints,
       _characterDescriptions = characterDescriptions;

  factory _$TextStructureAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$TextStructureAnalysisImplFromJson(json);

  @override
  final String analysisId;
  @override
  final String passageId;
  final List<String> _paragraphs;
  @override
  List<String> get paragraphs {
    if (_paragraphs is EqualUnmodifiableListView) return _paragraphs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paragraphs);
  }

  final List<String> _mainPoints;
  @override
  List<String> get mainPoints {
    if (_mainPoints is EqualUnmodifiableListView) return _mainPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mainPoints);
  }

  @override
  final String climax;
  // クライマックス部分
  @override
  final String resolution;
  // 解決部分
  final Map<String, String> _characterDescriptions;
  // 解決部分
  @override
  Map<String, String> get characterDescriptions {
    if (_characterDescriptions is EqualUnmodifiableMapView)
      return _characterDescriptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_characterDescriptions);
  }

  @override
  String toString() {
    return 'TextStructureAnalysis(analysisId: $analysisId, passageId: $passageId, paragraphs: $paragraphs, mainPoints: $mainPoints, climax: $climax, resolution: $resolution, characterDescriptions: $characterDescriptions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TextStructureAnalysisImpl &&
            (identical(other.analysisId, analysisId) ||
                other.analysisId == analysisId) &&
            (identical(other.passageId, passageId) ||
                other.passageId == passageId) &&
            const DeepCollectionEquality().equals(
              other._paragraphs,
              _paragraphs,
            ) &&
            const DeepCollectionEquality().equals(
              other._mainPoints,
              _mainPoints,
            ) &&
            (identical(other.climax, climax) || other.climax == climax) &&
            (identical(other.resolution, resolution) ||
                other.resolution == resolution) &&
            const DeepCollectionEquality().equals(
              other._characterDescriptions,
              _characterDescriptions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    analysisId,
    passageId,
    const DeepCollectionEquality().hash(_paragraphs),
    const DeepCollectionEquality().hash(_mainPoints),
    climax,
    resolution,
    const DeepCollectionEquality().hash(_characterDescriptions),
  );

  /// Create a copy of TextStructureAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TextStructureAnalysisImplCopyWith<_$TextStructureAnalysisImpl>
  get copyWith =>
      __$$TextStructureAnalysisImplCopyWithImpl<_$TextStructureAnalysisImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TextStructureAnalysisImplToJson(this);
  }
}

abstract class _TextStructureAnalysis implements TextStructureAnalysis {
  const factory _TextStructureAnalysis({
    required final String analysisId,
    required final String passageId,
    required final List<String> paragraphs,
    required final List<String> mainPoints,
    required final String climax,
    required final String resolution,
    required final Map<String, String> characterDescriptions,
  }) = _$TextStructureAnalysisImpl;

  factory _TextStructureAnalysis.fromJson(Map<String, dynamic> json) =
      _$TextStructureAnalysisImpl.fromJson;

  @override
  String get analysisId;
  @override
  String get passageId;
  @override
  List<String> get paragraphs;
  @override
  List<String> get mainPoints;
  @override
  String get climax; // クライマックス部分
  @override
  String get resolution; // 解決部分
  @override
  Map<String, String> get characterDescriptions;

  /// Create a copy of TextStructureAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TextStructureAnalysisImplCopyWith<_$TextStructureAnalysisImpl>
  get copyWith => throw _privateConstructorUsedError;
}
