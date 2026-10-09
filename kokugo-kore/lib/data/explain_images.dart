/// 慣用句・ことわざ・四字熟語の解説イラスト（assets/illustrations/explain_*.webp）。
/// キーは表記の基本形。ふりがな括弧や空白を除いた文字列に対し、部分一致で引く。
const Map<String, String> kExplainImages = {
  // 慣用句
  '猫の手も借りたい': 'idiom_neko_te',
  '足が棒になる': 'idiom_ashi_bou',
  '顔から火が出る': 'idiom_kao_hi',
  '目を丸くする': 'idiom_me_maruku',
  '耳を傾ける': 'idiom_mimi_katamukeru',
  '鼻が高い': 'idiom_hana_takai',
  '肩の荷が下りる': 'idiom_kata_ni',
  '手を貸す': 'idiom_te_kasu',
  '足を引っ張る': 'idiom_ashi_hipparu',
  '腹を割る': 'idiom_hara_waru',
  '水に流す': 'idiom_mizu_nagasu',
  '頭を抱える': 'idiom_atama_kakaeru',
  // ことわざ
  '猿も木から落ちる': 'proverb_saru_ki',
  '河童の川流れ': 'proverb_kappa',
  '棚からぼた餅': 'proverb_tana_botamochi',
  '鬼に金棒': 'proverb_oni_kanabou',
  '泣きっ面に蜂': 'proverb_nakitsura_hachi',
  '花より団子': 'proverb_hana_dango',
  '井の中の蛙': 'proverb_inonaka_kawazu',
  '石の上にも三年': 'proverb_ishi_sannen',
  '頭隠して尻隠さず': 'proverb_atama_kakushite',
  '転ばぬ先の杖': 'proverb_korobanu_saki',
  '立つ鳥跡を濁さず': 'proverb_tatsutori',
  '鬼のいぬ間に洗濯': 'proverb_oni_inu_ma',
  // 四字熟語
  '一石二鳥': 'yoji_isseki_nicho',
  '十人十色': 'yoji_junin_toiro',
  '弱肉強食': 'yoji_jakuniku',
};

final RegExp _kParen = RegExp(r'[（(][^）)]*[）)]');

/// 表示文字列（ふりがな括弧付きでも可）から解説画像のアセットパスを返す。無ければ null。
String? explainImageFor(String text) {
  final t = text.replaceAll(_kParen, '').replaceAll(RegExp(r'\s'), '');
  if (t.isEmpty) return null;
  for (final e in kExplainImages.entries) {
    if (t == e.key || t.contains(e.key) || e.key.contains(t) && t.length >= 4) {
      return 'assets/illustrations/explain_${e.value}.webp';
    }
  }
  return null;
}
