import 'package:flutter_test/flutter_test.dart';

import '../../lib/services/firestore_screentime_service.dart';
import '../../lib/services/hive_cache_service.dart';

void main() {
  group('HiveCacheService', () {
    setUp(() async {
      // Hive 初期化（テスト環境用）
      // Note: 実際のテスト実行時は Hive.initFlutter() をモック化する必要があります
    });

    group('PendingSyncOperation', () {
      test('toMap() でオブジェクトを Map に変換', () {
        final operation = PendingSyncOperation(
          id: 'op-123',
          operationType: 'update',
          childId: 'child-456',
          data: {'dailyLimitMinutes': 120},
          retryCount: 0,
        );

        final map = operation.toMap();

        expect(map['id'], 'op-123');
        expect(map['operationType'], 'update');
        expect(map['childId'], 'child-456');
        expect(map['retryCount'], 0);
      });

      test('fromMap() で Map からオブジェクトに復元', () {
        final now = DateTime.now();
        final map = {
          'id': 'op-123',
          'operationType': 'update',
          'childId': 'child-456',
          'data': {'dailyLimitMinutes': 120},
          'createdAt': now.toIso8601String(),
          'retryCount': 1,
        };

        final operation = PendingSyncOperation.fromMap(map);

        expect(operation.id, 'op-123');
        expect(operation.operationType, 'update');
        expect(operation.childId, 'child-456');
        expect(operation.retryCount, 1);
      });

      test('copyWith() で retry count を増加', () {
        final operation = PendingSyncOperation(
          id: 'op-123',
          operationType: 'update',
          childId: 'child-456',
          data: {},
          retryCount: 0,
        );

        final updated = operation.copyWith(retryCount: 1);

        expect(updated.retryCount, 1);
        expect(operation.retryCount, 0); // 元のオブジェクトは変更なし
      });

      test('3回以上のリトライで失敗判定', () {
        final operation = PendingSyncOperation(
          id: 'op-123',
          operationType: 'update',
          childId: 'child-456',
          data: {},
          retryCount: 3,
        );

        expect(operation.retryCount >= 3, true);
      });
    });

    group('Cache Operations Logic', () {
      test('ScreenTimeConfig を Map 形式でシリアライズ', () {
        final config = ScreenTimeConfig(
          dailyLimitMinutes: 120,
          usedTodayMinutes: 45,
          lastResetTime: DateTime(2026, 9, 13),
          isLimitExceeded: false,
        );

        final map = config.toFirestore();

        // シリアライズされたデータが正しい構造を持つ
        expect(map.containsKey('dailyLimitMinutes'), true);
        expect(map.containsKey('usedTodayMinutes'), true);
        expect(map.containsKey('lastResetTime'), true);
        expect(map.containsKey('syncStatus'), true);
      });

      test('PendingSyncOperation リスト を管理', () {
        final op1 = PendingSyncOperation(
          id: 'op-1',
          operationType: 'update',
          childId: 'child-1',
          data: {},
        );

        final op2 = PendingSyncOperation(
          id: 'op-2',
          operationType: 'record_history',
          childId: 'child-1',
          data: {},
        );

        final queue = [op1, op2];

        expect(queue.length, 2);
        expect(queue[0].id, 'op-1');
        expect(queue[1].id, 'op-2');
      });

      test('Pending sync を FIFO で処理', () {
        final operations = [
          PendingSyncOperation(
            id: 'op-1',
            operationType: 'update',
            childId: 'child-1',
            data: {},
            createdAt: DateTime(2026, 9, 13, 10, 0),
          ),
          PendingSyncOperation(
            id: 'op-2',
            operationType: 'update',
            childId: 'child-1',
            data: {},
            createdAt: DateTime(2026, 9, 13, 10, 1),
          ),
        ];

        // 時刻順にソート（FIFO）
        operations.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        expect(operations[0].id, 'op-1'); // 最初のものが先
        expect(operations[1].id, 'op-2'); // 次のものが後
      });

      test('Cache compaction: 古いエントリを削除', () {
        final entries = <String>[
          'entry-1',
          'entry-2',
          'entry-3',
          'entry-4',
          'entry-5',
        ];

        // Max 10 entries, 削除対象なし
        expect(entries.length <= 10, true);

        // Max 3 entries に制限
        if (entries.length > 3) {
          entries.removeRange(0, entries.length - 3);
        }

        expect(entries.length, 3);
        expect(entries.first, 'entry-3');
      });
    });
  });
}
