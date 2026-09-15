# 国語コレ！ — Claude Code 開発ガイド

## 📱 プロジェクト概要

**小学コレ！国語** は、小学3～4年生が日本語の音読・文法・漢字を楽しく学べるアプリです。ゲーミフィケーション要素を備えており、学習を習慣化させることを目指しています。

- **アプリ名**: 国語コレ！(kokugo-kore)
- **対象**: 小学3～4年生の国語学習
- **スタック**: Flutter 3.11.5+ / Riverpod 2.6.x / Firebase / RevenueCat
- **ステータス**: ✅ v1.0 リリース中 / 🔄 v1.1 開発中
- **ソース**: `H:\マイドライブ\apps\kokugo-kore`

## ✅ 実装済み機能

### Phase 1: 基本学習機能
| 機能 | 状態 | 詳細 |
|---|---|---|
| ユニット別クイズ | ✅ | 音読・文法・漢字問題 |
| 進捗管理 | ✅ | SharedPreferences + Hive ローカル永続化 |
| ユーザープロフィール | ✅ | 学年・名前設定 |
| ふりがな表示 | ✅ | FuriganaText widget 全問題対応 |

### Phase 2: ゲーミフィケーション
| 機能 | 状態 | ファイル |
|---|---|---|
| ポイント/コイン | ✅ | `lib/providers/coin_provider.dart` |
| バッジシステム | ✅ | shared_core BadgeNotifier（10個バッジ） |
| キャラクター育成 | ✅ | shared_core CharacterNotifier（16体） |
| ローカルランキング | ✅ | SharedPreferences 登録 |
| デイリーチャレンジ | ✅ | 毎日更新ミッション |

### Phase 3: UI/UX・課金
| 機能 | 状態 | 詳細 |
|---|---|---|
| テーマ（ライト/ダーク） | ✅ | ThemeProvider 統合 |
| Google Mobile Ads | ✅ | バナー・インタースティシャル広告 |
| RevenueCat 統合 | ✅ | 月額¥120 サブスク対応 |
| 領収書検証 | ✅ | Google Play/App Store API |

## 🛠️ セットアップ手順

### 初回セットアップ
```bash
cd /home/user/kokugo-kore
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Firebase 設定
1. Firebase コンソール（https://console.firebase.google.com）でプロジェクト作成
2. ファイル配置:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

### RevenueCat 設定（v1.1 必須）
1. RevenueCat ダッシュボード（https://dashboard.revenuecat.com）でアプリ作成
2. `lib/config/constants.dart` に API キーを設定:
   ```dart
   const String REVENUE_CAT_API_KEY = 'your_api_key_here';
   ```

## 🏗️ ディレクトリ構成

```
lib/
├── config/                      # theme, constants, Firebase設定
│   ├── theme.dart              # Material Design 3 テーマ
│   ├── constants.dart          # アプリ定数
│   └── firebase_config.dart    # Firebase 設定
├── models/
│   ├── quiz_model.dart         # クイズデータモデル
│   ├── user_progress.dart      # 進捗モデル
│   └── character_model.dart    # キャラクターモデル
├── providers/                  # Riverpod StateNotifier
│   ├── progress_provider.dart  # 進捗管理
│   ├── profile_provider.dart   # ユーザープロフィール
│   ├── coin_provider.dart      # ポイント管理
│   ├── character_provider.dart # キャラクター育成
│   └── ads_provider.dart       # 広告管理
├── screens/                    # UI 画面
│   ├── home_screen.dart
│   ├── quiz_screen.dart
│   ├── progress_screen.dart
│   ├── character_screen.dart   # → shared_core CharacterCollectionPage
│   └── shop_screen.dart        # → shared_core CoinShopPage
├── services/
│   ├── firebase_service.dart
│   ├── revenue_cat_service.dart
│   └── analytics_service.dart
├── widgets/                    # 再利用可能な UI コンポーネント
│   ├── quiz_widgets.dart
│   ├── common_widgets.dart
│   └── furigana_text.dart      # ふりがな対応テキスト
├── data/
│   ├── stage_data.dart         # クイズ問題データ
│   └── kokugo_characters.dart  # キャラクター定義
└── main.dart
```

## 🔧 技術スタック

- **Flutter**: 3.11.5+
- **State Management**: Riverpod 2.6.x StateNotifier
- **Backend**: Firebase Firestore, Authentication
- **In-app Purchase**: RevenueCat SDK
- **Ad Network**: Google Mobile Ads (AdMob)
- **Persistence**: SharedPreferences + Hive
- **UI**: Material Design 3
- **Package**: shared_core（git dependency）

## 🔄 Riverpod パターン

### StateNotifierProvider（進捗管理）
```dart
final progressProvider = StateNotifierProvider<ProgressNotifier, ProgressState>((ref) {
  return ProgressNotifier();
});

class ProgressNotifier extends StateNotifier<ProgressState> {
  void completeQuiz(String quizId, int score) {
    // 進捗を更新
    state = state.copyWith(
      completedQuizzes: {...state.completedQuizzes, quizId: score}
    );
  }
}
```

### 画面での使用
```dart
// 進捗を監視
final progress = ref.watch(progressProvider);

// 進捗を更新
ref.read(progressProvider.notifier).completeQuiz(quizId, score);
```

## 📊 SharedPreferences キー命名規則

```dart
// 形式: 'kokugo_[feature]_[name]'
'kokugo_quiz_total_completed'      // 完了クイズ数
'kokugo_quiz_total_score'          // 総スコア
'kokugo_badge_earned'              // 獲得バッジ
'kokugo_character_equipped'        # 装備キャラ
'kokugo_daily_streak'              # 連続学習日数
```

## 💳 課金・セキュリティ

### サブスクリプション実装（v1.1）
- **SDK**: RevenueCat（ベンダー中立的な決済管理）
- **商品**: `kokugo_premium_monthly` (¥120/月)
- **領収書検証**: Google Play Billing Library + App Store Server API
- **実装ファイル**: `lib/services/revenue_cat_service.dart`

```dart
// 領収書検証の例
final isValid = await revenueCatService.isSubscribed();
```

### API キー管理
```bash
# .env ファイル（ローカルのみ、コミット禁止）
FIREBASE_PROJECT_ID=kokugo-xxx
REVENUE_CAT_API_KEY=appl_xxxx
ADMOB_ANDROID_ID=ca-app-pub-xxxx

# CI/CD 環境（GitHub Secrets）
# → REVENUE_CAT_API_KEY, ADMOB_IDS など管理
```

### セキュリティベストプラクティス
- ✅ APIキーは環境変数で管理（コード直書き禁止）
- ✅ 領収書検証は本番環境で必須
- ✅ COPPA準拠（子ども情報最小化）
- ✅ データ暗号化（SharedPreferences → Hive に段階的移行）

## 🚀 ビルド・テスト手順

### 初回セットアップ（ホスト依存）
```bash
# 前提条件
# - Flutter 3.11.5+ インストール
# - Android SDK (NDK含む) インストール
# - Java 17 インストール

flutter doctor -v  # 環境確認
```

### ローカルテスト
```bash
# ホットリロード（開発中）
flutter run -v

# デバッグビルド
flutter build apk --debug
flutter build ios --debug

# テスト実行
flutter test

# コード分析
flutter analyze
```

### APKビルド（日本語パス対策）

プロジェクトパスに日本語が含まれるため、以下の手順で回避する。

#### 1. K: ドライブを割り当て（毎セッション初回のみ）

```powershell
subst K: "H:\マイドライブ\apps\kokugo-kore"
```

#### 2. ビルド実行（K: ドライブから）

リリース署名用のパスワードはリポジトリに含めず環境変数で渡す（`android/app/build.gradle.kts` 参照）。`KEYSTORE_PASSWORD` / `KEY_PASSWORD` は初回に設定しておけばセッション中は保持される。

```bash
cd K:/ && JAVA_HOME="C:/Program Files/Android/Android Studio/jbr" PATH="$JAVA_HOME/bin:$PATH" KEYSTORE_PASSWORD="<release_new.jksのストアパスワード>" KEY_PASSWORD="<kokugo_releaseのキーパスワード>" flutter build apk --release --no-pub
```

#### 3. APKの出力先

- ビルド成果物: `K:\build\app\outputs\flutter-apk\app-release.apk`
- 自動コピー先: `H:\マイドライブ\apps\kokugo-kore\apk\app-release.apk`

> **注意:** `flutter build apk` を含む Bash コマンドが成功すると、PostToolUse フックが自動的に `apk/` フォルダへコピーする。

### リリースビルド
```bash
# Android AAB（Google Play）
flutter build appbundle --release

# iOS（App Store）
flutter build ios --release
```

### Webビルド（検証用）

パス問題なしで使用可能:

```bash
flutter build web
```

## ⚠️ よくあるエラーと対処法

| エラー | 原因 | 解決方法 |
|--------|------|--------|
| `firebase_core not initialized` | Firebase 初期化失敗 | `main.dart` で `Firebase.initializeApp()` を待つ |
| `Riverpod state not watched` | Provider 参照ミス | `ref.watch()` 使用（`ref.read()` でなく） |
| `RevenueCat not connected` | SDK 初期化失敗 | ネットワーク接続・API キー確認 |
| `Ad Unit ID invalid` | テスト用 ID のまま | 本番 ID に変更 |
| `日本語パス問題` | Kotlin コンパイラエラー | K: ドライブ割り当て実行 |

## 🌳 Git ブランチ構成

```
main (v1.0 stable)
  ↓
develop
  ├─ feature/revenue-cat-integration  (v1.1 開発中 ← 現在地)
  ├─ feature/analytics-setup
  └─ feature/social-multiplayer (v1.2 計画中)
```

## 📝 日本語パス問題の背景

- `H:\マイドライブ\` の日本語文字が Kotlin コンパイラ・CMake の JSON 生成時に壊れる
- `subst K:` による仮想ドライブ割り当てで回避
- `android/gradle.properties` に `android.overridePathCheck=true` 追加済み
- `android/settings.gradle.kts` でビルドディレクトリを `C:/kokugo-build/` に変更済み

## 🎮 Phase 4: ゲーミフィケーション統一工事（v2.2 計画中）

### 背景
7つの小学コレシリーズアプリ（国語・算数・理科・英語・社会・プログラミング・道徳）が各自独立したゲーミフィケーション実装を持っているため、ユーザー体験が統一されていない。`shared_core` パッケージを活用して、全アプリで一貫したシステムを導入する計画。

### 実装予定機能

#### 1. キャラクターシステム統一 🎨
- **現状**: 各アプリが独自キャラセット（3Dモデル or Emoji）
- **統一案**: shared_core の `Character` モデルに統一
- **実装内容**:
  - キャラ取得: ステージ進捗のティア別に解放
  - キャラ育成: 経験値・レベルアップシステム
  - キャラ装着: ホーム画面・進捗画面で表示

#### 2. バッジシステム統一 🏆
- **現状**: 各アプリが 10-16 個の独立バッジ
- **統一案**: shared_core の `Badge` モデルに統一
- **実装内容**:
  - バッジ定義: 60+ 個の共通バッジライブラリ（教科別・スキル別）
  - 獲得条件: ステージクリア・連続学習・スコア達成
  - UI: 統一バッジ表示ウィジェット

#### 3. ランキング＆フレンド機能 👥
- **現状**: 算数のみローカルランキング実装
- **統一案**: Firestore ベースのマルチアプリランキング
- **実装内容**:
  - グローバルランキング: 7アプリ合計スコア
  - 教科別ランキング: 各教科ごと
  - フレンド機能: ユーザーID検索・友達登録・プライベートランキング

#### 4. サブスクリプション統一 💳
- **現状**: 社会アプリのみ RevenueCat 実装
- **統一案**: 全アプリ RevenueCat 統合
- **実装内容**:
  - 月額プラン: ¥120（全アプリ共通）
  - プレミアム機能: 無制限クイズ・AI相談・広告削除
  - 領収書検証: Google Play/App Store API

#### 5. 学習レポート&保護者ゲート 📊
- **現状**: 一部アプリのみ実装
- **統一案**: 統一フォーマットで全アプリに展開
- **実装内容**:
  - 日次学習時間・正答率
  - 週次グラフ（fl_chart）
  - 月次分析レポート（保護者向け）

#### 6. デイリーミッション＆リワード 🎁
- **現状**: 一部アプリのみ実装
- **統一案**: 共通ミッションシステム
- **実装内容**:
  - デイリーチャレンジ: 日替わり（3問正解など）
  - ウィークリーボーナス: 7日連続達成
  - マンスリーイベント: 期間限定ミッション

### 実装ロードマップ

| フェーズ | 内容 | 優先度 | 予定月 |
|---|---|---|---|
| 4.1 | shared_core キャラ・バッジ統一 | 🥇 | 10月 |
| 4.2 | 全アプリ RevenueCat 統合 | 🥇 | 10月 |
| 4.3 | マルチアプリランキング（Firestore） | 🥈 | 11月 |
| 4.4 | フレンド機能（ユーザー検索・申請） | 🥈 | 11月 |
| 4.5 | デイリーミッション統一 | 🥉 | 12月 |
| 4.6 | 保護者ゲート・スクリーンタイム制限 | 🥉 | 12月 |

## 📚 重要ファイル参考

| ファイル | 説明 |
|---------|------|
| `lib/main.dart` | アプリエントリーポイント（Firebase、サービス初期化） |
| `lib/config/theme.dart` | Material Design 3 テーマ |
| `lib/models/quiz_model.dart` | クイズデータモデル |
| `lib/providers/progress_provider.dart` | 進捗管理（コア） |
| `lib/screens/quiz_screen.dart` | クイズ表示画面 |
| `lib/data/stage_data.dart` | クイズ問題データ（大規模） |

## 🔍 デバッグ・確認コマンド

```bash
# 環境確認
flutter doctor -v

# 依存関係の問題診断
flutter pub get

# Lint エラー確認
flutter analyze

# テスト実行
flutter test

# ホットリロード（開発時）
flutter run -v
# 実行中に 'r' で hot reload, 'R' で hot restart
```

## ✅ チェックリスト（新規機能追加）

- [ ] Model を定義、テスト作成
- [ ] Provider で状態管理を実装
- [ ] Screen/Widget で UI 実装
- [ ] SharedPreferences 連携確認
- [ ] UI テスト実装
- [ ] エラーハンドリング追加
- [ ] flutter analyze でエラーなし

## 📊 実装状況（2026-09-09）

### v1.0（リリース中）
- ✅ 基本クイズ・進捗管理
- ✅ ゲーミフィケーション（ポイント・バッジ・キャラ）
- ✅ 広告システム統合

### v1.1（開発中）
- ✅ RevenueCat SDK 接続
- ✅ サブスク商品登録
- ✅ 領収書検証 API
- 🔄 Analytics 統合（準備中）

### v1.2（計画中）
- ⏳ マルチプレイ対応
- ⏳ フレンド機能
- ⏳ オンラインランキング

---

**最終更新**: 2026-09-09  
**ステータス**: ✅ v1.0 リリース中 / 🔄 v1.1 開発中
