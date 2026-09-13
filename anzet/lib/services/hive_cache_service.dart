import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firestore_screentime_service.dart';

/// Hive を使用したオフラインキャッシング
class HiveCacheService {
  static late Box<Map> _screenTimeBox;
  static late Box<List> _pendingSyncBox;

  /// 初期化
  static Future<void> init() async {
    await Hive.initFlutter();

    // ScreenTime Config キャッシュ
    _screenTimeBox = await Hive.openBox<Map>(
      'screentime_cache',
      compactionStrategy: (entries, deletedEntries) => deletedEntries > 10,
    );

    // Pending Sync キュー
    _pendingSyncBox = await Hive.openBox<List>(
      'pending_sync_queue',
      compactionStrategy: (entries, deletedEntries) => deletedEntries > 10,
    );
  }

  /// ScreenTime設定をキャッシング
  static Future<void> cacheScreenTimeConfig(
    String key,
    ScreenTimeConfig config,
  ) async {
    try {
      await _screenTimeBox.put(key, config.toFirestore());
    } catch (e) {
      if (kDebugMode) print('Error caching ScreenTime config: $e');
    }
  }

  /// キャッシュされたScreenTime設定を取得
  static ScreenTimeConfig? getCachedScreenTimeConfig(String key) {
    try {
      final cached = _screenTimeBox.get(key);
      if (cached == null) return null;
      return ScreenTimeConfig.fromFirestore(cached.cast<String, dynamic>());
    } catch (e) {
      if (kDebugMode) print('Error retrieving cached ScreenTime config: $e');
      return null;
    }
  }

  /// Pending Sync操作を追加
  static Future<void> addPendingSync(PendingSyncOperation operation) async {
    try {
      final queue = _pendingSyncBox.get('queue', defaultValue: [])!.toList();
      queue.add(operation.toMap());
      await _pendingSyncBox.put('queue', queue);
    } catch (e) {
      if (kDebugMode) print('Error adding pending sync: $e');
    }
  }

  /// Pending Sync キューを取得
  static List<PendingSyncOperation> getPendingSyncQueue() {
    try {
      final queue = _pendingSyncBox.get('queue', defaultValue: [])!.toList();
      return queue
          .cast<Map<String, dynamic>>()
          .map((item) => PendingSyncOperation.fromMap(item))
          .toList();
    } catch (e) {
      if (kDebugMode) print('Error getting pending sync queue: $e');
      return [];
    }
  }

  /// Pending Sync 操作を完了（削除）
  static Future<void> removePendingSync(String operationId) async {
    try {
      final queue = _pendingSyncBox.get('queue', defaultValue: [])!.toList();
      queue.removeWhere((item) => (item as Map)['id'] == operationId);
      await _pendingSyncBox.put('queue', queue);
    } catch (e) {
      if (kDebugMode) print('Error removing pending sync: $e');
    }
  }

  /// キャッシュをクリア
  static Future<void> clearCache() async {
    try {
      await _screenTimeBox.clear();
      await _pendingSyncBox.clear();
    } catch (e) {
      if (kDebugMode) print('Error clearing cache: $e');
    }
  }

  /// キャッシュサイズを取得
  static int getCacheSize() {
    return _screenTimeBox.length + _pendingSyncBox.length;
  }

  /// 全キャッシュ情報を取得（デバッグ用）
  static Map<String, dynamic> getCacheDebugInfo() {
    return {
      'screentime_entries': _screenTimeBox.length,
      'pending_sync_count':
          (_pendingSyncBox.get('queue', defaultValue: []) as List).length,
      'last_updated': DateTime.now().toIso8601String(),
    };
  }
}

/// Pending Sync 操作
class PendingSyncOperation {
  final String id;
  final String operationType; // 'update' | 'record_history'
  final String childId;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final int retryCount;

  PendingSyncOperation({
    required this.id,
    required this.operationType,
    required this.childId,
    required this.data,
    DateTime? createdAt,
    this.retryCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'operationType': operationType,
      'childId': childId,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
    };
  }

  factory PendingSyncOperation.fromMap(Map<String, dynamic> map) {
    return PendingSyncOperation(
      id: map['id'],
      operationType: map['operationType'],
      childId: map['childId'],
      data: map['data'],
      createdAt: DateTime.parse(map['createdAt']),
      retryCount: map['retryCount'] ?? 0,
    );
  }

  PendingSyncOperation copyWith({
    int? retryCount,
  }) {
    return PendingSyncOperation(
      id: id,
      operationType: operationType,
      childId: childId,
      data: data,
      createdAt: createdAt,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}
