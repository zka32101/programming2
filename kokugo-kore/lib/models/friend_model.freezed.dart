// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return _Friend.fromJson(json);
}

/// @nodoc
mixin _$Friend {
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get profileImageUrl => throw _privateConstructorUsedError;
  int get grade => throw _privateConstructorUsedError;
  DateTime get addedDate => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  int get totalScore => throw _privateConstructorUsedError; // 総合スコア
  double get averageAccuracy => throw _privateConstructorUsedError;

  /// Serializes this Friend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendCopyWith<Friend> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendCopyWith<$Res> {
  factory $FriendCopyWith(Friend value, $Res Function(Friend) then) =
      _$FriendCopyWithImpl<$Res, Friend>;
  @useResult
  $Res call({
    String userId,
    String displayName,
    String profileImageUrl,
    int grade,
    DateTime addedDate,
    bool isOnline,
    int totalScore,
    double averageAccuracy,
  });
}

/// @nodoc
class _$FriendCopyWithImpl<$Res, $Val extends Friend>
    implements $FriendCopyWith<$Res> {
  _$FriendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? profileImageUrl = null,
    Object? grade = null,
    Object? addedDate = null,
    Object? isOnline = null,
    Object? totalScore = null,
    Object? averageAccuracy = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
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
            addedDate: null == addedDate
                ? _value.addedDate
                : addedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isOnline: null == isOnline
                ? _value.isOnline
                : isOnline // ignore: cast_nullable_to_non_nullable
                      as bool,
            totalScore: null == totalScore
                ? _value.totalScore
                : totalScore // ignore: cast_nullable_to_non_nullable
                      as int,
            averageAccuracy: null == averageAccuracy
                ? _value.averageAccuracy
                : averageAccuracy // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FriendImplCopyWith<$Res> implements $FriendCopyWith<$Res> {
  factory _$$FriendImplCopyWith(
    _$FriendImpl value,
    $Res Function(_$FriendImpl) then,
  ) = __$$FriendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String displayName,
    String profileImageUrl,
    int grade,
    DateTime addedDate,
    bool isOnline,
    int totalScore,
    double averageAccuracy,
  });
}

/// @nodoc
class __$$FriendImplCopyWithImpl<$Res>
    extends _$FriendCopyWithImpl<$Res, _$FriendImpl>
    implements _$$FriendImplCopyWith<$Res> {
  __$$FriendImplCopyWithImpl(
    _$FriendImpl _value,
    $Res Function(_$FriendImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? profileImageUrl = null,
    Object? grade = null,
    Object? addedDate = null,
    Object? isOnline = null,
    Object? totalScore = null,
    Object? averageAccuracy = null,
  }) {
    return _then(
      _$FriendImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
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
        addedDate: null == addedDate
            ? _value.addedDate
            : addedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isOnline: null == isOnline
            ? _value.isOnline
            : isOnline // ignore: cast_nullable_to_non_nullable
                  as bool,
        totalScore: null == totalScore
            ? _value.totalScore
            : totalScore // ignore: cast_nullable_to_non_nullable
                  as int,
        averageAccuracy: null == averageAccuracy
            ? _value.averageAccuracy
            : averageAccuracy // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendImpl implements _Friend {
  const _$FriendImpl({
    required this.userId,
    required this.displayName,
    required this.profileImageUrl,
    required this.grade,
    required this.addedDate,
    required this.isOnline,
    required this.totalScore,
    required this.averageAccuracy,
  });

  factory _$FriendImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendImplFromJson(json);

  @override
  final String userId;
  @override
  final String displayName;
  @override
  final String profileImageUrl;
  @override
  final int grade;
  @override
  final DateTime addedDate;
  @override
  final bool isOnline;
  @override
  final int totalScore;
  // 総合スコア
  @override
  final double averageAccuracy;

  @override
  String toString() {
    return 'Friend(userId: $userId, displayName: $displayName, profileImageUrl: $profileImageUrl, grade: $grade, addedDate: $addedDate, isOnline: $isOnline, totalScore: $totalScore, averageAccuracy: $averageAccuracy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.addedDate, addedDate) ||
                other.addedDate == addedDate) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            (identical(other.averageAccuracy, averageAccuracy) ||
                other.averageAccuracy == averageAccuracy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    displayName,
    profileImageUrl,
    grade,
    addedDate,
    isOnline,
    totalScore,
    averageAccuracy,
  );

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendImplCopyWith<_$FriendImpl> get copyWith =>
      __$$FriendImplCopyWithImpl<_$FriendImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendImplToJson(this);
  }
}

abstract class _Friend implements Friend {
  const factory _Friend({
    required final String userId,
    required final String displayName,
    required final String profileImageUrl,
    required final int grade,
    required final DateTime addedDate,
    required final bool isOnline,
    required final int totalScore,
    required final double averageAccuracy,
  }) = _$FriendImpl;

  factory _Friend.fromJson(Map<String, dynamic> json) = _$FriendImpl.fromJson;

  @override
  String get userId;
  @override
  String get displayName;
  @override
  String get profileImageUrl;
  @override
  int get grade;
  @override
  DateTime get addedDate;
  @override
  bool get isOnline;
  @override
  int get totalScore; // 総合スコア
  @override
  double get averageAccuracy;

  /// Create a copy of Friend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendImplCopyWith<_$FriendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) {
  return _FriendRequest.fromJson(json);
}

/// @nodoc
mixin _$FriendRequest {
  String get requestId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String get senderImageUrl => throw _privateConstructorUsedError;
  String get recipientId => throw _privateConstructorUsedError;
  DateTime get sentDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this FriendRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendRequestCopyWith<FriendRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendRequestCopyWith<$Res> {
  factory $FriendRequestCopyWith(
    FriendRequest value,
    $Res Function(FriendRequest) then,
  ) = _$FriendRequestCopyWithImpl<$Res, FriendRequest>;
  @useResult
  $Res call({
    String requestId,
    String senderId,
    String senderName,
    String senderImageUrl,
    String recipientId,
    DateTime sentDate,
    String status,
  });
}

/// @nodoc
class _$FriendRequestCopyWithImpl<$Res, $Val extends FriendRequest>
    implements $FriendRequestCopyWith<$Res> {
  _$FriendRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? senderImageUrl = null,
    Object? recipientId = null,
    Object? sentDate = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            requestId: null == requestId
                ? _value.requestId
                : requestId // ignore: cast_nullable_to_non_nullable
                      as String,
            senderId: null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String,
            senderName: null == senderName
                ? _value.senderName
                : senderName // ignore: cast_nullable_to_non_nullable
                      as String,
            senderImageUrl: null == senderImageUrl
                ? _value.senderImageUrl
                : senderImageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            recipientId: null == recipientId
                ? _value.recipientId
                : recipientId // ignore: cast_nullable_to_non_nullable
                      as String,
            sentDate: null == sentDate
                ? _value.sentDate
                : sentDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FriendRequestImplCopyWith<$Res>
    implements $FriendRequestCopyWith<$Res> {
  factory _$$FriendRequestImplCopyWith(
    _$FriendRequestImpl value,
    $Res Function(_$FriendRequestImpl) then,
  ) = __$$FriendRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String requestId,
    String senderId,
    String senderName,
    String senderImageUrl,
    String recipientId,
    DateTime sentDate,
    String status,
  });
}

/// @nodoc
class __$$FriendRequestImplCopyWithImpl<$Res>
    extends _$FriendRequestCopyWithImpl<$Res, _$FriendRequestImpl>
    implements _$$FriendRequestImplCopyWith<$Res> {
  __$$FriendRequestImplCopyWithImpl(
    _$FriendRequestImpl _value,
    $Res Function(_$FriendRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FriendRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? senderImageUrl = null,
    Object? recipientId = null,
    Object? sentDate = null,
    Object? status = null,
  }) {
    return _then(
      _$FriendRequestImpl(
        requestId: null == requestId
            ? _value.requestId
            : requestId // ignore: cast_nullable_to_non_nullable
                  as String,
        senderId: null == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String,
        senderName: null == senderName
            ? _value.senderName
            : senderName // ignore: cast_nullable_to_non_nullable
                  as String,
        senderImageUrl: null == senderImageUrl
            ? _value.senderImageUrl
            : senderImageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        recipientId: null == recipientId
            ? _value.recipientId
            : recipientId // ignore: cast_nullable_to_non_nullable
                  as String,
        sentDate: null == sentDate
            ? _value.sentDate
            : sentDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendRequestImpl implements _FriendRequest {
  const _$FriendRequestImpl({
    required this.requestId,
    required this.senderId,
    required this.senderName,
    required this.senderImageUrl,
    required this.recipientId,
    required this.sentDate,
    required this.status,
  });

  factory _$FriendRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendRequestImplFromJson(json);

  @override
  final String requestId;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final String senderImageUrl;
  @override
  final String recipientId;
  @override
  final DateTime sentDate;
  @override
  final String status;

  @override
  String toString() {
    return 'FriendRequest(requestId: $requestId, senderId: $senderId, senderName: $senderName, senderImageUrl: $senderImageUrl, recipientId: $recipientId, sentDate: $sentDate, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendRequestImpl &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderImageUrl, senderImageUrl) ||
                other.senderImageUrl == senderImageUrl) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.sentDate, sentDate) ||
                other.sentDate == sentDate) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    requestId,
    senderId,
    senderName,
    senderImageUrl,
    recipientId,
    sentDate,
    status,
  );

  /// Create a copy of FriendRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendRequestImplCopyWith<_$FriendRequestImpl> get copyWith =>
      __$$FriendRequestImplCopyWithImpl<_$FriendRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendRequestImplToJson(this);
  }
}

abstract class _FriendRequest implements FriendRequest {
  const factory _FriendRequest({
    required final String requestId,
    required final String senderId,
    required final String senderName,
    required final String senderImageUrl,
    required final String recipientId,
    required final DateTime sentDate,
    required final String status,
  }) = _$FriendRequestImpl;

  factory _FriendRequest.fromJson(Map<String, dynamic> json) =
      _$FriendRequestImpl.fromJson;

  @override
  String get requestId;
  @override
  String get senderId;
  @override
  String get senderName;
  @override
  String get senderImageUrl;
  @override
  String get recipientId;
  @override
  DateTime get sentDate;
  @override
  String get status;

  /// Create a copy of FriendRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendRequestImplCopyWith<_$FriendRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendComparison _$FriendComparisonFromJson(Map<String, dynamic> json) {
  return _FriendComparison.fromJson(json);
}

/// @nodoc
mixin _$FriendComparison {
  String get userId => throw _privateConstructorUsedError;
  String get friendId => throw _privateConstructorUsedError;
  String get friendName => throw _privateConstructorUsedError;
  DateTime get comparisonDate => throw _privateConstructorUsedError;
  int get userScore => throw _privateConstructorUsedError;
  int get friendScore => throw _privateConstructorUsedError;
  double get userAccuracy => throw _privateConstructorUsedError;
  double get friendAccuracy => throw _privateConstructorUsedError;
  String get result => throw _privateConstructorUsedError;

  /// Serializes this FriendComparison to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendComparisonCopyWith<FriendComparison> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendComparisonCopyWith<$Res> {
  factory $FriendComparisonCopyWith(
    FriendComparison value,
    $Res Function(FriendComparison) then,
  ) = _$FriendComparisonCopyWithImpl<$Res, FriendComparison>;
  @useResult
  $Res call({
    String userId,
    String friendId,
    String friendName,
    DateTime comparisonDate,
    int userScore,
    int friendScore,
    double userAccuracy,
    double friendAccuracy,
    String result,
  });
}

/// @nodoc
class _$FriendComparisonCopyWithImpl<$Res, $Val extends FriendComparison>
    implements $FriendComparisonCopyWith<$Res> {
  _$FriendComparisonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? friendId = null,
    Object? friendName = null,
    Object? comparisonDate = null,
    Object? userScore = null,
    Object? friendScore = null,
    Object? userAccuracy = null,
    Object? friendAccuracy = null,
    Object? result = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            friendId: null == friendId
                ? _value.friendId
                : friendId // ignore: cast_nullable_to_non_nullable
                      as String,
            friendName: null == friendName
                ? _value.friendName
                : friendName // ignore: cast_nullable_to_non_nullable
                      as String,
            comparisonDate: null == comparisonDate
                ? _value.comparisonDate
                : comparisonDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            userScore: null == userScore
                ? _value.userScore
                : userScore // ignore: cast_nullable_to_non_nullable
                      as int,
            friendScore: null == friendScore
                ? _value.friendScore
                : friendScore // ignore: cast_nullable_to_non_nullable
                      as int,
            userAccuracy: null == userAccuracy
                ? _value.userAccuracy
                : userAccuracy // ignore: cast_nullable_to_non_nullable
                      as double,
            friendAccuracy: null == friendAccuracy
                ? _value.friendAccuracy
                : friendAccuracy // ignore: cast_nullable_to_non_nullable
                      as double,
            result: null == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FriendComparisonImplCopyWith<$Res>
    implements $FriendComparisonCopyWith<$Res> {
  factory _$$FriendComparisonImplCopyWith(
    _$FriendComparisonImpl value,
    $Res Function(_$FriendComparisonImpl) then,
  ) = __$$FriendComparisonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String friendId,
    String friendName,
    DateTime comparisonDate,
    int userScore,
    int friendScore,
    double userAccuracy,
    double friendAccuracy,
    String result,
  });
}

/// @nodoc
class __$$FriendComparisonImplCopyWithImpl<$Res>
    extends _$FriendComparisonCopyWithImpl<$Res, _$FriendComparisonImpl>
    implements _$$FriendComparisonImplCopyWith<$Res> {
  __$$FriendComparisonImplCopyWithImpl(
    _$FriendComparisonImpl _value,
    $Res Function(_$FriendComparisonImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FriendComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? friendId = null,
    Object? friendName = null,
    Object? comparisonDate = null,
    Object? userScore = null,
    Object? friendScore = null,
    Object? userAccuracy = null,
    Object? friendAccuracy = null,
    Object? result = null,
  }) {
    return _then(
      _$FriendComparisonImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        friendId: null == friendId
            ? _value.friendId
            : friendId // ignore: cast_nullable_to_non_nullable
                  as String,
        friendName: null == friendName
            ? _value.friendName
            : friendName // ignore: cast_nullable_to_non_nullable
                  as String,
        comparisonDate: null == comparisonDate
            ? _value.comparisonDate
            : comparisonDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        userScore: null == userScore
            ? _value.userScore
            : userScore // ignore: cast_nullable_to_non_nullable
                  as int,
        friendScore: null == friendScore
            ? _value.friendScore
            : friendScore // ignore: cast_nullable_to_non_nullable
                  as int,
        userAccuracy: null == userAccuracy
            ? _value.userAccuracy
            : userAccuracy // ignore: cast_nullable_to_non_nullable
                  as double,
        friendAccuracy: null == friendAccuracy
            ? _value.friendAccuracy
            : friendAccuracy // ignore: cast_nullable_to_non_nullable
                  as double,
        result: null == result
            ? _value.result
            : result // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendComparisonImpl implements _FriendComparison {
  const _$FriendComparisonImpl({
    required this.userId,
    required this.friendId,
    required this.friendName,
    required this.comparisonDate,
    required this.userScore,
    required this.friendScore,
    required this.userAccuracy,
    required this.friendAccuracy,
    required this.result,
  });

  factory _$FriendComparisonImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendComparisonImplFromJson(json);

  @override
  final String userId;
  @override
  final String friendId;
  @override
  final String friendName;
  @override
  final DateTime comparisonDate;
  @override
  final int userScore;
  @override
  final int friendScore;
  @override
  final double userAccuracy;
  @override
  final double friendAccuracy;
  @override
  final String result;

  @override
  String toString() {
    return 'FriendComparison(userId: $userId, friendId: $friendId, friendName: $friendName, comparisonDate: $comparisonDate, userScore: $userScore, friendScore: $friendScore, userAccuracy: $userAccuracy, friendAccuracy: $friendAccuracy, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendComparisonImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.friendId, friendId) ||
                other.friendId == friendId) &&
            (identical(other.friendName, friendName) ||
                other.friendName == friendName) &&
            (identical(other.comparisonDate, comparisonDate) ||
                other.comparisonDate == comparisonDate) &&
            (identical(other.userScore, userScore) ||
                other.userScore == userScore) &&
            (identical(other.friendScore, friendScore) ||
                other.friendScore == friendScore) &&
            (identical(other.userAccuracy, userAccuracy) ||
                other.userAccuracy == userAccuracy) &&
            (identical(other.friendAccuracy, friendAccuracy) ||
                other.friendAccuracy == friendAccuracy) &&
            (identical(other.result, result) || other.result == result));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    friendId,
    friendName,
    comparisonDate,
    userScore,
    friendScore,
    userAccuracy,
    friendAccuracy,
    result,
  );

  /// Create a copy of FriendComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendComparisonImplCopyWith<_$FriendComparisonImpl> get copyWith =>
      __$$FriendComparisonImplCopyWithImpl<_$FriendComparisonImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendComparisonImplToJson(this);
  }
}

abstract class _FriendComparison implements FriendComparison {
  const factory _FriendComparison({
    required final String userId,
    required final String friendId,
    required final String friendName,
    required final DateTime comparisonDate,
    required final int userScore,
    required final int friendScore,
    required final double userAccuracy,
    required final double friendAccuracy,
    required final String result,
  }) = _$FriendComparisonImpl;

  factory _FriendComparison.fromJson(Map<String, dynamic> json) =
      _$FriendComparisonImpl.fromJson;

  @override
  String get userId;
  @override
  String get friendId;
  @override
  String get friendName;
  @override
  DateTime get comparisonDate;
  @override
  int get userScore;
  @override
  int get friendScore;
  @override
  double get userAccuracy;
  @override
  double get friendAccuracy;
  @override
  String get result;

  /// Create a copy of FriendComparison
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendComparisonImplCopyWith<_$FriendComparisonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
