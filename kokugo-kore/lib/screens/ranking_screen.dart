import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/friend_model.dart';
import '../models/ranking_model.dart';
import '../providers/badge_metrics_provider.dart';
import '../providers/badge_provider.dart';
import '../providers/friend_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/ranking_privacy_provider.dart';
import '../providers/ranking_provider.dart' show rankingServiceProvider;
import '../theme/app_theme.dart';
import '../widgets/ranking_privacy_dialog.dart';

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(rankingPrivacyProvider.notifier).load();

      final userId = ref.read(profileProvider).currentProfile?.id;
      if (userId != null) {
        await ref.read(friendListProvider.notifier).loadFriends(userId);
      }

      await _checkTopTenBadge();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// フレンドランキングタブを構築
  Widget _buildFriendRankingTab(BuildContext context, WidgetRef ref) {
    return _buildFriendRanking(context, ref);
  }

  /// 全体ランキングでTOP10入りしていればバッジ獲得判定を行う
  Future<void> _checkTopTenBadge() async {
    final userId = ref.read(profileProvider).currentProfile?.id;
    if (userId == null) return;

    final rankingService = ref.read(rankingServiceProvider);
    final rank = await rankingService.getStudentRank(
      userId,
      RankingFilter(groupBy: RankingGroupBy.all),
    );

    final isTopTen = rank != null && rank > 0 && rank <= 10;
    if (!isTopTen) return;

    await ref.read(badgeMetricsProvider.notifier).setTopTenRanker(true);

    final metricsState = ref.read(badgeMetricsProvider);
    await ref.read(badgeProvider.notifier).checkSocialBadges(
          friendInviteCount: metricsState.friendInvites,
          multiplayerWins: metricsState.multiplayerWins,
          isTopTenRanker: metricsState.isTopTenRanker,
        );
  }

  @override
  Widget build(BuildContext context) {
    return RankingPrivacyGuard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ランキング'),
          elevation: 0,
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: '👥 友達'),
            ],
          ),
          actions: [
            IconButton(
              tooltip: '名前の公開設定',
              icon: const Icon(Icons.privacy_tip_outlined),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => const RankingPrivacyDialog(),
              ),
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildFriendRankingTab(context, ref),
          ],
        ),
      ),
    );
  }

  /// ランキングタイルを構築
  Widget _buildRankingTile(
    BuildContext context,
    int rank,
    StudentRankingData student,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isDarkMode ? Colors.grey.shade900 : Colors.white,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildRankBadge(rank),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.studentName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${student.currentGrade}年生 • ${student.startedAt.month}月開始',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'バッジ',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${student.score}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 友達ランキングを構築（[friendListProvider] のスコア順）
  Widget _buildFriendRanking(BuildContext context, WidgetRef ref) {
    final friends = ref.watch(friendListProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (friends.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.people_outline, size: 48, color: kTextMuted),
              const SizedBox(height: 12),
              const Text(
                'まだ友達がいません',
                style: TextStyle(fontWeight: FontWeight.bold, color: kTextMuted),
              ),
              const SizedBox(height: 8),
              const Text(
                '友達を招待してスコアを競い合おう！',
                style: TextStyle(fontSize: 12, color: kTextMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/friend-invitation'),
                child: const Text('友達を招待する'),
              ),
            ],
          ),
        ),
      );
    }

    final sorted = [...friends]
      ..sort((a, b) => b.totalScore.compareTo(a.totalScore));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final rank = index + 1;
        final Friend friend = sorted[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isDarkMode ? Colors.grey.shade900 : Colors.white,
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildRankBadge(rank),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friend.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${friend.grade}年生 • 正答率 ${(friend.averageAccuracy * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${friend.totalScore}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 順位バッジを構築
  Widget _buildRankBadge(int rank) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getRankColor(rank),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _getRankColor(rank).withAlpha(100),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$rank',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  /// 順位に応じた色を取得
  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // 金
      case 2:
        return const Color(0xFFC0C0C0); // 銀
      case 3:
        return const Color(0xFFCD7F32); // 銅
      default:
        return Colors.grey.shade500;
    }
  }
}
