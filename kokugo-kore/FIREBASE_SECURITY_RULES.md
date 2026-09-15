# Firebase Realtime Database セキュリティルール設定

## 概要

kokugo-kore アプリの Firebase Realtime Database セキュリティルールを本番レベルに設定するためのガイドです。

**プロジェクト情報:**
- Project ID: `kore1-6b58e`
- Database URL: `https://kore1-6b58e-default-rtdb.asia-southeast1.firebasedatabase.app`
- Region: `asia-southeast1`

## データ構造

```
{
  "kokugo-kore": {
    "rankings": {
      "students": {
        "student_1": {
          "studentId": "student_1",
          "studentName": "太郎",
          "score": 100,
          "startedAt": "2026-01-15",
          "birthYear": 2021,
          "acquiredAt": "2026-08-20",
          "currentGrade": 5
        }
        // ... other students
      }
    },
    "users": {
      "user_1": {
        "userId": "user_1",
        "displayName": "太郎",
        "email": "user@example.com",
        // ... user profile
      }
    },
    "friendships": {
      "user_1": {
        "user_2": true,
        // ... other friends
      }
    }
  }
}
```

## セキュリティルール設計

### アクセス制御の原則

1. **読み取り (read)**
   - ランキングデータ: 認証済みユーザーなら全員読み取り可能
   - ユーザー情報: 本人のみ読み取り可能
   - フレンドリスト: フレンド関係があるユーザーのみ読み取り可能

2. **書き込み (write)**
   - ランキングデータ: バックエンド(サーバー)のみ書き込み可能
   - ユーザー情報: 本人のみ書き込み可能
   - フレンドリスト: フレンド関係に関わるユーザーのみ書き込み可能

## Firebase Console での設定手順

### 1. Firebase Console へアクセス

```
https://console.firebase.google.com/project/kore1-6b58e
```

### 2. Realtime Database セキュリティルール画面へ移動

1. 左メニューから「Realtime Database」を選択
2. 「ルール」タブをクリック

### 3. 本番用セキュリティルールを設定

以下のルールをコピーして、ルール編集画面に貼り付けます：

```json
{
  "rules": {
    ".read": false,
    ".write": false,
    "kokugo-kore": {
      ".read": "auth != null",
      ".write": false,
      "rankings": {
        ".read": "auth != null",
        ".write": false,
        "students": {
          ".read": "auth != null",
          ".write": false,
          "$studentId": {
            ".read": "auth != null",
            ".write": false
          }
        }
      },
      "users": {
        ".read": "auth != null",
        ".write": false,
        "$uid": {
          ".read": "auth != null && ($uid === auth.uid || root.child('kokugo-kore/friendships').child(auth.uid).child($uid).val() === true)",
          ".write": "auth != null && $uid === auth.uid",
          ".validate": "newData.hasChildren(['userId', 'displayName', 'email'])"
        }
      },
      "friendships": {
        ".read": "auth != null",
        ".write": false,
        "$uid": {
          ".read": "auth != null && ($uid === auth.uid || root.child('kokugo-kore/friendships').child(auth.uid).child($uid).val() === true || root.child('kokugo-kore/friendships').child($uid).child(auth.uid).val() === true)",
          ".write": "auth != null && $uid === auth.uid",
          "$friendId": {
            ".read": "auth != null && ($uid === auth.uid || root.child('kokugo-kore/friendships').child(auth.uid).child($uid).val() === true)",
            ".write": "auth != null && $uid === auth.uid"
          }
        }
      }
    }
  }
}
```

### 4. ルールを公開

1. 上記ルールをコピー・ペーストした後、「公開」ボタンをクリック
2. 確認ダイアログが表示されたら「公開」をクリック
3. "Successfully published rules" メッセージが表示されることを確認

## セキュリティルールの説明

### ランキングデータ (`kokugo-kore/rankings/students`)

```
".read": "auth != null",
".write": false
```

- **読み取り**: 認証済みユーザーなら誰でもアクセス可能
  - これによりアプリはランキング全体を表示可能
  - 匿名ユーザーはアクセス不可

- **書き込み**: バックエンドのみ書き込み可能（セキュリティルールで制限）
  - ユーザーの直接操作によるスコア改ざんを防止
  - サーバーサイドロジックで検証後に書き込み

### ユーザー情報 (`kokugo-kore/users/$uid`)

```
".read": "auth != null && ($uid === auth.uid || root.child('kokugo-kore/friendships').child(auth.uid).child($uid).val() === true)",
".write": "auth != null && $uid === auth.uid"
```

- **読み取り**:
  - 本人: 常にアクセス可能
  - フレンド: フレンド関係があるユーザーのみアクセス可能
  - その他: アクセス不可

- **書き込み**: 本人のみ可能
  - プロフィール編集はユーザーが直接実行可能
  - パスワードなど機密情報は別途保護

### フレンドリスト (`kokugo-kore/friendships/$uid`)

```
".read": "auth != null && ($uid === auth.uid || ...)",
".write": "auth != null && $uid === auth.uid"
```

- **読み取り**:
  - 本人: 常にアクセス可能
  - フレンド: 相互フレンド関係があるユーザーのみアクセス可能

- **書き込み**: 本人のみ可能
  - フレンドリクエスト送受信はサーバーで処理（別ルール）

## テスト方法

### Firebase Console での動作確認

1. **Realtime Database の Emulator での事前テスト** (推奨)
   ```bash
   firebase emulators:start
   ```

2. **本番環境での段階的ロールアウト**
   - Development ユーザーで先に検証
   - 一定期間監視後、全体に展開

### Dart コードでのテスト

```dart
// ランキングデータ読み取りテスト
Future<void> testRankingRead() async {
  try {
    final snapshot = await FirebaseDatabase.instance
        .ref('kokugo-kore/rankings/students')
        .once();
    print('✅ Rankings read successful');
  } catch (e) {
    print('❌ Rankings read failed: $e');
  }
}

// ユーザー情報読み取りテスト
Future<void> testUserRead(String uid) async {
  try {
    final snapshot = await FirebaseDatabase.instance
        .ref('kokugo-kore/users/$uid')
        .once();
    print('✅ User read successful');
  } catch (e) {
    print('❌ User read failed: $e');
  }
}

// 書き込みテスト（権限エラーが返ることを確認）
Future<void> testUnauthorizedWrite() async {
  try {
    await FirebaseDatabase.instance
        .ref('kokugo-kore/rankings/students/test')
        .set({'score': 9999});
    print('❌ Unauthorized write succeeded (セキュリティルール未設定)');
  } catch (e) {
    print('✅ Unauthorized write blocked: $e');
  }
}
```

## セキュリティチェックリスト

- [ ] Firebase Console でセキュリティルールを公開
- [ ] Emulator で各パターンをテスト
  - [ ] 認証ユーザーでランキング読み取り
  - [ ] 認証ユーザーでユーザー情報読み取り（本人のみ）
  - [ ] 認証ユーザーでフレンドリスト読み取り
  - [ ] ランキング書き込み拒否を確認
- [ ] 本番環境で段階的にロールアウト
- [ ] CloudWatch でエラーログを監視
- [ ] ユーザーからのフィードバック収集

## トラブルシューティング

### "Permission denied" エラー

原因: セキュリティルールがまだ設定されていない、または制限が厳しすぎる

対処:
1. Firebase Console でルールを確認
2. ユーザーが認証済みか確認
3. `.read` の条件を見直す

### Emulator での検証

```bash
# Emulator 起動
firebase emulators:start

# Dart コードで Emulator に接続
await FirebaseDatabase.instance.useDatabaseEmulator('localhost', 9000);
```

## 参考リンク

- [Firebase Realtime Database セキュリティルール](https://firebase.google.com/docs/database/security)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Firebase Realtime Database のベストプラクティス](https://firebase.google.com/docs/database/usage/best-practices)
