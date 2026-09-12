import 'package:freezed_annotation/freezed_annotation.dart';

part 'adaptive_difficulty_model.freezed.dart';
part 'adaptive_difficulty_model.g.dart';

@freezed
class AdaptiveDifficulty with _$AdaptiveDifficulty {
  const factory AdaptiveDifficulty({
    required String userId,
    required String subject,
    @Default('intermediate') String currentLevel, // beginner, intermediate, advanced
    @Default(0.0) double performanceScore, // 0.0-100.0 based on accuracy
    @Default(0) int correctCount,
    @Default(0) int totalCount,
    @Default(0.0) double correctRate,
    @Default([]) List<String> recommendedTopics,
    required DateTime lastUpdated,
  }) = _AdaptiveDifficulty;

  factory AdaptiveDifficulty.fromJson(Map<String, dynamic> json) =>
      _$AdaptiveDifficultyFromJson(json);
}
