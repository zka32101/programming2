# 小学コレ！ 共通機能一覧

小学コレ！国語で実装された汎用的な機能を整理しました。他の教科版アプリに適用可能な機能です。

---

## 📋 I. ユーザー・プロフィール管理

### 1. プロフィール作成・管理
- **ファイル**: `providers/profile_provider.dart`, `screens/profile_selection_screen.dart`
- **機能**:
  - 複数プロフィール管理（学年別など）
  - アバター選択
  - プロフィール削除・編集
- **データ永続化**: SharedPreferences
- **UI**: プロフィール選択画面、プロフィール作成ダイアログ

### 2. アバター・キャラクター選択
- **ファイル**: `providers/avatar_unlock_provider.dart`, `screens/profile_selection_screen.dart`
- **機能**:
  - 無料アバターと有料アバター分離
  - アバター購入トラッキング
  - 複数キャラクター管理
- **データ永続化**: `purchasedItemsProvider`

---

## 💰 II. マネタイゼーション

### 3. コイン・通貨システム
- **ファイル**: `providers/coin_provider.dart`
- **機能**:
  - コイン獲得・消費追跡
  - ユーザー残高管理
  - 取引履歴管理
- **通知**: コイン変動時の UI 更新
- **データ永続化**: SharedPreferences + Firebase

### 4. In-App Purchase (IAP)
- **ファイル**: `main.dart` 内の IAP 初期化
- **パッケージ**: `in_app_purchase`
- **機能**:
  - プレミアムトライアル（7日間）
  - 永続ライセンス購入
  - 購入トラッキング・復元
- **Firebase**: プレミアム状態の同期

### 5. アイテム購入・インベントリ
- **ファイル**: `providers/purchased_items_provider.dart`
- **機能**:
  - 購入アイテム追跡
  - 背景テーマ選択
  - アバター・帽子などの装備
- **ショップUI**: `widgets/kokugo_shop_page.dart`

### 6. プレミアム機能ゲート
- **ファイル**: `widgets/premium_gate.dart`
- **機能**:
  - 機能ごとのプレミアム要件チェック
  - トライアル中・本購入による差別化
  - ロック画面表示
- **対象機能**: かんじ、文法、読解力強化、マルチプレイなど

---

## 📊 III. 学習進捗・分析

### 7. 学習進捗トラッキング
- **ファイル**: `providers/progress_provider.dart`
- **機能**:
  - ステージクリア記録
  - 正答数・解答時間追跡
  - 学習レベル管理
- **データ永続化**: SharedPreferences + Firebase

### 8. 学習分析・レポート
- **ファイル**: `providers/analytics_provider.dart`, `screens/learning_analytics_screen.dart`
- **機能**:
  - 日別・週別・月別統計
  - 正答率トレンド
  - 学習時間分析
  - パフォーマンスチャート
- **UI コンポーネント**: 
  - `widgets/accuracy_trend_widget.dart`
  - `widgets/monthly_chart_widget.dart`
  - `widgets/progress_chart_widget.dart`

### 9. 学習ペース推奨
- **ファイル**: `screens/recommended_pace_screen.dart`, `widgets/pace_recommendation_card.dart`
- **機能**:
  - 学習データに基づく推奨学習量
  - ペース調整アドバイス
  - 親向けダッシュボード統合

### 10. 親向けレポート・ダッシュボード
- **ファイル**: 
  - `screens/parent_report_screen.dart`
  - `screens/parent_dashboard_screen.dart`
  - `screens/child_profile_dashboard_screen.dart`
- **機能**:
  - 子どもの学習進捗表示
  - 正答率・完了度レポート
  - 複数子ども管理
  - 学習時間トラッキング

---

## 🎮 IV. ゲーミフィケーション

### 11. バッジ・達成システム
- **ファイル**: `providers/badge_provider.dart`, `screens/badge_screen.dart`
- **機能**:
  - 達成条件の自動チェック
  - バッジ報酬（コイン、アバター等）
  - バッジ図鑑表示
- **例**: 初クリア、連続学習日数、高正答率など

### 12. 日々のボーナス・ミッション
- **ファイル**: `providers/daily_bonus_provider.dart`, `widgets/daily_bonus_dialog.dart`
- **機能**:
  - 毎日ログインボーナス
  - ストリークシステム
  - 日々のミッション表示
- **UI**: ログイン時の自動ダイアログ

### 13. キャラクター・レベルアップシステム
- **ファイル**: `providers/character_provider.dart`, `screens/character_screen.dart`
- **機能**:
  - キャラクターの段階的アンロック
  - レベルアップ演出
  - キャラクター育成
- **データ連動**: ステージクリア数に基づく自動アンロック

### 14. ランキング・リーダーボード
- **ファイル**: `providers/leaderboard_provider.dart`, `screens/leaderboard_screen.dart`
- **機能**:
  - グローバルランキング
  - 友人ランキング
  - 正答率・スコアランキング
- **Firebase**: リアルタイムランキング同期

### 15. マルチプレイ・バトルシステム
- **ファイル**: 
  - `providers/battle_provider.dart`
  - `screens/battle_screen.dart`
  - `screens/multiplayer_menu_screen.dart`
- **機能**:
  - リアルタイム対戦
  - 友人招待
  - スコアランキング
  - バトル履歴

---

## 📱 V. UI・UX コンポーネント

### 16. 広告システム
- **ファイル**: `services/ad_service.dart`, `widgets/banner_ad_widget.dart`
- **機能**:
  - バナー広告表示（無料ユーザー向け）
  - プレミアムユーザーは非表示
  - AdMob 統合
- **戦略**: フリーミアムモデル対応

### 17. アプリ紹介ダイアログ
- **ファイル**: `widgets/app_intro_dialog.dart`
- **機能**:
  - 初回起動時の機能説明
  - 設定画面から再表示可能
  - スクリーンショット付き説明

### 18. 学習統計ウィジェット
- **ファイル**: `widgets/learning_stats_card.dart`
- **機能**:
  - 本日の学習統計表示
  - 正答数・問題数表示
  - インタラクティブカード

### 19. クイズウィジェット（汎用）
- **ファイル**: `widgets/generic_quiz_widget.dart`
- **機能**:
  - 複数選択肢クイズUI
  - 自動採点
  - スコア表示
  - 再挑戦機能

### 20. ステージカード
- **ファイル**: `widgets/stage_card.dart`
- **機能**:
  - ステージ進捗表示
  - クリア状態視覚化
  - タップでステージ開始

### 21. 学習タイマー
- **ファイル**: `providers/learning_timer_provider.dart`, `widgets/timer_chip_widget.dart`
- **機能**:
  - セッション時間トラッキング
  - 休憩通知
  - 学習時間合計表示

### 22. キャラクターコレクション表示
- **ファイル**: `widgets/kokugo_character_collection.dart`
- **機能**:
  - キャラクター一覧表示
  - アンロック状態表示
  - キャラクター詳細表示

---

## 🔐 VI. 認証・バックエンド

### 23. Firebase Authentication
- **ファイル**: `services/firebase_service.dart`, `firebase_options.dart`
- **機能**:
  - 匿名認証
  - ユーザーID生成・管理
  - デバイス認証
- **設定**: Google Cloud プロジェクト統合

### 24. Firebase Realtime Database
- **ファイル**: `services/firebase_realtime_db.dart`
- **機能**:
  - リアルタイムデータ同期
  - ユーザープロフィール同期
  - ランキングデータ同期
  - マルチプレイデータ管理

### 25. クロスプロモーション
- **パッケージ**: `shared_core/cross_promo_kit`
- **機能**:
  - 他アプリ推奨表示
  - アプリ内広告
  - コンバージョン追跡

---

## 🎯 VII. ナビゲーション・ルーティング

### 26. ナビゲーション・ボトムタブ
- **ファイル**: `main.dart` 内 RootShell クラス
- **タブ構成**: ホーム、学習、キャラクター、ショップ、設定
- **機能**: タブ間スムーズ遷移、状態保持

### 27. スプラッシュ画面
- **ファイル**: `screens/splash_screen.dart`
- **機能**:
  - ブランド表示
  - データ初期化
  - プロフィール選択への遷移

### 28. 設定画面
- **ファイル**: `screens/settings_screen.dart`
- **機能**:
  - 言語設定
  - 通知設定
  - データリセット
  - サポート・利用規約

---

## 📦 VIII. 国語固有機能（参考）

### ❌ 以下は国語固有で他アプリには不要:
- ひらがな・カタカナ学習
- 漢字学習（stroke order）
- 読解問題
- 文法クイズ
- ことわざ・慣用句・四字熟語
- 作文支援
- 単語帳機能

---

## 🔧 IX. 技術スタック

### UI フレームワーク
- **Flutter**: クロスプラットフォーム開発
- **Material Design**: UI コンポーネント

### 状態管理
- **Riverpod**: プロバイダベース状態管理
- **NotifierProvider**: 永続化対応のプロバイダ

### データ永続化
- **SharedPreferences**: ローカルキー・バリュー
- **Firebase**: クラウドデータベース

### バックエンド
- **Firebase**: 認証、Realtime DB、クラウド関数
- **Google Cloud**: プロジェクト・API管理

### 広告・マネタイズ
- **Google Mobile Ads**: AdMob 統合
- **In-App Purchases**: iOS/Android IAP

### 分析
- **Firebase Analytics**: 利用者行動分析

---

## 📈 X. 実装順序の推奨

新しい教科版アプリを開発する場合の推奨順序:

1. **ユーザー・プロフィール** (1-2)
2. **マネタイゼーション基盤** (3-6)
3. **UI・UXコンポーネント** (16-22)
4. **学習進捗トラッキング** (7-8)
5. **ゲーミフィケーション** (11-15)
6. **親向け機能** (10, 親ダッシュボード)
7. **認証・バックエンド** (23-25)
8. **教科固有の学習コンテンツ**

---

## 🎓 XI. 統合可能なコンポーネント

以下のコンポーネントは **shared_core** に統合されることが推奨:

- プロフィール管理システム
- コイン・購入システム
- バッジ・達成管理
- Firebase 統合
- IAP トラッキング
- リーダーボード
- アバター・キャラクターモデル

---

## 📝 注記

- **Firebase 設定**: 各アプリで独立した Google Cloud プロジェクトが必要
- **IAP 設定**: Google Play Console / App Store Connect での設定必須
- **データ互換性**: 教科間でデータ共有が必要な場合は shared_core で管理
- **UI カスタマイズ**: テーマ・色は教科ごとにカスタマイズ可能

