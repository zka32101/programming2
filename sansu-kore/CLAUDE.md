# 算数コレ！— Claude開発メモ

**バージョン**: v2.1 開発中  
**最終更新**: 2026年6月8日  
**アクティブブランチ**: `feature/v2.1-phase2-enhancements`

---

## 📊 プロジェクト状態

| 項目 | 状態 |
|------|------|
| **v2.0.0** | ✅ リリース準備完了（Google Play審査中） |
| **v2.1開発** | 🔄 Phase 1 バグ修正中 |
| **ビルド** | Android APK/AAB (56-57MB) |
| **問題数** | 312問 + v2.1で600+に拡張予定 |

---

## 🌳 Git ブランチ構造

```
master
  ↓ [v2.0.0 release]
develop
  ├─ feature/v2.1-phase1-bugfixes (🎯 現在地)
  │  ├─ 紹介機能バグ修正
  │  ├─ ユーザー切り替えバグ修正
  │  └─ 選択肢ランダム配置
  └─ feature/v2.1-phase2-enhancements
     ├─ ホーム画面 ガイドセクション
     ├─ ふりがな対応
     └─ ステージ倍増
```

---

## ✅ Phase 1: 緊急バグ修正（Week 1-2）完了

### 完了したタスク

#### 1. 紹介機能バグ修正 ✅
**状態**: コード実装完了（Firebase依存関係待ち）  
**内容**: キー発行システムに変更

**新規ファイル**:
```
lib/models/referral_model.dart       (紹介コード管理)
lib/providers/referral_provider.dart (紹介ロジック)
```

**修正ファイル**:
```
lib/screens/invite_screen.dart       (UI更新)
```

**実装内容**:
```dart
// 1. 紹介キー生成
String referralKey = "SANSU" + DateTime.now().format("yyyymmdd") + randomString(5);
// 例: SANSU20260608ABCDE

// 2. Firestore に保存
CollectionReference referralCodes = FirebaseFirestore.instance.collection('referral_codes');
await referralCodes.doc(referralKey).set({
  'creatorId': currentUser.id,
  'creatorCoins': 0,
  'usedCount': 0,
  'maxUses': 5,
  'createdAt': Timestamp.now(),
});

// 3. 紹介されたユーザーが入力
await validateAndApplyReferralCode(referralKey);
// → 紹介した側 +100 coins
// → 紹介された側 +50 coins
```

**進捗**:
- [ ] `referral_model.dart` 作成
- [ ] `referral_provider.dart` 作成
- [ ] `invite_screen.dart` 修正
- [ ] テスト

---

#### 2. ユーザー切り替えバグ修正
**現状**: ログアウト後も前のユーザーデータが残存  
**対応**: 完全クリア処理を実装

**修正ファイル**:
```
lib/providers/profile_provider.dart
lib/providers/progress_provider.dart
lib/screens/login_screen.dart
```

**実装内容**:
```dart
Future<void> logout() async {
  // 1. SharedPreferences をクリア
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  // 2. Firebase ログアウト
  await FirebaseAuth.instance.signOut();

  // 3. Provider を全リセット
  ref.invalidate(profileProvider);
  ref.invalidate(progressProvider);
  ref.invalidate(coinProvider);
  ref.invalidate(badgeProvider);
  ref.invalidate(characterProvider);
  ref.invalidate(growthProvider);
}
```

**進捗**:
- [ ] logout() メソッド実装
- [ ] provider reset 処理
- [ ] テスト

---

#### 3. 選択肢ランダム配置
**現状**: 正解が2番目・3番目に偏っている  
**対応**: ビルド時にシャッフル

**修正ファイル**:
```
lib/models/quest_model.dart
lib/data/stage_data.dart
```

**実装内容**:
```dart
class QuizQuestion {
  final String id;
  final List<String> choices;
  final int correctIndex;
  
  // ランダム化メソッド
  QuizQuestion randomizeChoices() {
    final shuffled = [...choices];
    shuffled.shuffle();
    final newCorrectIndex = shuffled.indexOf(choices[correctIndex]);
    
    return QuizQuestion(
      id: id,
      choices: shuffled,
      correctIndex: newCorrectIndex,
      // ... other fields
    );
  }
}

// stage_data.dart で適用
List<QuizQuestion> questions = [...].map((q) => q.randomizeChoices()).toList();
```

**進捗**:
- [ ] randomizeChoices() メソッド追加
- [ ] stage_data で適用
- [ ] テスト

---

## ✨ Phase 2: 機能改善（Week 2-3）開発開始

### 優先タスク

#### 1. ホーム画面にガイドセクション追加
**目的**: 算数のやり方をわかりやすく説明  
**内容**: 
- 学年別「算数ガイド」セクション
- 足し算のやり方、かけ算の仕組みなど
- 動画または図解での説明

**作業ファイル**:
```
lib/screens/math_guide_screen.dart (新規作成)
lib/screens/home_screen.dart (修正)
```

#### 2. 漢字にふりがなを追加
**目的**: 小学低学年が読める環境に  
**内容**:
- すべての漢字にふりがな
- TextSpan + RichText で実装
- 1年生優先

**作業ファイル**:
```
lib/screens/quest_screen.dart
lib/screens/home_screen.dart
lib/widgets/ (新規 furigana widget)
```

#### 3. ステージ倍増（54 → 108）
**目的**: ボリュームアップ + 達成感UP  
**内容**:
- 各学年 9 → 18 ステージ
- 各ステージ 3～5問（短時間クリア）
- 問題数: 312 → 600+

**作業ファイル**:
```
lib/data/stage_data.dart (大幅拡張)
```

---

## 🔧 セットアップ・ビルド手順

### 前提
- Flutter 3.11.5以上
- Android SDK (NDK含む)
- Java 17

### クリーンビルド
```bash
cd H:/マイドライブ/apps/sansu-kore
flutter clean
flutter pub get
flutter build apk --release  # Android
```

### デバッグビルド
```bash
flutter run --debug
```

---

## 📦 バージョン管理

**pubspec.yaml**:
```yaml
version: 2.0.0+2  # v2.0.0リリース版
# v2.1開発時に 2.1.0+3 に更新
```

**Git Tag**:
```bash
git tag v2.0.0     # リリース版
git tag v2.1-beta1 # 開発版
```

---

## 🚀 リリースチェックリスト（v2.1用）

### コード品質
- [ ] lint エラーなし (`flutter analyze`)
- [ ] 全テスト合格
- [ ] バグ修正3件 完了

### デバイステスト
- [ ] Android 6.0 テスト
- [ ] Android 12+ テスト
- [ ] 画面サイズ別テスト（phone/tablet）

### Google Play準備
- [ ] プライバシーポリシー最新化
- [ ] スクリーンショット準備
- [ ] リリースノート記入

---

## 📝 Notes

- **推奨エディタ**: VS Code + Flutter extension
- **デバッグ**: `flutter logs` でリアルタイム出力確認
- **ホットリロード**: `r` (デバッグ時)
- **再ビルド**: `R` (デバッグ時)

---

**次のステップ**: Phase 1 バグ修正開始 🔧

