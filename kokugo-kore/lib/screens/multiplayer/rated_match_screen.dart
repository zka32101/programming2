import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart'
    show
        matchmakingProvider,
        playerRatingProvider,
        MatchmakingStatus,
        MatchmakingSearchWidget,
        PlayerRatingCard;

import '../../providers/multiplayer_provider.dart';
import '../../theme/app_theme.dart';

class RatedMatchScreen extends ConsumerStatefulWidget {
  const RatedMatchScreen({super.key});

  @override
  ConsumerState<RatedMatchScreen> createState() => _RatedMatchScreenState();
}

class _RatedMatchScreenState extends ConsumerState<RatedMatchScreen> {
  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    final identity = ref.watch(kokugoPlayerIdentityProvider);

    // マッチ成立を検知したら対戦画面へ遷移する。
    ref.listen(matchmakingProvider, (previous, next) {
      if (_navigated) return;
      if (next.status == MatchmakingStatus.matched && next.matchId != null) {
        _navigated = true;
        Navigator.of(context).pushReplacementNamed(
          '/multiplayer/quiz',
          arguments: next.matchId,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('レートマッチ'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimaryColor, kPrimaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: identity == null
              ? const Center(
                  child: Text(
                    'プロフィールを選択してから\n対戦を始めてください',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              : _buildBody(identity),
        ),
      ),
    );
  }

  Widget _buildBody(KokugoPlayerIdentity identity) {
    final matchmaking = ref.watch(matchmakingProvider);
    final ratingAsync = ref.watch(
      playerRatingProvider((userId: identity.userId, displayName: identity.displayName)),
    );

    if (matchmaking.status == MatchmakingStatus.searching) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: MatchmakingSearchWidget(
            avatar: const Text('国', style: TextStyle(fontSize: 36, color: kPrimaryColor)),
            displayName: identity.displayName,
            rating: ratingAsync.value?.rating ?? 1500.0,
            accentColor: Colors.white,
            onCancel: () => ref.read(matchmakingProvider.notifier).cancelSearch(identity.userId),
          ),
        ),
      );
    }

    return ratingAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
      error: (err, _) => Center(
        child: Text('エラーが発生しました: $err', style: const TextStyle(color: Colors.white)),
      ),
      data: (rating) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlayerRatingCard(
              rating: rating,
              avatar: const Text('国', style: TextStyle(fontSize: 28)),
              gradientStart: kAccentBlue,
              gradientEnd: kPrimaryDark,
            ),
            const SizedBox(height: 32),
            const Icon(Icons.search, size: 56, color: Colors.white),
            const SizedBox(height: 16),
            const Text(
              '同じくらいの実力の相手を探して\n国語で1対1対戦しよう！',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 32),
            if (matchmaking.status == MatchmakingStatus.error && matchmaking.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  matchmaking.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ElevatedButton(
              onPressed: () => ref.read(matchmakingProvider.notifier).startSearching(
                    userId: identity.userId,
                    displayName: identity.displayName,
                    rating: rating.rating,
                    metadata: {'grade': identity.grade},
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kPrimaryDark,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('対戦相手を探す', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
