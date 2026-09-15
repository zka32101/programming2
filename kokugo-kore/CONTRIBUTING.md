# 貢献ガイドライン

国語コレ！プロジェクトへの貢献をありがとうございます。このガイドラインに従い、高品質なコードを維持してください。

## 📝 行動規範

このプロジェクトのすべての参加者に以下の行動規範を守ることをお願いします。

- 他の参加者を尊重し、敬意を持って接する
- 建設的で前向きなコミュニケーションを心がける
- 不適切な言動や嫌がらせは一切禁止

## 🐛 バグ報告

バグを発見した場合は、GitHub Issues で報告してください。

### バグ報告の際に含めるべき情報

```
## バグの説明
（バグの簡潔な説明）

## 再現手順
1. ...
2. ...
3. ...

## 期待される動作
（どのような挙動が正しいか）

## 実際の動作
（実際に起きた動作）

## スクリーンショット
（必要に応じて）

## 環境
- Flutter バージョン: 
- Dart バージョン: 
- OS: 
- デバイス:
```

## ✨ 機能提案

新しい機能の提案は GitHub Discussions で行ってください。

### 提案に含めるべき内容

- 機能の詳細な説明
- なぜこの機能が必要か
- 実装方法の提案（可能であれば）
- 期待される動作

## 🔧 開発環境の構築

### 必要な環境

- Flutter 3.11.5+
- Dart 3.11.5+
- Android SDK（Android開発の場合）
- Xcode（iOS開発の場合）

### セットアップ手順

```bash
# 1. リポジトリをクローン
git clone https://github.com/your-org/kokugo-kore.git
cd kokugo-kore

# 2. 依存関係をインストール
flutter pub get

# 3. コード生成を実行（必要な場合）
flutter pub run build_runner build

# 4. アプリを実行
flutter run
```

## 💻 コード規約

### ファイル構造

```
lib/
├── models/           # データモデル
├── screens/          # スクリーン（ページ）
├── widgets/          # 再利用可能なウィジェット
├── providers/        # Riverpod プロバイダー
├── data/             # 静的データ
├── theme/            # テーマ・スタイル定義
└── main.dart         # エントリーポイント
```

### ファイル命名規則

- **スクリーン**: `*_screen.dart`（例：`home_screen.dart`）
- **ウィジェット**: `*_widget.dart`（例：`badge_widget.dart`）
- **モデル**: `*_model.dart`（例：`quest_model.dart`）
- **プロバイダー**: `*_provider.dart`（例：`progress_provider.dart`）

### クラス命名規則

```dart
// パブリッククラス
class HomePage extends StatelessWidget { }

// プライベートウィジェット
class _CustomCard extends StatelessWidget { }

// 定数
const kPrimaryColor = Color(0xFFF39C12);
```

### コーディングスタイル

```dart
// ✅ 推奨：明示的な型指定
final List<String> names = ['Alice', 'Bob'];
final int age = 25;

// ❌ 非推奨：曖昧な型指定
final names = ['Alice', 'Bob'];
final age = 25;

// ✅ 推奨：const の積極利用
const itemCount = 10;
const SizedBox(height: 16);

// ✅ 推奨：適切なコメント
/// ユーザーの学習進捗を管理するプロバイダー
final progressProvider = NotifierProvider<ProgressNotifier, LearningProgress>(
  ProgressNotifier.new,
);

// ❌ 非推奨：不要なコメント
// progressProvider を定義
final progressProvider = ...;
```

## 📝 コミット規約

コミットメッセージは以下の形式に従ってください：

```
<type>: <subject>

<body>

<footer>
```

### タイプ

- **feat**: 新しい機能
- **fix**: バグ修正
- **refactor**: コードの改善（機能変更なし）
- **style**: コードスタイルの修正（機能変更なし）
- **test**: テストコードの追加・修正
- **docs**: ドキュメント修正
- **chore**: ビルドプロセス、依存関係の更新など

### コミットメッセージ例

```
feat: バッジシステムにダイレクトメッセージ機能を追加

- ユーザーが獲得したバッジの詳細情報をモーダルで表示
- バッジの獲得日時を記録して表示

Closes #123
```

## 🔄 プルリクエスト手順

### 1. フォークしてブランチを作成

```bash
# フォーク（初回のみ）
git clone https://github.com/YOUR-USERNAME/kokugo-kore.git
cd kokugo-kore

# ブランチ作成
git checkout -b feature/awesome-feature
```

### 2. コードを実装

```bash
# 開発中の実行
flutter run

# テストを実行
flutter test
```

### 3. コミットとプッシュ

```bash
# ステージング
git add lib/screens/awesome_screen.dart

# コミット
git commit -m "feat: 素晴らしい機能を追加"

# プッシュ
git push origin feature/awesome-feature
```

### 4. プルリクエストを作成

GitHub で以下の情報を含むプルリクエストを作成してください：

```markdown
## 説明
このプルリクエストは... を実装しています。

## タイプ
- [x] バグ修正
- [ ] 新機能
- [ ] ドキュメント更新
- [ ] リファクタリング

## チェックリスト
- [ ] コードが変更内容に従っている
- [ ] ユニットテストを追加した
- [ ] テストがパスしている
- [ ] ドキュメントを更新した
- [ ] コミットメッセージがルールに従っている

## 関連するイシュー
Closes #123
```

## 🧪 テスト

### ユニットテスト

```bash
# すべてのテストを実行
flutter test

# 特定のテストファイルを実行
flutter test test/models/quest_model_test.dart

# カバレッジレポートを生成
flutter test --coverage
```

### テストコード例

```dart
void main() {
  group('QuizQuestion', () {
    test('QuizQuestionが正しく生成される', () {
      const question = QuizQuestion(
        id: 'test_1',
        type: QuizType.kanji,
        grade: 1,
        question: 'テスト',
        kanjiChar: '試',
        choices: ['し', 'た', 'テ', 'ス'],
        correctIndex: 0,
        explanation: 'テスト説明',
      );

      expect(question.id, 'test_1');
      expect(question.grade, 1);
    });
  });
}
```

## 📚 ドキュメント

### ドキュメント生成

```bash
# API ドキュメントを生成
dartdoc
```

### コメント規約

```dart
/// ドキュメンテーションコメント（パブリック API 用）
/// 
/// 詳細な説明を書きます。
/// 
/// **例:**
/// ```dart
/// final result = calculateScore(10, 5);
/// ```
class MyClass {
  /// プロパティの説明
  final String name;

  // 通常のコメント（内部実装用）
  int _privateValue = 0;

  // TODO: 将来実装予定の機能について
  void futureFeature() { }
}
```

## 🚀 リリースプロセス

### バージョン管理

バージョンは `major.minor.patch+buildNumber` 形式を使用します：

```yaml
version: 1.0.0+1  # version: major.minor.patch+buildNumber
```

### リリース手順

1. バージョンを更新
2. CHANGELOG.md を更新
3. Pull Request を作成して承認
4. Merge
5. リリース Git タグを作成
6. GitHub Releases に公開

## 📞 質問・相談

- GitHub Issues: バグ報告、機能提案
- GitHub Discussions: 一般的な質問、アイデア交換
- メール: contact@example.com

## ✅ チェックリスト

プルリクエスト前に以下を確認してください：

- [ ] `flutter analyze` でエラーがない
- [ ] `flutter test` がパスしている
- [ ] コードをフォーマット済み（`flutter format`）
- [ ] コミットメッセージがルールに従っている
- [ ] ドキュメント/コメントを更新した
- [ ] スクリーンショット/動画を含めた（UI変更の場合）

## 🎉 貢献をありがとうございます！

プロジェクトの改善にご協力いただき、ありがとうございます。
質問や問題がある場合は、遠慮なく Issue を作成してください。
