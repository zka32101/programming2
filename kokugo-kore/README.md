# 📚 国語コレ！

**ひらがなから読解・作文まで** - 小学生向けの楽しい国語学習アプリ

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## 🎯 プロジェクト概要

「国語コレ！」は、小学1年生から6年生まで段階的に学習できる国語学習アプリです。

### ✨ 主な特徴

- 🎮 **ゲーミフィケーション** - ステージクリア、バッジ獲得、連続学習ストリーク
- 📖 **漢字学習** - 学年別の基礎漢字から実践的な問題まで
- 📚 **読解力養成** - 文章読解と記述問題で思考力をアップ
- 🏆 **バッジシステム** - 9種類のバッジで学習モチベーション維持
- 📊 **学習管理** - 進捗状況の可視化と統計情報
- 🎨 **キッズフレンドリーUI** - 直感的で楽しいデザイン
- 🔥 **ストリークシステム** - 連続学習で日々のモチベーション向上

## 🚀 クイック スタート

### 環境要件

- Flutter 3.11.5+
- Dart 3.11.5+
- iOS 12.0+
- Android 21+

### インストール手順

```bash
# リポジトリのクローン
git clone https://github.com/your-org/kokugo-kore.git
cd kokugo-kore

# 依存関係のインストール
flutter pub get

# アプリの実行
flutter run
```

### デバイス別実行

```bash
# iOS
flutter run -d iphone

# Android
flutter run -d android

# Web
flutter run -d web

# Windows
flutter run -d windows

# macOS
flutter run -d macos
```

## 📱 対応プラットフォーム

| プラットフォーム | サポート状況 |
|---------------|-----------|
| iOS | ✅ 対応 |
| Android | ✅ 対応 |
| Web | ✅ 対応 |
| Windows | ✅ 対応 |
| macOS | ✅ 対応 |
| Linux | ✅ 対応 |

## 📚 主要機能

### 1️⃣ 学習機能

#### ステージシステム
- **小学1年生**: ひらがな基礎、簡単な文章読解
- **小学2年生**: カタカナ導入、語彙拡張
- **小学3年生**: 漢字本格化、物語読解
- **小学4年生**: 複雑な漢字、説明文読解
- **小学5年生**: 高度な漢字、多様なジャンル読解
- **小学6年生**: 難易度の高い問題、作文準備

#### 問題タイプ
- **漢字クイズ** 📖 - 読み方、使い方、意味の理解
- **読解問題** 📚 - 文章理解、内容把握、論理的思考

### 2️⃣ バッジシステム

9種類のバッジを獲得して目標達成を目指そう：

| バッジ | 条件 | カテゴリ |
|------|-----|--------|
| 🔥 3日連続！ | 3日連続学習 | ストリーク |
| ⚡ 7日連続！ | 7日連続学習 | ストリーク |
| 🏆 継続力マスター | 30日連続学習 | ストリーク |
| 📖 はじめての漢字 | 漢字1問正解 | 漢字 |
| 🎓 漢字博士 | 漢字10問正解 | 漢字 |
| 📚 はじめての読解 | 読解1問正解 | 読解 |
| ⭐ 満点！ | ステージで全問正解 | スコア |
| 🌟 ステージ5達成 | ステージ5クリア | 特別 |
| 👑 マスター！ | ステージ10クリア | 特別 |

### 3️⃣ 学習進捗管理

- 📈 **学習統計** - 正解数、学習日数、ストリーク
- 🎯 **ステージ進捗** - クリア状況、成績表
- 🏅 **バッジコレクション** - 獲得バッジの確認と表示

## 🏗️ プロジェクト構造

```
lib/
├── main.dart                 # アプリケーション エントリーポイント
├── models/
│   ├── quest_model.dart     # クイズ・ステージのデータモデル
│   └── badge_model.dart     # バッジシステムのモデル
├── screens/
│   ├── splash_screen.dart   # スプラッシュ画面（初期ロード）
│   ├── onboarding_screen.dart # 初期設定画面（学年選択）
│   ├── home_screen.dart     # ホーム画面（ダッシュボード）
│   ├── stage_select_screen.dart # ステージ選択画面
│   ├── quest_screen.dart    # クイズ出題画面
│   ├── result_screen.dart   # 結果表示画面
│   ├── badge_screen.dart    # バッジコレクション画面
│   └── settings_screen.dart # 設定画面
├── widgets/
│   ├── stage_card.dart      # ステージカードUI
│   ├── badge_widget.dart    # バッジディスプレイUI
│   └── daily_mission_card.dart # デイリーミッションカード
├── providers/               # Riverpod 状態管理
│   ├── grade_provider.dart  # 学年選択状態
│   ├── progress_provider.dart # 学習進捗状態
│   └── badge_provider.dart  # バッジ獲得状態
├── data/
│   └── quiz_data.dart       # 1132行のクイズデータ（全学年対応）
└── theme/
    └── app_theme.dart       # UIテーマ・カラー定義
```

## 🔧 技術スタック

### フレームワーク
- **Flutter** - マルチプラットフォーム UI フレームワーク
- **Material Design 3** - Google の最新デザインシステム

### 状態管理
- **Riverpod** (2.6.1) - 次世代の状態管理ソリューション
- 特徴：型安全、テスト容易、プロバイダーベース

### ローカルストレージ
- **shared_preferences** (2.3.0) - キー・バリューストレージ
- 用途：ユーザー設定、学習記録の永続化

### その他のパッケージ
- **intl** (0.19.0) - 国際化・ローカライゼーション
- **confetti** (0.8.0) - パーティクルアニメーション（成功演出）
- **cupertino_icons** (1.0.8) - iOS スタイルのアイコン

## 📊 状態管理アーキテクチャ

### GradeProvider
```dart
// 現在の学年を管理
final gradeProvider = NotifierProvider<GradeNotifier, int>(GradeNotifier.new);
```

### ProgressProvider
```dart
// 学習進捗を管理
// - クリアしたステージ
// - 連続学習日数
// - 総正解数
// - 各分野別正解数
final progressProvider = NotifierProvider<ProgressNotifier, LearningProgress>(ProgressNotifier.new);
```

### BadgeProvider
```dart
// バッジ獲得状態を管理
// - 獲得済みバッジ
// - 獲得日時記録
final badgeProvider = NotifierProvider<BadgeNotifier, BadgeState>(BadgeNotifier.new);
```

## 🎨 デザインシステム

### カラーパレット

| 色 | 用途 | 値 |
|----|------|------|
| Primary Orange | メインカラー | `#F39C12` |
| Primary Dark | ダークカラー | `#D68910` |
| Accent Green | 成功・OK | `#27AE60` |
| Accent Red | エラー・NG | `#E74C3C` |
| Accent Blue | 情報・補足 | `#2980B9` |

### 学年グループのカラーリング
```dart
enum GradeGroup { low, mid, high }

// 低学年（1-2年） -> Orange (#F39C12)
// 中学年（3-4年） -> Green (#27AE60)
// 高学年（5-6年） -> Blue (#2980B9)
```

## 📐 画面フロー

```
Splash
   ↓
Onboarding (学年選択)
   ↓
Home (ダッシュボード)
   ├→ Stages (ステージ選択)
   │   ├→ Quest (クイズ)
   │   └→ Result (結果)
   ├→ Badges (バッジ)
   └→ Settings (設定)
```

## 🧪 テスト

### ユニットテストの実行
```bash
flutter test
```

### ウィジェットテストの実行
```bash
flutter test test/widget_test.dart
```

### 統合テストの実行
```bash
flutter test integration_test
```

## 📦 ビルド・デプロイ

### 🚀 自動ビルド（GitHub Actions）

このプロジェクトは GitHub Actions による自動ビルド・デプロイパイプラインに対応しています。

**詳細ガイド**: [`yourwish/docs/build-ci-cd-guide.md`](https://github.com/zka32101/yourwish/blob/master/docs/build-ci-cd-guide.md)

#### トリガー条件
- ✅ `claude/**` ブランチへの push
- ✅ Pull Request (main/develop)
- ✅ 手動実行 (workflow_dispatch)
- ✅ 週1回スケジュール実行

#### 自動実行内容
1. **コード分析・テスト** - `flutter analyze`, `flutter test`
2. **Android ビルド** - APK/AAB 生成
3. **iOS ビルド** - IPA 生成 (unsigned)
4. **ビルドサマリー** - 結果集計

#### ワークフローファイル
- `.github/workflows/build-apk.yml` - 基本ビルド
- `.github/workflows/deploy.yml` - 本番デプロイ
- テンプレート: [`yourwish/.github/workflows/build-template.yml`](https://github.com/zka32101/yourwish/blob/master/.github/workflows/build-template.yml)

---

### 💻 ローカルビルド

#### APK生成（Android）
```bash
flutter build apk --release
```

#### iOS IPA生成
```bash
flutter build ios --release
```

#### Web リリースビルド
```bash
flutter build web --release
```

---

### 📚 SessionStart Hook（自動初期化）

Claude Code セッション起動時に自動的に以下を実行：
- `flutter pub get` - 依存関係インストール
- `flutter analyze` - コード分析

設定ファイル: `.claude/hooks/session-start.sh`

---

### 🧪 build-and-test スキル（6観点テスト）

```bash
/build-and-test kokugo-kore
```

**テスト観点**:
1. 起動テスト
2. 接続テスト
3. 課金画面
4. 認証フロー
5. 広告表示
6. クラッシュ検出

## 🐛 トラブルシューティング

### キャッシュクリア
```bash
flutter clean
flutter pub get
```

### ホットリロードが動作しない場合
```bash
# ホットリスタート
r  # ホットリロード
R  # ホットリスタート
```

## 📋 コンベンション

### ファイル命名規則
- スクリーン: `*_screen.dart`
- ウィジェット: `*_widget.dart`
- モデル: `*_model.dart`
- プロバイダー: `*_provider.dart`

### クラス命名規則
- プライベートウィジェット: `_PascalCase`
- パブリッククラス: `PascalCase`

### 変数命名規則
- 定数: `kCamelCase` (例: `kPrimaryColor`)
- グローバル: `_privateCamelCase`

## 🤝 貢献ガイドライン

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 ライセンス

このプロジェクトは MIT ライセンスの下でライセンスされています。詳細は [LICENSE](LICENSE) ファイルを参照してください。

## 👨‍💻 開発者

- **開発者**: Your Name
- **バージョン**: 1.0.0
- **最終更新**: 2025年5月

## 📞 サポート

問題が発生した場合は、GitHub Issues で報告してください。

---

**楽しい学習を！📚✨**
