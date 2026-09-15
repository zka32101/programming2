# AAB (Android App Bundle) ビルドスクリプト
# 使用方法: PowerShell で実行
# PS> .\build-aab.ps1

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "算数コレ v3.1 — AAB ビルドスクリプト" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: プロジェクトディレクトリ確認
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

# Step 2: Flutter インストール確認
Write-Host "[Step 2] Flutter をチェック中..." -ForegroundColor Yellow
try {
    $flutterVersion = flutter --version 2>&1 | Select-Object -First 1
    Write-Host "✅ $flutterVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ エラー: Flutter が見つかりません" -ForegroundColor Red
    Write-Host "   PATH に Flutter を追加してください" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Step 3: 依存パッケージ確認
Write-Host "[Step 3] 依存パッケージを確認中..." -ForegroundColor Yellow
if (-not (Test-Path "pubspec.lock")) {
    Write-Host "⚠️  pubspec.lock が見つかりません。flutter pub get を実行します..." -ForegroundColor Yellow
    flutter pub get
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ エラー: flutter pub get に失敗しました" -ForegroundColor Red
        exit 1
    }
}
Write-Host "✅ 依存パッケージ確認完了" -ForegroundColor Green
Write-Host ""

# Step 4: キーストア確認
Write-Host "[Step 4] リリース署名キーストアを確認中..." -ForegroundColor Yellow
$keystorePath = "android/app/src/keystore/upload-keystore.jks"
if (-not (Test-Path $keystorePath)) {
    Write-Host "⚠️  警告: キーストアが見つかりません" -ForegroundColor Yellow
    Write-Host "   $keystorePath" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "キーストアが存在しない場合、新規作成する必要があります:" -ForegroundColor Cyan
    Write-Host "   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10950 -alias upload" -ForegroundColor White
    Write-Host ""
    $confirm = Read-Host "キーストアはありますか？ (y/n)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "❌ キーストアが必要です。作成してから実行してください" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✅ キーストア確認: $keystorePath" -ForegroundColor Green
}
Write-Host ""

# Step 5: AAB ビルド
Write-Host "[Step 5] AAB ビルドを開始します..." -ForegroundColor Yellow
Write-Host "これには 10～15 分かかります..." -ForegroundColor Cyan
Write-Host ""

$startTime = Get-Date

try {
    flutter build appbundle --release

    if ($LASTEXITCODE -eq 0) {
        $endTime = Get-Date
        $duration = $endTime - $startTime

        Write-Host ""
        Write-Host "✅ AAB ビルド成功！" -ForegroundColor Green
        Write-Host "   ビルド時間: $($duration.Minutes)分 $($duration.Seconds)秒" -ForegroundColor Green
        Write-Host ""

        # Step 6: AAB ファイル情報
        Write-Host "[Step 6] ビルド成果物を確認中..." -ForegroundColor Yellow
        $aabPath = "build/app/outputs/bundle/release/app-release.aab"

        if (Test-Path $aabPath) {
            $aabSize = (Get-Item $aabPath).Length / 1MB
            Write-Host "✅ AAB ファイル: $aabPath" -ForegroundColor Green
            Write-Host "   ファイルサイズ: $([Math]::Round($aabSize, 1)) MB" -ForegroundColor Green
            Write-Host ""

            # Step 7: Google Drive にコピー
            Write-Host "[Step 7] Google Drive に保存中..." -ForegroundColor Yellow
            $driveDir = "H:\マイドライブ\apk"

            if (-not (Test-Path $driveDir)) {
                New-Item -ItemType Directory -Path $driveDir -Force | Out-Null
            }

            $driveFile = "$driveDir\sansu-kore-v3.1-firebase.aab"
            Copy-Item $aabPath $driveFile -Force

            if (Test-Path $driveFile) {
                $driveSize = (Get-Item $driveFile).Length / 1MB
                Write-Host "✅ Google Drive に保存完了" -ForegroundColor Green
                Write-Host "   ファイル: $driveFile" -ForegroundColor Green
                Write-Host "   ファイルサイズ: $([Math]::Round($driveSize, 1)) MB" -ForegroundColor Green
            } else {
                Write-Host "❌ エラー: Google Drive への保存に失敗しました" -ForegroundColor Red
                exit 1
            }
        } else {
            Write-Host "❌ エラー: AAB ファイルが見つかりません" -ForegroundColor Red
            Write-Host "   $aabPath" -ForegroundColor Red
            exit 1
        }

        Write-Host ""
        Write-Host "=====================================" -ForegroundColor Green
        Write-Host "✅ AAB ビルド完了！Google Play 申請準備完了" -ForegroundColor Green
        Write-Host "=====================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "【次のステップ】" -ForegroundColor Cyan
        Write-Host "1. Google Play Console にログイン" -ForegroundColor White
        Write-Host "   https://play.google.com/apps/publish" -ForegroundColor Green
        Write-Host ""
        Write-Host "2. 新しいアプリを作成" -ForegroundColor White
        Write-Host "   アプリ名: 算数コレ！- 小学算数 完全マスター" -ForegroundColor Green
        Write-Host ""
        Write-Host "3. AAB ファイルをアップロード" -ForegroundColor White
        Write-Host "   ファイル: $driveFile" -ForegroundColor Green
        Write-Host ""
        Write-Host "4. ストア掲載情報を入力" -ForegroundColor White
        Write-Host "   テンプレート: google_play_listing_plaintext.md" -ForegroundColor Green
        Write-Host ""
        Write-Host "5. 申請" -ForegroundColor White
        Write-Host "   審査時間: 7～14日" -ForegroundColor Cyan
        Write-Host ""

    } else {
        Write-Host ""
        Write-Host "❌ ビルドに失敗しました" -ForegroundColor Red
        Write-Host "以下を確認してください:" -ForegroundColor Yellow
        Write-Host "  1. Flutter のバージョン: flutter --version" -ForegroundColor White
        Write-Host "  2. Java Development Kit (JDK) がインストールされているか" -ForegroundColor White
        Write-Host "  3. Android SDK がインストールされているか" -ForegroundColor White
        Write-Host "  4. キーストア設定が android/app/build.gradle.kts に設定されているか" -ForegroundColor White
        exit 1
    }
} catch {
    Write-Host ""
    Write-Host "❌ エラーが発生しました:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
