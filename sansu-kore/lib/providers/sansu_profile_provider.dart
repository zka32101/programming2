import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'firestore_provider.dart';

const _favoriteItemKey = 'sansu_favorite_item';
const _characterLevelsKey = 'sansu_character_levels';

/// 算数コレ独自のプロフィール拡張（主人公文章題で使用）
class SansuProfileState {
  /// 文章題に登場する好きなもの（例: りんご、ケーキ、チョコ）
  final String favoriteItem;

  /// キャラクターID → レベル (1-5) のマップ
  final Map<String, int> characterLevels;

  const SansuProfileState({
    this.favoriteItem = 'りんご',
    this.characterLevels = const {},
  });

  SansuProfileState copyWith({
    String? favoriteItem,
    Map<String, int>? characterLevels,
  }) =>
      SansuProfileState(
        favoriteItem: favoriteItem ?? this.favoriteItem,
        characterLevels: characterLevels ?? this.characterLevels,
      );

  /// キャラクターのレベルを取得（デフォルト: Lv.1）
  int getCharacterLevel(String characterId) =>
      characterLevels[characterId] ?? 1;
}

class SansuProfileNotifier extends Notifier<SansuProfileState> {
  @override
  SansuProfileState build() {
    _load();
    return const SansuProfileState();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final item = prefs.getString(_favoriteItemKey) ?? 'りんご';

      // キャラクターレベルの読み込み
      Map<String, int> characterLevels = {};
      final levelsJson = prefs.getString(_characterLevelsKey);
      if (levelsJson != null) {
        try {
          final decoded = jsonDecode(levelsJson) as Map<String, dynamic>;
          characterLevels = decoded.cast<String, int>();
        } catch (e) {
          print('Error decoding character levels: $e');
        }
      }

      state = SansuProfileState(
        favoriteItem: item,
        characterLevels: characterLevels,
      );
    } catch (e) {
      print('Error loading sansu profile: $e');
    }
  }

  Future<void> setFavoriteItem(String item) async {
    if (item.trim().isEmpty) return;
    final trimmed = item.trim();
    state = state.copyWith(favoriteItem: trimmed);

    // 1. SharedPreferences保存（ローカル）
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favoriteItemKey, trimmed);

    // 2. Firestore保存（クラウド）
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await UserProfileSync.updateProfile(userId, {
        'favoriteItem': trimmed,
      });
    }
  }

  /// キャラクターのレベルを設定（1-5）
  Future<void> setCharacterLevel(String characterId, int level) async {
    final validLevel = level.clamp(1, 5);
    final newLevels = {...state.characterLevels, characterId: validLevel};
    state = state.copyWith(characterLevels: newLevels);

    // ローカル保存
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_characterLevelsKey, jsonEncode(newLevels));

    // Firebase保存（オプション）
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        await UserProfileSync.updateProfile(userId, {
          'characterLevels': newLevels,
        });
      } catch (e) {
        print('Error saving character levels to Firebase: $e');
      }
    }
  }

  /// キャラクターのレベルをアップ（最大5）
  Future<void> levelUpCharacter(String characterId) async {
    final current = state.getCharacterLevel(characterId);
    if (current < 5) {
      await setCharacterLevel(characterId, current + 1);
    }
  }

  /// 全キャラクターレベルをリセット
  Future<void> resetAllCharacterLevels() async {
    state = state.copyWith(characterLevels: {});
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_characterLevelsKey);
  }
}

final sansuProfileProvider =
    NotifierProvider<SansuProfileNotifier, SansuProfileState>(
        SansuProfileNotifier.new);

/// 文章題の好きなもの候補リスト（設定画面で選択）
const kFavoriteItemOptions = [
  'りんご', 'ケーキ', 'チョコ', 'おかし', 'アイス',
  'ドーナツ', 'クッキー', 'キャンディ', 'カード', 'シール',
];
