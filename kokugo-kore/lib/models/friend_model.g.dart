// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendImpl _$$FriendImplFromJson(Map<String, dynamic> json) => _$FriendImpl(
  userId: json['userId'] as String,
  displayName: json['displayName'] as String,
  profileImageUrl: json['profileImageUrl'] as String,
  grade: (json['grade'] as num).toInt(),
  addedDate: DateTime.parse(json['addedDate'] as String),
  isOnline: json['isOnline'] as bool,
  totalScore: (json['totalScore'] as num).toInt(),
  averageAccuracy: (json['averageAccuracy'] as num).toDouble(),
);

Map<String, dynamic> _$$FriendImplToJson(_$FriendImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'profileImageUrl': instance.profileImageUrl,
      'grade': instance.grade,
      'addedDate': instance.addedDate.toIso8601String(),
      'isOnline': instance.isOnline,
      'totalScore': instance.totalScore,
      'averageAccuracy': instance.averageAccuracy,
    };

_$FriendRequestImpl _$$FriendRequestImplFromJson(Map<String, dynamic> json) =>
    _$FriendRequestImpl(
      requestId: json['requestId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderImageUrl: json['senderImageUrl'] as String,
      recipientId: json['recipientId'] as String,
      sentDate: DateTime.parse(json['sentDate'] as String),
      status: json['status'] as String,
    );

Map<String, dynamic> _$$FriendRequestImplToJson(_$FriendRequestImpl instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderImageUrl': instance.senderImageUrl,
      'recipientId': instance.recipientId,
      'sentDate': instance.sentDate.toIso8601String(),
      'status': instance.status,
    };

_$FriendComparisonImpl _$$FriendComparisonImplFromJson(
  Map<String, dynamic> json,
) => _$FriendComparisonImpl(
  userId: json['userId'] as String,
  friendId: json['friendId'] as String,
  friendName: json['friendName'] as String,
  comparisonDate: DateTime.parse(json['comparisonDate'] as String),
  userScore: (json['userScore'] as num).toInt(),
  friendScore: (json['friendScore'] as num).toInt(),
  userAccuracy: (json['userAccuracy'] as num).toDouble(),
  friendAccuracy: (json['friendAccuracy'] as num).toDouble(),
  result: json['result'] as String,
);

Map<String, dynamic> _$$FriendComparisonImplToJson(
  _$FriendComparisonImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'friendId': instance.friendId,
  'friendName': instance.friendName,
  'comparisonDate': instance.comparisonDate.toIso8601String(),
  'userScore': instance.userScore,
  'friendScore': instance.friendScore,
  'userAccuracy': instance.userAccuracy,
  'friendAccuracy': instance.friendAccuracy,
  'result': instance.result,
};
