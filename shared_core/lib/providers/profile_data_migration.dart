import 'package:shared_preferences/shared_preferences.dart';

/// ProfileDataMigration: profile-scoped key 生成と migration ロジック
class ProfileDataMigration {
  /// プロフィール ID をプレフィックスとしたローカルストレージキーを生成
  static String generateProfileKey(String profileId, String key) {
    return 'profile_${profileId}_$key';
  }

  /// 旧形式のデータ（プロフィール非対応）を新形式に migration
  static Future<void> migrateProfileData(
    String profileId, {
    required List<String> keysToCopy,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    for (final key in keysToCopy) {
      final oldValue = prefs.get(key);
      if (oldValue != null) {
        final newKey = generateProfileKey(profileId, key);
        // 旧データを新キーにコピー
        if (oldValue is String) {
          await prefs.setString(newKey, oldValue);
        } else if (oldValue is int) {
          await prefs.setInt(newKey, oldValue);
        } else if (oldValue is double) {
          await prefs.setDouble(newKey, oldValue);
        } else if (oldValue is bool) {
          await prefs.setBool(newKey, oldValue);
        } else if (oldValue is List<String>) {
          await prefs.setStringList(newKey, oldValue);
        }
        // 旧キーは削除しない（後方互換性のため）
      }
    }
  }

  /// プロフィール ID をキーとして保存
  static Future<void> setCurrentProfileId(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_profile_id', profileId);
  }

  /// 現在のプロフィール ID を取得
  static Future<String> getCurrentProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('current_profile_id') ?? 'default_profile_id';
  }
}
