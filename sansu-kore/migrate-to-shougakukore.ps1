# sansu-kore を shougakukore アカウント配下の新規リポジトリへ移行するスクリプト（PowerShell版）
#
# 実行方法（あなたのターミナルで、shougakukoreでgh auth login済みの状態）:
#   cd "H:\マイドライブ\apps\sansu-kore"
#   .\migrate-to-shougakukore.ps1

$ErrorActionPreference = "Stop"

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "算数コレ v3.1 — shougakukore アカウントへ移行" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Step 0: 現在の認証アカウント確認
Write-Host "[Step 0] 現在の gh 認証アカウントを確認..." -ForegroundColor Yellow
try {
    $currentUser = gh api user --jq .login 2>&1
    if ($LASTEXITCODE -ne 0) { throw "gh api user failed" }
} catch {
    Write-Host "❌ gh api user に失敗しました。gh auth login / gh auth switch を先に実行してください。" -ForegroundColor Red
    exit 1
}
Write-Host "現在のアカウント: $currentUser" -ForegroundColor Green

if ($currentUser -ne "shougakukore") {
    Write-Host ""
    Write-Host "⚠️  警告: 現在 shougakukore としてログインしていません（$currentUser のままです）" -ForegroundColor Yellow
    $confirm = Read-Host "それでも続行しますか？ (y/n)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "❌ キャンセルしました" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# Step 1: 既存リモートをバックアップとして退避
Write-Host "[Step 1] 既存の origin を origin-petitworksapps としてバックアップ..." -ForegroundColor Yellow
$remotes = git remote
if ($remotes -contains "origin-petitworksapps") {
    Write-Host "✓ origin-petitworksapps は既に存在します（スキップ）" -ForegroundColor Green
} else {
    git remote rename origin origin-petitworksapps
    Write-Host "✓ リネーム完了" -ForegroundColor Green
}
Write-Host ""

# Step 2: shougakukore 配下に新規リポジトリを作成 + push
Write-Host "[Step 2] shougakukore/sansu-kore を新規作成し、origin として push..." -ForegroundColor Yellow

$repoExists = $false
try {
    gh repo view shougakukore/sansu-kore --json name | Out-Null
    if ($LASTEXITCODE -eq 0) { $repoExists = $true }
} catch {
    $repoExists = $false
}

if ($repoExists) {
    Write-Host "✓ shougakukore/sansu-kore は既に存在します" -ForegroundColor Green
    $existingOrigin = git remote | Where-Object { $_ -eq "origin" }
    if (-not $existingOrigin) {
        git remote add origin "https://github.com/shougakukore/sansu-kore.git"
    }
    git push -u origin master
} else {
    Write-Host "（存在しないため新規作成します）" -ForegroundColor Cyan
    gh repo create shougakukore/sansu-kore --private --source=. --remote=origin --push
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host "✅ 移行完了！" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""
Write-Host "新リポジトリ: https://github.com/shougakukore/sansu-kore" -ForegroundColor Cyan
Write-Host "旧リポジトリ（バックアップ）: https://github.com/petitworksappsdev-hash/sansu-kore" -ForegroundColor Cyan
Write-Host "  → git remote -v で確認できます" -ForegroundColor White
Write-Host ""
Write-Host "次のステップ:" -ForegroundColor Cyan
Write-Host "1. https://github.com/shougakukore/sansu-kore/actions で Actions が有効か確認" -ForegroundColor White
Write-Host "2. iOS ビルドを手動実行する場合:" -ForegroundColor White
Write-Host "   gh workflow run build-apk.yml -R shougakukore/sansu-kore --ref master" -ForegroundColor White
Write-Host "   または Actions タブ → 'Flutter CI' → 'Run workflow' → build-ios を確認" -ForegroundColor White
Write-Host ""
