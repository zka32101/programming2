import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_model.freezed.dart';

part 'friend_model.g.dart';

@freezed
class Friend with _$Friend {
  const factory Friend({
    required String userId,
    required String displayName,
    required String profileImageUrl,
    required int grade,
    required DateTime addedDate,
    required bool isOnline,
    required int totalScore, // 総合スコア
    required double averageAccuracy,
  }) = _Friend;

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
}

@freezed
class FriendRequest with _$FriendRequest {
  const factory FriendRequest({
    required String requestId,
    required String senderId,
    required String senderName,
    required String senderImageUrl,
    required String recipientId,
    required DateTime sentDate,
    required String status, // pending, accepted, rejected
  }) = _FriendRequest;

  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);
}

@freezed
class FriendComparison with _$FriendComparison {
  const factory FriendComparison({
    required String userId,
    required String friendId,
    required String friendName,
    required DateTime comparisonDate,
    required int userScore,
    required int friendScore,
    required double userAccuracy,
    required double friendAccuracy,
    required String result, // win, lose, draw
  }) = _FriendComparison;

  factory FriendComparison.fromJson(Map<String, dynamic> json) =>
      _$FriendComparisonFromJson(json);
}
