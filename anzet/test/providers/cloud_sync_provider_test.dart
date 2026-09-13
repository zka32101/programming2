import 'package:flutter_test/flutter_test.dart';

import '../../lib/providers/cloud_sync_provider.dart';

void main() {
  group('CloudSyncState', () {
    test('初期状態は synced', () {
      final state = CloudSyncState();

      expect(state.status, SyncStatus.synced);
      expect(state.lastSyncTime, isNull);
      expect(state.errorMessage, isNull);
      expect(state.pendingSyncCount, 0);
      expect(state.isOffline, false);
    });

    test('copyWith() で部分更新', () {
      final state1 = CloudSyncState(
        status: SyncStatus.synced,
        pendingSyncCount: 0,
      );

      final state2 = state1.copyWith(
        status: SyncStatus.pending,
        pendingSyncCount: 2,
      );

      expect(state2.status, SyncStatus.pending);
      expect(state2.pendingSyncCount, 2);
      expect(state1.status, SyncStatus.synced); // 元のオブジェクトは変更なし
    });

    test('オフラインモード: status は offline', () {
      final state = CloudSyncState(
        status: SyncStatus.offline,
        isOffline: true,
      );

      expect(state.isOffline, true);
      expect(state.status, SyncStatus.offline);
    });

    test('エラーモード: errorMessage を保持', () {
      final errorMsg = 'Network error: Connection timeout';
      final state = CloudSyncState(
        status: SyncStatus.error,
        errorMessage: errorMsg,
      );

      expect(state.status, SyncStatus.error);
      expect(state.errorMessage, errorMsg);
    });
  });

  group('SyncStatus Enum', () {
    test('4 つのステータスが定義されている', () {
      expect(SyncStatus.synced, isNotNull);
      expect(SyncStatus.pending, isNotNull);
      expect(SyncStatus.error, isNotNull);
      expect(SyncStatus.offline, isNotNull);
    });

    test('ステータス遷移: synced → pending → synced', () {
      var currentStatus = SyncStatus.synced;

      expect(currentStatus, SyncStatus.synced);

      currentStatus = SyncStatus.pending;
      expect(currentStatus, SyncStatus.pending);

      currentStatus = SyncStatus.synced;
      expect(currentStatus, SyncStatus.synced);
    });

    test('エラーからの回復: error → offline → synced', () {
      var currentStatus = SyncStatus.error;

      expect(currentStatus, SyncStatus.error);

      currentStatus = SyncStatus.offline;
      expect(currentStatus, SyncStatus.offline);

      currentStatus = SyncStatus.synced;
      expect(currentStatus, SyncStatus.synced);
    });
  });

  group('Sync State Transitions', () {
    test('Pending sync count が 0 の場合は synced', () {
      final state = CloudSyncState(
        status: SyncStatus.synced,
        pendingSyncCount: 0,
      );

      expect(state.pendingSyncCount == 0, true);
      expect(state.status, SyncStatus.synced);
    });

    test('Pending sync count > 0 の場合は pending', () {
      final state = CloudSyncState(
        status: SyncStatus.pending,
        pendingSyncCount: 3,
      );

      expect(state.pendingSyncCount > 0, true);
      expect(state.status, SyncStatus.pending);
    });

    test('最終同期時刻の更新', () {
      final now = DateTime.now();
      final state = CloudSyncState(
        status: SyncStatus.synced,
        lastSyncTime: now,
      );

      expect(state.lastSyncTime, isNotNull);
      expect(state.lastSyncTime!.isAfter(now.subtract(Duration(seconds: 1))), true);
    });
  });

  group('Offline Mode', () {
    test('オフラインから online へ復帰', () {
      var state = CloudSyncState(
        status: SyncStatus.offline,
        isOffline: true,
        pendingSyncCount: 2,
      );

      expect(state.isOffline, true);

      state = state.copyWith(
        status: SyncStatus.pending,
        isOffline: false,
      );

      expect(state.isOffline, false);
      expect(state.status, SyncStatus.pending);
      expect(state.pendingSyncCount, 2); // Pending が残っている
    });

    test('Offline 時の pending sync queue 保持', () {
      final state = CloudSyncState(
        status: SyncStatus.offline,
        isOffline: true,
        pendingSyncCount: 5,
      );

      expect(state.pendingSyncCount, 5); // Offline でも pending queue は保持
      expect(state.isOffline, true);
    });
  });

  group('Error Handling', () {
    test('エラーメッセージの設定と解除', () {
      var state = CloudSyncState(
        status: SyncStatus.error,
        errorMessage: 'Firebase connection failed',
      );

      expect(state.errorMessage, isNotNull);
      expect(state.errorMessage!.isNotEmpty, true);

      // エラークリア
      state = state.copyWith(
        status: SyncStatus.synced,
        errorMessage: null,
      );

      expect(state.errorMessage, isNull);
      expect(state.status, SyncStatus.synced);
    });

    test('複数エラーの処理: 最新のエラーメッセージのみ保持', () {
      var state = CloudSyncState(
        status: SyncStatus.error,
        errorMessage: 'Error 1',
      );

      state = state.copyWith(errorMessage: 'Error 2');

      expect(state.errorMessage, 'Error 2'); // 最新のエラーのみ
    });
  });
}
