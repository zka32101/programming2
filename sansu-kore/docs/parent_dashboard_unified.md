# 小学コレシリーズ — 共通親ダッシュボード実装計画

**対象**: 小学コレ全6教科（算数・国語・社会・理科・芸術・プログラミング）  
**フェーズ**: v3.3 (2026年11月～12月)  
**期間**: 4～5週間  
**目的**: 複数教科の学習進捗を親が一元管理

---

## 📋 目次

1. [共通化アーキテクチャ](#共通化アーキテクチャ)
2. [親ダッシュボード 共通UI](#親ダッシュボード-共通ui)
3. [マルチアプリ連携](#マルチアプリ連携)
4. [実装ロードマップ](#実装ロードマップ)
5. [Firestore スキーマ統一](#firestore-スキーマ統一)

---

## 共通化アーキテクチャ

### 現在の状態（v3.1）

```
【アプリごとに独立】
算数コレ         国語コレ         社会コレ
├ Firebase     ├ Firebase      ├ Firebase
├ ユーザー管理   ├ ユーザー管理    ├ ユーザー管理
└ 親向けUI     └ 親向けUI      └ 親向けUI
    (個別)         (個別)         (個別)

【課題】
- 親が6アプリを開く必要がある
- 進捗の統一管理ができない
- ユーザー認証が重複
```

### 目指す形（v3.3）

```
【統一親ダッシュボード】

小学コレ親ポータル
├ 子どもアカウント管理
│ ├ 子1: 太郎（小3）
│ ├ 子2: 花子（小1）
│ └ 子3: 次郎（小5）
│
├ 全教科進捗パネル
│ ├ 算数: 68% ████░░░░
│ ├ 国語: 52% ███░░░░░
│ ├ 社会: 71% █████░░░
│ ├ 理科: 45% ██░░░░░░
│ ├ 芸術: 89% ██████░░
│ └ プログラミング: 34% ██░░░░░░░
│
├ 学力分析
│ ├ 得意分野: 芸術・算数
│ ├ 苦手分野: プログラミング・理科
│ └ 推奨学習ロード
│
├ 家族ランキング（教科別）
│ ├ 算数: 1位 太郎、2位 次郎、3位 花子
│ ├ 国語: 1位 花子、2位 太郎、3位 次郎
│ └ ...
│
└ レポート・エクスポート
  ├ 月間学習レポート
  └ CSV/PDF出力
```

---

## 親ダッシュボード 共通UI

### スクリーン設計

#### 1. 親ログイン画面

```
┌──────────────────────────┐
│  小学コレ親ポータル      │
│  (複数子ども対応)        │
├──────────────────────────┤
│                          │
│ メールアドレス:          │
│ [parent@example.com]     │
│                          │
│ パスワード:              │
│ [••••••••••]            │
│                          │
│ [ログイン]               │
│ [新規登録]               │
│                          │
│ または                   │
│                          │
│ [Googleでログイン]       │
│                          │
└──────────────────────────┘
```

#### 2. ダッシュボード（子ども選択）

```
┌──────────────────────────────────┐
│ 小学コレ親ダッシュボード         │
├──────────────────────────────────┤
│                                  │
│ 📚 お子さんを選択:              │
│                                  │
│ ┌────────────────────┐          │
│ │ 👦 太郎 (小3)    │          │
│ │ 算数: 68%        │          │
│ │ 国語: 52%        │          │
│ │ [選択]           │          │
│ └────────────────────┘          │
│                                  │
│ ┌────────────────────┐          │
│ │ 👧 花子 (小1)    │          │
│ │ 算数: 92%        │          │
│ │ 国語: 78%        │          │
│ │ [選択]           │          │
│ └────────────────────┘          │
│                                  │
│ ┌────────────────────┐          │
│ │ 👦 次郎 (小5)    │          │
│ │ 算数: 45%        │          │
│ │ 社会: 61%        │          │
│ │ [選択]           │          │
│ └────────────────────┘          │
│                                  │
└──────────────────────────────────┘
```

#### 3. 子ども詳細ダッシュボード

```
┌──────────────────────────────────┐
│ 太郎 (小3) の学習進捗            │
├──────────────────────────────────┤
│                                  │
│ 📊 全教科進捗                   │
│                                  │
│ 算数    ████████░░ 68% (84/124問) │
│ 国語    █████░░░░░ 52% (61/115問) │
│ 社会    ███░░░░░░░ 28% (25/90問)  │
│ 理科    ████░░░░░░ 45% (42/93問)  │
│ 芸術    ██████░░░░ 65% (57/88問)  │
│ プログラミング ██░░░░░░░░ 18% (10/56問) │
│                                  │
│ 📈 学習統計 (今月)              │
│                                  │
│ 総学習時間: 42時間 35分          │
│ 1日平均: 1時間 22分             │
│ ストリーク: 15日連続             │
│ 正解率: 78%                     │
│                                  │
│ 🎯 今週の目標達成度             │
│ ┌──────────────────────┐        │
│ │ 目標: 週10時間学習  │        │
│ │ 実績: 8時間 42分   │        │
│ │ 達成度: 87%        │        │
│ └──────────────────────┘        │
│                                  │
└──────────────────────────────────┘
```

#### 4. 分析・推奨画面

```
┌──────────────────────────────────┐
│ 学力分析・推奨                   │
├──────────────────────────────────┤
│                                  │
│ 🌟 得意分野                      │
│ ├ 算数 (68%)                     │
│ ├ 芸術 (65%)                     │
│ └ おすすめ: 発展問題へステップアップ│
│                                  │
│ ⚠️  苦手分野                     │
│ ├ プログラミング (18%)           │
│ ├ 社会 (28%)                     │
│ └ おすすめ: 基礎から丁寧に      │
│                                  │
│ 📝 学習アドバイス                │
│ ├ 「プログラミングが全体平均より｜
│ │  低いです。60分/日を心がけて｜
│ │  みてください」                │
│                                  │
│ ├ 「ストリーク継続中! 素晴らしい│」|
│                                  │
│ └ 「得意な算数をさらに伸ばすため｜
│    発展問題へ」                  │
│                                  │
└──────────────────────────────────┘
```

#### 5. 家族ランキング（教科別）

```
┌──────────────────────────────────┐
│ 🏆 家族ランキング (今週)          │
├──────────────────────────────────┤
│                                  │
│ ≡ 算数                           │
│ 1位 👦 太郎 450点 ⭐⭐⭐       │
│ 2位 👦 次郎 420点 ⭐⭐        │
│ 3位 👧 花子 380点 ⭐         │
│                                  │
│ ≡ 国語                           │
│ 1位 👧 花子 520点 ⭐⭐⭐⭐     │
│ 2位 👦 太郎 420点 ⭐⭐        │
│ 3位 👦 次郎 310点 ⭐         │
│                                  │
│ ≡ 全体                           │
│ 1位 👧 花子 2000点 👑          │
│ 2位 👦 太郎 1890点             │
│ 3位 👦 次郎 1620点             │
│                                  │
└──────────────────────────────────┘
```

#### 6. レポート・エクスポート

```
┌──────────────────────────────────┐
│ 学習レポート                     │
├──────────────────────────────────┤
│                                  │
│ 期間選択: 2026年11月             │
│                                  │
│ 【月間サマリー】                 │
│ 総学習時間: 42時間 35分          │
│ 学習日数: 28日                   │
│ 平均正解率: 78%                 │
│                                  │
│ 【教科別進捗】                   │
│ 算数: 68% → 72% (↑4%)          │
│ 国語: 52% → 56% (↑4%)          │
│ 社会: 28% → 32% (↑4%)          │
│ 理科: 45% → 48% (↑3%)          │
│ 芸術: 65% → 68% (↑3%)          │
│ プログラミング: 18% → 22% (↑4%)  │
│                                  │
│ [PDF出力] [CSV出力] [メール送信] │
│                                  │
└──────────────────────────────────┘
```

---

## マルチアプリ連携

### 認証統一化

#### Before（現在）

```
【各アプリで独立認証】

ユーザーがやること:
1. 算数コレ起動 → ログイン（親用メール + パスワード）
2. 国語コレ起動 → ログイン（親用メール + パスワード）
3. 社会コレ起動 → ログイン（親用メール + パスワード）
   ... (6アプリ全部)

【問題】
- 6回のログイン処理
- 認証情報の重複
- パスワード忘れのたびに複数回リセット
```

#### After（v3.3以降）

```
【統一認証 + SSO (Single Sign-On)】

ユーザーがやること:
1. 小学コレ親ポータルで1回ログイン
   → 認証トークン取得

2. 各アプリ（算数コレなど）で自動ログイン
   → 親ポータルから渡されたトークンで認証
   → ユーザー情報をキャッシュ

【メリット】
- ログイン1回で全アプリ利用可能
- パスワード管理が一元化
- 子どもアカウントも親ID配下で管理
```

### Firebase Firestore スキーマ統一

#### 現在（各アプリ独立）

```firestore
// 算数コレ Firebase
users/
├ p001/
│ ├ email: parent@example.com
│ ├ children/
│ │ └ c001/ (太郎の太郎専用ID)

// 国語コレ Firebase
users/
├ p002/  ← 別のID
│ ├ email: parent@example.com
│ ├ children/
│ │ └ c002/ (別のID)
```

#### After（統一スキーマ）

```firestore
// 統一 Firestore (your-wish-education プロジェクト)

parents/
├ p001/
│ ├ email: parent@example.com
│ ├ displayName: 山田太郎
│ ├ phoneNumber: 090-xxxx-xxxx
│ ├ children: [c001, c002, c003]
│ └ lastLogin: 2026-11-15T10:30:00Z

children/
├ c001/
│ ├ name: 太郎
│ ├ grade: 3
│ ├ birthDate: 2017-04-15
│ ├ avatar: avatar_001.png
│ ├ parentId: p001
│ └ registeredApps: ["sansu", "kokugo", "shakai"]

apps/sansu-kore/
├ users/
│ ├ c001/
│ │ ├ correctCount: 84
│ │ ├ totalAnswered: 124
│ │ ├ currentStreak: 15
│ │ ├ badges: [badge001, badge002, ...]
│ │ └ lastUpdated: 2026-11-15T10:30:00Z
│
├ c002/
│ ├ correctCount: 92
│ ├ totalAnswered: 120
│ └ ...

apps/kokugo-kore/
├ users/
│ ├ c001/
│ │ ├ correctCount: 61
│ │ └ ...
│
└ c002/
  ├ correctCount: 78
  └ ...

apps/shakai-kore/
├ users/
│ └ ...

// 親向けダッシュボード用の統合ビュー
parentDashboards/
├ p001/
│ ├ totalStudyTime: 2800  # 分
│ ├ totalCoins: 4200
│ ├ averageAccuracy: 0.78
│ ├ childrenProgress: {
│ │   c001: {
│ │     sansu: {correctCount: 84, total: 124, progress: 0.68},
│ │     kokugo: {correctCount: 61, total: 115, progress: 0.52},
│ │     shakai: {correctCount: 25, total: 90, progress: 0.28},
│ │     rigaku: {correctCount: 42, total: 93, progress: 0.45},
│ │     geijutsu: {correctCount: 57, total: 88, progress: 0.65},
│ │     programming: {correctCount: 10, total: 56, progress: 0.18}
│ │   },
│ │   c002: {...},
│ │   c003: {...}
│ │ }
│ └ lastUpdated: 2026-11-15T10:30:00Z
```

### マルチアプリ連携フロー

```
【Firestore リアルタイム同期】

1. 親が親ポータルにログイン
   ↓
2. 親ID (p001) の children フィールドから子どもIDを取得
   ├ c001 (太郎)
   ├ c002 (花子)
   └ c003 (次郎)
   ↓
3. 各教科アプリの進捗を並列取得
   ├ apps/sansu-kore/users/{c001}
   ├ apps/kokugo-kore/users/{c001}
   ├ apps/shakai-kore/users/{c001}
   ├ apps/rigaku-kore/users/{c001}
   ├ apps/geijutsu-kore/users/{c001}
   └ apps/programming-kore/users/{c001}
   ↓
4. parentDashboards/{p001} に統合ビューを書き込み
   (Cloud Functions で自動更新)
   ↓
5. 親ポータルがリアルタイム表示
   (Firestore リスナーで監視)
```

---

## 実装ロードマップ

### Phase 1: 認証統一化（1～2週）

```
Week 1:
- Firebase Authentication を統一
  (各教科アプリ → 同じ Firebase プロジェクトに)
- 親用トークン体系設計
- 子どもアカウント管理体系

Week 2:
- 各教科アプリに「親ポータルログイン」フロー実装
- SSO トークン引き渡しメカニズム
```

### Phase 2: スキーマ統一化（1～2週）

```
Week 2-3:
- Firestore スキーマ統一
  - parents/ コレクション追加
  - children/ コレクション追加
  - parentDashboards/ コレクション追加
- Cloud Functions でマイグレーション
  (既存ユーザーデータを新スキーマに変換)
```

### Phase 3: 親ポータルUI実装（2～3週）

```
Week 3-4:
- 親ポータル Web/モバイル UI 実装
  - ログイン画面
  - 子ども選択画面
  - ダッシュボード画面
  - 分析画面
  - レポート画面

Week 4-5:
- Firestore リアルタイム連携実装
- グラフ・チャート描画（charts_flutter など）
```

### Phase 4: Cloud Functions で統合ロジック（2週）

```
Week 5-6:
- onParentDashboardAccess() 関数
  → 各教科の最新進捗を集計
- generateMonthlyReport() 関数
  → CSV/PDF 生成
- updateChildProgress() 関数
  → 子どもが学習 → 親ダッシュボード自動更新
```

### Phase 5: テスト・デプロイ（1～2週）

```
Week 6-7:
- 統合テスト（各教科 × 親ポータル）
- パフォーマンステスト
- セキュリティテスト
- Beta リリース

Week 8:
- フィードバック反映
- 本番リリース
```

---

## 各教科アプリへの影響（最小限）

### 算数コレ での実装例

```dart
// lib/main.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 親ポータルからのトークンを確認
  final token = await SharedPreferences.getInstance().getString("parent_token");
  
  if (token != null) {
    // 親がこのアプリを開いた場合
    // 親トークンで自動認証
    await FirebaseAuth.instance.signInWithCustomToken(token);
  } else {
    // 子どもが直接このアプリを開いた場合
    // 通常のログイン画面へ
  }
  
  runApp(const MyApp());
}
```

```dart
// lib/models/child_progress.dart

class ChildProgress {
  final String childId;
  final String appName;  // "sansu", "kokugo", etc.
  final int correctCount;
  final int totalAnswered;
  final double progress;
  final DateTime lastUpdated;
  
  // 親ポータルから Firestore query される
  ChildProgress({
    required this.childId,
    required this.appName,
    required this.correctCount,
    required this.totalAnswered,
    required this.lastUpdated,
  }) : progress = correctCount / totalAnswered;
}
```

```dart
// lib/services/parent_dashboard_service.dart

class ParentDashboardService {
  // 定期的に親ダッシュボード用データを Firestore に書き込み
  Future<void> syncToParentDashboard() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance
      .collection("apps/sansu-kore/users")
      .doc(uid)
      .get();
    
    if (userDoc.exists) {
      // parentDashboards/{parentId} に同期
      await FirebaseFirestore.instance
        .collection("parentDashboards")
        .doc(getParentId(uid))  // 子どもIDから親IDを逆引き
        .update({
          "childrenProgress.${uid}.sansu": {
            "correctCount": userDoc.data()!["correctCount"],
            "totalAnswered": userDoc.data()!["totalAnswered"],
            "progress": userDoc.data()!["correctCount"] / userDoc.data()!["totalAnswered"],
          }
        });
    }
  }
}
```

---

## Firestore セキュリティルール（統一）

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // 親ポータル: 親のみアクセス
    match /parents/{parentId} {
      allow read: if request.auth.uid == parentId;
      allow write: if request.auth.uid == parentId;
    }
    
    // 子どもアカウント: 親のみ読み取り
    match /children/{childId} {
      allow read: if request.auth.uid in resource.data.parentIds;
      allow write: if false;  // Cloud Functions のみ書き込み
    }
    
    // 親ダッシュボード: 親のみアクセス
    match /parentDashboards/{parentId} {
      allow read: if request.auth.uid == parentId;
      allow write: if false;  // Cloud Functions のみ書き込み
    }
    
    // 各教科アプリのデータ: 子ども本人 + 親が読み取り可
    match /apps/{appName}/users/{userId} {
      allow read: if 
        request.auth.uid == userId ||
        request.auth.uid == resource.data.parentId;
      allow write: if request.auth.uid == userId;
    }
  }
}
```

---

## 実装効果

### ユーザー体験の向上

```
Before:
親: 「太郎の進捗は?」
→ 算数コレ開く → ログイン → 確認
→ 「国語は?」 → 国語コレ開く → ログイン → 確認
→ (6回繰り返し)

After:
親: 「太郎の進捗は?」
→ 親ポータル開く → 1画面で全教科確認 ✨
→ グラフで一目瞭然
→ AI推奨で「プログラミングを頑張ろう」
```

### 親の関与度向上

```
DAU増加: +40% (親ユーザー)
   - 親ポータル: 週3回以上アクセス
   - 「子どもが今日やったね」という認識が深まる

レビュー評価向上: +0.3★
   - 「子どもの成長が見える」という評判

紹介率向上: +30%
   - 「全教科を1つのアプリで管理できる」という強み
```

### マネタイズ

```
親向けプレミアム版:
- ¥199/月 (全教科セット)
- 詳細分析 + 月間PDF レポート
- 有料化率 5～10% → MRR ¥1M～3M

学校向け B2B:
- 学校が複数の小学コレを導入時
- 親ポータルで一括管理
- ライセンス料: 1校あたり ¥100k～300k/年
```

---

## 実装規模・コスト

### 開発工数

```
Web/モバイル親ポータル: 200h
Firestore スキーマ統一化: 80h
Cloud Functions (統合ロジック): 100h
各教科アプリ連携: 60h (× 6教科 = 360h)
テスト・デプロイ: 100h

合計: 840h = 21週 (1人開発)
      または 4～5週 (3～4人チーム開発)
```

### 外注コスト（3～4人チーム、4週間）

```
Frontend (親ポータル): ¥400k
Backend (Cloud Functions): ¥300k
各教科連携: ¥300k
テスト・デプロイ: ¥150k

合計: ¥1.15M
```

---

## 次のステップ

```
【完成後のイメージ】

2026年12月: v3.3 リリース
├ 算数コレ + 親ダッシュボード（全機能）
├ 国語コレ ダッシュボード連携
├ 社会コレ ダッシュボード連携
└ ... (順次、各教科が対応)

2027年3月: 全6教科が親ダッシュボード対応完了
└ 「小学コレ統合学習プラットフォーム」確立

2027年6月: 小学コレシリーズ全体で月次売上 ¥3M～5M
```

**共通親ダッシュボードは、小学コレシリーズを「単一の学習プラットフォーム」へと進化させるキー機能です。** 🎓

