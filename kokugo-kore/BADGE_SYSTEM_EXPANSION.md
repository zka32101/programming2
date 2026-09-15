# バッジシステム拡張計画

## 現状分析

### 既存バッジ (26個)
- **連続学習**: streak_3, streak_7, streak_14, streak_30, streak_60, streak_100
- **完璧なスコア**: perfect_score
- **クイズ達成**: quiz_total_100, quiz_total_500
- **完璧ストリーク**: perfect_3
- **漢字学習**: kanji_first, kanji_10
- **読解学習**: reading_first, reading_10
- **最初のスコア**: score_first
- **ステージ達成**: stage_20, stage_30
- **キャラクター**: character_3, character_lv_max
- **バッジコレクター**: badge_collector
- **未実装**: writing_*, grammar_*, vocab_* (機能側の実装待ち)

### 既存機能
- SharedPreferencesでの永続化
- 自動チェック・アンロック機能
- バッジ図鑑表示UI
- 獲得日時の記録

---

## 拡張方針

### 1️⃣ **バッジカテゴリの拡張**

#### A. 文法・文章系バッジ（実装待機）
```
- grammar_first: 文法クイズ初回クリア
- grammar_10: 文法クイズ10問正解
- writing_start: 作文チャレンジ開始
- vocab_10: ことば10語マスター
- vocab_50: ことば50語マスター
```

#### B. 新規：チャレンジバッジ
```
- challenge_3days_perfect: 3日連続100%正答
- challenge_all_stages: 全ステージクリア
- challenge_speedrun: 10問を2分以内にクリア
- challenge_nonstop: 20問連続正答
```

#### C. 新規：社交バッジ
```
- friend_invite_1: 友人を1人招待
- friend_invite_5: 友人を5人招待
- multiplayer_win_5: マルチプレイで5勝
- multiplayer_rank_top10: ランキングTOP10
```

#### D. 新規：時間帯バッジ
```
- early_bird: 朝6時前に学習
- night_owl: 夜22時以降に学習
- midnight_warrior: 深夜2時以降に学習（教育的観点から非推奨だが記録用）
```

#### E. 新規：マイルストーン
```
- learning_1hour: 累計1時間学習
- learning_10hour: 累計10時間学習
- learning_100hour: 累計100時間学習
- coins_1000: 1000コイン獲得
```

---

### 2️⃣ **バッジ報酬システム**

#### A. コイン報酬
```dart
class BadgeReward {
  final int coins;           // 獲得コイン
  final int? avatarRewardId; // 特別アバター
  final int? characterSkinId;// キャラスキン
  final bool isPremiumOnly;  // プレミアム限定
}
```

#### B. 報酬割り当て
- **通常バッジ**: 10~50コイン
- **レアバッジ**: 50~100コイン
- **レジェンダリー**: 100~200コイン + 特別報酬
- **シークレット**: 150~300コイン + 複数報酬

#### C. 実装方針
- BadgeModel に `reward: BadgeReward?` フィールド追加
- badge_provider.dart でバッジ獲得時にコイン自動加算
- 親向けダッシュボードで報酬履歴表示

---

### 3️⃣ **バッジレアリティシステム**

#### A. 4段階レアリティ
```dart
enum BadgeRarity {
  common,      // 🟦 通常（入手容易）
  rare,        // 🟪 レア（中難度）
  epic,        // 🟧 エピック（高難度）
  legendary,   // 🟨 レジェンダリー（極難度）
  secret,      // ⬛ シークレット（非表示）
}
```

#### B. UI反映
- バッジカード背景色をレアリティで変更
- レアリティアイコン表示（★の数）
- 図鑑で「レアリティ別フィルタ」追加
- 「獲得難度が高い順」ソート追加

---

### 4️⃣ **バッジ進捗トラッキング**

#### A. ProgressProvider拡張
```dart
class BadgeProgress {
  final String badgeId;
  final int currentValue;     // 現在値
  final int targetValue;      // 目標値
  final double progressPercent; // 進捗率
  final DateTime? estimatedDate; // 予想獲得日
}
```

#### B. 進捗チェック対象
```
- streak_X: 連続日数 (0/3, 0/7, ...)
- quiz_total_X: 正答数 (234/500)
- stage_X: クリアステージ数 (18/20)
- character_X: キャラ数 (2/3)
- learning_Xhour: 学習時間 (45min/1hour)
```

#### C. ホーム画面表示
- 上位3つの進捗中バッジを表示
- タップで詳細進捗ダイアログ
- 予想獲得日を表示（例: "あと3日で獲得可能")

---

### 5️⃣ **バッジ獲得通知システム**

#### A. 近接通知 (70%達成時)
```
例: "あなたは『完璧な1週間』バッジまであと2日です！🎯"
```

#### B. 達成通知 (100%達成時)
```
- トースト表示: "🎉 新しいバッジ『完璧な1週間』を獲得しました！"
- バッジ詳細ダイアログ表示
- コイン報酬アナウンス
- キャラクターボイス（あれば）
```

#### C. 日次リマインダー
- 進捗中のバッジ一覧を通知
- プレミアムユーザー向けに詳細通知オプション

---

### 6️⃣ **バッジ図鑑の拡張**

#### A. 新規フィルタ機能
```
- レアリティ別フィルタ
- カテゴリ別フィルタ
- 獲得状態フィルタ (取得済/未取得/あと少し)
```

#### B. 新規ソート機能
```
- 難度順（レア度順）
- 取得予想日順
- 獲得日順
```

#### C. 詳細表示拡張
```
- バッジの説明文
- 獲得条件の詳細説明
- 現在の進捗率（進捗中のバッジ）
- 報酬一覧（コイン、アバター等）
- 獲得日時（過去のバッジ）
```

#### D. 統計情報
```
- 取得済バッジ数/総数
- 完成度パーセンテージ
- レアリティ別の内訳グラフ
- 月別獲得数グラフ
```

---

## 実装ロードマップ

### Phase 1: 基盤拡張（優先度: 高）
- [ ] BadgeReward モデル追加
- [ ] BadgeRarity enum 追加
- [ ] BadgeProgress モデル追加
- [ ] badge_provider.dart 拡張（報酬システム、進捗トラッキング）
- [ ] badge_screen.dart 拡張（レアリティUI、フィルタ、ソート）

### Phase 2: 新規バッジ追加（優先度: 中）
- [ ] チャレンジバッジ実装（challenge_*）
- [ ] 社交バッジ実装（friend_invite_*, multiplayer_*）
- [ ] マイルストーンバッジ実装（learning_*hour, coins_*）

### Phase 3: 時間帯バッジ・通知（優先度: 中）
- [ ] 時間帯バッジ実装（early_bird, night_owl）
- [ ] 獲得通知システム実装
- [ ] 進捗通知システム実装

### Phase 4: UI・UX強化（優先度: 低）
- [ ] バッジ詳細ダイアログ拡張
- [ ] 統計グラフ追加
- [ ] ホーム画面への進捗表示
- [ ] アニメーション・エフェクト追加

---

## ファイル構成

```
lib/
├── models/
│   └── badge_reward_model.dart      [新規] 報酬情報
│   └── badge_progress_model.dart    [新規] 進捗情報
│
├── providers/
│   └── badge_provider.dart          [拡張] 報酬・進捗機能追加
│   └── badge_progress_provider.dart [新規] 進捗トラッキング
│
├── screens/
│   └── badge_screen.dart            [拡張] フィルタ・ソート・統計
│
└── widgets/
    └── badge_progress_card.dart     [新規] 進捗表示カード
    └── badge_notification.dart      [新規] 獲得通知UI
```

---

## 技術仕様

### BadgeReward
```dart
class BadgeReward {
  final int coinAmount;
  final List<String>? unlockedAvatarIds;
  final List<String>? unlockedCharacterSkins;
  final bool isPremiumOnly;
  
  const BadgeReward({
    required this.coinAmount,
    this.unlockedAvatarIds,
    this.unlockedCharacterSkins,
    this.isPremiumOnly = false,
  });
}
```

### BadgeProgress
```dart
class BadgeProgress {
  final String badgeId;
  final int currentValue;
  final int targetValue;
  final DateTime? unlockedAt;
  
  double get progressPercent => 
    (currentValue / targetValue).clamp(0.0, 1.0);
  
  bool get isComplete => currentValue >= targetValue;
}
```

---

## 参考資料

- **SHARED_FEATURES.md**: バッジ・達成システム (セクション 11)
- **badge_provider.dart**: 既存バッジロジック
- **badge_screen.dart**: バッジUI
- **TEMPLATE_COMMON_PROVIDERS.md**: プロバイダーテンプレート

---

## 注記

- 文法・文章系バッジは対応する学習機能の実装と合わせて実装予定
- 時間帯バッジの「深夜」カテゴリは学習習慣の観点から推奨しない（記録用のみ）
- プレミアム限定バッジは設計段階（要件確認待ち）
