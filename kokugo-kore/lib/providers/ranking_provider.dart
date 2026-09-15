import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ranking_model.dart';

import '../services/ranking_service.dart';
import 'ranking_privacy_provider.dart';

final rankingServiceProvider = Provider<RankingService>((ref) {
  return RankingService();
});

/// ランキングフィルター状態プロバイダー
final rankingFilterProvider = StateProvider<RankingFilter>((ref) {
  return RankingFilter(groupBy: RankingGroupBy.byGrade);
});

/// 学生ランキングデータプロバイダー
final studentRankingsProvider =
    FutureProvider<List<StudentRankingData>>((ref) async {
  final filter = ref.watch(rankingFilterProvider);
  final rankingService = ref.watch(rankingServiceProvider);

  return rankingService.getStudentRankings(filter);
});

/// グループ化されたランキングプロバイダー
/// Map<グループ名, ランキングリスト>を返す
/// プライバシー設定（rankingPrivacyProvider）に基づいて名前を匿名化する
final rankedByGroupProvider =
    FutureProvider<Map<String, List<StudentRankingData>>>((ref) async {
  final filter = ref.watch(rankingFilterProvider);
  final rankingService = ref.watch(rankingServiceProvider);
  final isNamePublic = ref.watch(rankingNamePublicProvider);

  return rankingService.getGroupedRankings(filter, isNamePublic: isNamePublic);
});

/// 特定の学生の順位プロバイダー
final studentRankProvider =
    FutureProvider.family<int?, String>((ref, studentId) async {
  final filter = ref.watch(rankingFilterProvider);
  final rankingService = ref.watch(rankingServiceProvider);

  return rankingService.getStudentRank(studentId, filter);
});
