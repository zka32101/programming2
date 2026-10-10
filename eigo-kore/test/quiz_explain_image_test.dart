import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eigo_kore/models/question.dart';
import 'package:eigo_kore/widgets/lesson_screen_components.dart';

void main() {
  testWidgets('解説に画像(320px幅 overflowなし)・無いステージは非表示', (t) async {
    t.view.physicalSize = const Size(320, 640);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);
    const q = Question(
      id: 'x',
      type: QuestionType.reading,
      difficulty: DifficultyLevel.beginner,
      text: '7',
      textJa: '「7」を英語で選ぼう',
      correctAnswer: 'seven',
    );
    Widget w(String? id) => MaterialApp(
        home: Scaffold(
            body: SingleChildScrollView(
                child: ImprovedAnswerExplanation(
                    question: q,
                    isCorrect: true,
                    stageId: id,
                    onPlayCorrect: () {}))));
    await t.pumpWidget(w('stage_11'));
    expect(find.byKey(const Key('explainQuizImage')), findsOneWidget);
    expect(t.takeException(), isNull);
    await t.pumpWidget(w('stage_2'));
    expect(find.byKey(const Key('explainQuizImage')), findsNothing);
  });
}
