<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

小学コレシリーズ共通パッケージ — models / providers / widgets / services / theme

## クロスプロモーション（他アプリ紹介）機能

`CrossPromoService` + `CrossPromoSection` で、各アプリの設定画面などに
「他のアプリもチェック！」セクションを追加できる。紹介ラインナップは
Firebase Remote Config の `cross_promo_apps` キー（JSON配列）で管理するため、
新作リリース時もアプリ更新なしで各アプリ側の Remote Config 値を書き換えるだけでよい。

### 導入手順（各アプリ側）

1. `main.dart` の `Firebase.initializeApp()` の直後で初期化する:
   ```dart
   import 'package:shared_core/shared_core.dart' show CrossPromoService;

   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   await CrossPromoService.init();
   ```
2. 設定画面などに埋め込む（`currentAppId` はそのアプリの applicationId。
   自アプリは紹介リストから自動的に除外される）:
   ```dart
   import 'package:shared_core/shared_core.dart' show CrossPromoSection;

   const CrossPromoSection(currentAppId: 'com.petitworksapps.shougakukore.sansu'),
   ```
3. 各アプリの Firebase プロジェクトの Remote Config コンソールで
   `cross_promo_apps` パラメータに以下形式の JSON を設定する:
   ```json
   [
     {
       "id": "com.petitworksapps.shougakukore.kokugo",
       "name": "国語コレ！",
       "tagline": "読解力を毎日ちょっとずつ",
       "iconUrl": "https://.../icon.png",
       "storeUrl": "https://play.google.com/store/apps/details?id=...",
       "category": "小学コレ"
     }
   ]
   ```
   紹介対象が0件・未設定・取得失敗時は `CrossPromoSection` は何も表示しない
   （`SizedBox.shrink()`）ため、未設定のまま出荷しても安全。

### 実装済みの参考実装

`sansu-kore`（算数コレ！）の `lib/main.dart` と `lib/screens/settings_screen.dart`
に導入済み。他アプリへの展開時はこれをテンプレートにする。

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
