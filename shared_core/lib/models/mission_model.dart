import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_model.freezed.dart';
part 'mission_model.g.dart';

@freezed
class Mission with _$Mission {
  const factory Mission({
    required String id,
    required String title,
    required String description,
    required int reward,
    required String category, // 'weekly', 'monthly', 'special'
    required DateTime startDate,
    required DateTime endDate,
    @Default([]) List<String> completedUserIds,
  }) = _Mission;

  factory Mission.fromJson(Map<String, dynamic> json) =>
      _$MissionFromJson(json);
}
