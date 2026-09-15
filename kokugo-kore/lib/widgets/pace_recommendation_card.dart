import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PaceRecommendationCard extends StatelessWidget {
  final int currentDaily;
  final int recommendedDaily;
  final double consistency;

  const PaceRecommendationCard({
    super.key,
    required this.currentDaily,
    required this.recommendedDaily,
    required this.consistency,
  });

  @override
  Widget build(BuildContext context) {
    final isPaceSufficient = currentDaily >= recommendedDaily;
    final isDailyConsistent = consistency >= 0.7;

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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '推奨学習ペース',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '最適な学習進度をご提案します',
                    style: TextStyle(fontSize: 12, color: kTextMuted),
                  ),
                ],
              ),
              _buildStatusBadge(isPaceSufficient),
            ],
          ),
          const SizedBox(height: 16),

          // ペース比較
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPaceColumn('現在', currentDaily),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),
              _buildPaceColumn('推奨', recommendedDaily),
            ],
          ),
          const SizedBox(height: 16),

          // 進捗インジケーター
          _buildProgressIndicator(),
          const SizedBox(height: 16),

          // 一貫性スコア
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '学習一貫性',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${(consistency * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDailyConsistent ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: consistency,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDailyConsistent ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 推奨メッセージ
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kPrimaryColor.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Text('💡 ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    _getRecommendationMessage(),
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),

          // アクションボタン
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/analytics');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '詳しく見る',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ステータスバッジ
  Widget _buildStatusBadge(bool isPaceSufficient) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPaceSufficient ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPaceSufficient ? '✓ 良好' : '⚠ 要改善',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isPaceSufficient ? Colors.green : Colors.orange,
        ),
      ),
    );
  }

  /// ペースカラム
  Widget _buildPaceColumn(String label, int value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: kTextMuted),
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const TextSpan(
                text: '問/日',
                style: TextStyle(fontSize: 12, color: kTextMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// プログレスインジケーター
  Widget _buildProgressIndicator() {
    final percentage = (currentDaily / recommendedDaily).clamp(0.0, 1.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ペース達成度',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 10,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              percentage >= 1.0 ? Colors.green : kPrimaryColor,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${(percentage * 100).toStringAsFixed(0)}% 達成',
          style: TextStyle(
            fontSize: 11,
            color: percentage >= 1.0 ? Colors.green : kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// 推奨メッセージ
  String _getRecommendationMessage() {
    if (consistency < 0.5) {
      return 'まず毎日の学習習慣をつけることが大切です。';
    }

    if (currentDaily < recommendedDaily) {
      final diff = recommendedDaily - currentDaily;
      return '1日あたり $diff 問増やすと、より効果的です。';
    }

    if (consistency >= 0.8) {
      return 'すばらしい継続学習です！調子をキープしましょう。';
    }

    return 'ペースが好調です。難易度を上げてみるのも良いでしょう。';
  }
}
