import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GoalSettingScreen extends StatefulWidget {
  const GoalSettingScreen({super.key});

  @override
  State<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  late TextEditingController _dailyQuestController;
  late TextEditingController _weeklyAccuracyController;
  late TextEditingController _monthlyStageController;

  @override
  void initState() {
    super.initState();
    _dailyQuestController = TextEditingController(text: '10');
    _weeklyAccuracyController = TextEditingController(text: '80');
    _monthlyStageController = TextEditingController(text: '5');
  }

  @override
  void dispose() {
    _dailyQuestController.dispose();
    _weeklyAccuracyController.dispose();
    _monthlyStageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学習目標の設定'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '毎日の目標',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dailyQuestController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '1日あたりのクエスト数',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.task_alt),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '週間目標',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _weeklyAccuracyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '目標正答率（%）',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.trending_up),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '月間目標',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _monthlyStageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'クリアするステージ数',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.flag),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('目標を保存しました！')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('保存する', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
