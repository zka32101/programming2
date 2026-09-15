import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BattleStatsScreen extends StatelessWidget {
  const BattleStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('対戦統計'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCard('総対戦数', '42', Colors.blue),
            const SizedBox(height: 12),
            _buildStatCard('勝利数', '28', Colors.green),
            const SizedBox(height: 12),
            _buildStatCard('敗北数', '14', Colors.red),
            const SizedBox(height: 24),
            const Text(
              '統計情報',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildDetailRow('勝率', '66.7%'),
            _buildDetailRow('平均スコア', '87.3点'),
            _buildDetailRow('最高スコア', '100点'),
            _buildDetailRow('最低スコア', '62点'),
            const SizedBox(height: 24),
            const Text(
              '最近の対戦',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildBattleRecord('太郎', '勝ち', '95点', '2時間前'),
            _buildBattleRecord('花子', '負け', '78点', '5時間前'),
            _buildBattleRecord('次郎', '勝ち', '88点', '1日前'),
            _buildBattleRecord('三郎', '勝ち', '92点', '3日前'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
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
          Text(title, style: const TextStyle(fontSize: 14, color: kTextMuted)),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: kTextMuted)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBattleRecord(String opponent, String result, String score, String time) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(opponent, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(time, style: const TextStyle(fontSize: 11, color: kTextMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: result == '勝ち' ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              result,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: result == '勝ち' ? Colors.green : Colors.red,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(score, style: const TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor)),
        ],
      ),
    );
  }
}
