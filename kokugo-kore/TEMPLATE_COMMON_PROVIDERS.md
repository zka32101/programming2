# 共通機能プロバイダ・テンプレート集

新しい教科版アプリで再利用可能なプロバイダのテンプレートです。

---

## 📋 1. ProfileProvider テンプレート

```dart
// lib/providers/profile_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserProfile {
  final String id;
  final String name;
  final int grade;  // 学年: 1-6
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.grade,
    required this.createdAt,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    int? grade,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ProfileState {
  final List<UserProfile> profiles;
  final String? selectedProfileId;

  ProfileState({
    this.profiles = const [],
    this.selectedProfileId,
  });

  UserProfile? get selectedProfile =>
      profiles.firstWhereOrNull((p) => p.id == selectedProfileId);
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState());

  static const _key = 'user_profiles';
  static const _selectedKey = 'selected_profile_id';
  final _uuid = const Uuid();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    // プロフィール復元ロジック
  }

  Future<void> addProfile(String name, int grade) async {
    final prefs = await SharedPreferences.getInstance();
    final newProfile = UserProfile(
      id: _uuid.v4(),
      name: name,
      grade: grade,
      createdAt: DateTime.now(),
    );
    final profiles = [...state.profiles, newProfile];
    state = ProfileState(
      profiles: profiles,
      selectedProfileId: state.selectedProfileId,
    );
    // SharedPreferences に保存
  }

  Future<void> selectProfile(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedKey, profileId);
    state = ProfileState(
      profiles: state.profiles,
      selectedProfileId: profileId,
    );
  }

  Future<void> deleteProfile(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    final profiles = state.profiles
        .where((p) => p.id != profileId)
        .toList();
    state = ProfileState(
      profiles: profiles,
      selectedProfileId:
          state.selectedProfileId == profileId ? null : state.selectedProfileId,
    );
    // SharedPreferences に保存
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(),
);
```

---

## 💰 2. CoinProvider テンプレート

```dart
// lib/providers/coin_provider.dart

class CoinState {
  final int totalCoins;
  final List<CoinTransaction> transactions;

  CoinState({
    this.totalCoins = 0,
    this.transactions = const [],
  });
}

class CoinTransaction {
  final String id;
  final int amount;
  final String reason;  // 'quiz_complete', 'daily_bonus', 'purchase', etc.
  final DateTime timestamp;

  CoinTransaction({
    required this.id,
    required this.amount,
    required this.reason,
    required this.timestamp,
  });
}

class CoinNotifier extends StateNotifier<CoinState> {
  CoinNotifier() : super(CoinState());

  static const _key = 'total_coins';
  static const _transactionKey = 'coin_transactions';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final coins = prefs.getInt(_key) ?? 0;
    state = CoinState(totalCoins: coins);
  }

  Future<void> earnCoins(int amount, String reason) async {
    final prefs = await SharedPreferences.getInstance();
    final newTotal = state.totalCoins + amount;
    final transaction = CoinTransaction(
      id: const Uuid().v4(),
      amount: amount,
      reason: reason,
      timestamp: DateTime.now(),
    );

    state = CoinState(
      totalCoins: newTotal,
      transactions: [...state.transactions, transaction],
    );
    await prefs.setInt(_key, newTotal);
  }

  Future<bool> spendCoins(int amount) async {
    if (state.totalCoins < amount) return false;

    final prefs = await SharedPreferences.getInstance();
    final newTotal = state.totalCoins - amount;
    
    state = CoinState(
      totalCoins: newTotal,
      transactions: state.transactions,
    );
    await prefs.setInt(_key, newTotal);
    return true;
  }
}

final coinProvider = StateNotifierProvider<CoinNotifier, CoinState>(
  (ref) => CoinNotifier(),
);
```

---

## 📊 3. ProgressProvider テンプレート

```dart
// lib/providers/progress_provider.dart

class ProgressState {
  final Set<String> clearedStageIds;
  final Map<String, int> stageScores;  // stageId -> score
  final int totalLearningTime;         // 分

  ProgressState({
    this.clearedStageIds = const {},
    this.stageScores = const {},
    this.totalLearningTime = 0,
  });

  bool isStageClear(String stageId) => clearedStageIds.contains(stageId);
  int getStagedScore(String stageId) => stageScores[stageId] ?? 0;
}

class ProgressNotifier extends StateNotifier<ProgressState> {
  ProgressNotifier() : super(ProgressState());

  static const _clearedKey = 'cleared_stages';
  static const _scoresKey = 'stage_scores';
  static const _timeKey = 'total_learning_time';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final clearedJson = prefs.getString(_clearedKey);
    final scoresJson = prefs.getString(_scoresKey);
    final time = prefs.getInt(_timeKey) ?? 0;

    // JSON からデータ復元
    state = ProgressState(
      totalLearningTime: time,
    );
  }

  Future<void> clearStage(String stageId, int score) async {
    final prefs = await SharedPreferences.getInstance();
    
    final clearedStages = {...state.clearedStageIds, stageId};
    final scores = {...state.stageScores, stageId: score};

    state = ProgressState(
      clearedStageIds: clearedStages,
      stageScores: scores,
      totalLearningTime: state.totalLearningTime,
    );

    // SharedPreferences に保存
    await prefs.setString(_clearedKey, jsonEncode(clearedStages.toList()));
    await prefs.setString(_scoresKey, jsonEncode(scores));
  }

  Future<void> addLearningTime(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    final newTotal = state.totalLearningTime + minutes;
    
    state = ProgressState(
      clearedStageIds: state.clearedStageIds,
      stageScores: state.stageScores,
      totalLearningTime: newTotal,
    );

    await prefs.setInt(_timeKey, newTotal);
  }
}

final progressProvider = StateNotifierProvider<ProgressNotifier, ProgressState>(
  (ref) => ProgressNotifier(),
);
```

---

## 🎖️ 4. BadgeProvider テンプレート

```dart
// lib/providers/badge_provider.dart

class Badge {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final int? rewardCoins;
  final DateTime? unlockedAt;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.rewardCoins,
    this.unlockedAt,
  });

  bool get isUnlocked => unlockedAt != null;
}

class BadgeState {
  final Map<String, DateTime> unlockedBadges;

  BadgeState({this.unlockedBadges = const {}});

  bool isUnlocked(String badgeId) => unlockedBadges.containsKey(badgeId);
}

class BadgeNotifier extends StateNotifier<BadgeState> {
  BadgeNotifier() : super(BadgeState());

  static const _key = 'unlocked_badges';

  final badges = [
    Badge(
      id: 'first_clear',
      name: '初心者',
      description: '最初のステージをクリア',
      icon: Icons.star,
      rewardCoins: 50,
    ),
    Badge(
      id: 'perfect_week',
      name: '完璧な1週間',
      description: '7日連続で100%正答',
      icon: Icons.favorite,
      rewardCoins: 200,
    ),
    // ... その他のバッジ
  ];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    // バッジデータ復元
  }

  Future<void> unlockBadge(String badgeId) async {
    if (state.isUnlocked(badgeId)) return;

    final prefs = await SharedPreferences.getInstance();
    final unlockedBadges = {
      ...state.unlockedBadges,
      badgeId: DateTime.now(),
    };

    state = BadgeState(unlockedBadges: unlockedBadges);
    await prefs.setString(_key, jsonEncode(unlockedBadges));
  }

  void checkAndUnlock(String badgeId, bool condition) {
    if (condition && !state.isUnlocked(badgeId)) {
      unlockBadge(badgeId);
    }
  }
}

final badgeProvider = StateNotifierProvider<BadgeNotifier, BadgeState>(
  (ref) => BadgeNotifier(),
);
```

---

## 🎮 5. PremiumProvider テンプレート

```dart
// lib/providers/premium_provider.dart

class PremiumState {
  final bool isPremium;
  final bool isTrialActive;
  final DateTime? trialExpiresAt;
  final DateTime? purchasedAt;

  PremiumState({
    this.isPremium = false,
    this.isTrialActive = false,
    this.trialExpiresAt,
    this.purchasedAt,
  });

  bool get isPayingUser => isPremium || isTrialActive;
}

class PremiumNotifier extends StateNotifier<PremiumState> {
  PremiumNotifier() : super(PremiumState());

  static const _premiumKey = 'is_premium';
  static const _trialKey = 'trial_expires_at';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final isPremium = prefs.getBool(_premiumKey) ?? false;
    final trialExpiry = prefs.getString(_trialKey);

    state = PremiumState(
      isPremium: isPremium,
      isTrialActive: trialExpiry != null &&
          DateTime.parse(trialExpiry).isAfter(DateTime.now()),
      trialExpiresAt:
          trialExpiry != null ? DateTime.parse(trialExpiry) : null,
    );
  }

  Future<void> startTrial() async {
    final prefs = await SharedPreferences.getInstance();
    final expiresAt = DateTime.now().add(Duration(days: 7));
    
    state = PremiumState(
      isPremium: false,
      isTrialActive: true,
      trialExpiresAt: expiresAt,
    );

    await prefs.setString(_trialKey, expiresAt.toIso8601String());
  }

  Future<void> purchasePremium() async {
    final prefs = await SharedPreferences.getInstance();
    
    state = PremiumState(
      isPremium: true,
      isTrialActive: false,
      purchasedAt: DateTime.now(),
    );

    await prefs.setBool(_premiumKey, true);
  }

  Future<void> restoreSubscription() async {
    // In-App Purchase 復元ロジック
    await purchasePremium();
  }
}

final premiumProvider = StateNotifierProvider<PremiumNotifier, PremiumState>(
  (ref) => PremiumNotifier(),
);
```

---

## 🏠 6. 他のテンプレート

以下のプロバイダも同様にテンプレート化可能:

- `avatar_unlock_provider.dart` - アバター管理
- `character_provider.dart` - キャラクター進捗
- `daily_bonus_provider.dart` - デイリーボーナス
- `learning_timer_provider.dart` - 学習タイマー
- `analytics_provider.dart` - 学習分析
- `battle_provider.dart` - マルチプレイ
- `leaderboard_provider.dart` - ランキング

国語コレのコードを参考にカスタマイズしてください。

---

## 🎯 使い方

1. 上記テンプレートをコピー
2. `[教科名]` など教科に合わせて修正
3. ビジネスロジック（学習ロジック等）を追加
4. プロバイダを `main.dart` で初期化

