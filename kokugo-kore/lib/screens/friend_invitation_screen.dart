import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/badge_metrics_provider.dart';
import '../theme/app_theme.dart';
import '../providers/friend_provider.dart';
import '../providers/badge_provider.dart';
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
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            tabs: const [
              Tab(text: '👥 登録済み (8)'),
              Tab(text: '📨 リクエスト (3)'),
              Tab(text: '➕ 追加'),
            ],
          ),

          // タブコンテンツ
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRegisteredFriendsTab(),
                _buildFriendRequestsTab(),
                _buildAddFriendsTab(),
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
    final friendsList = [
      ('太郎', '小学1年', 95, 2850, '🔴'),
      ('花子', '小学2年', 88, 3120, '🟢'),
      ('次郎', '小学1年', 85, 2640, '🔴'),
      ('三郎', '小学3年', 92, 3500, '🟢'),
      ('四郎', '小学2年', 78, 2200, '🔴'),
      ('五郎', '小学1年', 81, 2800, '🟢'),
      ('六郎', '小学4年', 88, 3100, '🔴'),
      ('七郎', '小学2年', 85, 2950, '🟢'),
    ];

    final filtered = _searchQuery.isEmpty
        ? friendsList
        : friendsList
            .where((f) => f.$1.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final friend = filtered[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildFriendCard(
            friend.$1,
            friend.$2,
            friend.$3,
            friend.$4,
            friend.$5,
            () {
              // Start battle with friend
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BattleScreen(
                    opponentId: 'friend_${index}',
                    opponentName: friend.$1,
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
  Widget _buildFriendRequestsTab() {
    final requests = [
      ('健太', '小学1年'),
      ('美咲', '小学3年'),
      ('悟', '小学2年'),
    ];

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
                        req.$1,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        req.$2,
                        style: const TextStyle(fontSize: 12, color: kTextMuted),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${req.$1}を承認しました')),
                        );
                      },
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
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${req.$1}を却下しました')),
                        );
                      },
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
  }

  /// 友人追加タブ
  Widget _buildAddFriendsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // おすすめ友人
          const Text(
            'おすすめの友人',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSuggestedFriendsList(),
          const SizedBox(height: 24),

          // 招待コード
          const Text(
            '招待コードで追加',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
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
            child: Consumer(
              builder: (context, ref, child) => ElevatedButton(
                onPressed: () async {
                  // 招待数を増やす
                  await ref.read(badgeMetricsProvider.notifier).incrementFriendInvites();

                  // Phase 2+ 社交バッジチェック
                  final metricsState = ref.read(badgeMetricsProvider);
                  final socialBadges = await ref.read(badgeProvider.notifier).checkSocialBadges(
                    friendInviteCount: metricsState.friendInvites,
                    multiplayerWins: metricsState.multiplayerWins,
                    isTopTenRanker: metricsState.isTopTenRanker,
                  );

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('招待リクエストを送信しました')),
                  );

                  // 新規バッジ取得時は表示
                  if (socialBadges.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('🎉 ${socialBadges.map((b) => b.title).join(', ')} を獲得しました！'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                ),
                child: const Text('招待を送る'),
              ),
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KOKUGO-ABC123XYZ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'この招待コードを友人と共有してください',
                      style: TextStyle(fontSize: 11, color: kTextMuted),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
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

  /// 推奨友人リスト
  Widget _buildSuggestedFriendsList() {
    final suggested = [
      ('八郎', '小学1年', 'あなたと同じ学年'),
      ('九郎', '小学2年', 'あなたの友人と友人'),
      ('十郎', '小学1年', 'オンラインで活動中'),
    ];

    return Column(
      children: suggested
          .map(
            (friend) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: Text('😊', style: TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            friend.$1,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            friend.$2,
                            style: const TextStyle(fontSize: 11, color: kTextMuted),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            friend.$3,
                            style: const TextStyle(fontSize: 10, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${friend.$1}に招待を送りました')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      child: const Text(
                        '追加',
                        style: TextStyle(fontSize: 11, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  /// 友人カード
  Widget _buildFriendCard(
    String name,
    String grade,
    int accuracy,
    int score,
    String status,
    VoidCallback onTap,
  ) {
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
            child: Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const Text('😊', style: TextStyle(fontSize: 24)),
                  Text(status, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      grade,
                      style: const TextStyle(fontSize: 11, color: kTextMuted),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '正答率 $accuracy%',
                      style: const TextStyle(fontSize: 11, color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'スコア: $score',
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
