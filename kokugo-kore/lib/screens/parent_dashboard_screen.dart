import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/analytics_model.dart';
import '../providers/analytics_provider.dart';
import '../providers/friend_provider.dart';
import '../providers/battle_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/progress_chart_widget.dart';
import '../widgets/accuracy_trend_widget.dart';
import '../widgets/kanji_mastery_list_widget.dart';
import '../widgets/pace_recommendation_card.dart';

class ParentDashboardScreen extends ConsumerStatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  ConsumerState<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends ConsumerState<ParentDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedChildId;

  final List<Map<String, String>> _children = [
    {'id': 'child_001', 'name': '太郎', 'grade': '小1'},
    {'id': 'child_002', 'name': '花子', 'grade': '小3'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedChildId = _children.first['id'];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👨‍👩‍👧‍👦 保護者ダッシュボード'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kPrimaryColor, kPrimaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
      ),
      body: Column(
        children: [
          // 子ども選択セクション
          _buildChildSelector(context),
          // タブ
          Material(
            elevation: 2,
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: kPrimaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: kPrimaryColor,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: '📊 進捗'),
                Tab(text: '🎯 分析'),
                Tab(text: '⭐ バッジ'),
              ],
            ),
          ),
          // タブコンテンツ
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProgressTab(),
                _buildAnalyticsTab(),
                _buildBadgesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 子ども選択セクション
  Widget _buildChildSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.purple.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '👧 お子様を選択',
            style: TextStyle(fontSize: 13, color: kTextMuted, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ..._children.map((child) => _buildChildButton(
                      '${child['name']} (${child['grade']})',
                      _selectedChildId == child['id'],
                    )),
                _buildChildButton('➕ 新規追加', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 子どもボタン
  Widget _buildChildButton(String name, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() => _selectedChildId = name);
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(
                      colors: [kPrimaryColor, kPrimaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [Colors.white, Colors.grey.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              border: Border.all(
                color: selected ? kPrimaryColor : Colors.grey.shade300,
                width: selected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: selected
                  ? [BoxShadow(color: kPrimaryColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
                  : [],
            ),
            child: Center(
              child: Text(
                name,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 進捗タブ
  Widget _buildProgressTab() {
    final analyticsAsync = ref.watch(analyticsProvider);

    return analyticsAsync == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 学習統計カード
                _buildStatCard(analyticsAsync),
                const SizedBox(height: 20),

                // 進捗グラフ
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📊 進捗状況',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        const ProgressChartWidget(
                          totalQuestions: 500,
                          completedQuestions: 342,
                          accuracy: 0.78,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 推奨学習ペース
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '⏱️ 学習ペース',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        const PaceRecommendationCard(
                          currentDaily: 12,
                          recommendedDaily: 15,
                          consistency: 0.75,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  /// 分析タブ
  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 正答率トレンド
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📈 正答率の推移',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const AccuracyTrendWidget(
                    weeklyAccuracies: [65, 68, 70, 72, 75, 78, 80],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 漢字習得リスト
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔤 漢字習得状況',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const KanjiMasteryListWidget(
                    masteredCount: 85,
                    totalCount: 240,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // カテゴリ別分析
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 カテゴリ別成績',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryAnalysis(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// バッジタブ
  Widget _buildBadgesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 獲得バッジ
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🏆 獲得したバッジ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _buildBadgeTile('🌟', '初心者'),
                      _buildBadgeTile('⭐', 'がんばり'),
                      _buildBadgeTile('🥇', 'チャンピオン'),
                      _buildBadgeTile('🎯', '目標達成'),
                      _buildBadgeTile('🔥', '連続学習'),
                      _buildBadgeTile('📚', '読書家'),
                      _buildBadgeTile('🤝', '友人招待'),
                      _buildBadgeTile('🏆', 'ランキング'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// バッジタイル（カード風）
  Widget _buildBadgeTile(String emoji, String label) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 統計カード
  Widget _buildStatCard(ProgressAnalytics? analytics) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimaryColor, kPrimaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '学習統計',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('完了数', '${analytics?.totalQuestsCompleted ?? 0}', '問'),
              _buildStatItem('正答率', '${(analytics?.overallAccuracy ?? 0).toStringAsFixed(1)}', '%'),
              _buildStatItem('コイン', '${analytics?.totalCoinsEarned ?? 0}', 'C'),
            ],
          ),
        ],
      ),
    );
  }

  /// 統計アイテム
  Widget _buildStatItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: unit,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// カテゴリ別分析
  Widget _buildCategoryAnalysis() {
    final categories = [
      ('ひらがな', 0.95),
      ('カタカナ', 0.88),
      ('漢字', 0.72),
      ('ことわざ', 0.65),
      ('作文', 0.58),
    ];

    return Column(
      children: categories.map((category) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(category.$1, style: const TextStyle(fontSize: 13)),
                  Text(
                    '${(category.$2 * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: category.$2,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    category.$2 > 0.8
                        ? Colors.green
                        : category.$2 > 0.6
                            ? kPrimaryColor
                            : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
