# 算数コレ v3.2 Phase 3 — Cloud Functions 実装計画

**フェーズ**: v3.2 Phase 3 (Phase 2 の後)  
**時期**: 2026年10月中旬～11月  
**期間**: 3～4週間  
**目的**: リアルタイム性・自動化・スケーラビリティ向上

---

## 📋 目次

1. [Cloud Functions の役割](#cloud-functions-の役割)
2. [実装する5つの関数](#実装する5つの関数)
3. [データフロー図](#データフロー図)
4. [詳細実装仕様](#詳細実装仕様)
5. [テスト・デプロイ](#テスト・デプロイ)

---

## Cloud Functions の役割

### なぜ Cloud Functions が必要か

```
Before (v3.1):
- クライアントがバッジ判定ロジック実行
- 問題: ローカルで判定→不正操作の可能性
  (時間巻き戻し, オフラインで不正加算など)
- 問題: 各デバイスが独立→ランキング同期が遅延

After (v3.2 Phase 3):
- サーバー側（Cloud Functions）で判定
- 問題: なし（不正は防止）
- リアルタイム: ランキングが即座に反映
```

### 実装効果

```
✅ セキュリティ向上（不正防止）
✅ リアルタイム性（ランキング即座に反映）
✅ スケーラビリティ（数百万ユーザーに対応）
✅ クライアント処理軽減（バッテリー・CPU節約）
```

---

## 実装する5つの関数

### 関数一覧

| # | 関数名 | トリガー | 処理内容 | 優先度 |
|---|--------|---------|---------|--------|
| **1** | `onQuestionAnswered` | Firestore write | バッジ判定・コイン加算 | **P0** |
| **2** | `updateWeeklyRanking` | Scheduled (毎日0:00 JST) | ランキング再計算 | **P0** |
| **3** | `awardBadges` | onQuestionAnswered後 | バッジ一括付与 | **P0** |
| **4** | `sendNotification` | バッジ獲得時 | プッシュ通知 | **P1** |
| **5** | `generateRecommendations` | 日次 (0:30 JST) | 復習問題推奨 | **P1** |

---

## 関数1: `onQuestionAnswered` (P0)

### 役割
クイズ回答時に自動実行。バッジ判定・コイン加算・ユーザーメタデータ更新。

### トリガー
```typescript
// Firestore: users/{uid}/answers/{answerId}
// 新規ドキュメント作成時に自動実行

{
  stageId: "g3s5",
  questionId: "q2",
  isCorrect: true,
  answeredAt: Timestamp.now(),
  timeSpent: 45  // 秒
}
```

### 処理フロー

```
1. ユーザーが答える
   ↓
2. Firestore: users/{uid}/answers/{answerId} に write
   ↓
3. Cloud Function トリガー
   ↓
4. 正解判定
   ├ isCorrect == true なら:
   │ ├ コイン +10 加算
   │ ├ 連続正解数 +1
   │ └ ストリーク +1
   │
   └ isCorrect == false なら:
     ├ コイン +0
     ├ 連続正解数 = 0
     └ (ストリーク維持)
   ↓
5. ユーザー統計更新
   ├ totalAnswered +1
   ├ correctCount +1 (if correct)
   ├ totalCoins +10 (if correct)
   ├ currentStreak +1 (if correct)
   └ longestStreak = max(currentStreak, longestStreak)
   ↓
6. ステージ進捗更新
   ├ stageProgress/{uid}/g3s5
   │ └ correctCount +1
   ↓
7. バッジ判定 (awardBadges 関数呼び出し)
   ↓
8. ユーザーに Firestore write 結果を返す
```

### コード例

```typescript
// functions/src/index.ts

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

exports.onQuestionAnswered = functions
  .region("asia-northeast1")  // 東京リージョン（レイテンシー最小化）
  .firestore
  .document("users/{uid}/answers/{answerId}")
  .onCreate(async (snap, context) => {
    const uid = context.params.uid;
    const answer = snap.data();
    
    const userRef = db.collection("users").doc(uid);
    const userDoc = await userRef.get();
    const userData = userDoc.data();
    
    // コイン計算
    const coins = answer.isCorrect ? 10 : 0;
    
    // ストリーク計算
    let newStreak = answer.isCorrect ? (userData.currentStreak || 0) + 1 : 0;
    let longestStreak = Math.max(newStreak, userData.longestStreak || 0);
    
    // ユーザー統計更新
    await userRef.update({
      totalAnswered: admin.firestore.FieldValue.increment(1),
      correctCount: answer.isCorrect 
        ? admin.firestore.FieldValue.increment(1)
        : userData.correctCount,
      totalCoins: admin.firestore.FieldValue.increment(coins),
      currentStreak: newStreak,
      longestStreak: longestStreak,
      lastAnsweredAt: admin.firestore.Timestamp.now(),
    });
    
    // ステージ進捗更新
    const stageProgressRef = userRef.collection("stageProgress").doc(answer.stageId);
    await stageProgressRef.update({
      answeredCount: admin.firestore.FieldValue.increment(1),
      correctCount: answer.isCorrect
        ? admin.firestore.FieldValue.increment(1)
        : (await stageProgressRef.get()).data().correctCount,
    });
    
    // バッジ判定（別関数で実装）
    await awardBadges(uid, userData);
  });
```

### 注意点
```
- 複数正解時の処理（トランザクション）
- オフライン→オンライン戻時の同期確認
- Firestore write コスト（1 function = 複数 write）
```

---

## 関数2: `updateWeeklyRanking` (P0)

### 役割
毎日0:00 JSTに全ユーザーを集計し、ランキング再計算。

### トリガー
```typescript
// Scheduled function: Cloud Scheduler で毎日 0:00 JST に実行
```

### 処理フロー

```
1. 前日終了時点の全ユーザーを集計
   ├ collectUsers: users コレクションから全ユーザー取得
   └ calculateScores: 各ユーザーのスコア計算
      // スコア = (正解数 × 10) + (ストリーク × 5)
   
2. スコア順でソート
   
3. ランキング書き込み
   ├ weeklyRankings/{week}/
   │ ├ rank001: {uid: "u001", score: 450, ...}
   │ ├ rank002: {uid: "u002", score: 420, ...}
   │ └ ...
   │
   └ userRankings/{uid}/
     └ currentRank: 1
        previousRank: 5
        
4. ランク変動でバッジ判定
   ├ 「1位獲得」バッジ
   ├ 「ランク50以内」バッジ
   └ 「ランク上昇」バッジ

5. メモリ節約: 前週のランキングを削除
```

### コード例

```typescript
exports.updateWeeklyRanking = functions
  .region("asia-northeast1")
  .pubsub
  .schedule("0 0 * * *")  // 毎日 0:00 UTC (9:00 JST は 23:00 UTC 前日 or 0:00 JST)
  .timeZone("Asia/Tokyo")  // JST 指定
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    const week = getWeekKey(now);  // "2026-W28" など
    
    // 全ユーザー取得 & スコア計算
    const usersSnapshot = await db.collection("users").get();
    const scores: Array<{uid: string, score: number}> = [];
    
    for (const userDoc of usersSnapshot.docs) {
      const userData = userDoc.data();
      const score = (userData.correctCount || 0) * 10 + (userData.currentStreak || 0) * 5;
      scores.push({uid: userDoc.id, score});
    }
    
    // スコア順ソート
    scores.sort((a, b) => b.score - a.score);
    
    // Firestore に書き込み
    const rankingRef = db.collection("weeklyRankings").doc(week);
    const batch = db.batch();
    
    scores.slice(0, 100).forEach((item, index) => {
      batch.set(rankingRef.collection("rankings").doc(`rank${String(index + 1).padStart(3, "0")}`), {
        uid: item.uid,
        score: item.score,
        rank: index + 1,
      });
      
      batch.update(db.collection("users").doc(item.uid), {
        currentRank: index + 1,
        lastRankUpdated: now,
      });
    });
    
    await batch.commit();
  });
```

---

## 関数3: `awardBadges` (P0)

### 役割
バッジ取得条件を判定し、自動付与。

### バッジ判定ロジック

```typescript
type BadgeCheckFn = (userData: any) => Promise<string[]>;

const badgeChecks: {[key: string]: BadgeCheckFn} = {
  // ストリーク系
  "streak_day1": async (u) => u.currentStreak >= 1 ? ["streak_day1"] : [],
  "streak_day7": async (u) => u.currentStreak >= 7 ? ["streak_day7"] : [],
  "streak_day30": async (u) => u.longestStreak >= 30 ? ["streak_day30"] : [],
  "streak_day100": async (u) => u.longestStreak >= 100 ? ["streak_day100"] : [],
  
  // スコア系
  "score_100": async (u) => u.totalCoins >= 100 ? ["score_100"] : [],
  "score_500": async (u) => u.totalCoins >= 500 ? ["score_500"] : [],
  "score_1000": async (u) => u.totalCoins >= 1000 ? ["score_1000"] : [],
  
  // ステージ系
  "stage_clear_all": async (u) => {
    const stages = await db.collection("users").doc(u.uid).collection("stageProgress").get();
    const cleared = stages.docs.filter(s => s.data().isCleared).length;
    return cleared >= 92 ? ["stage_clear_all"] : [];
  },
  
  // 正解率系
  "accuracy_90": async (u) => {
    const accuracy = (u.correctCount || 0) / (u.totalAnswered || 1);
    return accuracy >= 0.9 ? ["accuracy_90"] : [];
  },
};

exports.awardBadges = async (uid: string, userData: any) => {
  const earnedBadges: string[] = [];
  
  for (const [badgeId, checkFn] of Object.entries(badgeChecks)) {
    const result = await checkFn({...userData, uid});
    earnedBadges.push(...result);
  }
  
  // 新規バッジを Firestore に書き込み
  if (earnedBadges.length > 0) {
    const userRef = db.collection("users").doc(uid);
    for (const badgeId of earnedBadges) {
      await userRef.collection("badges").doc(badgeId).set({
        earnedAt: admin.firestore.Timestamp.now(),
      });
    }
  }
};
```

---

## 関数4: `sendNotification` (P1)

### 役割
バッジ獲得時にプッシュ通知を送信。

### トリガー
```typescript
// Firestore: users/{uid}/badges/{badgeId}
// 新規ドキュメント作成時にトリガー
```

### 処理フロー

```
バッジ獲得
  ↓
Firestore 書き込み
  ↓
Cloud Function トリガー
  ↓
Firestore から FCM トークン取得
  ↓
firebase-admin の messaging API で送信
  ↓
ユーザーの端末に通知
```

### コード例

```typescript
exports.sendNotification = functions
  .region("asia-northeast1")
  .firestore
  .document("users/{uid}/badges/{badgeId}")
  .onCreate(async (snap, context) => {
    const uid = context.params.uid;
    const badgeId = context.params.badgeId;
    
    // ユーザーの FCM トークン取得
    const userDoc = await db.collection("users").doc(uid).get();
    const fcmToken = userDoc.data()?.fcmToken;
    
    if (!fcmToken) return;  // トークンがなければ送信不可
    
    // バッジ情報取得
    const badge = badgeData[badgeId];  // badge_data.dart から参照
    
    // 通知送信
    const message = {
      notification: {
        title: "🎉 新しいバッジをゲット!",
        body: `「${badge.title}」を獲得しました！`,
      },
      data: {
        badgeId: badgeId,
        deeplink: "app://badge-collection",
      },
      token: fcmToken,
    };
    
    await admin.messaging().send(message);
  });
```

---

## 関数5: `generateRecommendations` (P1)

### 役割
毎日0:30にユーザーの弱点を検出し、復習問題をリコメンド。

### トリガー
```typescript
// Scheduled: 毎日 0:30 JST
```

### 処理フロー

```
1. 前日の全ユーザーを走査
2. ユーザーごとに:
   ├ 正解率50%以下の問題を抽出
   ├ その問題が含まれるステージの同難度問題を3問ピックアップ
   └ users/{uid}/recommendations/ に書き込み
3. アプリ起動時に recommendations を表示
   「昨日間違えた問題をもう一度解いてみて」
```

### コード例

```typescript
exports.generateRecommendations = functions
  .region("asia-northeast1")
  .pubsub
  .schedule("30 0 * * *")
  .timeZone("Asia/Tokyo")
  .onRun(async (context) => {
    const users = await db.collection("users").get();
    
    for (const userDoc of users.docs) {
      const uid = userDoc.id;
      
      // 昨日の回答を取得
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      yesterday.setHours(0, 0, 0, 0);
      
      const answers = await db
        .collection("users").doc(uid)
        .collection("answers")
        .where("answeredAt", ">=", admin.firestore.Timestamp.fromDate(yesterday))
        .get();
      
      // 誤答を集計
      const wrongAnswers = answers.docs.filter(d => !d.data().isCorrect);
      
      if (wrongAnswers.length === 0) continue;
      
      // 復習問題生成
      const recommendations = [];
      for (const wrong of wrongAnswers.slice(0, 3)) {  // 最大3問
        recommendations.push({
          questionId: wrong.data().questionId,
          reason: "昨日間違えた問題",
          recommendedAt: admin.firestore.Timestamp.now(),
        });
      }
      
      // Firestore に書き込み
      for (const rec of recommendations) {
        await db
          .collection("users").doc(uid)
          .collection("recommendations")
          .add(rec);
      }
    }
  });
```

---

## データフロー図

```
┌───────────────────────────────────────────────────────┐
│              クライアント (Flutter)                     │
│                                                       │
│  Quiz Answer → POST /quiz                             │
└────────────────────┬────────────────────────────────┘
                     │
                     ↓
        ┌─────────────────────────────┐
        │ Firestore: users/{uid}/     │
        │           answers/{answerId}│
        └────────────┬────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
         ↓                       ↓
    ┌────────────────┐  ┌─────────────────┐
    │onQuestionAnsw  │  │awardBadges      │
    │    ered        │  │(バッジ判定)     │
    │(スコア計算)    │  └────────┬────────┘
    └────────────────┘           │
         │                       │
         ↓                       ↓
    ┌──────────────────────────────────┐
    │users/{uid}/badges/{badgeId}      │
    └────────────┬─────────────────────┘
                 │
                 ↓
        ┌────────────────────┐
        │sendNotification    │
        │(プッシュ通知)      │
        └────────────────────┘
                 │
                 ↓
        ┌────────────────────┐
        │ユーザーの端末      │
        │(通知表示)          │
        └────────────────────┘

【毎日0:00 実行】
        ┌────────────────────┐
        │updateWeeklyRanking │
        │(ランキング再計算)  │
        └────────┬───────────┘
                 │
                 ↓
    ┌──────────────────────┐
    │weeklyRankings/{week} │
    │(トップ100)           │
    └──────────────────────┘

【毎日0:30 実行】
        ┌────────────────────┐
        │generateRecommenda  │
        │tions               │
        │(復習推奨)          │
        └────────┬───────────┘
                 │
                 ↓
    ┌──────────────────────┐
    │users/{uid}/          │
    │recommendations       │
    └──────────────────────┘
```

---

## Firestore セキュリティルール追加

```firestore
// 既存ルール + 新規追加

match /users/{uid}/answers/{document=**} {
  allow write: if request.auth.uid == uid;
  allow read: if request.auth.uid == uid || isAdmin();
}

match /users/{uid}/badges/{document=**} {
  allow read: if request.auth.uid == uid || request.auth.uid in resource.data.sharedWith;
  allow write: if false;  // Cloud Functions のみ書き込み可
}

match /weeklyRankings/{week}/rankings/{rank} {
  allow read: if request.auth.uid != null;
  allow write: if false;  // Cloud Functions のみ
}

match /users/{uid}/recommendations/{document=**} {
  allow read: if request.auth.uid == uid;
  allow write: if false;  // Cloud Functions のみ
}
```

---

## デプロイ手順

### Step 1: Firebase CLI 初期化

```bash
firebase init functions
# 言語: TypeScript
# ESLint: Yes
# dependencies install: Yes
```

### Step 2: functions/src/index.ts 実装

```bash
# 上記5つの関数をすべて実装
# テストは emulator で
```

### Step 3: ローカルテスト

```bash
firebase emulators:start --only firestore,functions

# Firestore emulator: http://localhost:4000
# Functions emulator: 自動テスト実行
```

### Step 4: デプロイ

```bash
firebase deploy --only functions

# デプロイ後、Firebase Console で実行ログ確認
# Cloud Scheduler で scheduled functions を有効化
```

---

## コスト見積もり

### 関数実行料

```
onQuestionAnswered:
- 月間実行数: 100万 (DAU 50k × 20問/日)
- 費用: 100万 × $0.40/100万 = $0.40

updateWeeklyRanking:
- 月間実行数: 30 (日1回)
- 費用: 30 × $0.40 = $0.012

awardBadges:
- onQuestionAnswered に含まれる

sendNotification:
- 月間実行数: 50万
- 費用: 50万 × $0.40/100万 = $0.20

generateRecommendations:
- 月間実行数: 30
- 費用: 30 × $0.40 = $0.012

合計: 約 $0.60/月 (時間がかかるため上限超え時は追加)
```

### Firebase 全体コスト

```
Firestore: 読み取り100万件/月 + 書き込み50万件/月 = $0.60
Functions: $0.60 (上記)
Messaging (プッシュ通知): 無料

合計: $1.20/月 程度（従量制）
```

---

## テスト計画

### Unit Test (関数単体テスト)

```typescript
// functions/src/__tests__/onQuestionAnswered.test.ts

describe("onQuestionAnswered", () => {
  it("正解時にコイン+10とストリーク+1", async () => {
    // テストデータ作成
    // 関数実行
    // 結果確認
  });
  
  it("誤答時にコイン+0とストリーク=0", async () => {
    // ...
  });
});
```

### Integration Test (Firestore emulator + functions emulator)

```bash
# emulator 起動
firebase emulators:start --only firestore,functions

# テスト実行
npm test
```

### e2e Test (実機 + 本番 functions)

```
1. テストアカウント作成
2. クイズ 100問解答
3. バッジ判定確認
4. ランキング反映確認
5. プッシュ通知確認
```

---

## リリース後の監視

### Cloud Console ダッシュボード

```
監視項目:
- 関数実行数
- エラーレート
- レイテンシー (平均 < 2秒)
- Firestore read/write 量
```

### ロギング

```
functions logs:read -n 100 --limit 1h
# 直近1時間のログを確認
```

---

**v3.2 Phase 3 完成で、ユーザー数 100k+ に対応できるスケーラビリティが確保されます。** 🚀

