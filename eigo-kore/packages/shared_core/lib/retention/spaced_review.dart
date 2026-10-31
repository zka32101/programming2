import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/date_key.dart';

/// 復習キューの 1 問。
class ReviewItem {
  final String id; // アプリ側の問題ID
  final int box; // 0..kReviewIntervals.length-1
  final String dueDate; // 'YYYY-MM-DD'
  final String? subject; // 任意（単元・教科の絞り込み用）

  const ReviewItem({
    required this.id,
    required this.box,
    required this.dueDate,
    this.subject,
  });

  Map<String, dynamic> toJson() =>
      {'id': id, 'box': box, 'due': dueDate, 'subject': subject};

  factory ReviewItem.fromJson(Map<String, dynamic> j) => ReviewItem(
        id: j['id'] as String,
        box: j['box'] as int? ?? 0,
        dueDate: j['due'] as String,
        subject: j['subject'] as String?,
      );
}

/// ライトナー式の復習間隔（日）。まちがえたら box 0 に戻る。
const List<int> kReviewIntervals = [1, 2, 4, 7, 14, 30];

/// 復習スケジュールの純粋ロジック。
class SpacedReview {
  /// 回答後の状態。[current] が null（未登録）で正解なら null（キューに入れない）。
  /// 最後の box を正解で通過したら null（卒業）。
  static ReviewItem? afterAnswer({
    required String id,
    required bool correct,
    required DateTime today,
    ReviewItem? current,
    String? subject,
  }) {
    if (!correct) {
      return ReviewItem(
        id: id,
        box: 0,
        dueDate: dateKeyOf(DateTime(today.year, today.month, today.day + kReviewIntervals[0])),
        subject: subject ?? current?.subject,
      );
    }
    if (current == null) return null;
    final next = current.box + 1;
    if (next >= kReviewIntervals.length) return null;
    return ReviewItem(
      id: id,
      box: next,
      dueDate: dateKeyOf(DateTime(today.year, today.month, today.day + kReviewIntervals[next])),
      subject: current.subject,
    );
  }

  static bool isDue(ReviewItem item, DateTime today) =>
      item.dueDate.compareTo(dateKeyOf(today)) <= 0;
}

const _reviewKey = 'sc_review_queue';

/// 間違えた問題の復習キュー。
///
/// クイズ回答のたびに `recordAnswer(id, correct)` を呼ぶだけでよい。
/// ホームでは `reviewDueCountProvider` を見て「今日の復習」を出し、
/// `dueIds()` の問題を出題する。
class ReviewQueueNotifier extends Notifier<Map<String, ReviewItem>> {
  @override
  Map<String, ReviewItem> build() => {};

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_reviewKey);
    if (raw == null) return;
    try {
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      state = {
        for (final j in list) (j['id'] as String): ReviewItem.fromJson(j)
      };
    } catch (_) {}
  }

  Future<void> recordAnswer(
    String questionId,
    bool correct, {
    String? subject,
    DateTime? now,
  }) async {
    final next = SpacedReview.afterAnswer(
      id: questionId,
      correct: correct,
      today: now ?? DateTime.now(),
      current: state[questionId],
      subject: subject,
    );
    final map = Map<String, ReviewItem>.of(state);
    if (next == null) {
      if (map.remove(questionId) == null) return;
    } else {
      map[questionId] = next;
    }
    state = map;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _reviewKey, jsonEncode(map.values.map((e) => e.toJson()).toList()));
  }

  /// 今日が期限（または期限切れ）の問題ID。古いものから。
  List<String> dueIds({DateTime? now, String? subject, int? limit}) {
    final today = now ?? DateTime.now();
    final due = state.values
        .where((e) =>
            SpacedReview.isDue(e, today) &&
            (subject == null || e.subject == subject))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final ids = due.map((e) => e.id).toList();
    return limit == null || ids.length <= limit ? ids : ids.sublist(0, limit);
  }
}

final reviewQueueProvider =
    NotifierProvider<ReviewQueueNotifier, Map<String, ReviewItem>>(
        ReviewQueueNotifier.new);

/// 今日の復習件数。
final reviewDueCountProvider = Provider<int>((ref) {
  final queue = ref.watch(reviewQueueProvider);
  final today = DateTime.now();
  return queue.values.where((e) => SpacedReview.isDue(e, today)).length;
});
