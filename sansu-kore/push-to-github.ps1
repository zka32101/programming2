# GitHub へ push するスクリプト
# 使用方法: PowerShell で実行
# PS> .\push-to-github.ps1

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "算数コレ v3.1 — GitHub Push スクリプト" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: ディレクトリ確認
Write-Host "[Step 1] プロジェクトディレクトリを確認中..." -ForegroundColor Yellow
$projectDir = "H:\マイドライブ\apps\sansu-kore"

if (-not (Test-Path $projectDir)) {
    Write-Host "❌ エラー: プロジェクトディレクトリが見つかりません" -ForegroundColor Red
    Write-Host "   $projectDir" -ForegroundColor Red
    exit 1
}

Set-Location $projectDir
Write-Host "✅ ディレクトリ: $projectDir" -ForegroundColor Green
Write-Host ""

# Step 2: Git 初期化確認
Write-Host "[Step 2] Git リポジトリを確認中..." -ForegroundColor Yellow
if (-not (Test-Path ".git")) {
    Write-Host "❌ エラー: .git フォルダが見つかりません" -ForegroundColor Red
    Write-Host "   git init が必要です" -ForegroundColor Red
    exit 1
}

$remoteUrl = git remote get-url origin 2>$null
if ($remoteUrl) {
    Write-Host "✅ リモート URL: $remoteUrl" -ForegroundColor Green
} else {
    Write-Host "⚠️  警告: リモートが設定されていません" -ForegroundColor Yellow
    Write-Host "   設定中..." -ForegroundColor Yellow
    git remote add origin https://github.com/petitworksappsdev-hash/sansu-kore.git
    Write-Host "✅ リモート追加完了" -ForegroundColor Green
}
Write-Host ""

# Step 3: 現在の状態確認
Write-Host "[Step 3] 変更ファイルを確認中..." -ForegroundColor Yellow
$gitStatus = git status --short
if ($gitStatus) {
    Write-Host "⚠️  コミットされていない変更があります:" -ForegroundColor Yellow
    Write-Host $gitStatus -ForegroundColor White
    Write-Host ""
    $confirm = Read-Host "これらの変更をコミットして push しますか？ (y/n)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "❌ キャンセルしました" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✅ すべてコミット済み" -ForegroundColor Green
}
Write-Host ""

# Step 4: ブランチ確認
Write-Host "[Step 4] ブランチを確認中..." -ForegroundColor Yellow
$currentBranch = git rev-parse --abbrev-ref HEAD
Write-Host "✅ 現在のブランチ: $currentBranch" -ForegroundColor Green

if ($currentBranch -ne "main") {
    Write-Host "⚠️  警告: main ブランチではありません" -ForegroundColor Yellow
    $confirm = Read-Host "main ブランチに切り替えますか？ (y/n)"
    if ($confirm -eq "y" -or $confirm -eq "Y") {
        git checkout main
    } else {
        Write-Host "❌ キャンセルしました" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# Step 5: GitHub に Push
Write-Host "[Step 5] GitHub に push 中..." -ForegroundColor Yellow
Write-Host "これには 2～5 分かかる場合があります..." -ForegroundColor Cyan
Write-Host ""

try {
    git push -u origin main

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ Push 成功！" -ForegroundColor Green
        Write-Host ""

        # Step 6: GitHub Actions 確認用 URL 表示
        Write-Host "[Step 6] GitHub Actions を確認中..." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "📱 以下のリンクで自動ビルドの進行状況を確認できます:" -ForegroundColor Cyan
        Write-Host "   https://github.com/petitworksappsdev-hash/sansu-kore/actions" -ForegroundColor Green
        Write-Host ""
        Write-Host "⏱️  ビルド時間: 約 15～20 分" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "完了すると以下が表示されます:" -ForegroundColor Cyan
        Write-Host "  ✅ Build APK" -ForegroundColor Green
        Write-Host ""
        Write-Host "APK ダウンロード:" -ForegroundColor Cyan
        Write-Host "  1. Actions タブで 「Build APK」 をクリック" -ForegroundColor White
        Write-Host "  2. 下部の 「Artifacts」 セクションから 「sansu-kore-apk」 をダウンロード" -ForegroundColor White
        Write-Host ""

        # GitHub リポジトリを自動で開く
        Write-Host "ブラウザを開きますか？ (y/n)" -ForegroundColor Yellow
        $openBrowser = Read-Host
        if ($openBrowser -eq "y" -or $openBrowser -eq "Y") {
            Start-Process "https://github.com/petitworksappsdev-hash/sansu-kore/actions"
        }

        Write-Host ""
        Write-Host "=====================================" -ForegroundColor Green
        Write-Host "✅ 完了！v3.1 のローンチが開始されました 🚀" -ForegroundColor Green
        Write-Host "=====================================" -ForegroundColor Green

    } else {
        Write-Host ""
        Write-Host "❌ Push に失敗しました" -ForegroundColor Red
        Write-Host "以下を確認してください:" -ForegroundColor Yellow
        Write-Host "  1. インターネット接続" -ForegroundColor White
        Write-Host "  2. GitHub 認証情報（トークン）" -ForegroundColor White
        Write-Host "  3. リモート URL の確認: git remote -v" -ForegroundColor White
        exit 1
    }
} catch {
    Write-Host ""
    Write-Host "❌ エラーが発生しました:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
