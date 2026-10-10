/// 解説用の挿絵（水彩）。キーは '学年-ステージ番号'。
const _stageExplainImages = <String, String>{
  '1-1': 'g1_tashizan',
  '1-2': 'g1_hikizan',
  '1-3': 'g1_tashizan2',
  '1-4': 'g1_tashizan3',
  '1-5': 'g1_kurisage',
  '1-7': 'g1_jikan',
  '1-8': 'g1_katachi',
  '1-14': 'g1_nagasa',
  '2-1': 'g2_kakezan',
  '2-2': 'g2_kakezan',
  '2-3': 'g2_kakezan',
  '2-4': 'g2_kakezan',
  '2-5': 'g2_hissan',
  '2-6': 'g2_hissan',
  '2-7': 'g2_nagasa_tani',
  '2-11': 'g2_ichinichi',
  '2-12': 'g2_sankaku_shikaku',
  '2-16': 'kasa_tani',
  '3-1': 'g3_warizan',
  '3-3': 'g3_warizan',
  '3-4': 'g2_ichinichi',
  '3-5': 'g3_amari',
  '3-6': 'g3_shousuu',
  '3-7': 'g3_bunsuu',
  '3-8': 'g3_en_kyuu',
  '3-12': 'g3_omosa',
  '3-13': 'g3_shousuu',
  '3-16': 'bou_graph',
  '4-4': 'g4_menseki',
  '4-6': 'g4_kakudo',
  '4-10': 'g4_heikou_suichoku',
  '4-11': 'g4_orekkusen',
  '4-12': 'g4_menseki',
  '5-3': 'g5_hayasa',
  '5-4': 'g5_wariai',
  '5-5': 'g5_tsubun',
  '5-7': 'g5_baisuu',
  '5-8': 'g5_taiseki',
  '5-11': 'g5_tan_i_ryou',
  '5-13': 'g5_seitakkakkei',
  '6-6': 'g6_hirei',
  '6-7': 'g6_taishou',
  '6-8': 'g6_baai',
  '6-9': 'g6_suzu',
  '6-10': 'g5_hayasa',
  '6-11': 'g6_ryutai',
  '6-12': 'g6_hirei',
  '6-13': 'data_katsuyou',
  '6-15': 'data_katsuyou',
};

/// 算数ガイド項目タイトル → 画像名。
const _guideExplainImages = <String, String>{
  'たし算（足し算）のやり方': 'g1_tashizan',
  'ひき算（引き算）のやり方': 'g1_hikizan',
  'かけ算（乗法）の仕組み': 'g2_kakezan',
  '小数（しょうすう）の計算': 'g3_shousuu',
  '分数（ぶんすう）とは': 'g3_bunsuu',
  '時間の読み方': 'g1_jikan',
  '面積（めんせき）と体積': 'g4_menseki',
  'グラフと統計': 'bou_graph',
};

String? _path(String? name) =>
    name == null ? null : 'assets/illustrations/explain_$name.webp';

/// 該当ステージの解説画像アセットパス。無ければ null。
String? explainImageForStage(int grade, int stageNumber) =>
    _path(_stageExplainImages['$grade-$stageNumber']);

String? explainImageForGuide(String title) => _path(_guideExplainImages[title]);

/// テスト用: 登録されている全アセットパス。
Iterable<String> allExplainImagePaths() => {
      ..._stageExplainImages.values,
      ..._guideExplainImages.values,
    }.map((e) => _path(e)!);
