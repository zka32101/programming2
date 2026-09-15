import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../theme/app_theme.dart';

class ProgressChartWidget extends StatelessWidget {
  final int totalQuestions;

  final int completedQuestions;
  final double accuracy;

  const ProgressChartWidget({
    super.key,
    required this.totalQuestions,
    required this.completedQuestions,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    final remainingQuestions = totalQuestions - completedQuestions;
    final completionPercentage = (completedQuestions / totalQuestions) * 100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ドーナツグラフ
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: completedQuestions.toDouble(),
                    title: '${completionPercentage.toStringAsFixed(0)}%',
                    color: kPrimaryColor,
                    radius: 60,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: remainingQuestions.toDouble(),
                    title: '',
                    color: Colors.grey.shade300,
                    radius: 60,
                  ),
                ],
                centerSpaceRadius: 50,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 統計情報
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoColumn('完了', completedQuestions, Colors.green),
              _buildInfoColumn('残り', remainingQuestions, Colors.orange),
              _buildInfoColumn('正答率', (accuracy * 100).toInt(), kPrimaryColor),
            ],
          ),
          const SizedBox(height: 16),

          // プログレスバー
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '学習進度',
                style: TextStyle(fontSize: 12, color: kTextMuted),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: completionPercentage / 100,
                  minHeight: 12,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: kTextMuted),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
