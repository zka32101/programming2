# 🚀 トークン節約最適化ガイド

**目標**: 15M トークン/セッションを 75% 削減 → 4-5M で完成度同じ実装

---

## 📊 現状分析

### 前セッション消費パターン

| フェーズ | トークン | 時間 | 削減案 |
|---|---|---|---|
| **状態確認** | 1.5M | 5分 | ✅ 30秒で完了 |
| **修正実行** | 8M | 10分 | ⚡ バッチ化で 5分 |
| **テスト** | 3M | 5分 | ✅ tail で制限 |
| **コミット・Push** | 2M | 3分 | ✅ スクリプト化 |
| **ドキュメント** | 0.5M | 2分 | ✅ template 化 |

**削減可能: 8.5M トークン (56%)**

---

## ✨ 3つのツール

### 1️⃣ SESSION_WORKFLOW.md
**用途**: セッション計画テンプレート

```bash
# セッション開始時
cat .claude/SESSION_WORKFLOW.md
```

**含まれるもの:**
- ✅ 開始時チェック (1分)
- ✅ 計画テンプレート (2分)
- ✅ バッチスクリプト例 (3分)
- ✅ 確認フェーズ (1分)

### 2️⃣ SESSION_CHECKLIST.md
**用途**: メモリに保存された確認リスト

```bash
# 前セッション結果確認
cat memory/SESSION_CHECKLIST.md
```

**含まれるもの:**
- ✅ MEMORY 確認方法
- ✅ タスク定義テンプレート
- ✅ チェックリスト短縮版
- ✅ トークン消費の目安

### 3️⃣ bash_helpers.sh
**用途**: 一括修正・テスト・コミットの関数セット

```bash
# セッション開始時
source .claude/bash_helpers.sh

# 使用可能な関数を表示
bash_helpers.sh help
```

**関数一覧:**

```bash
# セッション管理
session_status          # git log + status
last_session           # 前セッション結果確認

# 修正実行
batch_replace          # 複数ファイル一括置換
add_apps               # 複数アプリを add
commit_apps            # 複数アプリをコミット
push_changes           # add + commit + push

# テスト検証
analyze_apps           # flutter analyze (複数)
test_apps              # flutter test (複数)
diff_summary           # 修正内容統計

# 情報取得
find_in_files          # パターン検索
all_app_versions       # アプリバージョン一覧

# ユーティリティ
recent                 # 最近のコミット
show_prev              # 前のコミット詳細
time_task              # 実行時間計測
```

---

## 🎯 セッション実行パターン

### パターン A: 小規模修正 (1-2ファイル)

```bash
# 1. 状態確認 (30秒)
session_status

# 2. 修正 (2分)
sed -i 's/oldText/newText/g' file1.dart file2.dart

# 3. コミット (1分)
commit_apps "feat: description" app1 app2

# 4. 確認 (30秒)
diff_summary
recent 1
```

**トークン消費**: ~2M (従来 4-5M)

---

### パターン B: 大規模修正 (3+アプリ)

```bash
# 1. 計画書作成 (2分) → SESSION_WORKFLOW.md 参照
# 2. スクリプト作成 (3分)
cat > /tmp/fix_all.sh << 'EOF'
#!/bin/bash
cd "H:\\マイドライブ\\apps"
# Fix 1: eigo-kore theme
sed -i 's/old/new/g' eigo-kore/lib/main.dart
# Fix 2: shogaku-kore-programming theme
sed -i 's/old/new/g' shogaku-kore-programming/lib/main.dart
EOF

# 3. 実行 (1分)
bash /tmp/fix_all.sh

# 4. テスト (2分)
analyze_apps eigo-kore shogaku-kore-programming

# 5. コミット (1分)
commit_apps "feat: UI統一" eigo-kore shogaku-kore-programming

# 6. 確認 (30秒)
diff_summary
```

**トークン消費**: ~3-4M (従来 10-12M)

---

### パターン C: 複数タスク並行

```bash
# 1. タスク定義 (1分)
cat << 'PLAN'
## 本セッション
- [ ] Task A: eigo-kore 修正 (2ファイル)
- [ ] Task B: sansu-kore テスト (analyze + test)
- [ ] Task C: コミット

## ファイル一覧
- eigo-kore/lib/main.dart
- eigo-kore/lib/config/xxx.dart
- sansu-kore/lib/screens/yyy.dart
PLAN

# 2. スクリプト作成 (2分)
source .claude/bash_helpers.sh
batch_replace 'A' 'B' eigo-kore/lib/main.dart eigo-kore/lib/config/xxx.dart
add_apps 'lib' eigo-kore sansu-kore
time_task "分析" analyze_apps eigo-kore sansu-kore

# 3. コミット (1分)
commit_apps "feat: A and B" eigo-kore sansu-kore

# 4. 結果確認 (30秒)
recent 1
```

**トークン消費**: ~4-5M (従来 12-15M)

---

## 📋 チェックリスト（毎セッション）

### 開始時 (2分)

- [ ] `session_status` 実行 → untracked files 確認
- [ ] `last_session` 実行 → 前セッション結果確認
- [ ] タスク定義 1行記述

### 修正フェーズ (3-5分)

- [ ] スクリプトを /tmp に作成
- [ ] 実行前に確認 (cat)
- [ ] 実行
- [ ] エラーは `tail -3` で確認

### テスト (2分)

- [ ] `analyze_apps` 実行
- [ ] 重要なエラーのみ対応
- [ ] `diff_summary` で修正内容確認

### 完了 (1分)

- [ ] `commit_apps` + `push_changes`
- [ ] `recent 1` で確認
- [ ] MEMORY.md 更新

**合計: 8-10分 (従来 20-25分)**

---

## 💡 高度な使用法

### 複数修正の並行実行

```bash
# 修正A実行 (background)
(bash /tmp/fix_a.sh && echo "✅ A完了") &

# 修正B実行
bash /tmp/fix_b.sh && echo "✅ B完了"

# 並行待機
wait
```

### 条件付きコミット

```bash
# エラーなければコミット
if analyze_apps app1 | grep -q "0 errors"; then
  commit_apps "safe commit" app1
fi
```

### 自動テスト後コミット

```bash
# テスト成功 → コミット自動実行
test_apps sansu-kore && \
commit_apps "feat: tested implementation" sansu-kore || \
echo "❌ Tests failed, skipping commit"
```

---

## 📊 効果測定

### Before (本セッション実績)

```
状態確認:   1.5M tokens, 5分
修正実行:   8.0M tokens, 10分
テスト:     3.0M tokens, 5分
コミット:   2.0M tokens, 3分
ドキュメント: 0.5M tokens, 2分
─────────────────────────
合計:      15.0M tokens, 25分
```

### After (目標)

```
状態確認:   0.3M tokens, 30秒
修正実行:   2.0M tokens, 5分
テスト:     0.8M tokens, 2分
コミット:   0.5M tokens, 1分
ドキュメント: 0.4M tokens, 1分
─────────────────────────
合計:       4.0M tokens, 9分
```

**削減率: 73% (15M → 4M)**

---

## 🚀 次セッション開始テンプレート

```bash
#!/bin/bash
# セッション開始スクリプト

echo "📋 セッション開始ガイド"
echo ""

# 1. Tools load
source .claude/bash_helpers.sh
echo "✅ Helper functions loaded"
echo ""

# 2. Status check
echo "📊 Current Status:"
session_status
echo ""

# 3. Previous session
echo "📚 Previous Session:"
last_session
echo ""

# 4. Next steps
echo "🎯 Ready to start!"
echo "   1. Define task (1 line)"
echo "   2. Create script in /tmp"
echo "   3. Execute batch script"
echo "   4. Test & Commit"
echo ""
echo "⏱️  Target: 8-10 minutes total"
```

使用例:
```bash
bash .claude/start_session.sh
```

---

**最終目標**: セッション1回 = 4-5M トークン, 8-10分で完成度同等の実装 ✅
