// lib/screens/lesson_screen.dart — 「学ぶ」解説メニュー画面
//
// shared_core の LessonMenuPage をラップし、表示時に国語の解説記事
// （lib/data/lesson_data.dart）を lessonProvider へ読み込む。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart' show LessonMenuPage;

import '../providers/lesson_provider.dart';

class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({super.key});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: Load lessons from Phase 4 implementation
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(lessonProvider.notifier).load(kLessons);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Load lessons from shared_core LessonMenuPage
    return const LessonMenuPage(lessons: const []);
  }
}
