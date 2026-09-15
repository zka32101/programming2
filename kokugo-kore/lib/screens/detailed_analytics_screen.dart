import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DetailedAnalyticsScreen extends StatelessWidget {
  const DetailedAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('詳細分析'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('学習進捗'),
            const SizedBox(height: 12),
            _buildProgressCard('今週の学習時間', '12.5時間', Colors.blue),
            const SizedBox(height: 12),
            _buildProgressCard('今月の正答率', '82.3%', Colors.green),
            const SizedBox(height: 24),
            _buildSectionTitle('カテゴリー別実績'),
            const SizedBox(height: 12),
            _buildCategoryRow('漢字', '78%', 0.78),
            _buildCategoryRow('ひらがな', '92%', 0.92),
            _buildCategoryRow('ことわざ', '65%', 0.65),
            _buildCategoryRow('文法', '88%', 0.88),
            const SizedBox(height: 24),
            _buildSectionTitle('改善提案'),
            const SizedBox(height: 12),
            _buildRecommendation('漢字の学習をもっと増やしましょう', '正答率が低めです'),
            _buildRecommendation('ひらがなは得意科目です', 'この調子を保ちましょう'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildProgressCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        border: Border.all(color: color.withAlpha(100)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: kTextMuted)),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(String category, String percentage, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(percentage, style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor.withAlpha(200)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendation(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: kAccentTeal.withAlpha(25),
        border: Border.all(color: kAccentTeal.withAlpha(100)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: kAccentTeal, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: kTextMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
