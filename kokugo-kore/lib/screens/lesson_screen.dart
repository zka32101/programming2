import 'package:flutter/material.dart';
import 'learn_screen.dart';

/// ホームの「学ぶ」カードの遷移先。
///
/// 小学校で学ぶ国語の内容（ひらがな・カタカナ、漢字の部首、ことわざ、
/// 慣用句など。クイズの出題範囲と同じ）を一覧で確認できる [LearnScreen] を表示する。
class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key});

  @override
  Widget build(BuildContext context) => const LearnScreen();
}
