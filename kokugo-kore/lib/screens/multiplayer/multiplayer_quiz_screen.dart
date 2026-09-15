import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';

class MultiplayerQuizScreen extends ConsumerWidget {
  final String matchId;

  const MultiplayerQuizScreen({required this.matchId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('対戦クイズ'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text('対戦クイズ機能は準備中です'),
          ],
        ),
      ),
    );
  }
}
