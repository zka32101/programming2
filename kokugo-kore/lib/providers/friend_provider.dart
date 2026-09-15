import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/friend_model.dart';
import '../services/firebase_realtime_db.dart';

final friendListProvider = StateNotifierProvider<FriendNotifier, List<Friend>>((ref) {
  return FriendNotifier();
});

final friendRequestsProvider = StreamProvider.family<List<FriendRequest>, String>((ref, userId) {
  return FirebaseRealtimeAPI.getFriendRequestsStream(userId);
});

final friendComparisonProvider = StateProvider<FriendComparison?>((ref) => null);

class FriendNotifier extends StateNotifier<List<Friend>> {
  FriendNotifier() : super([]);

  /// Load friends list from Firebase
  Future<void> loadFriends(String userId) async {
    try {
      final friends = await FirebaseRealtimeAPI.getFriends(userId);
      state = friends;
    } catch (e) {
      debugPrint('❌ Error loading friends: $e');
    }
  }

  /// Add a friend to the list
  Future<void> addFriend(String userId, Friend friend) async {
    try {
      await FirebaseRealtimeAPI.addFriend(userId, friend.userId, friend);
      state = [...state, friend];
    } catch (e) {
      debugPrint('❌ Error adding friend: $e');
      rethrow;
    }
  }

  /// Remove a friend from the list
  Future<void> removeFriend(String userId, String friendId) async {
    try {
      await FirebaseRealtimeAPI.removeFriend(userId, friendId);
      state = state.where((f) => f.userId != friendId).toList();
    } catch (e) {
      debugPrint('❌ Error removing friend: $e');
      rethrow;
    }
  }

  /// Search for users to add as friends (local search for now)
  List<Friend> searchFriends(String query) {
    return state
        .where((friend) =>
            friend.displayName.toLowerCase().contains(query.toLowerCase()) ||
            friend.userId.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Send friend request
  Future<void> sendFriendRequest(
    String senderId,
    String recipientId,
    String recipientName,
    String recipientImage,
    {String senderName = '', String senderImageUrl = ''}
  ) async {
    try {
      final request = FriendRequest(
        requestId: const Uuid().v4(),
        senderId: senderId,
        senderName: senderName.isNotEmpty ? senderName : 'User',
        senderImageUrl: senderImageUrl,
        recipientId: recipientId,
        sentDate: DateTime.now(),
        status: 'pending',
      );

      await FirebaseRealtimeAPI.sendFriendRequest(senderId, request);
    } catch (e) {
      debugPrint('❌ Error sending friend request: $e');
      rethrow;
    }
  }

  /// Get friend by ID
  Friend? getFriend(String friendId) {
    try {
      return state.firstWhere((f) => f.userId == friendId);
    } catch (e) {
      return null;
    }
  }

  /// Get total number of friends
  int getTotalFriends() => state.length;

  /// Get online friends count
  int getOnlineFriendCount() => state.where((f) => f.isOnline).length;

  /// Get top friends by score
  List<Friend> getTopFriends({int limit = 5}) {
    final sorted = [...state];
    sorted.sort((a, b) => b.totalScore.compareTo(a.totalScore));
    return sorted.take(limit).toList();
  }

  /// Calculate friend statistics
  Map<String, dynamic> getFriendStatistics() {
    return {
      'total': state.length,
      'online': state.where((f) => f.isOnline).length,
      'averageAccuracy': state.isEmpty ? 0.0 : (state.map((f) => f.averageAccuracy).reduce((a, b) => a + b) / state.length),
      'topScore': state.isEmpty ? 0 : state.map((f) => f.totalScore).reduce((a, b) => a > b ? a : b),
    };
  }

  /// Get friend IDs for ranking filtering
  List<String> getFriendIds() {
    return state.map((f) => f.userId).toList();
  }

  /// Accept friend request and add to friends list
  Future<void> acceptFriendRequest(
    String userId,
    FriendRequest request,
    Friend friendData,
  ) async {
    try {
      // Add friend to list
      await addFriend(userId, friendData);

      // Mark request as accepted
      debugPrint('✅ Friend request accepted from ${request.senderId}');
    } catch (e) {
      debugPrint('❌ Error accepting friend request: $e');
      rethrow;
    }
  }

  /// Decline friend request
  Future<void> declineFriendRequest(FriendRequest request) async {
    try {
      debugPrint('✅ Friend request declined from ${request.senderId}');
    } catch (e) {
      debugPrint('❌ Error declining friend request: $e');
      rethrow;
    }
  }
}
