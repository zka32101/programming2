# 算数コレ！ アーキテクチャ

## 概要

小学1〜6年生向け算数学習アプリ。設計書に基づくSランク＋教育工学機能を実装。

## 実装済み機能

### Sランク（v1.0 必須）
1. **オンボーディング「最初の5分で感動」** - `lib/screens/onboarding_screen.dart`
   - 6ステップ（名前→学年→クイズ→キャラ獲得→図鑑→完了）
   - 初回スタートボーナスコイン30枚

2. **デイリーログインボーナス** - `lib/providers/daily_login_provider.dart`, `lib/screens/daily_bonus_screen.dart`
   - 7日サイクル（Day1:10コイン〜Day7:特別ボックス）
   - 連続ログイン記録・バッジ連動

3. **親のほめ導線自動化** - `lib/services/notification_service.dart`
   - ステージクリア時に親向けメッセージキュー追加
   - 設定画面でメッセージ履歴を確認可能
   - FCM連携準備済み（本番実装時に有効化）

### 教育工学機能（設計書より）
4. **アダプティブラーニング** - `lib/providers/adaptive_provider.dart`
   - トピック別正答率追跡
   - 正答率60%未満でヒントボタン自動表示（ZPD実装）
   - ホーム画面にAI推奨コース表示

5. **フォーメティブ評価** - `lib/screens/quest_screen.dart`
   - 全問題に解説文付き（正解・不正解どちらも）
   - 誤答後に正解ハイライト表示

6. **セーフティネット（つまずき検出）** - `lib/providers/adaptive_provider.dart`
   - 3回連続失敗でparentsAlertNeededフラグ
   - 結果画面で親向けアラート通知

## ディレクトリ構成

```
lib/
├── main.dart              # アプリエントリポイント
├── firebase_options.dart  # Firebase設定（flutterfire configureで生成）
├── data/
│   └── stage_data.dart    # 小1〜小6 全ステージ問題データ
├── models/
│   ├── quest_model.dart   # Stage, QuizQuestion, QuestResult
│   ├── badge_model.dart   # バッジ定義（13種）
│   └── user_profile.dart  # ユーザープロフィール
├── providers/
│   ├── grade_provider.dart        # 学年管理
│   ├── profile_provider.dart      # プロフィール管理
│   ├── progress_provider.dart     # 学習進捗・ストリーク
│   ├── badge_provider.dart        # バッジ獲得管理
│   ├── coin_provider.dart         # コイン管理
│   ├── premium_provider.dart      # サブスクリプション
│   ├── daily_login_provider.dart  # ★NEW デイリーログインボーナス
│   └── adaptive_provider.dart     # ★NEW アダプティブラーニング
├── screens/
│   ├── splash_screen.dart          # スプラッシュ
│   ├── onboarding_screen.dart      # ★ENHANCED 6ステップオンボーディング
│   ├── profile_selection_screen.dart
│   ├── home_screen.dart            # ★ENHANCED AI推奨+デイリーボーナス
│   ├── daily_bonus_screen.dart     # ★NEW デイリーボーナスポップアップ
│   ├── stage_select_screen.dart    # ステージ選択
│   ├── quest_screen.dart           # ★ENHANCED ヒント+解説
│   ├── result_screen.dart          # ★ENHANCED 親ほめ導線+セーフティネット
│   ├── character_screen.dart       # バッジ・キャラクター
│   ├── settings_screen.dart        # ★ENHANCED ほめメッセージ履歴表示
│   ├── upgrade_screen.dart         # サブスクリプション
│   └── privacy_policy_screen.dart  # ★ENHANCED データ透明化
├── services/
│   ├── firebase_service.dart       # Firebase認証
│   └── notification_service.dart   # ★NEW 親のほめ導線・FCM準備
└── theme/
    └── app_theme.dart              # レッドテーマ（算数コレカラー）
```

## 算数コンテンツ

| 学年 | ステージ | トピック |
|------|---------|---------|
| 小1 | 4ステージ | たし算×3、ひき算×1 |
| 小2 | 4ステージ | かけ算（2〜9の段） |
| 小3 | 4ステージ | わり算×3、大きい数のたし算、時刻 |
| 小4 | 4ステージ | 分数、小数、大きいかけ算、面積 |
| 小5 | 4ステージ | 分数のかけ算、小数の掛割、速さ、割合 |
| 小6 | 4ステージ | 文字と式、比、円の面積、総合 |

計：24ステージ × 5問 = 120問

## セットアップ

```bash
# Flutter依存インストール
flutter pub get

# Firebase設定（本番時）
flutterfire configure

# 実行
flutter run
```

## 次のステップ（v1.1）

- ウィークリーチャレンジ「今週のミッション」
- ほめカード（SNSシェア）
- 友達招待「ともコレ！」
- 成長タイムカプセル「あの日の自分」
