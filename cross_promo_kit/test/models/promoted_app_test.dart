import 'package:flutter_test/flutter_test.dart';
import 'package:cross_promo_kit/models/promoted_app.dart';

void main() {
  group('PromotedApp', () {
    test('fromJson parses all fields', () {
      final app = PromotedApp.fromJson(const {
        'id': 'com.example.kokugo',
        'name': '国語コレ！',
        'tagline': '読解力を毎日ちょっとずつ',
        'iconUrl': 'https://example.com/icon.png',
        'storeUrl': 'https://play.google.com/store/apps/details?id=com.example.kokugo',
        'category': '小学コレ',
      });

      expect(app.id, 'com.example.kokugo');
      expect(app.name, '国語コレ！');
      expect(app.tagline, '読解力を毎日ちょっとずつ');
      expect(app.iconUrl, 'https://example.com/icon.png');
      expect(app.storeUrl, 'https://play.google.com/store/apps/details?id=com.example.kokugo');
      expect(app.category, '小学コレ');
    });

    test('fromJson defaults missing fields to empty string', () {
      final app = PromotedApp.fromJson(const {'id': 'x'});

      expect(app.id, 'x');
      expect(app.name, '');
      expect(app.tagline, '');
      expect(app.iconUrl, '');
      expect(app.storeUrl, '');
      expect(app.category, '');
    });

    test('toJson round-trips through fromJson', () {
      const original = PromotedApp(
        id: 'com.example.sansu',
        name: '算数コレ！',
        tagline: '算数を楽しく',
        iconUrl: 'https://example.com/sansu.png',
        storeUrl: 'https://play.google.com/store/apps/details?id=com.example.sansu',
        category: '小学コレ',
      );

      final roundTripped = PromotedApp.fromJson(original.toJson());

      expect(roundTripped.id, original.id);
      expect(roundTripped.name, original.name);
      expect(roundTripped.tagline, original.tagline);
      expect(roundTripped.iconUrl, original.iconUrl);
      expect(roundTripped.storeUrl, original.storeUrl);
      expect(roundTripped.category, original.category);
    });
  });
}
