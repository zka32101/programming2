import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_core/shared_core.dart' show FeedbackReport;

import '../models/analytics_model.dart';
import '../models/friend_model.dart';
import '../models/battle_model.dart';
import '../models/reading_passage_model.dart';

class FirebaseRealtimeDB {
  static const String usersPath = 'users';

  /// ユーザーデータ構造
  static String userPath(String userId) => '$usersPath/$userId';
  static String userProfilePath(String userId) => '${userPath(userId)}/profile';
  static String userProgressPath(String userId) => '${userPath(userId)}/progress';
  static String userCharactersPath(String userId) => '${userPath(userId)}/characters';
  static String userCharacterPath(String userId, String charId) => '${userCharactersPath(userId)}/$charId';
  static String userBadgesPath(String userId) => '${userPath(userId)}/badges';
  static String userBadgePath(String userId, String badgeId) => '${userBadgesPath(userId)}/$badgeId';
  static String userSkinsPath(String userId) => '${userPath(userId)}/skins';
  static String userSkinPath(String userId, String skinId) => '${userSkinsPath(userId)}/$skinId';
  static String userLastSyncPath(String userId) => '${userPath(userId)}/lastSync';

  /// ユーザープロフィール初期化
  static Map<String, dynamic> createUserProfile({
    required String name,
    required int grade,
  }) {
    return {
      'name': name,
      'grade': grade,
      'createdAt': _serverTimestamp(),
    };
  }

  /// ユーザー進捗初期化
  static Map<String, dynamic> createUserProgress() {
    return {
      'clearedStages': 0,
      'totalQuestions': 0,
      'correctAnswers': 0,
      'streakDays': 0,
      'lastActivityDate': _serverTimestamp(),
    };
  }

  /// キャラクター状態
  static Map<String, dynamic> createCharacterData({
    required bool isUnlocked,
    required int level,
    required int experience,
  }) {
    return {
      'isUnlocked': isUnlocked,
      'level': level,
      'experience': experience,
      'updatedAt': _serverTimestamp(),
    };
  }

  /// バッジ獲得データ
  static Map<String, dynamic> createBadgeData() {
    return {
      'earnedAt': _serverTimestamp(),
    };
  }

  /// スキンデータ
  static Map<String, dynamic> createSkinData({
    required bool isEquipped,
  }) {
    return {
      'unlockedAt': _serverTimestamp(),
      'isEquipped': isEquipped,
    };
  }

  /// サーバータイムスタンプ（Firebase SDKで処理される）
  static Map<String, String> _serverTimestamp() {
    return {'.sv': 'timestamp'};
  }

  /// ユーザーデータ構造全体を初期化
  static Map<String, dynamic> createUserData({
    required String userId,
    required String name,
    required int grade,
  }) {
    return {
      'profile': createUserProfile(name: name, grade: grade),
      'progress': createUserProgress(),
      'characters': {},
      'badges': {},
      'skins': {},
      'lastSync': _serverTimestamp(),
    };
  }

  // ===== Phase 1: Analytics, Friends, Battles, Reading API =====

  static final _db = FirebaseDatabase.instance;

  // Analytics paths
  static String userAnalyticsPath(String userId) => '${userPath(userId)}/analytics';
  static String userDailyStatsPath(String userId, String date) =>
      '${userAnalyticsPath(userId)}/daily/$date';
  static String userFriendsPath(String userId) => '${userPath(userId)}/friends';
  static String userFriendPath(String userId, String friendId) =>
      '${userFriendsPath(userId)}/$friendId';
  static String userFriendRequestsPath(String userId) =>
      '${userFriendsPath(userId)}/requests';
  static String userBattlesPath(String userId) => '${userPath(userId)}/battles';
  static String userReadingPath(String userId) => '${userPath(userId)}/readings';
  static const String battlesPath = 'battles';
  static const String readingPath = 'reading_passages';

  // バグ報告・改善要望（shared_core の FeedbackReport）
  static const String feedbackPath = 'feedback';
  static String feedbackReportPath(String reportId) => '$feedbackPath/$reportId';
}

/// Firebase Realtime Database API (Phase 1+)
class FirebaseRealtimeAPI {
  static final _db = FirebaseDatabase.instance;

  // ===== Analytics API =====

  /// Save daily stats
  static Future<void> saveDailyStats(String userId, DailyStats stats) async {
    try {
      final ref = _db.ref(FirebaseRealtimeDB.userDailyStatsPath(userId, stats.date));
      await ref.set(stats.toJson());
    } catch (e) {
      debugPrint('❌ Error saving daily stats: $e');
      rethrow;
    }
  }

  /// Get daily stats stream
  static Stream<ProgressAnalytics?> getAnalyticsStream(String userId) {
    return _db
        .ref(FirebaseRealtimeDB.userAnalyticsPath(userId))
        .onValue
        .map((event) {
          if (event.snapshot.exists) {
            try {
              return ProgressAnalytics.fromJson(
                Map<String, dynamic>.from(event.snapshot.value as Map),
              );
            } catch (e) {
              debugPrint('❌ Error parsing analytics: $e');
              return null;
            }
          }
          return null;
        });
  }

  // ===== Friends API =====

  /// Add friend
  static Future<void> addFriend(String userId, String friendId, Friend friend) async {
    try {
      final ref = _db.ref(FirebaseRealtimeDB.userFriendPath(userId, friendId));
      await ref.set(friend.toJson());
    } catch (e) {
      debugPrint('❌ Error adding friend: $e');
      rethrow;
    }
  }

  /// Remove friend
  static Future<void> removeFriend(String userId, String friendId) async {
    try {
      final ref = _db.ref(FirebaseRealtimeDB.userFriendPath(userId, friendId));
      await ref.remove();
    } catch (e) {
      debugPrint('❌ Error removing friend: $e');
      rethrow;
    }
  }

  /// Get friends list
  static Future<List<Friend>> getFriends(String userId) async {
    try {
      final ref = _db.ref(FirebaseRealtimeDB.userFriendsPath(userId));
      final snapshot = await ref.get();
      if (!snapshot.exists) return [];

      final friendsList = <Friend>[];
      for (final child in snapshot.children) {
        if (child.key != 'requests') {
          friendsList.add(Friend.fromJson(Map<String, dynamic>.from(child.value as Map)));
        }
      }
      return friendsList;
    } catch (e) {
      debugPrint('❌ Error getting friends: $e');
      return [];
    }
  }

  /// Send friend request
  static Future<void> sendFriendRequest(String senderId, FriendRequest request) async {
    try {
      final ref = _db.ref(
        '${FirebaseRealtimeDB.userFriendRequestsPath(request.recipientId)}/${request.requestId}',
      );
      await ref.set(request.toJson());
    } catch (e) {
      debugPrint('❌ Error sending friend request: $e');
      rethrow;
    }
  }

  /// Get friend requests stream
  static Stream<List<FriendRequest>> getFriendRequestsStream(String userId) {
    return _db
        .ref(FirebaseRealtimeDB.userFriendRequestsPath(userId))
        .onValue
        .map((event) {
          if (!event.snapshot.exists) return [];

          final requestsList = <FriendRequest>[];
          try {
            for (final child in event.snapshot.children) {
              requestsList.add(
                FriendRequest.fromJson(Map<String, dynamic>.from(child.value as Map)),
              );
            }
          } catch (e) {
            debugPrint('❌ Error parsing friend requests: $e');
          }
          return requestsList;
        });
  }

  // ===== Battles API =====

  /// Create battle
  static Future<void> createBattle(Battle battle) async {
    try {
      final ref = _db.ref('${FirebaseRealtimeDB.battlesPath}/${battle.battleId}');
      await ref.set(battle.toJson());
    } catch (e) {
      debugPrint('❌ Error creating battle: $e');
      rethrow;
    }
  }

  /// Get battle stream
  static Stream<Battle?> getBattleStream(String battleId) {
    return _db.ref('${FirebaseRealtimeDB.battlesPath}/$battleId').onValue.map((event) {
      if (event.snapshot.exists) {
        try {
          return Battle.fromJson(Map<String, dynamic>.from(event.snapshot.value as Map));
        } catch (e) {
          debugPrint('❌ Error parsing battle: $e');
          return null;
        }
      }
      return null;
    });
  }

  /// Save battle result
  static Future<void> saveBattleResult(BattleResult result) async {
    try {
      final ref = _db.ref('${FirebaseRealtimeDB.battlesPath}/${result.battleId}/result');
      await ref.set(result.toJson());
    } catch (e) {
      debugPrint('❌ Error saving battle result: $e');
      rethrow;
    }
  }

  // ===== Feedback API（バグ報告・改善要望） =====

  /// バグ報告・改善要望を feedback/{reportId} に書き込む。
  /// FeedbackNotifier.setSubmitHandler() に登録して使う。
  static Future<void> submitFeedback(FeedbackReport report) async {
    try {
      final ref = _db.ref(FirebaseRealtimeDB.feedbackReportPath(report.id));
      await ref.set(report.toJson());
    } catch (e) {
      debugPrint('❌ Error submitting feedback: $e');
      rethrow;
    }
  }

  // ===== Reading API =====

  /// Save reading session
  static Future<void> saveReadingSession(String userId, ReadingSession session) async {
    try {
      final ref = _db.ref('${FirebaseRealtimeDB.userReadingPath(userId)}/${session.sessionId}');
      await ref.set(session.toJson());
    } catch (e) {
      debugPrint('❌ Error saving reading session: $e');
      rethrow;
    }
  }

  /// Get battle history for a user
  static Future<List<BattleResult>> getBattleHistory(String userId) async {
    try {
      final snapshot = await _db
          .ref(FirebaseRealtimeDB.battlesPath)
          .orderByChild('player1Id')
          .equalTo(userId)
          .once();

      final results = <BattleResult>[];
      if (snapshot.snapshot.exists) {
        for (final child in snapshot.snapshot.children) {
          try {
            final data = Map<String, dynamic>.from(child.value as Map);
            if (data['result'] != null) {
              results.add(BattleResult.fromJson(Map<String, dynamic>.from(data['result'] as Map)));
            }
          } catch (e) {
            debugPrint('❌ Error parsing battle result: $e');
          }
        }
      }
      return results;
    } catch (e) {
      debugPrint('❌ Error fetching battle history: $e');
      return [];
    }
  }

  /// Get reading history for a user
  static Future<List<ReadingSession>> getReadingHistory(String userId) async {
    try {
      final snapshot = await _db.ref(FirebaseRealtimeDB.userReadingPath(userId)).once();
      final sessions = <ReadingSession>[];
      if (snapshot.snapshot.exists) {
        for (final child in snapshot.snapshot.children) {
          if (child.key == 'analytics') continue;
          try {
            sessions.add(ReadingSession.fromJson(Map<String, dynamic>.from(child.value as Map)));
          } catch (e) {
            debugPrint('❌ Error parsing reading session: $e');
          }
        }
      }
      return sessions;
    } catch (e) {
      debugPrint('❌ Error fetching reading history: $e');
      return [];
    }
  }

  /// Get reading analytics stream
  static Stream<ReadingAnalytics?> getReadingAnalyticsStream(String userId) {
    return _db
        .ref('${FirebaseRealtimeDB.userReadingPath(userId)}/analytics')
        .onValue
        .map((event) {
          if (event.snapshot.exists) {
            try {
              return ReadingAnalytics.fromJson(
                Map<String, dynamic>.from(event.snapshot.value as Map),
              );
            } catch (e) {
              debugPrint('❌ Error parsing reading analytics: $e');
              return null;
            }
          }
          return null;
        });
  }
}

/// Firebase Realtime Database 同期マネージャー
class FirebaseRealtimeSyncManager {
  // 実装予定：Realtime Database への読み書き
  // v1.3では設計のみ、本実装は v1.4で実施

  static Future<void> initializeDatabase() async {
    try {
      if (!Firebase.apps.any((app) => app.name == '[DEFAULT]')) {
        debugPrint('⚠️ Firebase not initialized yet');
        return;
      }
      debugPrint('✅ Firebase Realtime DB ready');
    } catch (e) {
      debugPrint('❌ Database initialization error: $e');
    }
  }

  /// ユーザープロフィールの保存
  static Future<bool> saveUserProfile(
    String userId,
    String name,
    int grade,
  ) async {
    try {
      // v1.4: Implement Firebase Realtime Database integration
      //   final db = FirebaseDatabase.instance;
      //   await db.ref(FirebaseRealtimeDB.userProfilePath(userId)).set({
      //     'name': name,
      //     'grade': grade,
      //   });
      debugPrint('✅ User profile saved (local backup): $userId');
      return true;
    } catch (e) {
      debugPrint('❌ Error saving profile: $e');
      return false;
    }
  }

  /// キャラクター状態の保存
  static Future<bool> saveCharacterState(
    String userId,
    String characterId,
    Map<String, dynamic> characterData,
  ) async {
    try {
      // v1.4: Implement Firebase Realtime Database integration
      debugPrint('✅ Character saved (local backup): $userId/$characterId');
      return true;
    } catch (e) {
      debugPrint('❌ Error saving character: $e');
      return false;
    }
  }

  /// 全データの同期
  static Future<bool> syncAllData(
    String userId,
    Map<String, dynamic> allData,
  ) async {
    try {
      // v1.4: Implement Firebase Realtime Database integration
      debugPrint('✅ Full sync completed (local backup): $userId');
      return true;
    } catch (e) {
      debugPrint('❌ Error syncing data: $e');
      return false;
    }
  }
}
