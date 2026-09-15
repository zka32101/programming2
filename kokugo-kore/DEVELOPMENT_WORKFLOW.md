# 🎯 バッジシステム開発・テスト・APK ビルド ワークフロー

このドキュメントは、バッジシステムの実装から APK ビルド、テストまでの完全なワークフローをまとめたものです。

---

## 📅 開発フェーズ概要

| フェーズ | 期間 | 内容 | 成果物 |
|---------|------|------|--------|
| **Phase 1-5** | Week 1-2 | バッジシステム基礎実装 | データモデル、プロバイダー、基本UI |
| **Phase 3-1～3-4** | Week 2 | 追加機能実装 | 通知、アニメーション、ダイアログ、図鑑 |
| **Phase 4** | Week 2-3 | UI ポーランド | アニメーション最適化、ビジュアル改善 |
| **コードレビュー** | Week 3 | 品質検査 | バグ修正（6項目） |
| **バグ修正** | Week 3 | ポーランド | メモリリーク、ダークモード、レスポンシブ |
| **テスト実装** | Week 3 | テストカバレッジ | 統合テスト（9+2ケース） |
| **APK ビルド準備** | Week 3 | 自動化 | GitHub Actions, PowerShell, ガイドドキュメント |

---

## 🔧 開発ワークフロー（詳細）

### **Step 1: ブランチ作成と開発環境準備**

```bash
# 指定ブランチで開発開始
git checkout -b claude/apk-build-b3xkbd origin/main

# 依存関係をインストール
flutter pub get

# コードを確認
flutter analyze
```

### **Step 2: バッジシステム実装**

**実装順序:**
1. **モデル層定義** (`lib/models/`)
   - `badge_model.dart` - バッジデータ構造
   - `badge_set_bonus_model.dart` - セットボーナス
   - `badge_acquisition_history.dart` - 獲得履歴

2. **プロバイダー実装** (`lib/providers/`)
   - `badge_provider.dart` - バッジ状態管理
   - `badge_acquisition_history_provider.dart` - 履歴管理
   - `badge_cache_provider.dart` - パフォーマンス最適化

3. **UI ウィジェット実装** (`lib/widgets/`)
   - `badge_achievement_notification.dart` - 獲得通知
   - `set_bonus_completion_screen.dart` - セット完成演出
   - `badge_detail_dialog.dart` - バッジ詳細表示
   - `badge_encyclopedia.dart` - バッジ図鑑

### **Step 3: コードレビュー実行**

```bash
# コード静的解析
flutter analyze

# 高難度コードレビューを実行
# /code-review high
```

**検査項目:**
- ✅ Null Safety & 型安全性
- ✅ Riverpod統合
- ✅ データ永続化
- ✅ UI/UX テスト項目
- ✅ アニメーション
- ✅ Firebase統合
- ✅ エッジケース

### **Step 4: バグ修正**

検出されたバグを修正：

**修正例:**
```dart
// Issue: メモリリーク
// 修正: Timer を dispose() でキャンセル

late Timer? _dismissTimer;

@override
void dispose() {
  _dismissTimer?.cancel();  // ← 追加
  super.dispose();
}
```

### **Step 5: ダークモード・レスポンシブ対応**

```dart
// ダークモード判定
final isDarkMode = Theme.of(context).brightness == Brightness.dark;

// レスポンシブレイアウト
final crossAxisCount = constraints.maxWidth > 600 ? 6 : 4;
```

### **Step 6: テスト実装**

**テストファイル構成:**

```
test/
├── badge_encyclopedia_test.dart         # 9個のテストケース
├── badge_detail_dialog_test.dart        # 9個のテストケース
├── set_bonus_completion_screen_test.dart # 8個のテストケース
└── integration_test/
    └── badge_system_e2e_test.dart       # (推奨) E2E テスト
```

**テスト実行:**
```bash
flutter test
```

### **Step 7: パフォーマンス計測**

```dart
// パフォーマンスプロファイラーの使用
final profiler = PerformanceProfiler();

// 非同期処理の計測
await profiler.measure('badge_load', () => loadBadges());

// 統計情報を表示
profiler.printReport();
```

### **Step 8: GitHub Actions ワークフロー設定**

**セットアップ手順:**

1. **GitHub Secrets 登録**（リポジトリ Settings → Secrets and variables）

   ```
   - ANDROID_KEYSTORE_BASE64 = (Base64エンコードされたkeystore)
   - ANDROID_KEYSTORE_PASSWORD = (パスワード)
   - ANDROID_KEY_PASSWORD = (キーパスワード)
   ```

2. **ワークフロー実行**

   ```
   GitHub → Actions → Build Android APK
   → Run workflow → build_type = "release"
   ```

3. **成果物ダウンロード**

   ```
   Actions → Artifacts → apk-release
   ```

### **Step 9: APK ビルド実行**

**オプション A: GitHub Actions（推奨）**
```
[GitHub Actions から実行] → ビルド完了 → Artifacts から APK ダウンロード
```

**オプション B: Windows ローカル実行**
```powershell
.\build-apk.ps1 -KeystorePassword "<pwd>" -KeyPassword "<pwd>"
```

### **Step 10: 実機テスト**

```bash
# 実機へのインストール
adb install -r app-release.apk

# テスト項目
- バッジ獲得通知が表示される
- セットボーナス完成演出が表示される
- ダークモードで表示が適切
- 横画面でレスポンシブ対応
- 低メモリデバイスで動作
```

### **Step 11: コミット・プッシュ**

```bash
# ステージング
git add .

# コミット（Attribution 付き）
git commit -m "feat: implement badge system with complete test coverage

[詳細な変更内容]

Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>"

# プッシュ
git push -u origin claude/apk-build-b3xkbd
```

### **Step 12: プルリクエスト作成**

自動的に PR が作成される（または手動で作成）

```
PR #16: APK ビルド自動化とバッジシステム完成
```

---

## 📊 チェックリスト

### **開発チェックリスト**
- [ ] バッジシステムのすべてのモデルを実装
- [ ] プロバイダーの状態管理を完成
- [ ] UI ウィジェットをすべて実装
- [ ] アニメーションのタイミングを最適化
- [ ] データ永続化（SharedPreferences）を実装

### **テストチェックリスト**
- [ ] `flutter analyze` でエラーなし
- [ ] `flutter test` ですべてのテスト成功
- [ ] UI/UX テスト（4項目以上）
- [ ] パフォーマンス計測完了
- [ ] エッジケーステスト完了

### **ビルドチェックリスト**
- [ ] GitHub Secrets を登録
- [ ] ワークフローの実行確認
- [ ] APK ファイルの生成確認
- [ ] 実機へのインストール成功
- [ ] 機能動作確認完了

### **コードレビューチェックリスト**
- [ ] 高難度コードレビュー実行
- [ ] 検出されたバグをすべて修正
- [ ] ユニットテストカバレッジ確認
- [ ] パフォーマンス問題なし

---

## 🔍 デバッグ・トラブルシューティング

### **よくある問題と解決方法**

| 問題 | 原因 | 解決策 |
|------|------|--------|
| コンパイルエラー（context undefined） | StatelessWidget で context 参照 | BuildContext をパラメータで渡す |
| メモリリーク | Timer や Future.delayed が破棄されない | dispose() で cancel() を呼び出す |
| ダークモード表示崩れ | hard-coded カラー使用 | Theme.of(context).brightness で判定 |
| 横画面で見切れ | GridView の crossAxisCount hard-coded | LayoutBuilder で動的に調整 |
| APK ビルドエラー | 日本語パス問題 | K: ドライブ割り当てで回避 |

### **パフォーマンスプロファイリング**

```dart
// CPU 使用率計測
final stopwatch = Stopwatch()..start();
// 処理実行
stopwatch.stop();
debugPrint('Duration: ${stopwatch.elapsedMilliseconds}ms');
```

**ベンチマーク目標:**
- バッジ図鑑初期化: < 200ms
- グリッド描画: 60fps 維持
- セット完成演出: 85% CPU 以下

---

## 📚 参考ドキュメント

| ドキュメント | 用途 |
|------------|------|
| `APK_BUILD_GUIDE.md` | Windows APK ビルド手動手順 |
| `GITHUB_ACTIONS_SETUP.md` | GitHub Actions セットアップ |
| `BADGE_SYSTEM_OPTIMIZATION.md` | 最適化の詳細説明 |
| `DEVELOPMENT_WORKFLOW.md` | このドキュメント |

---

## 🚀 デプロイメント・リリース

### **本番リリース前チェック**

```bash
# バージョン更新
pubspec.yaml: version: 1.5.0+17
android/app/build.gradle.kts: versionCode = 17

# リリースノート作成
CHANGELOG.md に 1.5.0 の変更内容を記載

# 署名付き APK ビルド
./build-apk.ps1 -KeystorePassword "..." -KeyPassword "..."

# Play Store Console にアップロード
```

### **ロールバック手順**

```bash
# 前のバージョンに戻す
git revert <commit-hash>
git push origin main
```

---

## ✅ まとめ

このワークフローに従うことで、以下が実現できます：

✅ **品質**: コードレビュー → バグ修正 → テスト検証  
✅ **自動化**: GitHub Actions による継続的ビルド  
✅ **パフォーマンス**: 計測ツールで最適化検証  
✅ **ユーザー体験**: ダークモード・レスポンシブ対応  
✅ **保守性**: 完全なテストカバレッジとドキュメント

---

**次のプロジェクトでも、このワークフローを参考にしてください！** 🎯

