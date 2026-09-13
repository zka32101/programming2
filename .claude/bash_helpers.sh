#!/bin/bash
# トークン節約用 Bash ヘルパー関数セット
# 使用: source .claude/bash_helpers.sh

# 🎯 目的: 複数アプリへの一括修正・テスト・コミット を効率化

# ============================================================================
# セッション開始時
# ============================================================================

## セッション状態確認 (30秒)
session_status() {
  echo "=== Git Status ==="
  git log --oneline -3
  echo ""
  echo "=== Untracked/Modified ==="
  git status -s | head -10
  echo ""
  echo "=== Recent PRs ==="
  gh pr list -L 3 --json number,title,state 2>/dev/null || echo "(gh not configured)"
}

## 前セッション確認
last_session() {
  local memory_file="C:\\Users\\zka32\\.claude\\projects\\H---------apps\\memory\\MEMORY.md"
  if [ -f "$memory_file" ]; then
    echo "=== Latest Sessions ==="
    head -10 "$memory_file" | grep "^\-"
  fi
}

# ============================================================================
# 修正フェーズ
# ============================================================================

## 複数ファイルの同じ文字列を置換
batch_replace() {
  local old_text="$1"
  local new_text="$2"
  shift 2
  local files=("$@")

  if [ ${#files[@]} -eq 0 ]; then
    echo "❌ 使用: batch_replace 'old' 'new' file1 file2 ..."
    return 1
  fi

  for file in "${files[@]}"; do
    if [ -f "$file" ]; then
      sed -i "s/${old_text}/${new_text}/g" "$file"
      echo "✅ $file"
    fi
  done
}

## 複数アプリの特定ディレクトリを add
add_apps() {
  local path="$1"
  shift
  local apps=("$@")

  if [ ${#apps[@]} -eq 0 ]; then
    echo "❌ 使用: add_apps 'lib/screens' app1 app2 ..."
    return 1
  fi

  for app in "${apps[@]}"; do
    git add "$app/$path" --update 2>/dev/null && echo "✅ $app/$path"
  done
}

## 複数アプリをコミット
commit_apps() {
  local message="$1"
  shift
  local apps=("$@")

  if [ ${#apps[@]} -eq 0 ]; then
    echo "❌ 使用: commit_apps 'message' app1 app2 ..."
    return 1
  fi

  # Add all modified files from specified apps
  for app in "${apps[@]}"; do
    git add "$app/" --update 2>/dev/null
  done

  # Commit with proper attribution
  git commit -m "$message

Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>" && \
  echo "✅ Committed" || echo "❌ Commit failed"
}

## Add + Commit + Push (3つを一度に)
push_changes() {
  local message="$1"

  git add -A && \
  git commit -m "$message

Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>" && \
  git push origin main && \
  echo "✅ Pushed: $message" || echo "❌ Push failed"
}

# ============================================================================
# テスト・検証フェーズ
# ============================================================================

## 複数アプリの flutter analyze (3分以内)
analyze_apps() {
  local apps=("$@")
  if [ ${#apps[@]} -eq 0 ]; then
    apps=(sansu-kore kokugo-kore shogaku-kore-programming)
  fi

  for app in "${apps[@]}"; do
    echo "=== $app ==="
    cd "$app" 2>/dev/null || continue
    timeout 30 flutter analyze 2>&1 | tail -1
    cd ..
  done
}

## 複数アプリの flutter test (制限時間付き)
test_apps() {
  local apps=("$@")
  if [ ${#apps[@]} -eq 0 ]; then
    apps=(sansu-kore kokugo-kore shogaku-kore-programming)
  fi

  for app in "${apps[@]}"; do
    echo "=== $app ==="
    cd "$app" 2>/dev/null || continue
    timeout 60 flutter test 2>&1 | tail -3
    cd ..
  done
}

## git diff 統計 (修正内容確認)
diff_summary() {
  echo "=== Modified Files ==="
  git diff --stat
  echo ""
  echo "=== Line Changes ==="
  git diff --stat | tail -1
}

# ============================================================================
# 情報取得
# ============================================================================

## ファイルの特定行を表示 (頻度: 検索代わり)
find_in_files() {
  local pattern="$1"
  local app="$2"

  grep -r "$pattern" "$app/lib" --include="*.dart" 2>/dev/null | head -5
}

## アプリの pubspec.yaml から情報抽出
get_app_version() {
  local app="$1"
  grep "^version:" "$app/pubspec.yaml" | cut -d: -f2 | xargs
}

## 全アプリのバージョン一覧
all_app_versions() {
  for app in sansu-kore kokugo-kore shogaku-kore-programming eigo-kore; do
    if [ -f "$app/pubspec.yaml" ]; then
      ver=$(get_app_version "$app")
      echo "$app: $ver"
    fi
  done
}

# ============================================================================
# ユーティリティ
# ============================================================================

## Recent commits 表示
recent() {
  local limit="${1:-5}"
  git log --oneline -n "$limit"
}

## 前のコミット確認
show_prev() {
  git show HEAD~1 --stat
}

## すべての未コミット変更をリセット (危険!)
reset_hard() {
  echo "⚠️  注意: すべての変更をリセットします"
  read -p "続行? (yes/no): " -r
  if [[ $REPLY =~ ^[Yy]es$ ]]; then
    git reset --hard origin/main
    echo "✅ Reset完了"
  fi
}

# ============================================================================
# 時間計測
# ============================================================================

## タスク実行時間計測
time_task() {
  local task_name="$1"
  local start_time=$(date +%s)

  shift
  "$@"

  local end_time=$(date +%s)
  local elapsed=$((end_time - start_time))
  echo "⏱️  $task_name: ${elapsed}秒"
}

# ============================================================================
# 使用例
# ============================================================================

show_examples() {
  cat << 'EOF'
📚 ヘルパー関数の使用例

【セッション開始】
  $ session_status          # 状態確認
  $ last_session           # 前セッション確認

【修正実行】
  $ batch_replace 'old' 'new' app1/lib/x.dart app2/lib/y.dart
  $ add_apps 'lib/screens' sansu-kore kokugo-kore
  $ commit_apps "feat: description" sansu-kore kokugo-kore

【テスト】
  $ analyze_apps sansu-kore kokugo-kore
  $ test_apps
  $ diff_summary

【情報取得】
  $ find_in_files 'AppTheme' sansu-kore
  $ all_app_versions
  $ recent 10

【時間計測】
  $ time_task "修正実行" bash /tmp/script.sh

EOF
}

# 使用例を表示
if [ "$1" = "help" ] || [ "$1" = "-h" ]; then
  show_examples
fi
