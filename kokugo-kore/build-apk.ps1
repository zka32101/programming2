# 国語コレ！ APKビルド自動化スクリプト
# 使用法: .\build-apk.ps1 -KeystorePassword "<password>" -KeyPassword "<password>"

param(
    [Parameter(Mandatory=$false)]
    [string]$KeystorePassword,

    [Parameter(Mandatory=$false)]
    [string]$KeyPassword,

    [Parameter(Mandatory=$false)]
    [switch]$SkipDriveMapping = $false,

    [Parameter(Mandatory=$false)]
    [switch]$CleanBuild = $false,

    [Parameter(Mandatory=$false)]
    [switch]$DebugBuild = $false
)

# エラーが発生した場合は終了
$ErrorActionPreference = "Stop"

# カラー出力関数
function Write-Status {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "HH:mm:ss"
    $color = switch($Level) {
        "SUCCESS" { "Green" }
        "WARNING" { "Yellow" }
        "ERROR" { "Red" }
        default { "Cyan" }
    }
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

function Write-Step {
    param([string]$Step)
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
    Write-Host $Step -ForegroundColor Magenta
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
}

# ステップ 1: 管理者権限確認
Write-Step "ステップ 1: 権限確認"
$isAdmin = ([System.Security.Principal.WindowsIdentity]::GetCurrent().Groups -match "S-1-5-32-544") -eq $null -eq $false
if (-not $isAdmin) {
    Write-Status "警告: 管理者権限で実行することを推奨します" "WARNING"
    Write-Status "仮想ドライブ割り当てに失敗する可能性があります" "WARNING"
}

# ステップ 2: 環境確認
Write-Step "ステップ 2: 開発環境確認"
$envChecks = @{
    "Flutter" = "flutter --version"
    "Java" = "java -version"
    "Gradle" = "gradle --version"
}

foreach ($tool in $envChecks.Keys) {
    try {
        $version = & cmd /c $envChecks[$tool] 2>&1
        Write-Status "$tool: インストール済み" "SUCCESS"
    } catch {
        Write-Status "$tool: インストールされていません" "ERROR"
        exit 1
    }
}

# ステップ 3: K:ドライブ割り当て
Write-Step "ステップ 3: 仮想ドライブ割り当て"
if (-not $SkipDriveMapping) {
    # 既存の割り当てを削除
    $existingMapping = subst | Select-String "K:"
    if ($existingMapping) {
        Write-Status "既存の K: マッピングを削除しています..." "INFO"
        subst /d K: 2>&1 | Out-Null
        Start-Sleep -Seconds 1
    }

    # 新規割り当て
    $projectPath = "H:\マイドライブ\apps\kokugo-kore"
    if (-not (Test-Path $projectPath)) {
        Write-Status "プロジェクトパスが見つかりません: $projectPath" "ERROR"
        exit 1
    }

    subst K: $projectPath
    Write-Status "K: ドライブを割り当てました: $projectPath" "SUCCESS"
    Start-Sleep -Seconds 2
} else {
    Write-Status "K: ドライブ割り当てをスキップ" "WARNING"
}

# ステップ 4: ビルド環境変数設定
Write-Step "ステップ 4: ビルド環境変数設定"

if (-not $KeystorePassword -or -not $KeyPassword) {
    Write-Status "パスワードが提供されていません" "WARNING"
    Write-Status "以下のコマンドで環境変数を設定してください:" "INFO"
    Write-Host "`$env:KEYSTORE_PASSWORD = `"<release_new.jksのストアパスワード>`"" -ForegroundColor Yellow
    Write-Host "`$env:KEY_PASSWORD = `"<kokugo_releaseのキーパスワード>`"" -ForegroundColor Yellow
    Write-Host ""
    $KeystorePassword = Read-Host "Keystoreパスワード"
    $KeyPassword = Read-Host "Keyパスワード"
}

$env:KEYSTORE_PASSWORD = $KeystorePassword
$env:KEY_PASSWORD = $KeyPassword
$env:JAVA_HOME = "C:/Program Files/Android/Android Studio/jbr"

Write-Status "KEYSTORE_PASSWORD: 設定済み" "SUCCESS"
Write-Status "KEY_PASSWORD: 設定済み" "SUCCESS"
Write-Status "JAVA_HOME: $($env:JAVA_HOME)" "SUCCESS"

# ステップ 5: ディレクトリ移動とキャッシュクリア
Write-Step "ステップ 5: ビルド準備"
try {
    cd K:/
    Write-Status "ディレクトリ: K:/" "SUCCESS"

    if ($CleanBuild) {
        Write-Status "キャッシュをクリアしています..." "INFO"
        flutter clean
        Write-Status "キャッシュクリア完了" "SUCCESS"
    }
} catch {
    Write-Status "ディレクトリ移動に失敗しました" "ERROR"
    exit 1
}

# ステップ 6: APKビルド実行
Write-Step "ステップ 6: APKビルド実行"
$buildCmd = if ($DebugBuild) {
    "flutter build apk --debug"
} else {
    "flutter build apk --release --no-pub"
}

Write-Status "実行コマンド: $buildCmd" "INFO"
Write-Status "ビルドを開始しています... (5-15分程度かかります)" "INFO"
Write-Host ""

try {
    Invoke-Expression $buildCmd
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Step "ビルド完了！"
        Write-Status "APKビルド成功" "SUCCESS"
    } else {
        throw "ビルドコマンドが失敗しました (終了コード: $LASTEXITCODE)"
    }
} catch {
    Write-Status "ビルド失敗: $_" "ERROR"
    Write-Status "トラブルシューティングについては APK_BUILD_GUIDE.md を参照してください" "WARNING"
    exit 1
}

# ステップ 7: ビルド成果物確認
Write-Step "ステップ 7: ビルド成果物確認"
$apkPath = "K:\build\app\outputs\flutter-apk\app-release.apk"
if (-not (Test-Path $apkPath)) {
    $apkPath = "K:\build\app\outputs\flutter-apk\app-debug.apk"
}

if (Test-Path $apkPath) {
    $apkSize = (Get-Item $apkPath).Length / 1MB
    Write-Status "APK パス: $apkPath" "SUCCESS"
    Write-Status "APK サイズ: $([Math]::Round($apkSize, 2)) MB" "SUCCESS"
} else {
    Write-Status "APKファイルが見つかりません" "ERROR"
    exit 1
}

# ステップ 8: Google Driveへのコピー（オプション）
Write-Step "ステップ 8: Google Driveへのコピー（オプション）"
$driveFolder = "H:\マイドライブ\apps\kokugo-kore\apk"
if (Test-Path $driveFolder) {
    Write-Status "Google Driveへコピーしています..." "INFO"
    Copy-Item -Path $apkPath -Destination "$driveFolder\app-release.apk" -Force
    Write-Status "Google Driveへのコピー完了" "SUCCESS"
} else {
    Write-Status "Google Driveフォルダが見つかりません: $driveFolder" "WARNING"
}

# 完了
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✓ APKビルドが正常に完了しました！                     ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "次のステップ:" -ForegroundColor Green
Write-Host "1. 実機へのインストール:" -ForegroundColor Cyan
Write-Host "   adb install -r `"$apkPath`"" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. アプリをテスト:" -ForegroundColor Cyan
Write-Host "   実機でアプリを起動して動作確認を行ってください" -ForegroundColor Yellow
Write-Host ""
