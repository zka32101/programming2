import 'dart:convert';

class ReferralCode {
  final String code;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

  final String generatorId;
  final int coinsReward;
  final List<String> usedByUserIds;
  final int maxUses;

  const ReferralCode({
    required this.code,
    required this.generatorId,
    this.coinsReward = 10,
    this.usedByUserIds = const [],
    this.maxUses = 5,
  });

  bool canBeUsedBy(String userId) => !usedByUserIds.contains(userId);
  bool isMaxReached() => usedByUserIds.length >= maxUses;

  ReferralCode copyWith({
    String? code,
    String? generatorId,
    int? coinsReward,
    List<String>? usedByUserIds,
    int? maxUses,
  }) {
    return ReferralCode(
      code: code ?? this.code,
      generatorId: generatorId ?? this.generatorId,
      coinsReward: coinsReward ?? this.coinsReward,
      usedByUserIds: usedByUserIds ?? this.usedByUserIds,
      maxUses: maxUses ?? this.maxUses,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'generatorId': generatorId,
    'coinsReward': coinsReward,
    'usedByUserIds': usedByUserIds,
    'maxUses': maxUses,
  };

  factory ReferralCode.fromJson(Map<String, dynamic> json) => ReferralCode(
    code: json['code'] as String,
    generatorId: json['generatorId'] as String,
    coinsReward: json['coinsReward'] as int? ?? 10,
    usedByUserIds: List<String>.from(json['usedByUserIds'] as List? ?? []),
    maxUses: json['maxUses'] as int? ?? 5,
  );
}

class ReferralState {
  final List<ReferralCode> codes;
  final Map<String, String> userReferralHistory;

  const ReferralState({
    this.codes = const [],
    this.userReferralHistory = const {},
  });

  ReferralCode? findCodeByValue(String codeValue) {
    try {
      return codes.firstWhere((c) => c.code == codeValue);
    } catch (_) {
      return null;
    }
  }

  ReferralState copyWith({
    List<ReferralCode>? codes,
    Map<String, String>? userReferralHistory,
  }) {
    return ReferralState(
      codes: codes ?? this.codes,
      userReferralHistory: userReferralHistory ?? this.userReferralHistory,
    );
  }
}

class ReferralNotifier extends StateNotifier<ReferralState> {
  ReferralNotifier() : super(const ReferralState()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final codesJson = prefs.getStringList('referral_codes') ?? [];
    final historyJson = prefs.getString('referral_history') ?? '{}';

    final codes = codesJson.map((j) => ReferralCode.fromJson(jsonDecode(j))).toList();
    final history = Map<String, String>.from(jsonDecode(historyJson) as Map);

    state = ReferralState(codes: codes, userReferralHistory: history);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final codesJson = state.codes.map((c) => jsonEncode(c.toJson())).toList();
    await prefs.setStringList('referral_codes', codesJson);
    await prefs.setString('referral_history', jsonEncode(state.userReferralHistory));
  }

  Future<String> generateReferralCode(String userId) async {
    final code = _generateUniqueCode();
    final newCode = ReferralCode(
      code: code,
      generatorId: userId,
    );
    state = state.copyWith(codes: [...state.codes, newCode]);
    await _save();
    return code;
  }

  Future<bool> useReferralCode(String code, String userId) async {
    final referralCode = state.findCodeByValue(code);
    if (referralCode == null) return false;
    if (!referralCode.canBeUsedBy(userId)) return false;
    if (referralCode.isMaxReached()) return false;

    final updatedCode = referralCode.copyWith(
      usedByUserIds: [...referralCode.usedByUserIds, userId],
    );

    state = state.copyWith(
      codes: state.codes.map((c) => c.code == code ? updatedCode : c).toList(),
      userReferralHistory: {
        ...state.userReferralHistory,
        userId: code,
      },
    );

    await _save();
    return true;
  }

  int getReferralRewardCoins(String code) {
    final referralCode = state.findCodeByValue(code);
    return referralCode?.coinsReward ?? 0;
  }

  String _generateUniqueCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String code;
    do {
      code = List.generate(6, (_) => chars[(DateTime.now().microsecond) % chars.length]).join();
    } while (state.codes.any((c) => c.code == code));
    return code;
  }

  String? getUserReferralCode(String userId) {
    return state.userReferralHistory[userId];
  }

  ReferralCode? getReferralCodeByUser(String userId) {
    try {
      return state.codes.firstWhere((c) => c.generatorId == userId);
    } catch (_) {
      return null;
    }
  }
}

final referralProvider = StateNotifierProvider<ReferralNotifier, ReferralState>((ref) {
  return ReferralNotifier();
});
