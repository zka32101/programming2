# セッション最適化ワークフロー

## 📋 開始時 (1分)

```bash
# 1. 状態確認
git log --oneline -3
git status -s | head -5

# 2. 前セッション確認
cat C:\Users\zka32\.claude\projects\H---------apps\memory\MEMORY.md | head -20
```

## 📝 計画フェーズ (2分)

修正計画を Markdown で記述:

```markdown
## 今セッションのゴール
- [ ] Task 1: xxxx
- [ ] Task 2: xxxx

## 修正ファイル一覧
- app1/lib/screens/xxx.dart (Line N: change A→B)
- app2/lib/main.dart (Import: remove X, add Y)

## 実行スクリプト
```bash
# See below
```
```

## ⚡ 実行フェーズ (3分)

### バッチ修正スクリプト

```bash
# Multiple edits in one command
for app in sansu-kore kokugo-kore; do
  sed -i 's/oldText/newText/g' "$app/lib/screens/settings_screen.dart"
done && \
git add sansu-kore/lib/screens/settings_screen.dart \
        kokugo-kore/lib/screens/settings_screen.dart && \
git commit -m "feat: description

Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>" && \
git push origin main
```

### 複数ファイル同時修正

```bash
# Edit multiple files without repeated reads
cat > /tmp/fixes.sh << 'EOF'
#!/bin/bash
cd "H:\\マイドライブ\\apps"
# Fix 1
sed -i 's/A/B/g' file1.dart
# Fix 2  
sed -i 's/C/D/g' file2.dart
# Commit all
git add file1.dart file2.dart && \
git commit -m "feat: description"
EOF
bash /tmp/fixes.sh
```

## ✅ 確認フェーズ (1分)

```bash
# 実行結果確認 (出力は制限)
git log --oneline -1
git diff --stat HEAD~1

# エラーチェック (重要なもののみ)
flutter analyze 2>&1 | tail -3
```

## 📌 更新フェーズ (1分)

MEMORY.md を更新:

```markdown
- [🔄 Session Title](session_file.md) — brief summary of what was done
```

## ⏱️ トータル: ~8分

---

## 🚫 避けるべきパターン

| ❌ | ✅ |
|---|---|
| 複数回の Read (同じファイル) | Read 1回 → 複数修正計画 |
| `ls` → `cat` → `echo` の連鎖 | `grep -l` で直接検索 |
| エラーハンドリング試行錯誤 | 計画フェーズで原因分析 |
| 説明の繰り返し | チェックリスト形式 |
| 単一コマンド実行 | バッチで複数実行 |

---

## 🔧 helper 関数 (~/.claude/bash_helpers.sh)

```bash
#!/bin/bash

# Commit multiple apps at once
commit_apps() {
  local message="$1"
  shift
  local apps=("$@")
  
  cd "H:\\マイドライブ\\apps"
  
  # Add all changed files in specified apps
  for app in "${apps[@]}"; do
    git add "$app/" --update 2>/dev/null
  done
  
  git commit -m "$message

Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>" && \
  git push origin main && \
  echo "✅ Pushed: $message"
}

# Quick status check
check_status() {
  echo "Recent commits:"
  git log --oneline -3
  echo ""
  echo "Modified files:"
  git status -s | head -5
}

# Run all apps' flutter tests
test_all_apps() {
  for app in sansu-kore kokugo-kore shogaku-kore-programming eigo-kore; do
    echo "=== Testing $app ==="
    cd "$app" && timeout 60 flutter test 2>&1 | tail -1
    cd ..
  done
}
```

**使用例:**
```bash
source ~/.claude/bash_helpers.sh
commit_apps "feat: description" sansu-kore kokugo-kore
check_status
test_all_apps
```

---

**次セッション開始時:**
1. このファイルを読む (30秒)
2. 計画フェーズに進む
3. スクリプトをコピペして実行
