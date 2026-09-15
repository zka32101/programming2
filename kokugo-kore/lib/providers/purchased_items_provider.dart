import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchasedItemsState {
  final Set<String> ownedItemIds;
  final String? selectedBgId;

  const PurchasedItemsState({
    this.ownedItemIds = const {},
    this.selectedBgId,
  });

  PurchasedItemsState copyWith({Set<String>? ownedItemIds, String? selectedBgId, bool clearBg = false}) {
    return PurchasedItemsState(
      ownedItemIds: ownedItemIds ?? this.ownedItemIds,
      selectedBgId: clearBg ? null : (selectedBgId ?? this.selectedBgId),
    );
  }
}

class PurchasedItemsNotifier extends StateNotifier<PurchasedItemsState> {
  PurchasedItemsNotifier() : super(const PurchasedItemsState());

  static const _ownedKey = 'purchased_shop_items';
  static const _selectedBgKey = 'selected_bg_theme';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final owned = Set<String>.from(prefs.getStringList(_ownedKey) ?? []);
    final selectedBg = prefs.getString(_selectedBgKey);
    state = PurchasedItemsState(ownedItemIds: owned, selectedBgId: selectedBg);
  }

  bool isOwned(String itemId) => state.ownedItemIds.contains(itemId);

  Future<void> purchase(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final newOwned = {...state.ownedItemIds, itemId};
    state = state.copyWith(ownedItemIds: newOwned);
    await prefs.setStringList(_ownedKey, newOwned.toList());
  }

  Future<void> selectBackground(String? itemId) async {
    final prefs = await SharedPreferences.getInstance();
    if (itemId == null) {
      state = PurchasedItemsState(ownedItemIds: state.ownedItemIds);
      await prefs.remove(_selectedBgKey);
    } else {
      state = state.copyWith(selectedBgId: itemId);
      await prefs.setString(_selectedBgKey, itemId);
    }
  }
}

final purchasedItemsProvider =
    StateNotifierProvider<PurchasedItemsNotifier, PurchasedItemsState>(
  (ref) => PurchasedItemsNotifier(),
);

// Background item definitions (shared between shop and settings)
const bgItems = [
  _BgItem('bg_space',   '🌌', '宇宙の背景'),
  _BgItem('bg_library', '📖', '図書館の背景'),
  _BgItem('bg_ocean',   '🌊', '深海の背景'),
  _BgItem('bg_sakura',  '🌸', '桜の背景'),
  _BgItem('bg_fireworks','🎆','花火の背景'),
  _BgItem('bg_leaves',  '🍁', '紅葉の背景'),
  _BgItem('bg_snow',    '❄️', '雪の背景'),
];

class _BgItem {
  final String id, emoji, name;
  const _BgItem(this.id, this.emoji, this.name);
}

// Gradient colors for each background theme
const Map<String, List<int>> bgThemeColors = {
  'bg_space':     [0xFF1A237E, 0xFF4A148C],
  'bg_library':   [0xFF5D4037, 0xFF3E2723],
  'bg_ocean':     [0xFF0D47A1, 0xFF01579B],
  'bg_sakura':    [0xFFE91E63, 0xFFAD1457],
  'bg_fireworks': [0xFFBF360C, 0xFF6D1B00],
  'bg_leaves':    [0xFFE65100, 0xFF5D4037],
  'bg_snow':      [0xFF1565C0, 0xFF37474F],
};
