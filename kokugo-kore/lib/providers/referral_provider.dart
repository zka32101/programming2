import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firebase_realtime_db.dart';

/// ともコレ紹介コード。
///
/// 以前は6桁コードを端末内の SharedPreferences だけに保存・照合していたため、
/// 発行した端末以外では常に「このコードは使用できません」になっていた
/// （コードがFirebaseに同期されず、他端末からは存在しないコードに見えるため）。
///
/// バトル機能の招待（friend_provider.sendFriendRequestByCode）は
/// 「コード＝相手のuserId」をFirebase上で直接検索する方式で、これは
/// 端末間で正しく動作する。重複した2つの発行方式を統一し、紹介コードも
/// 同じ「userIdをそのままコードとして使う」方式にする。
const int kReferralCoinsReward = 10;

class ReferralState {
  final Set<String> redeemedCodes;
  const ReferralState({this.redeemedCodes = const {}});
}

class ReferralNotifier extends StateNotifier<ReferralState> {
  static const _prefsKey = 'referral_redeemed_codes';

  ReferralNotifier() : super(const ReferralState()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefsKey) ?? [];
    state = ReferralState(redeemedCodes: raw.toSet());
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, state.redeemedCodes.toList());
  }

  /// 自分の紹介コード＝自分のuserId。発行の手続きは不要（常に同じ値）だが、
  /// 既存の呼び出し側（せってい画面）との互換のため関数として残す。
  Future<String> generateReferralCode(String userId) async => userId;

  /// 相手のコード（＝相手のuserId）を入力してコインを受け取る。
  /// バトル招待と同じ方式でFirebase上に実在するユーザーか直接確認する。
  Future<bool> useReferralCode(String code, String userId) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty || trimmed == userId) return false;
    if (state.redeemedCodes.contains(trimmed)) return false;

    final profile = await FirebaseRealtimeAPI.findUserProfileById(trimmed);
    if (profile == null) return false;

    state = ReferralState(redeemedCodes: {...state.redeemedCodes, trimmed});
    await _save();
    return true;
  }
}

final referralProvider =
    StateNotifierProvider<ReferralNotifier, ReferralState>((ref) {
  return ReferralNotifier();
});
