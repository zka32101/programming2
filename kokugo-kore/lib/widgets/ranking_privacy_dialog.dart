import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/ranking_privacy_provider.dart';

/// ランキング名前公開許可ダイアログ
/// ユーザーがランキングでユーザー名を公開するかどうかを確認
class RankingPrivacyDialog extends ConsumerWidget {
  final VoidCallback? onAllowCallback;

  final VoidCallback? onDenyCallback;

  const RankingPrivacyDialog({
    this.onAllowCallback,
    this.onDenyCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('ランキング表示設定'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ランキングにあなたの名前を表示しますか？',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            '• 許可：ランキングに本名を表示します',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            '• 拒否：ランキングに「ユーザーXXX」と匿名表示されます',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Text(
            '設定は後でプロフィール画面から変更できます。',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final privacy = ref.read(rankingPrivacyProvider.notifier);
            await privacy.markDialogShown();
            Navigator.of(context).pop();
            onDenyCallback?.call();
          },
          child: const Text('拒否'),
        ),
        FilledButton.tonal(
          onPressed: () async {
            final privacy = ref.read(rankingPrivacyProvider.notifier);
            await privacy.setNamePublic(true);
            await privacy.markDialogShown();
            Navigator.of(context).pop();
            onAllowCallback?.call();
          },
          child: const Text('許可'),
        ),
      ],
    );
  }
}

/// ランキング表示時にプライバシーダイアログを自動表示
/// ランキング画面の build メソッド内で使用
class RankingPrivacyGuard extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onPrivacyShown;

  const RankingPrivacyGuard({
    required this.child,
    this.onPrivacyShown,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldShow = ref.watch(rankingPrivacyDialogProvider);

    // ダイアログ表示が必要な場合は、ウィジェットツリー構築後に表示
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (shouldShow && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => RankingPrivacyDialog(
            onAllowCallback: onPrivacyShown,
            onDenyCallback: onPrivacyShown,
          ),
        );
      }
    });

    return child;
  }

  bool get mounted => true;
}
