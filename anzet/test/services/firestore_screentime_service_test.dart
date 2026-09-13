import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../lib/services/firestore_screentime_service.dart';

void main() {
  group('FirestoreScreenTimeService', () {

    group('ScreenTimeConfig', () {
      test('toFirestore() は正しい Map を返す', () {
        final config = ScreenTimeConfig(
          dailyLimitMinutes: 120,
          usedTodayMinutes: 45,
          lastResetTime: DateTime(2026, 9, 13),
          isLimitExceeded: false,
        );

        final firestore = config.toFirestore();

        expect(firestore['dailyLimitMinutes'], 120);
        expect(firestore['usedTodayMinutes'], 45);
        expect(firestore['isLimitExceeded'], false);
        expect(firestore['update_version'], 2); // version increment
      });

      test('fromFirestore() で Firestore ドキュメントから復元', () {
        final data = {
          'dailyLimitMinutes': 120,
          'usedTodayMinutes': 45,
          'lastResetTime': Timestamp.now(),
          'isLimitExceeded': false,
          'update_version': 1,
        };

        final config = ScreenTimeConfig.fromFirestore(data);

        expect(config.dailyLimitMinutes, 120);
        expect(config.usedTodayMinutes, 45);
        expect(config.isLimitExceeded, false);
      });

      test('copyWith() で部分更新', () {
        final config1 = ScreenTimeConfig(
          dailyLimitMinutes: 120,
          usedTodayMinutes: 45,
          lastResetTime: DateTime(2026, 9, 13),
          isLimitExceeded: false,
        );

        final config2 = config1.copyWith(
          usedTodayMinutes: 90,
          isLimitExceeded: true,
        );

        expect(config2.dailyLimitMinutes, 120); // 変更なし
        expect(config2.usedTodayMinutes, 90); // 変更
        expect(config2.isLimitExceeded, true); // 変更
      });
    });

    group('resolveConflict', () {
      test('remote が新しい場合は remote を採用', () {
        final localTime = DateTime(2026, 9, 13, 10, 0);
        final remoteTime = DateTime(2026, 9, 13, 10, 5); // 5分新しい

        final local = ScreenTimeConfig(
          dailyLimitMinutes: 120,
          usedTodayMinutes: 30,
          lastResetTime: DateTime(2026, 9, 13),
          isLimitExceeded: false,
          lastUpdated: localTime,
        );

        final remote = ScreenTimeConfig(
          dailyLimitMinutes: 180,
          usedTodayMinutes: 60,
          lastResetTime: DateTime(2026, 9, 13),
          isLimitExceeded: true,
          lastUpdated: remoteTime,
        );

        final merged = FirestoreScreenTimeService.resolveConflict(local, remote);

        expect(merged.dailyLimitMinutes, 180); // remote の値
        expect(merged.usedTodayMinutes, 60); // remote の値
        expect(merged.isLimitExceeded, true); // remote の値
      });

      test('local が新しい場合は local を採用', () {
        final localTime = DateTime(2026, 9, 13, 10, 5); // 新しい
        final remoteTime = DateTime(2026, 9, 13, 10, 0);

        final local = ScreenTimeConfig(
          dailyLimitMinutes: 120,
          usedTodayMinutes: 30,
          lastResetTime: DateTime(2026, 9, 13),
          isLimitExceeded: false,
          lastUpdated: localTime,
        );

        final remote = ScreenTimeConfig(
          dailyLimitMinutes: 180,
          usedTodayMinutes: 60,
          lastResetTime: DateTime(2026, 9, 13),
          isLimitExceeded: true,
          lastUpdated: remoteTime,
        );

        final merged = FirestoreScreenTimeService.resolveConflict(local, remote);

        expect(merged.dailyLimitMinutes, 120); // local の値
        expect(merged.usedTodayMinutes, 30); // local の値
        expect(merged.isLimitExceeded, false); // local の値
      });

      test('同一時刻の場合は deviceId で決定', () {
        final sameTime = DateTime(2026, 9, 13, 10, 0);

        final local = ScreenTimeConfig(
          dailyLimitMinutes: 120,
          usedTodayMinutes: 30,
          lastResetTime: DateTime(2026, 9, 13),
          isLimitExceeded: false,
          lastUpdated: sameTime,
          updatedByDeviceId: 'device-aaa',
        );

        final remote = ScreenTimeConfig(
          dailyLimitMinutes: 180,
          usedTodayMinutes: 60,
          lastResetTime: DateTime(2026, 9, 13),
          isLimitExceeded: true,
          lastUpdated: sameTime,
          updatedByDeviceId: 'device-zzz',
        );

        final merged = FirestoreScreenTimeService.resolveConflict(local, remote);

        // device-zzz > device-aaa なので remote を採用
        expect(merged.dailyLimitMinutes, 180);
        expect(merged.usedTodayMinutes, 60);
      });
    });

    group('ScreenTimeHistoryEntry', () {
      test('toMap() でオブジェクトを Map に変換', () {
        final entry = ScreenTimeHistoryEntry(
          startTime: DateTime(2026, 9, 13, 10, 0),
          endTime: DateTime(2026, 9, 13, 10, 30),
          durationMinutes: 30,
          appName: 'YouTube',
        );

        final map = entry.toMap();

        expect(map['durationMinutes'], 30);
        expect(map['appName'], 'YouTube');
        expect(map.containsKey('startTime'), true);
        expect(map.containsKey('endTime'), true);
      });
    });
  });
}
