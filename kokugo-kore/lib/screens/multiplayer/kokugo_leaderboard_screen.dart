import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_core/shared_core.dart' show leaderboardProvider, LeaderboardView;
import '../../providers/multiplayer_provider.dart';

import '../../theme/app_theme.dart';

/// マルチプレイ対戦のレーティング・リーダーボード画面。
/// Phase 4 実装予定
class KokugoLeaderboardScreen extends ConsumerWidget {
  const KokugoLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('対戦レートランキング'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text('ランキング機能は準備中です'),
          ],
        ),
      ),
    );
  }
}

