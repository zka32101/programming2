/// 説明画像 (assets/explain/) のステージ/会話IDからの対応表。
///
/// 画像が無いIDは null を返し、画面側では非表示にする。
const Map<String, String> _explainImages = {
  'stage_10': 'assets/explain/stage_10_hobbies.webp',
  'stage_11': 'assets/explain/stage_11_vehicles.webp',
  'stage_12': 'assets/explain/stage_12_sports.webp',
  'stage_13': 'assets/explain/stage_13_jobs.webp',
  'stage_14': 'assets/explain/stage_14_seasons.webp',
  'stage_15': 'assets/explain/stage_15_town.webp',
  'stage_18': 'assets/explain/stage_18_clothes.webp',
  'stage_19': 'assets/explain/stage_19_feelings.webp',
  'stage_1': 'assets/explain/stage_1_greetings.webp',
  'stage_20': 'assets/explain/stage_20_food.webp',
  'stage_25': 'assets/explain/stage_25_shopping.webp',
  'stage_29': 'assets/explain/stage_29_house.webp',
  'stage_30': 'assets/explain/stage_30_daily_life.webp',
  'stage_32': 'assets/explain/stage_32_park.webp',
  'stage_33': 'assets/explain/stage_33_hospital.webp',
  'stage_37': 'assets/explain/stage_37_events.webp',
  'stage_39': 'assets/explain/stage_39_cooking.webp',
  'stage_41': 'assets/explain/stage_41_space.webp',
  'stage_42': 'assets/explain/stage_42_insects.webp',
  'stage_45': 'assets/explain/stage_45_compare.webp',
  'stage_46': 'assets/explain/stage_46_clock.webp',
  'stage_47': 'assets/explain/stage_47_aquarium.webp',
  'stage_52': 'assets/explain/stage_52_japan.webp',
  'stage_65': 'assets/explain/stage_65_directions.webp',
  'stage_7': 'assets/explain/stage_7_family.webp',
  'stage_8': 'assets/explain/stage_8_body.webp',
  'conv_12': 'assets/explain/conv_12_birthday.webp',
  'conv_1': 'assets/explain/conv_1_hajimemashite.webp',
  'conv_2': 'assets/explain/conv_2_restaurant.webp',
};

/// ステージID (例: stage_1) の説明画像アセットパス。無ければ null。
String? explainImageForStage(String stageId) =>
    stageId.startsWith('stage_') ? _explainImages[stageId] : null;

/// 会話ID (例: conv_1) の説明画像アセットパス。無ければ null。
String? explainImageForConversation(String convId) =>
    convId.startsWith('conv_') ? _explainImages[convId] : null;

/// 登録済みの全アセットパス (テスト用)。
Iterable<String> get allExplainImagePaths => _explainImages.values;
