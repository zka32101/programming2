import 'package:freezed_annotation/freezed_annotation.dart';

part 'retention_model.freezed.dart';
part 'retention_model.g.dart';

@freezed
class RetentionMetric with _$RetentionMetric {
  const factory RetentionMetric({
    required String userId,
    required DateTime lastActiveDate,
    required int daysSinceLastActive,
    required int totalLearningDays,
    required int currentStreak,
    @Default(false) bool isAtRisk, // True if no activity for 7+ days
    required double engagementScore, // 0.0-100.0
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RetentionMetric;

  factory RetentionMetric.fromJson(Map<String, dynamic> json) =>
      _$RetentionMetricFromJson(json);
}
