# 小学コレ！ 共通機能実装ガイド

新しい教科版アプリに共通機能を適用するためのステップバイステップガイドです。

---

## 🚀 1. プロジェクト初期化

### 1.1 pubspec.yaml の依存関係

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  shared_preferences: ^2.3.0
  firebase_core: ^3.13.1
  firebase_auth: ^5.5.4
  firebase_database: ^11.3.10
  in_app_purchase: ^3.2.0
  google_mobile_ads: ^5.2.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  freezed: ^2.4.6
  build_runner: ^2.4.9
  json_serializable: ^6.7.1
```

### 1.2 Firebase 設定

各教科ごとに独立した Google Cloud プロジェクトを作成:

```bash
# iOS
cd ios
pod install --repo-update
cd ..

# Android - google-services.json を取得・配置
cp path/to/google-services.json android/app/
```

---

## 📁 2. ディレクトリ構造

推奨ディレクトリ構造（国語コレと同じ）:

```
lib/
├── main.dart                    # アプリエントリー、ナビゲーション定義
├── firebase_options.dart        # Firebase 設定
├── data/
│   ├── kana_data.dart          # 教科固有: ひらがなデータ等
│   └── quiz_data.dart          # 共通: クイズデータテンプレート
├── models/
│   ├── analytics_model.dart     # 共通: 分析モデル
│   ├── battle_model.dart        # 共通: バトルモデル
│   └── character_model.dart     # 共通: キャラクターモデル
├── providers/
│   ├── coin_provider.dart       # 共通: コイン管理
│   ├── progress_provider.dart   # 共通: 進捗管理
│   ├── badge_provider.dart      # 共通: バッジ管理
│   ├── profile_provider.dart    # 共通: プロフィール
│   ├── premium_provider.dart    # 共通: プレミアム状態
│   └── [教科固有_provider.dart]  # 教科固有プロバイダ
├── screens/
│   ├── home_screen.dart         # 共通: ホーム画面
│   ├── splash_screen.dart       # 共通: スプラッシュ
│   ├── settings_screen.dart     # 共通: 設定
│   ├── badge_screen.dart        # 共通: バッジ
│   ├── [教科固有_screen.dart]    # 教科固有画面
├── services/
│   ├── firebase_service.dart    # 共通: Firebase
│   └── ad_service.dart          # 共通: 広告
├── theme/
│   └── app_theme.dart           # 教科ごとにカスタマイズ
└── widgets/
    ├── premium_gate.dart        # 共通: プレミアムゲート
    ├── banner_ad_widget.dart    # 共通: 広告
    ├── generic_quiz_widget.dart # 共通: クイズUI
    └── [教科固有_widget.dart]    # 教科固有ウィジェット
```

---

## 💾 3. ユーザー・プロフィール管理

### 3.1 ProfileProvider の実装

```dart
// lib/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileState {
  final List<UserProfile> profiles;
  final String? selectedProfileId;

  ProfileState({
    this.profiles = const [],
    this.selectedProfileId,
  });
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState());

  static const _key = 'user_profiles';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    // SharedPreferences から復元
  }

  Future<void> addProfile(String name, int grade) async {
    final profile = UserProfile(
      id: uuid.v4(),
      name: name,
      grade: grade,
      createdAt: DateTime.now(),
    );
    // プロフィール追加ロジック
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(),
);
```

### 3.2 アバター・キャラクター統合

```dart
// lib/providers/avatar_unlock_provider.dart
// 国語コレの avatar_unlock_provider.dart をコピー
// _freeAvatarIds と _paidAvatarIds をカスタマイズ
```

---

## 💰 4. マネタイゼーション

### 4.1 コインシステムの初期化

```dart
// lib/providers/coin_provider.dart をコピー
// 必要に応じて:
// - 初期コイン数の変更
// - コイン獲得ボーナスの調整
// - 通知ロジックのカスタマイズ
```

### 4.2 In-App Purchase (IAP) 設定

```dart
// lib/main.dart で IAP を初期化
await InAppPurchase.instance.restorePurchases();

// プレミアムプロダクト ID の定義
const kProProductId = 'com.example.app.premium';
const kTrialProductId = 'com.example.app.trial_7days';
```

### 4.3 Google Play Console での設定

1. **Google Play Console** にログイン
2. **Your app** → **Products** → **In-app products**
3. プレミアムサブスクリプション作成:
   - Product ID: `com.example.math.premium`
   - 7日間無料トライアル有効化
   - 月額 ¥240（日本）

### 4.4 App Store での設定

1. **App Store Connect** にログイン
2. **In-App Purchases** セクション
3. Auto-Renewable Subscriptions 作成

---

## 📊 5. 学習進捗トラッキング

### 5.1 ProgressProvider の実装

```dart
// lib/providers/progress_provider.dart をコピー
// 以下をカスタマイズ:
// - clearedStageIds: ステージID スキーム
// - perfectStages: 100% クリアトラッキング
// - quizStats: クイズ別統計
```

### 5.2 AnalyticsProvider の実装

```dart
// lib/providers/analytics_provider.dart をコピー
// カスタマイズ:
// - 教科ごとの統計計算
// - 月別・週別の集計ロジック
```

---

## 🎮 6. ゲーミフィケーション

### 6.1 バッジシステム

```dart
// lib/providers/badge_provider.dart をコピー
// バッジ定義をカスタマイズ:

const badges = [
  Badge(
    id: 'first_complete',
    name: '初心者',
    description: '最初の問題をクリア',
    icon: Icons.star,
  ),
  Badge(
    id: 'perfect_streak_7',
    name: '完璧な1週間',
    description: '7日間連続で100%',
    unlockedAt: null,
  ),
  // ... 教科ごとのバッジ
];
```

### 6.2 キャラクター・レベルアップ

```dart
// lib/providers/character_provider.dart をコピー
// 以下をカスタマイズ:
// - キャラクター数
// - アンロック条件 (unlockAt フィールド)
// - レベルアップ報酬
```

### 6.3 日々のボーナス・ミッション

```dart
// lib/providers/daily_bonus_provider.dart をコピー
// ボーナス ロジック（変更不要）
// ミッション定義をカスタマイズ:

const dailyMissions = [
  Mission(
    id: 'login',
    title: 'ログインボーナス',
    reward: 10,  // コイン
  ),
  Mission(
    id: 'study_10min',
    title: '10分勉強する',
    reward: 50,
  ),
];
```

---

## 🎯 7. Firebase バックエンド

### 7.1 Firebase Authentication

```dart
// lib/services/firebase_service.dart
final auth = FirebaseAuth.instance;

// 匿名ユーザーとしてサインイン
await auth.signInAnonymously();

// または Google Sign-In
// await _googleSignIn.signIn();
```

### 7.2 Realtime Database 設定

Firebaseコンソール → Database → Rules:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid",
        "progress": { ".indexOn": ["clearedStageIds"] },
        "leaderboard": { ".indexOn": ["score", "timestamp"] }
      },
      "leaderboard": {
        ".read": true,
        "$uid": {
          ".write": "$uid === auth.uid"
        }
      }
    }
  }
}
```

---

## 🎨 8. UI・テーマのカスタマイズ

### 8.1 theme/app_theme.dart

```dart
// lib/theme/app_theme.dart

const Color kPrimaryColor = Color(0xFF2E86AB);      // 教科色に変更
const Color kAccentGreen = Color(0xFF06A77D);
const Color kBgLight = Color(0xFFF5F5F5);
const Color kTextDark = Color(0xFF333333);
const Color kTextMuted = Color(0xFF999999);

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: kPrimaryColor,
    colorScheme: ColorScheme.light(
      primary: kPrimaryColor,
      // 教科ごとにカスタマイズ
    ),
    // ... その他のテーマ設定
  );
}
```

### 8.2 カラーパレット例

```
国語: 紫系 (#6366F1)
算数: 青系 (#3B82F6)
理科: 緑系 (#10B981)
社会: 橙系 (#F59E0B)
英語: 赤系 (#EF4444)
```

---

## 📱 9. ナビゲーション・ルーティング

### 9.1 main.dart での route 定義

```dart
routes: {
  '/': (context) => const SplashScreen(),
  '/profile-selection': (context) => const ProfileSelectionScreen(),
  '/home': (context) => const RootShell(),
  '/settings': (context) => const SettingsScreen(),
  // 教科固有ルート
  '/lesson-1': (context) => LessonScreen(lessonId: '1'),
  // ...
},
onGenerateRoute: (settings) {
  // 動的ルート処理
  if (settings.name == '/quiz') {
    final quizId = settings.arguments as String;
    return MaterialPageRoute(
      builder: (_) => QuizScreen(quizId: quizId),
    );
  }
  return null;
},
```

---

## 🔧 10. ビルド・デプロイ

### 10.1 Android ビルド

```bash
cd android
# google-services.json の配置確認
flutter build apk --release

# AAB（Google Play）ビルド
flutter build appbundle --release
```

### 10.2 iOS ビルド

```bash
cd ios
pod install --repo-update
cd ..
flutter build ios --release
```

### 10.3 version 管理

**pubspec.yaml**:
```yaml
version: 1.0.0+1  # version+buildNumber
```

リリースごとにインクリメント:
- version: X.Y.Z（セマンティックバージョニング）
- buildNumber: 連番（1, 2, 3, ...）

---

## ✅ 11. チェックリスト

新しい教科版を立ち上げるときの確認事項:

- [ ] Firebase プロジェクト作成
- [ ] google-services.json / GoogleService-Info.plist 配置
- [ ] In-App Purchase プロダクト ID 定義
- [ ] テーマカラー・ロゴ変更
- [ ] キャラクター・バッジ定義
- [ ] クイズデータ実装
- [ ] プライバシーポリシー作成
- [ ] Google Play Console / App Store Connect 登録
- [ ] キーストア・証明書準備
- [ ] 最終テスト・QA実施

---

## 📚 12. 参考資料

- **Flutter 公式**: https://flutter.dev
- **Riverpod**: https://riverpod.dev
- **Firebase**: https://firebase.google.com
- **Google Play Console**: https://play.google.com/console
- **App Store Connect**: https://appstoreconnect.apple.com

---

## 🤝 サポート

共通機能に関する質問・バグ報告は shared_core リポジトリで管理してください。

