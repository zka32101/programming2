import 'package:freezed_annotation/freezed_annotation.dart';

part 'global_ranking_model.freezed.dart';
part 'global_ranking_model.g.dart';

@freezed
class GlobalRanking with _$GlobalRanking {
  const factory GlobalRanking({
    required String userId,
    required String userName,
    required int rank,
    required int score,
    required int correctCount,
    required int totalCount,
    @Default(0.0) double correctRate,
    required String subject, // 'eigo', 'sansu', 'kokugo', etc.
    required DateTime updatedAt,
    String? avatarUrl,
    @Default('') String grade,
  }) = _GlobalRanking;

  factory GlobalRanking.fromJson(Map<String, dynamic> json) =>
      _$GlobalRankingFromJson(json);
}
