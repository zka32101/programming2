# GitHub Actions APK ビルド セットアップガイド

## 📋 前提条件

- GitHub リポジトリへのアクセス権
- Android Keystore ファイル (`release_new.jks`)
- Keystore パスワード
- Key パスワード

---

## 🔐 GitHub Secrets の登録手順

### ステップ 1: リポジトリ設定を開く

1. GitHub のリポジトリページを開く
2. **Settings** タブをクリック
3. 左側メニューから **Secrets and variables** → **Actions** を選択

### ステップ 2: Secrets を登録

以下の 3 つを登録します：

#### 1. `ANDROID_KEYSTORE_BASE64`

Keystore ファイルを Base64 エンコードして登録：

**Windows PowerShell:**
```powershell
$keystore = Get-Content -Path "android/keystore/release_new.jks" -Encoding Byte
$base64 = [Convert]::ToBase64String($keystore)
Set-Clipboard -Value $base64
# クリップボードにコピーされました
```

**macOS/Linux:**
```bash
base64 -i android/keystore/release_new.jks | pbcopy
# または
base64 -w 0 android/keystore/release_new.jks | xclip -selection clipboard
```

GitHub Actions の Secrets に登録：
- **Name:** `ANDROID_KEYSTORE_BASE64`
- **Value:** ↑ コピーした Base64 文字列を貼り付け

#### 2. `ANDROID_KEYSTORE_PASSWORD`

- **Name:** `ANDROID_KEYSTORE_PASSWORD`
- **Value:** `release_new.jks` のストアパスワード

#### 3. `ANDROID_KEY_PASSWORD`

- **Name:** `ANDROID_KEY_PASSWORD`
- **Value:** `kokugo_release` キーのパスワード

---

## 🚀 ワークフローの実行

### GitHub Actions から実行

1. リポジトリの **Actions** タブを開く
2. 左側で **Build Android APK** を選択
3. **Run workflow** ボタンをクリック
4. **Build type** を選択（`release` または `debug`）
5. **Run workflow** をクリック

### 実行状況の確認

- ワークフローが開始され、Windows ランナー上でビルドが実行されます
- 進捗状況はリアルタイムで表示されます
- ビルド完了後、APK がアーティファクトとしてアップロードされます

---

## 📥 ビルド成果物のダウンロード

1. ワークフロー実行ページで **Artifacts** セクションを確認
2. `apk-release` または `apk-debug` をダウンロード
3. APK ファイルを抽出

---

## 🔍 トラブルシューティング

### エラー: "ANDROID_KEYSTORE_BASE64 not set"

**原因:** GitHub Secrets が設定されていません

**解決策:** 上記の「GitHub Secrets の登録手順」を実行してください

### エラー: "Keystore password is incorrect"

**原因:** `ANDROID_KEYSTORE_PASSWORD` または `ANDROID_KEY_PASSWORD` が間違っています

**解決策:** Secrets の値を確認・修正してください

### エラー: "K: drive already in use"

**原因:** 前回のビルド時の K: ドライブ割り当てが残っている

**解決策:** PowerShell で以下を実行：
```powershell
subst K: /d
```

---

## 📊 ワークフロー構成

| ステップ | 内容 |
|---------|------|
| Checkout | コード取得 |
| Setup Java | Java 17 インストール |
| Setup Flutter | Flutter 3.44.4 インストール |
| Get dependencies | `flutter pub get` 実行 |
| Analyze code | コード静的解析 |
| Decode keystore | Base64 → バイナリに変換 |
| Map K: drive | 仮想ドライブ割り当て |
| Build APK | `flutter build apk` 実行 |
| Upload artifact | ビルド成果物をアップロード |

---

## ✅ セットアップ完了チェックリスト

- [ ] `ANDROID_KEYSTORE_BASE64` を登録
- [ ] `ANDROID_KEYSTORE_PASSWORD` を登録
- [ ] `ANDROID_KEY_PASSWORD` を登録
- [ ] ワークフローを実行してビルド成功を確認

---

**セットアップお疲れ様です！** 🎉

GitHub Actions でビルドが実行されるようになりました。

