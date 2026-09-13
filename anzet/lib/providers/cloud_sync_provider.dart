import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../services/firestore_screentime_service.dart';
import '../services/hive_cache_service.dart';

/// 同期ステータス
enum SyncStatus { synced, pending, error, offline }

/// Cloud Sync 状態
class CloudSyncState {
  final SyncStatus status;
  final DateTime? lastSyncTime;
  final String? errorMessage;
  final int pendingSyncCount;
  final bool isOffline;

  CloudSyncState({
    this.status = SyncStatus.synced,
    this.lastSyncTime,
    this.errorMessage,
    this.pendingSyncCount = 0,
    this.isOffline = false,
  });

  CloudSyncState copyWith({
    SyncStatus? status,
    DateTime? lastSyncTime,
    String? errorMessage,
    int? pendingSyncCount,
    bool? isOffline,
  }) {
    return CloudSyncState(
      status: status ?? this.status,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      errorMessage: errorMessage,
      pendingSyncCount: pendingSyncCount ?? this.pendingSyncCount,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

/// Cloud Sync Provider
final cloudSyncProvider =
    StateNotifierProvider<CloudSyncNotifier, CloudSyncState>((ref) {
  return CloudSyncNotifier();
});

/// Cloud Sync 状態管理
class CloudSyncNotifier extends StateNotifier<CloudSyncState> {
  CloudSyncNotifier() : super(CloudSyncState());

  /// ScreenTime設定をファッチしてキャッシング
  Future<ScreenTimeConfig?> fetchAndCacheScreenTimeConfig(
    String childId,
  ) async {
    try {
      // Firestore から取得を試みる
      final remoteConfig =
          await FirestoreScreenTimeService.getScreenTimeConfig(childId);

      if (remoteConfig != null) {
        // キャッシングして status を更新
        await HiveCacheService.cacheScreenTimeConfig(childId, remoteConfig);
        state = state.copyWith(
          status: SyncStatus.synced,
          lastSyncTime: DateTime.now(),
          errorMessage: null,
        );
        return remoteConfig;
      }
    } catch (e) {
      state = state.copyWith(
        status: SyncStatus.error,
        errorMessage: e.toString(),
      );
    }

    // フォールバック: ローカルキャッシュから取得
    final cachedConfig =
        HiveCacheService.getCachedScreenTimeConfig(childId);
    if (cachedConfig != null) {
      state = state.copyWith(
        status: SyncStatus.offline,
        isOffline: true,
      );
      return cachedConfig;
    }

    return null;
  }

  /// ScreenTime設定を更新してSync
  Future<bool> updateAndSyncScreenTimeConfig(
    String childId,
    ScreenTimeConfig config,
  ) async {
    try {
      // ローカルキャッシング
      await HiveCacheService.cacheScreenTimeConfig(childId, config);

      // Firestore への非同期 push
      state = state.copyWith(status: SyncStatus.pending);

      final success =
          await FirestoreScreenTimeService.updateScreenTimeConfig(
        childId,
        config,
      );

      if (success) {
        state = state.copyWith(
          status: SyncStatus.synced,
          lastSyncTime: DateTime.now(),
          errorMessage: null,
        );
        return true;
      } else {
        // 失敗時は pending queue に追加
        await _addToPendingQueue(
          childId,
          'update',
          config.toFirestore(),
        );
        state = state.copyWith(
          status: SyncStatus.pending,
          pendingSyncCount: HiveCacheService.getPendingSyncQueue().length,
        );
        return false;
      }
    } catch (e) {
      // 失敗時は pending queue に追加
      await _addToPendingQueue(
        childId,
        'update',
        config.toFirestore(),
      );
      state = state.copyWith(
        status: SyncStatus.error,
        errorMessage: e.toString(),
        pendingSyncCount: HiveCacheService.getPendingSyncQueue().length,
      );
      return false;
    }
  }

  /// Pending Sync キューから全て実行
  Future<void> syncPendingOperations() async {
    final queue = HiveCacheService.getPendingSyncQueue();
    if (queue.isEmpty) return;

    state = state.copyWith(status: SyncStatus.pending);

    int successCount = 0;
    for (final operation in queue) {
      try {
        if (operation.operationType == 'update') {
          final config = ScreenTimeConfig.fromFirestore(
            operation.data.cast<String, dynamic>(),
          );
          final success =
              await FirestoreScreenTimeService.updateScreenTimeConfig(
            operation.childId,
            config,
          );

          if (success) {
            await HiveCacheService.removePendingSync(operation.id);
            successCount++;
          }
        }
      } catch (e) {
        if (kDebugMode) print('Error syncing operation ${operation.id}: $e');
        // Retry count を増やして続行
        final updatedOp = operation.copyWith(
          retryCount: operation.retryCount + 1,
        );
        await HiveCacheService.addPendingSync(updatedOp);
      }
    }

    final remaining = HiveCacheService.getPendingSyncQueue().length;
    if (remaining == 0) {
      state = state.copyWith(
        status: SyncStatus.synced,
        lastSyncTime: DateTime.now(),
        errorMessage: null,
        pendingSyncCount: 0,
      );
    } else {
      state = state.copyWith(
        status: SyncStatus.pending,
        pendingSyncCount: remaining,
      );
    }
  }

  /// Pending queue に操作を追加
  Future<void> _addToPendingQueue(
    String childId,
    String operationType,
    Map<String, dynamic> data,
  ) async {
    const uuid = Uuid();
    final operation = PendingSyncOperation(
      id: uuid.v4(),
      operationType: operationType,
      childId: childId,
      data: data,
    );
    await HiveCacheService.addPendingSync(operation);
  }

  /// オフライン状態を設定
  void setOfflineMode(bool isOffline) {
    state = state.copyWith(
      isOffline: isOffline,
      status: isOffline ? SyncStatus.offline : SyncStatus.synced,
    );
  }

  /// エラーをクリア
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// 同期ステータス Provider（計算型）
final syncStatusProvider = Provider<SyncStatus>((ref) {
  return ref.watch(cloudSyncProvider).status;
});

/// 最終同期時刻 Provider（計算型）
final lastSyncTimeProvider = Provider<DateTime?>((ref) {
  return ref.watch(cloudSyncProvider).lastSyncTime;
});

/// Pending Sync 数 Provider（計算型）
final pendingSyncCountProvider = Provider<int>((ref) {
  return ref.watch(cloudSyncProvider).pendingSyncCount;
});

/// オフラインフラグ Provider（計算型）
final isOfflineProvider = Provider<bool>((ref) {
  return ref.watch(cloudSyncProvider).isOffline;
});
