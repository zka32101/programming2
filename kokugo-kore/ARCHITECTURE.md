# アーキテクチャ設計書

国語コレ！のシステムアーキテクチャを説明しています。

## 📐 全体構造

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (Screens & Widgets)                   │
│  ・home_screen.dart                     │
│  ・quest_screen.dart                    │
│  ・result_screen.dart                   │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│         State Management Layer           │
│  (Riverpod Providers)                  │
│  ・gradeProvider                        │
│  ・progressProvider                     │
│  ・badgeProvider                        │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│         Data Layer                      │
│  (Models & Persistence)                │
│  ・shared_preferences                   │
│  ・LocalStorage                         │
└─────────────────────────────────────────┘
```

## 🎯 レイヤー設計

### 1. Presentation Layer（プレゼンテーション層）

ユーザーが見るUI・ユーザー操作を処理します。

#### Screens（画面）
```
screens/
├── splash_screen.dart          # アプリ起動時のスプラッシュ画面
├── onboarding_screen.dart      # 初期設定（学年選択）
├── home_screen.dart            # ホーム・ダッシュボード
├── stage_select_screen.dart    # ステージ選択
├── quest_screen.dart           # クイズ出題
├── result_screen.dart          # 結果表示
├── badge_screen.dart           # バッジコレクション
└── settings_screen.dart        # 設定
```

#### Widgets（再利用可能な部品）
```
widgets/
├── stage_card.dart             # ステージカードUI
├── badge_widget.dart           # バッジ表示UI
└── daily_mission_card.dart     # デイリーミッションカード
```

**特徴:**
- StatelessWidget を優先
- ConsumerWidget（Riverpod統合）で状態読み込み
- プライベートクラス（`_WidgetName`）で局所的なUIを定義

### 2. State Management Layer（状態管理層）

アプリケーションの状態を一元管理します。

#### Riverpod Providers

```dart
// ============================================
// GradeProvider - 学年選択状態
// ============================================
final gradeProvider = NotifierProvider<GradeNotifier, int>(
  GradeNotifier.new,
);

class GradeNotifier extends Notifier<int> {
  @override
  int build() => 1;  // デフォルト1年生
  
  Future<void> load() async { }      // 保存済みの学年を読み込み
  Future<void> setGrade(int grade) async { }  // 学年を変更・保存
}

// ============================================
// ProgressProvider - 学習進捗管理
// ============================================
final progressProvider = NotifierProvider<ProgressNotifier, LearningProgress>(
  ProgressNotifier.new,
);

class LearningProgress {
  final Set<String> clearedStageIds;     // クリア済みステージID
  final int streakDays;                  // 連続学習日数
  final DateTime? lastStudyDate;         // 最後の学習日
  final int totalCorrect;                // 総正解数
  final int totalKanjiCorrect;           // 漢字分野正解数
  final int totalReadingCorrect;         // 読解分野正解数
  final int maxStageCleared;             // 最高クリアステージ
  final int perfectStageCount;           // パーフェクトクリア数
}

// ============================================
// BadgeProvider - バッジ管理
// ============================================
final badgeProvider = NotifierProvider<BadgeNotifier, BadgeState>(
  BadgeNotifier.new,
);

class BadgeState {
  final List<EarnedBadge> earnedBadges;   // 獲得済みバッジ
  final List<BadgeModel> newlyEarned;     // 直近獲得バッジ
}
```

**設計原則:**
- Notifier パターンで状態を管理
- ビジネスロジックはプロバイダーに
- UI は状態の変化に反応（`ref.watch`）

### 3. Data Layer（データ層）

永続化とデータアクセスを担当します。

#### Models（データモデル）
```dart
// ========== Quiz Models ==========
enum QuizType { kanji, reading }

class QuizQuestion {
  String id;              // 問題ID
  QuizType type;          // 問題のタイプ
  int grade;              // 対象学年
  String question;        // 問題文
  String? context;        // 読解文章（読解タイプのみ）
  List<String> choices;   // 選択肢（通常4択）
  int correctIndex;       // 正解のインデックス
  String explanation;     // 解説
  String? kanjiChar;      // 漢字（漢字タイプのみ）
}

class Stage {
  int stageNumber;        // ステージ番号
  String title;           // ステージタイトル
  int grade;              // 学年
  QuizType quizType;      // クイズタイプ
  List<QuizQuestion> questions;  // 問題のリスト
}

class QuestResult {
  int correctCount;       // 正解数
  int totalCount;         // 全問題数
  Duration elapsed;       // 所要時間
  
  int score;              // スコア（計算プロパティ）
  bool isPerfect;         // 満点か（計算プロパティ）
  bool isPassed;          // 合格か（計算プロパティ）
}

// ========== Badge Models ==========
enum BadgeCategory { streak, score, kanji, reading, special }

class BadgeModel {
  String id;              // バッジID
  String title;           // タイトル
  String description;     // 説明
  String emoji;           // 絵文字
  BadgeCategory category; // カテゴリ
  int requiredCount;      // 獲得条件
}

class EarnedBadge {
  BadgeModel badge;       // バッジ定義
  DateTime earnedAt;      // 獲得日時
}
```

#### Persistence（永続化）

**shared_preferences を使用:**

```dart
// ========== データキー定義 ==========
const _gradeKey = 'selected_grade';
const _clearedPrefix = 'stage_cleared_';
const _streakKey = 'streak_count';
const _totalCorrectKey = 'total_correct';
const _earnedPrefix = 'badge_earned_';

// ========== 保存例 ==========
final prefs = await SharedPreferences.getInstance();

// 学年を保存
await prefs.setInt(_gradeKey, 3);

// クリア済みステージを保存
await prefs.setBool('${_clearedPrefix}g3_s5', true);

// 獲得したバッジを保存
await prefs.setString('${_earnedPrefix}streak_3', now.toIso8601String());
```

#### Quiz Data（クイズデータ）
```
data/
└── quiz_data.dart       # 1132行のクイズデータ
    ├── _grade1Stages    # 小学1年生
    ├── _grade2Stages    # 小学2年生
    ├── _grade3Stages    # 小学3年生
    ├── _grade4Stages    # 小学4年生
    ├── _grade5Stages    # 小学5年生
    └── _grade6Stages    # 小学6年生
```

## 🔄 データフロー

### ユースケース1: ステージをクリアする

```
QuestScreen
   │
   ├─ User selects answer
   │
   ├─ _onChoiceTap()
   │  └─ setState(() { _selectedAnswer = index })
   │
   └─ User taps "Next" → "Result"
      │
      ResultScreen
      │
      ├─ _saveResult()
      │  │
      │  ├─ ref.read(progressProvider.notifier).recordResult(
      │  │    grade, stageNumber, correct, total, isKanji, isPerfect)
      │  │  │
      │  │  └─ ProgressNotifier
      │  │     ├─ Update state
      │  │     └─ Save to SharedPreferences
      │  │
      │  └─ ref.read(badgeProvider.notifier).checkAndAward(...)
      │     │
      │     └─ BadgeNotifier
      │        ├─ Check badge conditions
      │        ├─ Award new badges
      │        └─ Save to SharedPreferences
      │
      └─ Show result with celebration effect
```

### ユースケース2: ホーム画面を表示

```
SplashScreen
   │
   ├─ Load initial data
   │  ├─ gradeProvider.notifier.load()
   │  ├─ progressProvider.notifier.load()
   │  └─ badgeProvider.notifier.load()
   │
   └─ Navigate to HomeScreen
      │
      HomeScreen
      │
      ├─ ref.watch(gradeProvider)         ← 学年の読み込み
      ├─ ref.watch(progressProvider)      ← 進捗の読み込み
      └─ ref.watch(badgeProvider)         ← バッジの読み込み
         │
         └─ Display stats & recent badges
```

## 🎨 Theme System（テーマシステム）

```dart
// ========== カラー定義 ==========
const kPrimaryColor = Color(0xFFF39C12);    // メインオレンジ
const kPrimaryDark = Color(0xFFD68910);     // ダークオレンジ
const kAccentGreen = Color(0xFF27AE60);     // 成功：グリーン
const kAccentRed = Color(0xFFE74C3C);       // エラー：レッド
const kAccentBlue = Color(0xFF2980B9);      // 情報：ブルー

// ========== 学年グループのカラーマッピング ==========
enum GradeGroup { low, mid, high }

Color gradeColor(GradeGroup g) {
  switch (g) {
    case GradeGroup.low:  return Color(0xFFF39C12);   // 低学年：オレンジ
    case GradeGroup.mid:  return Color(0xFF27AE60);   // 中学年：グリーン
    case GradeGroup.high: return Color(0xFF2980B9);   // 高学年：ブルー
  }
}

// ========== テーマビルド ==========
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
    // ...
  );
}
```

## 🔐 セキュリティ考慮事項

### データ保護
- ✅ ローカルストレージのみ使用（ネットワーク通信なし）
- ✅ 個人情報の最小化
- ✅ shared_preferences は自動で暗号化（プラットフォーム依存）

### 入力検証
- ✅ クイズデータは静的・不変（const）
- ✅ ユーザー入力は制限されている

## 📊 State Lifecycle

```
┌─────────────────────────────────────────┐
│     App Initialization                  │
│  (SplashScreen)                        │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│  Data Loading                           │
│  progressProvider.load()               │
│  gradeProvider.load()                  │
│  badgeProvider.load()                  │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│     Main Application                    │
│  (HomeScreen & Navigation)              │
│                                        │
│  User interactions trigger state       │
│  updates via providers                 │
└─────────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│  Data Persistence                       │
│  All state changes saved to             │
│  SharedPreferences                      │
└─────────────────────────────────────────┘
```

## 🧪 テスト戦略

### Unit Tests
```
models/
├── quiz_model_test.dart          # QuizQuestion, Stage テスト
├── badge_model_test.dart         # Badge モデルテスト
└── providers_test.dart           # Notifier ロジックテスト

data/
└── quiz_data_test.dart           # クイズデータの完全性テスト
```

### Widget Tests
```
screens/
├── home_screen_test.dart         # ホーム画面表示テスト
├── quest_screen_test.dart        # クイズ画面インタラクションテスト
└── result_screen_test.dart       # 結果画面表示テスト
```

## 🚀 パフォーマンス最適化

### メモリ
- ✅ const コンストラクタの使用
- ✅ IndexedStack で画面切り替え（state 保持）
- ✅ 遅延読み込み（必要時のみ読み込み）

### 描画
- ✅ AnimatedContainer で効率的なアニメーション
- ✅ CustomScrollView + Sliver でスクロール最適化
- ✅ const ウィジェットの活用

### ストレージ
- ✅ shared_preferences は高速
- ✅ 必要最小限のデータ保存
- ✅ 非同期操作で UI ブロッキング回避

## 📝 命名規則

### ファイル名
- `snake_case.dart`（例：`home_screen.dart`）

### クラス名
- `PascalCase`（例：`HomeScreen`）
- プライベート：`_PascalCase`（例：`_CustomCard`）

### 変数名
- `camelCase`（例：`correctCount`）
- 定数：`kCamelCase`（例：`kPrimaryColor`）
- プライベート：`_camelCase`（例：`_selectedAnswer`）

### メソッド名
- `camelCase`（例：`recordResult()`）
- プライベート：`_camelCase`（例：`_saveResult()`）
- イベントハンドラー：`_onEventName`（例：`_onChoiceTap()`）

## 🔗 依存関係

```
main.dart
   ├─ app_theme.dart
   ├─ providers/
   │  ├─ grade_provider.dart
   │  ├─ progress_provider.dart
   │  └─ badge_provider.dart
   ├─ screens/
   │  └─ [各スクリーン]
   ├─ widgets/
   │  └─ [再利用ウィジェット]
   ├─ models/
   │  ├─ quest_model.dart
   │  └─ badge_model.dart
   └─ data/
      └─ quiz_data.dart
```

## 🎓 拡張方法

### 新しい機能を追加する

1. **モデルを定義**（`models/`）
2. **プロバイダーを作成**（`providers/`）
3. **画面を実装**（`screens/`）
4. **ルーティングを追加**（`main.dart`）
5. **テストを作成**（`test/`）

### 既存機能を拡張する

1. 対応するモデルを拡張
2. プロバイダーのロジックを更新
3. UIを調整
4. テストを追加

---

**このアーキテクチャは拡張性と保守性を重視して設計されています。**
