import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Implement LessonNotifier for Phase 4
// This is a stub implementation to prevent build errors

class LessonState {
  const LessonState({
    required this.readIds,
    required this.favoriteIds,
  });

  final Set<String> readIds;
  final Set<String> favoriteIds;

  static const empty = LessonState(readIds: {}, favoriteIds: {});

  bool isRead(String id) => readIds.contains(id);
  bool isFavorite(String id) => favoriteIds.contains(id);
  int get readCount => readIds.length;
}

class LessonNotifier extends Notifier<LessonState> {
  @override
  LessonState build() => LessonState.empty;
}

final lessonProvider = NotifierProvider<LessonNotifier, LessonState>(
  LessonNotifier.new,
);
