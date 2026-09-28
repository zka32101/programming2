import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ショップで購入したテーマカラー・背景・称号のうち、
/// 実際に「適用中」のものを1つずつ記憶する。
/// 所持しているかどうかは shared_core の inventoryProvider が別途管理する。
class CustomizationState {
  final String? themeId;
  final String? backgroundId;
  final String? titleId;

  const CustomizationState({this.themeId, this.backgroundId, this.titleId});

  CustomizationState copyWith({
    String? Function()? themeId,
    String? Function()? backgroundId,
    String? Function()? titleId,
  }) {
    return CustomizationState(
      themeId: themeId != null ? themeId() : this.themeId,
      backgroundId: backgroundId != null ? backgroundId() : this.backgroundId,
      titleId: titleId != null ? titleId() : this.titleId,
    );
  }
}

class CustomizationNotifier extends Notifier<CustomizationState> {
  static const _keyTheme = 'customization_theme_id';
  static const _keyBackground = 'customization_background_id';
  static const _keyTitle = 'customization_title_id';

  @override
  CustomizationState build() {
    Future.microtask(load);
    return const CustomizationState();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    state = CustomizationState(
      themeId: prefs.getString(_keyTheme),
      backgroundId: prefs.getString(_keyBackground),
      titleId: prefs.getString(_keyTitle),
    );
  }

  Future<void> selectTheme(String? id) async {
    state = state.copyWith(themeId: () => id);
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_keyTheme);
    } else {
      await prefs.setString(_keyTheme, id);
    }
  }

  Future<void> selectBackground(String? id) async {
    state = state.copyWith(backgroundId: () => id);
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_keyBackground);
    } else {
      await prefs.setString(_keyBackground, id);
    }
  }

  Future<void> selectTitle(String? id) async {
    state = state.copyWith(titleId: () => id);
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_keyTitle);
    } else {
      await prefs.setString(_keyTitle, id);
    }
  }
}

final customizationProvider =
    NotifierProvider<CustomizationNotifier, CustomizationState>(
        CustomizationNotifier.new);
