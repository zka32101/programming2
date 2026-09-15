import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/analytics_provider.dart';

class LearningAnalyticsScreen extends ConsumerWidget {
  final String childId;
import '../theme/app_theme.dart';
import '../widgets/accuracy_trend_widget.dart';
import '../widgets/monthly_chart_widget.dart';
import '../widgets/learning_stats_card.dart';

  const LearningAnalyticsScreen({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('学習分析'),
          backgroundColor: kPrimaryColor,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: '📊 統計'),
              Tab(text: '📈 トレンド'),
              Tab(text: '📅 月別学力'),
              Tab(text: '🎯 カテゴリ'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStatisticsTab(),
            _buildTrendTab(),
            _buildMonthlyAnalyticsTab(context, ref),
            _buildCategoryTab(),
          ],
        ),
      ),
    );
  }

  /// 月別学力タブ
  Widget _buildMonthlyAnalyticsTab(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);

    if (analytics == null) {
      return const Center(child: Text('データを読み込み中...'));
    }

    final monthlyList = (analytics as dynamic).getMonthlyStatsList(12);

    if (monthlyList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.analytics, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('月ごとのデータがまだありません'),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 正答率推移グラフ
          MonthlyChartWidget(
            monthlyStatsList: monthlyList,
            title: '📊 月ごと正答率推移',
          ),
          const SizedBox(height: 24),

          // 学習量グラフ
          MonthlyBarChartWidget(
            monthlyStatsList: monthlyList,
            title: '📝 月ごと問題数',
            metric: 'quests',
          ),
          const SizedBox(height: 24),

          // 学習時間グラフ
          MonthlyBarChartWidget(
            monthlyStatsList: monthlyList,
            title: '⏱️ 月ごと学習時間',
            metric: 'minutes',
          ),
          const SizedBox(height: 24),

          // 月別統計カード
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '月別統計',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          ...monthlyList.map((stats) => LearningStatsCard(monthlyStats: stats)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// 統計タブ
  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 週間統計
          const Text(
            '週間統計',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildWeeklyStatistics(),
          const SizedBox(height: 24),

          // 学習時間分析
          const Text(
            '学習時間分析',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildStudyTimeAnalysis(),
          const SizedBox(height: 24),

          // 得点分布
          const Text(
            '得点分布',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildScoreDistribution(),
        ],
      ),
    );
  }

  /// トレンドタブ
  Widget _buildTrendTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 正答率推移（4週間）
          const Text(
            '4週間の正答率推移',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const AccuracyTrendWidget(
            weeklyAccuracies: [65, 68, 70, 72, 75, 78, 80],
            dayLabels: ['月', '火', '水', '木', '金', '土', '日'],
          ),
          const SizedBox(height: 24),

          // 月別トレンド
          const Text(
            '月別成長',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildMonthlyGrowthChart(),
          const SizedBox(height: 24),

          // トレンド分析
          _buildTrendAnalysis(),
        ],
      ),
    );
  }

  /// カテゴリタブ
  Widget _buildCategoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // カテゴリ成績
          const Text(
            'カテゴリ別成績',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildCategoryPerformance(),
          const SizedBox(height: 24),

          // 強み・弱み分析
          const Text(
            '強み・弱み分析',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildStrengthWeakness(),
        ],
      ),
    );
  }

  /// 週間統計
  Widget _buildWeeklyStatistics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildStatRow('学習時間', '3.5時間', Icons.schedule),
          const Divider(),
          _buildStatRow('問題数', '47問', Icons.quiz),
          const Divider(),
          _buildStatRow('正答率', '78%', Icons.trending_up),
          const Divider(),
          _buildStatRow('バッジ獲得', '2個', Icons.star),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: kPrimaryColor, size: 20),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 13)),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 学習時間分析
  Widget _buildStudyTimeAnalysis() {
    final timeByDay = [
      ('月', 35),
      ('火', 42),
      ('水', 28),
      ('木', 50),
      ('金', 45),
      ('土', 60),
      ('日', 55),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: timeByDay
            .map(
              (day) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Text(day.$1, style: const TextStyle(fontSize: 12)),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (day.$2 / 60).clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 35,
                      child: Text(
                        '${day.$2}分',
                        style: const TextStyle(fontSize: 11, color: kTextMuted),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  /// 得点分布
  Widget _buildScoreDistribution() {
    final distribution = [
      ('90-100点', 15, Colors.green),
      ('80-89点', 28, Colors.blue),
      ('70-79点', 12, Colors.orange),
      ('60-69点', 5, Colors.red),
      ('50-59点', 2, Colors.redAccent),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: distribution
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(item.$1, style: const TextStyle(fontSize: 12)),
                    ),
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (item.$2 / 30).clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(item.$3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 30,
                      child: Text(
                        '${item.$2}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  /// 月別成長チャート
  Widget _buildMonthlyGrowthChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMonthBar('9月', 65),
              _buildMonthBar('10月', 70),
              _buildMonthBar('11月', 75),
              _buildMonthBar('12月', 80),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthBar(String month, int percentage) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 40,
                height: (percentage / 100) * 80,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(month, style: const TextStyle(fontSize: 11)),
        Text('$percentage%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  /// トレンド分析
  Widget _buildTrendAnalysis() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📈 トレンド分析',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '✓ 正答率が安定して上昇しています\n✓ 学習時間が毎日確保されています\n✓ 難しい問題への挑戦が増えています',
            style: TextStyle(fontSize: 12, height: 1.6),
          ),
        ],
      ),
    );
  }

  /// カテゴリ別成績
  Widget _buildCategoryPerformance() {
    final categories = [
      ('ひらがな', 95, Colors.green),
      ('カタカナ', 88, Colors.blue),
      ('漢字', 72, Colors.orange),
      ('ことわざ', 65, Colors.orange),
      ('作文', 58, Colors.red),
    ];

    return Column(
      children: categories
          .map(
            (cat) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(cat.$1, style: const TextStyle(fontSize: 12)),
                        Text(
                          '${cat.$2}%',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: cat.$3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: cat.$2 / 100,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(cat.$3),
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

  /// 強み・弱み分析
  Widget _buildStrengthWeakness() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            border: Border.all(color: Colors.green.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '💪 強み',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                '• ひらがなとカタカナの習得が完璧\n• 漢字の学習速度が平均より速い',
                style: TextStyle(fontSize: 11, height: 1.6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            border: Border.all(color: Colors.orange.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🎯 改善が必要な点',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                '• 作文問題の成績が他より低い\n• ことわざの習得率が50%未満\n→ これらのカテゴリに注力すると効果的です',
                style: TextStyle(fontSize: 11, height: 1.6),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
