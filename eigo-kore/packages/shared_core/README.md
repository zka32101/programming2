# shared_core

Petit Works apps 共通の Flutter ウィジェット/モデル集です。
[kokugo-kore](https://github.com/zka32101/kokugo-kore)、`social_quiz_app`、
および今後増える他アプリから、各アプリの `pubspec.yaml` に git dependency として
参照されることを想定しています。

## 含まれるもの

- `lib/models/` — 共通データモデル（ユーザープロフィール、クエスト、バッジ、アバター、キャラクターなど）
- `lib/providers/` — Riverpod ベースの状態管理プロバイダー
- `lib/widgets/` — 共通UIウィジェット（クイズ、デイリーボーナス、コインショップなど）
- `lib/services/` — Firebase連携などの共通サービス
- `lib/theme/` — アプリ共通のベーステーマ
- `lib/assets/` — バッジアイコン、アバター、UI素材などの共通アセット

エントリポイントは `lib/shared_core.dart`（バレルファイル）です。

## 利用方法

利用側アプリの `pubspec.yaml` に以下のように追加します。

```yaml
dependencies:
  shared_core:
    git:
      url: https://github.com/zka32101/shared_core.git
      ref: main
```

```dart
import 'package:shared_core/shared_core.dart';
```

## 注意事項

- `shared_core` は姉妹パッケージ `cross_promo_kit`（クロスプロモーション
  機能）を git dependency として参照し、`lib/shared_core.dart` から
  re-export しています。`cross_promo_kit` は独立リポジトリ
  ([zka32101/cross_promo_kit](https://github.com/zka32101/cross_promo_kit))
  として切り出し済みです。
