import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class KanjiMasteryListWidget extends StatelessWidget {
  final int masteredCount;
  final int totalCount;

  const KanjiMasteryListWidget({
    super.key,
    required this.masteredCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final masteryPercentage = (masteredCount / totalCount) * 100;
    final remainingCount = totalCount - masteredCount;

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
          // ヘッダー
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '習得状況',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: masteredCount.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        TextSpan(
                          text: ' / $totalCount',
                          style: const TextStyle(fontSize: 14, color: kTextMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryColor.withAlpha(25),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${masteryPercentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      const Text(
                        '習得',
                        style: TextStyle(fontSize: 11, color: kTextMuted),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // プログレスバー
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '進捗',
                style: TextStyle(fontSize: 12, color: kTextMuted),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: masteryPercentage / 100,
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 統計情報
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('習得済み', masteredCount, Colors.green),
              _buildStatColumn('学習中', remainingCount, kPrimaryColor),
              _buildStatColumn('習得率', masteryPercentage.toInt(), Colors.blue),
            ],
          ),
          const SizedBox(height: 16),

          // グレードリスト
          const Text(
            '学年別習得',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildGradeProgressList(),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: kTextMuted),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildGradeProgressList() {
    final grades = [
      ('1年', 0.95),
      ('2年', 0.88),
      ('3年', 0.72),
      ('4年', 0.56),
      ('5年', 0.35),
      ('6年', 0.15),
    ];

    return Column(
      children: grades.map((grade) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(
                width: 35,
                child: Text(
                  grade.$1,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: grade.$2,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      grade.$2 > 0.8
                          ? Colors.green
                          : grade.$2 > 0.5
                              ? kPrimaryColor
                              : Colors.orange,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 35,
                child: Text(
                  '${(grade.$2 * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 11, color: kTextMuted),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
