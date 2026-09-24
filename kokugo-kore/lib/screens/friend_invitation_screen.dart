import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/friend_model.dart';
import '../providers/badge_metrics_provider.dart';
import '../providers/badge_provider.dart';
import '../providers/friend_provider.dart';
import '../providers/profile_provider.dart';
import '../theme/app_theme.dart';
import 'battle_screen.dart';

class FriendInvitationScreen extends ConsumerStatefulWidget {
  const FriendInvitationScreen({super.key});

  @override
  ConsumerState<FriendInvitationScreen> createState() => _FriendInvitationScreenState();
}

class _FriendInvitationScreenState extends ConsumerState<FriendInvitationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String _searchQuery = '';
  bool _isSendingRequest = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = ref.read(profileProvider).currentProfile?.id;
      if (userId != null) {
        await ref.read(friendListProvider.notifier).loadFriends(userId);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friendCount = ref.watch(friendListProvider).length;
    final userId = ref.watch(profileProvider).currentProfile?.id;
    final requestCount = userId == null
        ? 0
        : ref.watch(friendRequestsProvider(userId)).maybeWhen(
              data: (requests) => requests.length,
              orElse: () => 0,
            );

    return Scaffold(
      appBar: AppBar(
        title: const Text('友人と対戦'),
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 検索バー
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '友人名で検索...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ),
            ),

            // タブ
            TabBar(
              controller: _tabController,
              labelColor: kPrimaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: kPrimaryColor,
              tabs: [
                Tab(text: '👥 登録済み ($friendCount)'),
                Tab(text: '📨 リクエスト ($requestCount)'),
                const Tab(text: '➕ 追加'),
              ],
            ),

            // タブコンテンツ
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRegisteredFriendsTab(),
                  _buildFriendRequestsTab(userId),
                  _buildAddFriendsTab(userId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 登録済み友人タブ
  Widget _buildRegisteredFriendsTab() {
    final friends = ref.watch(friendListProvider);

    final filtered = _searchQuery.isEmpty
        ? friends
        : friends
            .where((f) => f.displayName.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    if (filtered.isEmpty) {
      return _buildEmptyState(
        icon: Icons.people_outline,
        title: friends.isEmpty ? 'まだ友人がいません' : '一致する友人がいません',
        subtitle: friends.isEmpty ? '「追加」タブから友人を招待しましょう' : '検索キーワードを変えてお試しください',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final friend = filtered[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildFriendCard(
            friend,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BattleScreen(
                    opponentId: friend.userId,
                    opponentName: friend.displayName,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// 友人リクエストタブ
  Widget _buildFriendRequestsTab(String? userId) {
    if (userId == null) {
      return _buildEmptyState(
        icon: Icons.person_off_outlined,
        title: 'プロフィール未設定です',
        subtitle: 'プロフィールを作成してからご利用ください',
      );
    }

    final requestsAsync = ref.watch(friendRequestsProvider(userId));

    return requestsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => _buildEmptyState(
        icon: Icons.error_outline,
        title: 'リクエストを取得できませんでした',
        subtitle: '$err',
      ),
      data: (requests) {
        if (requests.isEmpty) {
          return _buildEmptyState(
            icon: Icons.mail_outline,
            title: '届いているリクエストはありません',
            subtitle: '友人があなたを招待すると、ここに表示されます',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(child: Text('😊', style: TextStyle(fontSize: 24))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            req.senderName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            req.senderId,
                            style: const TextStyle(fontSize: 11, color: kTextMuted),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => _acceptRequest(userId, req),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          ),
                          child: const Text(
                            '承認',
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: () => _declineRequest(userId, req),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          ),
                          child: const Text(
                            '却下',
                            style: TextStyle(fontSize: 11, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _acceptRequest(String userId, FriendRequest req) async {
    try {
      final friendData = Friend(
        userId: req.senderId,
        displayName: req.senderName,
        profileImageUrl: req.senderImageUrl,
        grade: 0,
        addedDate: DateTime.now(),
        isOnline: false,
        totalScore: 0,
        averageAccuracy: 0,
      );
      await ref.read(friendListProvider.notifier).acceptFriendRequest(userId, req, friendData);

      // 招待受諾数のバッジ判定
      final metricsState = ref.read(badgeMetricsProvider);
      final socialBadges = await ref.read(badgeProvider.notifier).checkSocialBadges(
            friendInviteCount: metricsState.friendInvites,
            multiplayerWins: metricsState.multiplayerWins,
            isTopTenRanker: metricsState.isTopTenRanker,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${req.senderName}を友人に追加しました')),
      );
      if (socialBadges.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 ${socialBadges.map((b) => b.title).join(', ')} を獲得しました！'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('承認に失敗しました: $e')),
      );
    }
  }

  Future<void> _declineRequest(String userId, FriendRequest req) async {
    try {
      await ref.read(friendListProvider.notifier).declineFriendRequest(userId, req);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${req.senderName}のリクエストを却下しました')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('却下に失敗しました: $e')),
      );
    }
  }

  /// 友人追加タブ
  Widget _buildAddFriendsTab(String? userId) {
    final profile = ref.watch(profileProvider).currentProfile;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 招待コード
          const Text(
            '招待コードで追加',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _codeController,
            decoration: InputDecoration(
              hintText: '友人の招待コードを入力',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (userId == null || _isSendingRequest)
                  ? null
                  : () => _sendRequest(userId, profile?.name ?? ''),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
              ),
              child: _isSendingRequest
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('招待を送る'),
            ),
          ),
          const SizedBox(height: 24),

          // 自分の招待コード
          const Text(
            'あなたの招待コード',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userId ?? '---',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'この招待コードを友人と共有してください',
                        style: TextStyle(fontSize: 11, color: kTextMuted),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: userId == null
                      ? null
                      : () {
                          Clipboard.setData(ClipboardData(text: userId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('コピーしました')),
                          );
                        },
                  icon: const Icon(Icons.copy),
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendRequest(String userId, String senderName) async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isSendingRequest = true);
    try {
      final sent = await ref.read(friendListProvider.notifier).sendFriendRequestByCode(
            userId,
            senderName,
            '',
            code,
          );

      if (!mounted) return;

      if (!sent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('その招待コードのユーザーが見つかりませんでした')),
        );
        return;
      }

      await ref.read(badgeMetricsProvider.notifier).incrementFriendInvites();
      final metricsState = ref.read(badgeMetricsProvider);
      final socialBadges = await ref.read(badgeProvider.notifier).checkSocialBadges(
            friendInviteCount: metricsState.friendInvites,
            multiplayerWins: metricsState.multiplayerWins,
            isTopTenRanker: metricsState.isTopTenRanker,
          );

      if (!mounted) return;
      _codeController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('招待リクエストを送信しました')),
      );
      if (socialBadges.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 ${socialBadges.map((b) => b.title).join(', ')} を獲得しました！'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('招待の送信に失敗しました: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSendingRequest = false);
    }
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: kTextMuted),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: kTextMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: kTextMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 友人カード
  Widget _buildFriendCard(Friend friend, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: kPrimaryColor.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                const Center(child: Text('😊', style: TextStyle(fontSize: 24))),
                Icon(
                  Icons.circle,
                  size: 10,
                  color: friend.isOnline ? Colors.green : Colors.grey,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.displayName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${friend.grade}年生',
                      style: const TextStyle(fontSize: 11, color: kTextMuted),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '正答率 ${(friend.averageAccuracy * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 11, color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'スコア: ${friend.totalScore}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text(
              '対戦',
              style: TextStyle(fontSize: 11, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
