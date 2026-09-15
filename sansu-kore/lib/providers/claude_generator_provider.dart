import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/quest_model.dart';

String get _apiKey => dotenv.env['CLAUDE_API_KEY'] ?? '';
String get _apiUrl => dotenv.env['CLAUDE_API_URL'] ?? 'https://api.anthropic.com/v1/messages';

enum MathGrade { grade1, grade2, grade3, grade4, grade5, grade6 }

class GeneratedQuestion {
  final String questionText;
  final List<String> choices;
  final int correctIndex;
  final String topic;
  final int difficulty;

  GeneratedQuestion({
    required this.questionText,
    required this.choices,
    required this.correctIndex,
    required this.topic,
    required this.difficulty,
  });

  factory GeneratedQuestion.fromJson(Map<String, dynamic> json) {
    final choices = List<String>.from(json['choices'] as List);
    return GeneratedQuestion(
      questionText: json['question'] as String,
      choices: choices,
      correctIndex: json['correctIndex'] as int,
      topic: json['topic'] as String,
      difficulty: json['difficulty'] as int? ?? 1,
    );
  }

  QuizQuestion toQuizQuestion(int stageId) => QuizQuestion(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    questionText: questionText,
    choices: choices,
    correctIndex: correctIndex,
    hint: 'よく考えて解いてみてください',
  );
}

class ClaudeGeneratorNotifier extends Notifier<AsyncValue<List<GeneratedQuestion>>> {
  @override
  build() => const AsyncValue.data([]);

  /// Claude APIを使用して問題を生成
  Future<List<GeneratedQuestion>> generateQuestions({
    required MathGrade grade,
    required String topic,
    required int count,
  }) async {
    state = const AsyncValue.loading();
    try {
      final gradeMap = {
        MathGrade.grade1: '小学1年',
        MathGrade.grade2: '小学2年',
        MathGrade.grade3: '小学3年',
        MathGrade.grade4: '小学4年',
        MathGrade.grade5: '小学5年',
        MathGrade.grade6: '小学6年',
      };

      final prompt = '''
${gradeMap[grade]}向けの算数問題を${count}問生成してください。
トピック: $topic

以下のJSON形式で出力してください:
[
  {
    "question": "問題文",
    "choices": ["選択肢1", "選択肢2", "選択肢3", "選択肢4"],
    "correctIndex": 0,
    "topic": "$topic",
    "difficulty": 1
  }
]

要件:
- 各問題に4つの選択肢を用意してください
- correctIndexは正解の選択肢のインデックス（0-3）
- 年齢相応の難易度にしてください
- difficultyは1-5の値を設定してください
- JSONのみを返してください
''';

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
          'x-api-key': _apiKey,
        },
        body: jsonEncode({
          'model': 'claude-opus-4-1-20250805',
          'max_tokens': 2048,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['content'][0]['text'] as String;

        // JSONを抽出して解析
        final jsonMatch = RegExp(r'\[.*\]', dotAll: true).firstMatch(content);
        if (jsonMatch == null) {
          throw Exception('Invalid response format');
        }

        final jsonStr = jsonMatch.group(0)!;
        final questionsList = jsonDecode(jsonStr) as List;
        final questions = questionsList
            .map((q) => GeneratedQuestion.fromJson(q as Map<String, dynamic>))
            .toList();

        state = AsyncValue.data(questions);
        return questions;
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e, st) {
      if (kDebugMode) print('Claude API error: $e\n$st');
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// 単一の問題を生成
  Future<GeneratedQuestion> generateSingleQuestion({
    required MathGrade grade,
    required String topic,
  }) async {
    final questions = await generateQuestions(
      grade: grade,
      topic: topic,
      count: 1,
    );
    return questions.isNotEmpty ? questions.first : throw Exception('No question generated');
  }
}

final claudeGeneratorProvider =
    NotifierProvider<ClaudeGeneratorNotifier, AsyncValue<List<GeneratedQuestion>>>(
  ClaudeGeneratorNotifier.new,
);
