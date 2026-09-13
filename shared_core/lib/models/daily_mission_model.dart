import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_mission_model.freezed.dart';
part 'daily_mission_model.g.dart';

@freezed
class DailyMission with _$DailyMission {
  const factory DailyMission({
    required String id,
    required String userId,
    required String missionId,
    required String title,
    required int currentProgress,
    required int targetProgress,
    @Default(false) bool isCompleted,
    required DateTime date,
    required int rewardAmount,
    DateTime? completedAt,
  }) = _DailyMission;

  factory DailyMission.fromJson(Map<String, dynamic> json) =>
      _$DailyMissionFromJson(json);
}
