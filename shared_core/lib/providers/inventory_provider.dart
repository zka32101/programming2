import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'coin_provider.dart';

/// Tracks purchased shop items by ID.
/// Storage key is per-app (different APK = different SharedPreferences namespace).
class InventoryNotifier extends Notifier<Set<String>> {
  static const _prefsKey = 'shared_inventory';

  @override
  Set<String> build() {
    Future.microtask(_load);
    return {};
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      state = (jsonDecode(raw) as List<dynamic>).cast<String>().toSet();
    }
  }

  bool owns(String itemId) => state.contains(itemId);

  /// Returns error message or null on success.
  Future<String?> purchase(String itemId, int coinCost) async {
    if (state.contains(itemId)) return 'すでに所持しているアイテムです';
    final ok = await ref.read(coinProvider.notifier).spendCoins(coinCost);
    if (!ok) return 'コインが足りません（必要: ${coinCost}コイン）';
    state = {...state, itemId};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(state.toList()));
    return null;
  }
}

final inventoryProvider =
    NotifierProvider<InventoryNotifier, Set<String>>(InventoryNotifier.new);
