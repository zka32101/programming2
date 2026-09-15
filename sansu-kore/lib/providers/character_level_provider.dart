import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// キャラクターのレベル情報を管理するプロバイダー
/// キャラクターID → レベル（1-5）のマッピング

class CharacterLevelState {
  /// キャラクターID → レベルのマップ
  final Map<String, int> levels;

  const CharacterLevelState({this.levels = const {}});

  int getLevel(String characterId) => levels[characterId] ?? 1;

  CharacterLevelState copyWith({Map<String, int>? levels}) =>
      CharacterLevelState(levels: levels ?? this.levels);
}

class CharacterLevelNotifier extends Notifier<CharacterLevelState> {
  static const _storageKey = 'sansu_character_levels';

  @override
  CharacterLevelState build() {
    _load();
    return const CharacterLevelState();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_storageKey);
      if (json != null) {
        final decoded = jsonDecode(json) as Map<String, dynamic>;
        final levels = decoded.cast<String, int>();
        state = CharacterLevelState(levels: levels);
      }
    } catch (e) {
      // デフォルト状態のまま
      print('Error loading character levels: $e');
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(state.levels));
    } catch (e) {
      print('Error saving character levels: $e');
    }
  }

  /// キャラクターのレベルを設定（1-5）
  Future<void> setLevel(String characterId, int level) async {
    final validLevel = level.clamp(1, 5);
    final newLevels = {...state.levels, characterId: validLevel};
    state = CharacterLevelState(levels: newLevels);
    await _save();
  }

  /// キャラクターのレベルをアップ（最大5）
  Future<void> levelUp(String characterId) async {
    final current = state.getLevel(characterId);
    if (current < 5) {
      await setLevel(characterId, current + 1);
    }
  }

  /// キャラクターのレベルをリセット
  Future<void> reset(String characterId) async {
    final newLevels = {...state.levels};
    newLevels.remove(characterId);
    state = CharacterLevelState(levels: newLevels);
    await _save();
  }

  /// すべてのレベルをリセット
  Future<void> resetAll() async {
    state = const CharacterLevelState();
    await _save();
  }
}

final characterLevelProvider =
    NotifierProvider<CharacterLevelNotifier, CharacterLevelState>(
        CharacterLevelNotifier.new);

/// キャラクターIDからTierを取得するヘルパー関数
int getTierByCharacterId(String characterId) {
  const tierMap = {
    // Tier 1
    'ichiko': 1,
    'niniko': 1,
    'trai': 1,
    'fouku': 1,
    // Tier 2
    'gogo': 2,
    'plaruga': 2,
    'foxmy': 2,
    'multiko': 2,
    'divido': 2,
    // Tier 3
    'geome': 3,
    'calcuku': 3,
    'fukuju': 3,
    // Tier 4
    'plus_minus': 4,
  };
  return tierMap[characterId] ?? 1;
}

/// キャラクターのレベル画像パスを取得
String getCharacterImagePath(String characterId, int level) {
  final validLevel = level.clamp(1, 5);
  final tier = getTierByCharacterId(characterId);
  return 'assets/characters/tier$tier/$characterId/${characterId}_lv${validLevel}_normal.png';
}
