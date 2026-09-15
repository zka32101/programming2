# ランキング表示プライバシー実装ガイド

## 概要

ランキング表示時にユーザープライバシーを保護する機能を実装しました。デフォルトではユーザー名を匿名化し、ユーザーが明示的に許可した場合のみ本名を表示します。

## 実装コンポーネント

### 1. ユーザー名匿名化 (`lib/models/ranking_model.dart`)

```dart
// 匿名化名を取得
String get displayName => 'ユーザー $studentId'.replaceFirst('student_', '');

// ランキング表示用の名前を取得
String getDisplayName({bool isNamePublic = false}) {
  return isNamePublic ? studentName : displayName;
}
```

**表示例:**
- `isNamePublic: false` → "ユーザー 001"
- `isNamePublic: true` → "太郎"

### 2. プライバシー設定プロバイダ (`lib/providers/ranking_privacy_provider.dart`)

```dart
// 設定の読み込み
await ref.read(rankingPrivacyProvider.notifier).load();

// ユーザー名公開の設定
await ref.read(rankingPrivacyProvider.notifier).setNamePublic(true);

// ダイアログ表示判定
bool shouldShow = ref.watch(rankingPrivacyDialogProvider);
```

**SharedPreferences キー:**
- `ranking_name_public`: ユーザー名を公開するか (true/false)
- `ranking_privacy_dialog_shown`: ダイアログを表示済みか (true/false)

### 3. ランキングサービス更新 (`lib/services/ranking_service.dart`)

```dart
// プライバシー設定を適用してランキングを取得
final grouped = await rankingService.getGroupedRankings(
  filter,
  isNamePublic: userPrivacySetting,
);
```

**内部処理:**
- `getGroupedRankings()` に `isNamePublic` パラメータを追加
- false の場合は `_applyPrivacyMask()` でユーザー名を匿名化

### 4. プライバシーダイアログ (`lib/widgets/ranking_privacy_dialog.dart`)

```dart
// 手動で表示
showDialog(
  context: context,
  builder: (_) => RankingPrivacyDialog(
    onAllowCallback: () => print('ユーザー名公開を許可'),
    onDenyCallback: () => print('ユーザー名公開を拒否'),
  ),
);

// 自動表示ウィジェット
RankingPrivacyGuard(
  child: YourRankingScreen(),
  onPrivacyShown: () => ref.refresh(rankingProvider),
)
```

## 使用例

### ランキング画面での実装

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final privacy = ref.watch(rankingNamePublicProvider);
  final rankings = ref.watch(rankingDataProvider(privacy));

  return RankingPrivacyGuard(
    child: ListView.builder(
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        final student = rankings[index];
        return ListTile(
          // プライバシー設定に基づいて表示
          title: Text(student.getDisplayName(isNamePublic: privacy)),
          subtitle: Text('順位: ${student.rank}'),
          trailing: Text('${student.score}点'),
        );
      },
    ),
    onPrivacyShown: () {
      // プライバシー設定変更後の処理
      ref.refresh(rankingDataProvider);
    },
  );
}
```

### 設定画面での実装

```dart
// プライバシー設定を表示・変更
class RankingPrivacySettings extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacy = ref.watch(rankingPrivacyProvider);

    return SwitchListTile(
      title: const Text('ランキングに名前を表示'),
      subtitle: const Text('オンにするとランキングに本名が表示されます'),
      value: privacy.isNamePublic,
      onChanged: (value) async {
        await ref.read(rankingPrivacyProvider.notifier)
            .setNamePublic(value);
      },
    );
  }
}
```

### 初期化時の処理

```dart
// main.dart または App の initState で実行
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(rankingPrivacyProvider.notifier).load();
  });
}
```

## プライバシーフロー

```
ユーザーがランキング画面を初回訪問
    ↓
ダイアログ表示判定: shouldShowPrivacyDialog()
    ↓
true → プライバシーダイアログを表示
    ↓
ユーザーが「許可」または「拒否」を選択
    ↓
設定を SharedPreferences に保存
    ↓
ダイアログ表示フラグを true に設定（以後表示しない）
    ↓
ランキング画面に設定に基づいてデータを表示
```

## セキュリティに関する注意

1. **クライアント側のみの処理**
   - プライバシー設定はクライアント側のみで管理
   - サーバー (Firebase) には本名を保存し続ける
   - 表示時のみマスキング

2. **バックアップ時の配慮**
   - SharedPreferences は暗号化されていない
   - 重要な個人情報は保存しない

3. **将来の拡張**
   - Firebase セキュリティルールで条件付き読み取り制御も検討
   - Cloud Functions でユーザー設定に基づくフィルタリング

## テスト方法

```dart
// プライバシー設定をテスト
Future<void> testPrivacySettings() async {
  final privacy = ref.read(rankingPrivacyProvider.notifier);
  
  // 初期状態: 非公開
  await privacy.load();
  assert(privacy.state.isNamePublic == false);
  
  // 公開に変更
  await privacy.setNamePublic(true);
  assert(privacy.state.isNamePublic == true);
  
  // ダイアログ表示状態
  await privacy.markDialogShown();
  assert(privacy.state.dialogShown == true);
  assert(privacy.shouldShowPrivacyDialog() == false);
}
```

## チェックリスト

- [ ] プライバシープロバイダを load() で初期化
- [ ] ランキング画面で RankingPrivacyGuard でラップ
- [ ] 設定画面でプライバシー設定を表示・変更可能にする
- [ ] getDisplayName() でユーザー名を取得
- [ ] テスト: 初回訪問でダイアログが表示される
- [ ] テスト: 設定を変更するとランキング表示が更新される
- [ ] テスト: アプリ再起動後も設定が保持される

## 今後の改善案

1. **より高度な匿名化**
   - ユーザーが自分で匿名名を設定
   - ニックネーム機能の追加

2. **プライバシー設定の詳細化**
   - 全体公開 / フレンドのみ公開 / 非公開の3段階

3. **Firebase との連携**
   - ユーザー設定を Firebase に保存
   - 複数端末での同期

4. **監査ログ**
   - ユーザー名が表示された回数をログに記録
