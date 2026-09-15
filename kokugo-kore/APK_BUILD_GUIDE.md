# 国語コレ！ APKビルドガイド

## 📋 ビルド前チェックリスト

- [x] プロジェクトコード完成
- [x] バッジシステム統合完了
- [x] Firebase設定確認
- [x] Android署名設定確認
- [ ] 開発マシンの環境準備（Windows）
- [ ] パスワード準備（Keystore & Key）

---

## 🚀 ビルド手順

### ステップ 1: Windows環境セットアップ

**前提条件:**
- Windows 10/11
- Flutter SDK インストール済み
- Android Studio インストール済み
- Git インストール済み

**確認コマンド:**
```powershell
flutter --version
java -version
```

---

### ステップ 2: 仮想ドライブ割り当て

日本語パスの問題を回避するため、K:ドライブを割り当てます：

```powershell
# PowerShellを管理者権限で実行
subst K: "H:\マイドライブ\apps\kokugo-kore"

# 割り当てを確認
subst
```

**確認結果例:**
```
K:\: => H:\マイドライブ\apps\kokugo-kore
```

---

### ステップ 3: ビルド環境変数設定

**Keystoreパスワードを取得:**
1. `release_new.jks` のストアパスワードを用意
2. `kokugo_release` のキーパスワードを用意

**PowerShellで環境変数を設定（セッション内のみ保持）:**
```powershell
$env:KEYSTORE_PASSWORD = "<release_new.jksのストアパスワード>"
$env:KEY_PASSWORD = "<kokugo_releaseのキーパスワード>"
$env:JAVA_HOME = "C:/Program Files/Android/Android Studio/jbr"
```

**確認:**
```powershell
echo $env:KEYSTORE_PASSWORD
echo $env:KEY_PASSWORD
echo $env:JAVA_HOME
```

---

### ステップ 4: APKビルド実行

K:ドライブから実行（重要）：

```powershell
cd K:/
flutter build apk --release --no-pub
```

**ビルド進捗:**
```
Running gradle assemble...
✓ Compilation successful
✓ APK created
✓ Build complete
```

**所要時間:** 5-15分（マシンスペックに依存）

---

### ステップ 5: ビルド成果物確認

ビルド完了後、APKファイルが生成されます：

**ビルド出力:**
```
✓ K:\build\app\outputs\flutter-apk\app-release.apk
```

**サイズ確認:**
```powershell
ls -lh K:\build\app\outputs\flutter-apk\app-release.apk
```

---

### ステップ 6: APKをGoogle Driveにコピー（自動）

```
ビルド完了時に自動的に以下にコピーされます：
H:\マイドライブ\apps\kokugo-kore\apk\app-release.apk
```

**手動コピー（オプション）:**
```powershell
Copy-Item `
  "K:\build\app\outputs\flutter-apk\app-release.apk" `
  "H:\マイドライブ\apps\kokugo-kore\apk\app-release.apk"
```

---

## ⚙️ トラブルシューティング

### エラー: "日本語パスが壊れている"

**症状:**
```
FAILURE: Build failed with an exception.
* Exception is: com.android.build.gradle.internal.cxx.CMakeException
```

**解決策:**
```powershell
# K:ドライブが正しく割り当てられていることを確認
subst

# 再度割り当て
subst /d K:
subst K: "H:\マイドライブ\apps\kokugo-kore"
```

---

### エラー: "KEYSTORE_PASSWORD が設定されていない"

**症状:**
```
FAILURE: Build failed with an exception.
* What went wrong:
Execution failed for task ':app:signReleaseApk'.
```

**解決策:**
```powershell
# 環境変数を確認
echo $env:KEYSTORE_PASSWORD
echo $env:KEY_PASSWORD

# 設定されていない場合は再度設定
$env:KEYSTORE_PASSWORD = "<パスワード>"
$env:KEY_PASSWORD = "<パスワード>"
```

---

### エラー: "JAVA_HOME が見つからない"

**症状:**
```
FAILURE: Build failed with an exception.
* What went wrong:
JAVA_HOME is not set
```

**解決策:**
```powershell
# Android Studioのjbrパスを確認
$env:JAVA_HOME = "C:/Program Files/Android/Android Studio/jbr"
echo $env:JAVA_HOME

# または別パスの場合：
$env:JAVA_HOME = "C:/Program Files/Android/Android Studio/jre"
```

---

## 📝 ビルドコマンド リファレンス

### デバッグビルド（署名なし）
```powershell
cd K:/
flutter build apk --debug
```

### リリースビルド（本番用・署名あり）
```powershell
cd K:/
KEYSTORE_PASSWORD="<password>" KEY_PASSWORD="<password>" `
flutter build apk --release --no-pub
```

### キャッシュをクリアして再ビルド
```powershell
cd K:/
flutter clean
flutter build apk --release --no-pub
```

---

## 🔍 ビルド後の検証

### APKの情報確認
```powershell
# APKサイズ
(Get-Item "K:\build\app\outputs\flutter-apk\app-release.apk").Length / 1MB

# APK署名確認
aapt dump badging "K:\build\app\outputs\flutter-apk\app-release.apk"
```

### 実機へのインストール
```powershell
# Android SDKのadbを使用
adb install -r "K:\build\app\outputs\flutter-apk\app-release.apk"
```

---

## 📊 ビルド統計

**プロジェクト情報:**
- アプリ名: 小学コレ！国語
- パッケージ: com.kokugo_kore.app
- ターゲット: Android 5.0+ (API 21+)

**対応デバイス:**
- スマートフォン (4.5"～6.7")
- タブレット (7"～10")

**ビルド設定:**
- ビルドツール: gradle 7.x
- Flutter: 最新安定版
- Dart: 最新安定版

---

## ✅ ビルド成功の確認

ビルド完了時に以下のメッセージが表示されます：

```
✓ Built build/app/outputs/flutter-apk/app-release.apk (XX.X MB)
```

**APKが正常に作成されたことを確認してください。**

---

## 🎯 次のステップ

ビルド完了後：

1. **実機テスト**
   ```powershell
   adb install -r "K:\build\app\outputs\flutter-apk\app-release.apk"
   ```

2. **Google Playストア提出**
   - App Bundle生成: `flutter build appbundle --release`
   - Google Play Console登録
   - 本番ファイアベース設定

3. **ベータテスト配布**
   - テスター向けAPK配布
   - フィードバック収集
   - バグ修正

---

**ビルドの成功をお祈りします！** 🚀
