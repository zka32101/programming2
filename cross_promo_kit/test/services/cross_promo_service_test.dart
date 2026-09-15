import 'package:flutter_test/flutter_test.dart';
import 'package:cross_promo_kit/services/cross_promo_service.dart';

const _portfolio = '''
[
  {"id": "com.example.sansu", "name": "算数コレ！", "tagline": "t", "iconUrl": "i",
   "storeUrl": "https://play.google.com/store/apps/details?id=com.example.sansu", "category": "小学コレ"},
  {"id": "com.example.kokugo", "name": "国語コレ！", "tagline": "t", "iconUrl": "i",
   "storeUrl": "https://play.google.com/store/apps/details?id=com.example.kokugo", "category": "小学コレ"},
  {"id": "com.example.defense", "name": "日本領土ディフェンス", "tagline": "t", "iconUrl": "i",
   "storeUrl": "https://play.google.com/store/apps/details?id=com.example.defense", "category": "パズル・ゲーム"}
]
''';

void main() {
  group('CrossPromoService.parseApps', () {
    test('without currentCategory, returns all apps except self', () {
      final apps = CrossPromoService.parseApps(_portfolio, currentAppId: 'com.example.sansu');

      expect(apps.length, 2);
      expect(apps.map((a) => a.id), containsAll(['com.example.kokugo', 'com.example.defense']));
    });

    test('with currentCategory, only same-category apps are returned (similar apps)', () {
      final apps = CrossPromoService.parseApps(
        _portfolio,
        currentAppId: 'com.example.sansu',
        currentCategory: '小学コレ',
      );

      expect(apps.length, 1);
      expect(apps.single.id, 'com.example.kokugo');
    });

    test('empty currentCategory behaves like no category filter', () {
      final apps = CrossPromoService.parseApps(
        _portfolio,
        currentAppId: 'com.example.sansu',
        currentCategory: '',
      );

      expect(apps.length, 2);
    });

    test('a category with no other matching apps returns empty', () {
      final apps = CrossPromoService.parseApps(
        _portfolio,
        currentAppId: 'com.example.defense',
        currentCategory: 'パズル・ゲーム',
      );

      expect(apps, isEmpty);
    });

    test('strips a .debug applicationIdSuffix before self-exclusion', () {
      final apps = CrossPromoService.parseApps(
        _portfolio,
        currentAppId: 'com.example.sansu.debug',
      );

      expect(apps.any((a) => a.id == 'com.example.sansu'), isFalse);
      expect(apps.length, 2);
    });

    test('strips a .dev applicationIdSuffix before self-exclusion', () {
      final apps = CrossPromoService.parseApps(
        _portfolio,
        currentAppId: 'com.example.sansu.dev',
      );

      expect(apps.any((a) => a.id == 'com.example.sansu'), isFalse);
    });

    test('excludes the current app by id regardless of category filter', () {
      final apps = CrossPromoService.parseApps(
        _portfolio,
        currentAppId: 'com.example.sansu',
        currentCategory: '小学コレ',
      );

      expect(apps.any((a) => a.id == 'com.example.sansu'), isFalse);
    });

    test('filters out entries with no storeUrl', () {
      const raw = '''
      [
        {"id": "com.example.a", "name": "A", "tagline": "t", "iconUrl": "i", "storeUrl": ""},
        {"id": "com.example.b", "name": "B", "tagline": "t", "iconUrl": "i", "storeUrl": "https://play.google.com/store/apps/details?id=com.example.b"}
      ]
      ''';

      final apps = CrossPromoService.parseApps(raw, currentAppId: 'com.example.sansu');

      expect(apps.length, 1);
      expect(apps.single.id, 'com.example.b');
    });

    test('returns empty list for empty array', () {
      final apps = CrossPromoService.parseApps('[]', currentAppId: 'com.example.sansu');
      expect(apps, isEmpty);
    });

    test('returns empty list for malformed JSON instead of throwing', () {
      final apps = CrossPromoService.parseApps('not json', currentAppId: 'com.example.sansu');
      expect(apps, isEmpty);
    });

    test('returns empty list when JSON is an object instead of an array', () {
      final apps = CrossPromoService.parseApps('{"id":"x"}', currentAppId: 'com.example.sansu');
      expect(apps, isEmpty);
    });
  });
}
