import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart' show leaderboardProvider, LeaderboardView;
import '../../providers/multiplayer_provider.dart';

import '../../theme/app_theme.dart';

/// マルチプレイ対戦のレーティング・リーダーボード画面。
///
/// shared_core の [LeaderboardView] にそのままデータを渡すだけの薄いラッパー
/// （バッジ獲得数ベースの既存 `/ranking` とは別物：こちらは対戦レートの順位）。
class KokugoLeaderboardScreen extends ConsumerWidget {
  const KokugoLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final identity = ref.watch(kokugoPlayerIdentityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('対戦レートランキング'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: leaderboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('エラーが発生しました: $err')),
        data: (ratings) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(leaderboardProvider),
          child: LeaderboardView(
            ratings: ratings,
            currentUserId: identity?.userId,
            accentColor: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
