import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// ScreenTime設定のFirestore同期サービス
class FirestoreScreenTimeService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ScreenTime設定を取得
  static Future<ScreenTimeConfig?> getScreenTimeConfig(
    String childId,
  ) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      final docSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('children')
          .doc(childId)
          .collection('screen_time_config')
          .doc('config')
          .get();

      if (!docSnapshot.exists) return null;

      return ScreenTimeConfig.fromFirestore(docSnapshot.data()!);
    } catch (e) {
      if (kDebugMode) print('Error getting ScreenTime config: $e');
      return null;
    }
  }

  /// ScreenTime設定を更新
  static Future<bool> updateScreenTimeConfig(
    String childId,
    ScreenTimeConfig config,
  ) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('children')
          .doc(childId)
          .collection('screen_time_config')
          .doc('config')
          .set(
            config.toFirestore(),
            SetOptions(merge: true),
          );

      return true;
    } catch (e) {
      if (kDebugMode) print('Error updating ScreenTime config: $e');
      return false;
    }
  }

  /// リアルタイム更新をリッスン
  static Stream<ScreenTimeConfig?> subscribeToScreenTimeUpdates(
    String childId,
  ) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value(null);
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('children')
        .doc(childId)
        .collection('screen_time_config')
        .doc('config')
        .snapshots()
        .map((docSnapshot) {
      if (!docSnapshot.exists) return null;
      return ScreenTimeConfig.fromFirestore(docSnapshot.data()!);
    }).handleError((error) {
      if (kDebugMode) print('Error listening to ScreenTime updates: $error');
      return null;
    });
  }

  /// 使用時間の履歴を保存
  static Future<bool> recordUsageHistory(
    String childId,
    ScreenTimeHistoryEntry entry,
  ) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final today = DateTime.now();
      final dateStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('children')
          .doc(childId)
          .collection('screen_time_history')
          .doc(dateStr)
          .set({
        'date': dateStr,
        'entries': FieldValue.arrayUnion([entry.toMap()])
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      if (kDebugMode) print('Error recording usage history: $e');
      return false;
    }
  }

  /// Conflict 解決（最終更新時刻ベース）
  static ScreenTimeConfig resolveConflict(
    ScreenTimeConfig local,
    ScreenTimeConfig remote,
  ) {
    // remoteの方が新しい場合
    if (remote.lastUpdated.isAfter(local.lastUpdated)) {
      return remote;
    }
    // localの方が新しい場合
    else if (local.lastUpdated.isAfter(remote.lastUpdated)) {
      return local;
    }
    // 同一時刻の場合は deviceId の辞書順
    else {
      final localDeviceId = local.updatedByDeviceId;
      final remoteDeviceId = remote.updatedByDeviceId;
      return remoteDeviceId.compareTo(localDeviceId) > 0 ? remote : local;
    }
  }
}

/// ScreenTime設定モデル
class ScreenTimeConfig {
  final int dailyLimitMinutes;
  final int usedTodayMinutes;
  final DateTime lastResetTime;
  final bool isLimitExceeded;
  final int updateVersion;
  final DateTime lastUpdated;
  final String updatedByDeviceId;
  final DateTime? lastSyncTime;
  final String syncStatus; // 'synced' | 'pending' | 'error'

  ScreenTimeConfig({
    required this.dailyLimitMinutes,
    required this.usedTodayMinutes,
    required this.lastResetTime,
    required this.isLimitExceeded,
    this.updateVersion = 1,
    DateTime? lastUpdated,
    String? updatedByDeviceId,
    this.lastSyncTime,
    this.syncStatus = 'synced',
  })  : lastUpdated = lastUpdated ?? DateTime.now(),
        updatedByDeviceId = updatedByDeviceId ?? _generateDeviceId();

  /// Firestore ドキュメントから生成
  factory ScreenTimeConfig.fromFirestore(Map<String, dynamic> data) {
    return ScreenTimeConfig(
      dailyLimitMinutes: data['dailyLimitMinutes'] ?? 120,
      usedTodayMinutes: data['usedTodayMinutes'] ?? 0,
      lastResetTime: (data['lastResetTime'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      isLimitExceeded: data['isLimitExceeded'] ?? false,
      updateVersion: data['update_version'] ?? 1,
      lastUpdated:
          (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedByDeviceId: data['updatedByDeviceId'] ?? _generateDeviceId(),
      lastSyncTime: (data['lastSyncTime'] as Timestamp?)?.toDate(),
      syncStatus: data['syncStatus'] ?? 'synced',
    );
  }

  /// Firestore ドキュメント形式に変換
  Map<String, dynamic> toFirestore() {
    return {
      'dailyLimitMinutes': dailyLimitMinutes,
      'usedTodayMinutes': usedTodayMinutes,
      'lastResetTime': Timestamp.fromDate(lastResetTime),
      'isLimitExceeded': isLimitExceeded,
      'update_version': updateVersion + 1,
      'lastUpdated': Timestamp.fromDate(DateTime.now()),
      'updatedByDeviceId': updatedByDeviceId,
      'lastSyncTime': lastSyncTime != null ? Timestamp.fromDate(lastSyncTime!) : null,
      'syncStatus': syncStatus,
    };
  }

  /// コピーコンストラクタ
  ScreenTimeConfig copyWith({
    int? dailyLimitMinutes,
    int? usedTodayMinutes,
    DateTime? lastResetTime,
    bool? isLimitExceeded,
    int? updateVersion,
    DateTime? lastUpdated,
    String? updatedByDeviceId,
    DateTime? lastSyncTime,
    String? syncStatus,
  }) {
    return ScreenTimeConfig(
      dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
      usedTodayMinutes: usedTodayMinutes ?? this.usedTodayMinutes,
      lastResetTime: lastResetTime ?? this.lastResetTime,
      isLimitExceeded: isLimitExceeded ?? this.isLimitExceeded,
      updateVersion: updateVersion ?? this.updateVersion,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      updatedByDeviceId: updatedByDeviceId ?? this.updatedByDeviceId,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  static String _generateDeviceId() {
    // TODO: 実装 - UniqueIdentifier を使用
    return 'device-${DateTime.now().millisecondsSinceEpoch}';
  }
}

/// ScreenTime 使用履歴エントリ
class ScreenTimeHistoryEntry {
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final String? appName;

  ScreenTimeHistoryEntry({
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    this.appName,
  });

  Map<String, dynamic> toMap() {
    return {
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'durationMinutes': durationMinutes,
      'appName': appName,
    };
  }
}
