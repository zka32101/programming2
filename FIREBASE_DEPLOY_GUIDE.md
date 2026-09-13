# Firebase Deploy Guide

## 📋 Firestore Rules デプロイ手順

### 前提条件
```bash
# 1. Firebase CLI インストール
npm install -g firebase-tools

# 2. Firebase ログイン
firebase login

# 3. Firebase プロジェクト初期化（初回のみ）
firebase init firestore
```

### デプロイ方法

#### **方法 1: コマンドラインデプロイ（推奨）**
```bash
# Firestore Rules のみをデプロイ
firebase deploy --only firestore:rules

# ルールの検証のみ（デプロイなし）
firebase rules:test
```

#### **方法 2: Cloud Console経由**
1. [Google Cloud Console](https://console.cloud.google.com/) にログイン
2. プロジェクト選択 → **Firestore Database**
3. **Rules** タブ → **Edit Rules**
4. `firestore.rules` の内容をコピー＆ペースト
5. **Publish** をクリック

### ルール検証

```bash
# ローカルテスト実行（rulesの構文確認）
firebase rules:test
```

### デプロイ対象ファイル

| ファイル | 内容 |
|---|---|
| **firestore.rules** | Firestore Security Rules |
| **firestore.indexes.json** | Firestore インデックス定義 |
| **firebase.json** | Firebase プロジェクト設定 |

### デプロイ後の確認

```bash
# デプロイされたルールをダウンロード（確認用）
firebase rules:download firestore

# Cloud Console で確認
# Firestore Database → Rules → View Current Rules
```

---

## 🔐 ルール概要

### Users Collection
- **読取/書き込み**: 本人のみ (`request.auth.uid == userId`)

### ScreenTime Config
- **読取/書き込み**: 親（userId）のみ
- **検証ルール**:
  - `dailyLimitMinutes`: 1-480分
  - `usedTodayMinutes`: 0-1440分
  - `lastUpdated`: Timestamp 必須

### ScreenTime History
- **読取/書き込み**: 親（userId）のみ
- **検証ルール**:
  - `date`: 文字列必須
  - `entries`: 配列必須

### セキュリティ
- デフォルトで全アクセスを拒否
- 明示的に許可されたパスのみアクセス可

---

## 🧪 テスト

ルールをテストする場合：

```dart
// Firestore Emulator を使用したテスト
firebase emulators:start --only firestore

// テストコード例
group('Firestore Security Rules', () {
  test('親のみが children 配下にアクセス可', () {
    // test implementation
  });
});
```

---

## 📊 デプロイ状況

| 項目 | 状態 |
|---|---|
| **firestore.rules** | ✅ 作成済み |
| **firestore.indexes.json** | ✅ 作成済み |
| **firebase.json** | ✅ 作成済み |
| **Firebase CLI** | ⚠️ インストール必要 |
| **デプロイ実行** | ⏳ 次ステップ |

---

## 🚀 デプロイ実行コマンド

```bash
# ターミナルで実行
cd H:\マイドライブ\apps

# Firebase CLI インストール（初回のみ）
npm install -g firebase-tools

# Firebase ログイン（初回のみ）
firebase login

# Firestore Rules をデプロイ
firebase deploy --only firestore:rules
```

---

**デプロイ完了後**: Cloud Console で Rules が反映されたことを確認
