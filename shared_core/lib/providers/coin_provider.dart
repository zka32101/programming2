import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _coinKey = 'total_coins';

class CoinState {
  final int totalCoins;

  const CoinState({required this.totalCoins});

  CoinState copyWith({int? totalCoins}) {
    return CoinState(totalCoins: totalCoins ?? this.totalCoins);
  }

  static const empty = CoinState(totalCoins: 0);
}

class CoinNotifier extends Notifier<CoinState> {
  @override
  CoinState build() => CoinState.empty;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    state = CoinState(totalCoins: prefs.getInt(_coinKey) ?? 0);
  }

  Future<void> addCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final newTotal = state.totalCoins + amount;
    await prefs.setInt(_coinKey, newTotal);
    state = state.copyWith(totalCoins: newTotal);
  }

  Future<bool> spendCoins(int amount) async {
    if (state.totalCoins < amount) return false;
    final prefs = await SharedPreferences.getInstance();
    final newTotal = state.totalCoins - amount;
    await prefs.setInt(_coinKey, newTotal);
    state = state.copyWith(totalCoins: newTotal);
    return true;
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_coinKey);
    state = CoinState.empty;
  }
}

final coinProvider = NotifierProvider<CoinNotifier, CoinState>(CoinNotifier.new);
