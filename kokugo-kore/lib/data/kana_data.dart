// lib/data/kana_data.dart
// Kana data for 国語コレ！ - Hiragana, Katakana, Romaji, Alphabet

enum KanaType { hiragana, katakana, romaji, alphabet }

class KanaItem {
  final String kana;     // e.g. 'あ', 'ア', 'a'
  final String reading;  // romaji for hiragana/katakana; hiragana for romaji
  final String romaji;   // always the romaji representation
  final bool isPlaceholder; // empty cell for grid alignment

  const KanaItem({
    required this.kana,
    required this.reading,
    required this.romaji,
    this.isPlaceholder = false,
  });

  static const KanaItem empty = KanaItem(kana: '', reading: '', romaji: '', isPlaceholder: true);
}

// ---------------------------------------------------------------------------
// Hiragana list
// ---------------------------------------------------------------------------

const List<KanaItem> hiraganaList = [
  // Basic gojuuon
  KanaItem(kana: 'あ', reading: 'あ', romaji: 'a'),
  KanaItem(kana: 'い', reading: 'い', romaji: 'i'),
  KanaItem(kana: 'う', reading: 'う', romaji: 'u'),
  KanaItem(kana: 'え', reading: 'え', romaji: 'e'),
  KanaItem(kana: 'お', reading: 'お', romaji: 'o'),

  KanaItem(kana: 'か', reading: 'か', romaji: 'ka'),
  KanaItem(kana: 'き', reading: 'き', romaji: 'ki'),
  KanaItem(kana: 'く', reading: 'く', romaji: 'ku'),
  KanaItem(kana: 'け', reading: 'け', romaji: 'ke'),
  KanaItem(kana: 'こ', reading: 'こ', romaji: 'ko'),

  KanaItem(kana: 'さ', reading: 'さ', romaji: 'sa'),
  KanaItem(kana: 'し', reading: 'し', romaji: 'shi'),
  KanaItem(kana: 'す', reading: 'す', romaji: 'su'),
  KanaItem(kana: 'せ', reading: 'せ', romaji: 'se'),
  KanaItem(kana: 'そ', reading: 'そ', romaji: 'so'),

  KanaItem(kana: 'た', reading: 'た', romaji: 'ta'),
  KanaItem(kana: 'ち', reading: 'ち', romaji: 'chi'),
  KanaItem(kana: 'つ', reading: 'つ', romaji: 'tsu'),
  KanaItem(kana: 'て', reading: 'て', romaji: 'te'),
  KanaItem(kana: 'と', reading: 'と', romaji: 'to'),

  KanaItem(kana: 'な', reading: 'な', romaji: 'na'),
  KanaItem(kana: 'に', reading: 'に', romaji: 'ni'),
  KanaItem(kana: 'ぬ', reading: 'ぬ', romaji: 'nu'),
  KanaItem(kana: 'ね', reading: 'ね', romaji: 'ne'),
  KanaItem(kana: 'の', reading: 'の', romaji: 'no'),

  KanaItem(kana: 'は', reading: 'は', romaji: 'ha'),
  KanaItem(kana: 'ひ', reading: 'ひ', romaji: 'hi'),
  KanaItem(kana: 'ふ', reading: 'ふ', romaji: 'fu'),
  KanaItem(kana: 'へ', reading: 'へ', romaji: 'he'),
  KanaItem(kana: 'ほ', reading: 'ほ', romaji: 'ho'),

  KanaItem(kana: 'ま', reading: 'ま', romaji: 'ma'),
  KanaItem(kana: 'み', reading: 'み', romaji: 'mi'),
  KanaItem(kana: 'む', reading: 'む', romaji: 'mu'),
  KanaItem(kana: 'め', reading: 'め', romaji: 'me'),
  KanaItem(kana: 'も', reading: 'も', romaji: 'mo'),

  KanaItem(kana: 'や', reading: 'や', romaji: 'ya'),
  KanaItem(kana: 'ゆ', reading: 'ゆ', romaji: 'yu'),
  KanaItem(kana: 'よ', reading: 'よ', romaji: 'yo'),
  KanaItem.empty, KanaItem.empty, // alignment spacers

  KanaItem(kana: 'ら', reading: 'ら', romaji: 'ra'),
  KanaItem(kana: 'り', reading: 'り', romaji: 'ri'),
  KanaItem(kana: 'る', reading: 'る', romaji: 'ru'),
  KanaItem(kana: 'れ', reading: 'れ', romaji: 're'),
  KanaItem(kana: 'ろ', reading: 'ろ', romaji: 'ro'),

  KanaItem(kana: 'わ', reading: 'わ', romaji: 'wa'),
  KanaItem(kana: 'を', reading: 'を', romaji: 'wo'),
  KanaItem(kana: 'ん', reading: 'ん', romaji: 'n'),
  KanaItem.empty, KanaItem.empty, // alignment spacers

  // Dakuten (voiced)
  KanaItem(kana: 'が', reading: 'が', romaji: 'ga'),
  KanaItem(kana: 'ぎ', reading: 'ぎ', romaji: 'gi'),
  KanaItem(kana: 'ぐ', reading: 'ぐ', romaji: 'gu'),
  KanaItem(kana: 'げ', reading: 'げ', romaji: 'ge'),
  KanaItem(kana: 'ご', reading: 'ご', romaji: 'go'),

  KanaItem(kana: 'ざ', reading: 'ざ', romaji: 'za'),
  KanaItem(kana: 'じ', reading: 'じ', romaji: 'ji'),
  KanaItem(kana: 'ず', reading: 'ず', romaji: 'zu'),
  KanaItem(kana: 'ぜ', reading: 'ぜ', romaji: 'ze'),
  KanaItem(kana: 'ぞ', reading: 'ぞ', romaji: 'zo'),

  KanaItem(kana: 'だ', reading: 'だ', romaji: 'da'),
  KanaItem(kana: 'ぢ', reading: 'ぢ', romaji: 'di'),
  KanaItem(kana: 'づ', reading: 'づ', romaji: 'du'),
  KanaItem(kana: 'で', reading: 'で', romaji: 'de'),
  KanaItem(kana: 'ど', reading: 'ど', romaji: 'do'),

  KanaItem(kana: 'ば', reading: 'ば', romaji: 'ba'),
  KanaItem(kana: 'び', reading: 'び', romaji: 'bi'),
  KanaItem(kana: 'ぶ', reading: 'ぶ', romaji: 'bu'),
  KanaItem(kana: 'べ', reading: 'べ', romaji: 'be'),
  KanaItem(kana: 'ぼ', reading: 'ぼ', romaji: 'bo'),

  // Handakuten (semi-voiced)
  KanaItem(kana: 'ぱ', reading: 'ぱ', romaji: 'pa'),
  KanaItem(kana: 'ぴ', reading: 'ぴ', romaji: 'pi'),
  KanaItem(kana: 'ぷ', reading: 'ぷ', romaji: 'pu'),
  KanaItem(kana: 'ぺ', reading: 'ぺ', romaji: 'pe'),
  KanaItem(kana: 'ぽ', reading: 'ぽ', romaji: 'po'),

  // Youon (compound kana)
  KanaItem(kana: 'きゃ', reading: 'きゃ', romaji: 'kya'),
  KanaItem(kana: 'きゅ', reading: 'きゅ', romaji: 'kyu'),
  KanaItem(kana: 'きょ', reading: 'きょ', romaji: 'kyo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'しゃ', reading: 'しゃ', romaji: 'sha'),
  KanaItem(kana: 'しゅ', reading: 'しゅ', romaji: 'shu'),
  KanaItem(kana: 'しょ', reading: 'しょ', romaji: 'sho'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'ちゃ', reading: 'ちゃ', romaji: 'cha'),
  KanaItem(kana: 'ちゅ', reading: 'ちゅ', romaji: 'chu'),
  KanaItem(kana: 'ちょ', reading: 'ちょ', romaji: 'cho'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'にゃ', reading: 'にゃ', romaji: 'nya'),
  KanaItem(kana: 'にゅ', reading: 'にゅ', romaji: 'nyu'),
  KanaItem(kana: 'にょ', reading: 'にょ', romaji: 'nyo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'ひゃ', reading: 'ひゃ', romaji: 'hya'),
  KanaItem(kana: 'ひゅ', reading: 'ひゅ', romaji: 'hyu'),
  KanaItem(kana: 'ひょ', reading: 'ひょ', romaji: 'hyo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'みゃ', reading: 'みゃ', romaji: 'mya'),
  KanaItem(kana: 'みゅ', reading: 'みゅ', romaji: 'myu'),
  KanaItem(kana: 'みょ', reading: 'みょ', romaji: 'myo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'りゃ', reading: 'りゃ', romaji: 'rya'),
  KanaItem(kana: 'りゅ', reading: 'りゅ', romaji: 'ryu'),
  KanaItem(kana: 'りょ', reading: 'りょ', romaji: 'ryo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'ぎゃ', reading: 'ぎゃ', romaji: 'gya'),
  KanaItem(kana: 'ぎゅ', reading: 'ぎゅ', romaji: 'gyu'),
  KanaItem(kana: 'ぎょ', reading: 'ぎょ', romaji: 'gyo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'じゃ', reading: 'じゃ', romaji: 'ja'),
  KanaItem(kana: 'じゅ', reading: 'じゅ', romaji: 'ju'),
  KanaItem(kana: 'じょ', reading: 'じょ', romaji: 'jo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'びゃ', reading: 'びゃ', romaji: 'bya'),
  KanaItem(kana: 'びゅ', reading: 'びゅ', romaji: 'byu'),
  KanaItem(kana: 'びょ', reading: 'びょ', romaji: 'byo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'ぴゃ', reading: 'ぴゃ', romaji: 'pya'),
  KanaItem(kana: 'ぴゅ', reading: 'ぴゅ', romaji: 'pyu'),
  KanaItem(kana: 'ぴょ', reading: 'ぴょ', romaji: 'pyo'),
  KanaItem.empty, KanaItem.empty,
];

// ---------------------------------------------------------------------------
// Katakana list (kana=katakana, reading=hiragana equivalent)
// ---------------------------------------------------------------------------

const List<KanaItem> katakanaList = [
  // Basic gojuuon
  KanaItem(kana: 'ア', reading: 'あ', romaji: 'a'),
  KanaItem(kana: 'イ', reading: 'い', romaji: 'i'),
  KanaItem(kana: 'ウ', reading: 'う', romaji: 'u'),
  KanaItem(kana: 'エ', reading: 'え', romaji: 'e'),
  KanaItem(kana: 'オ', reading: 'お', romaji: 'o'),

  KanaItem(kana: 'カ', reading: 'か', romaji: 'ka'),
  KanaItem(kana: 'キ', reading: 'き', romaji: 'ki'),
  KanaItem(kana: 'ク', reading: 'く', romaji: 'ku'),
  KanaItem(kana: 'ケ', reading: 'け', romaji: 'ke'),
  KanaItem(kana: 'コ', reading: 'こ', romaji: 'ko'),

  KanaItem(kana: 'サ', reading: 'さ', romaji: 'sa'),
  KanaItem(kana: 'シ', reading: 'し', romaji: 'shi'),
  KanaItem(kana: 'ス', reading: 'す', romaji: 'su'),
  KanaItem(kana: 'セ', reading: 'せ', romaji: 'se'),
  KanaItem(kana: 'ソ', reading: 'そ', romaji: 'so'),

  KanaItem(kana: 'タ', reading: 'た', romaji: 'ta'),
  KanaItem(kana: 'チ', reading: 'ち', romaji: 'chi'),
  KanaItem(kana: 'ツ', reading: 'つ', romaji: 'tsu'),
  KanaItem(kana: 'テ', reading: 'て', romaji: 'te'),
  KanaItem(kana: 'ト', reading: 'と', romaji: 'to'),

  KanaItem(kana: 'ナ', reading: 'な', romaji: 'na'),
  KanaItem(kana: 'ニ', reading: 'に', romaji: 'ni'),
  KanaItem(kana: 'ヌ', reading: 'ぬ', romaji: 'nu'),
  KanaItem(kana: 'ネ', reading: 'ね', romaji: 'ne'),
  KanaItem(kana: 'ノ', reading: 'の', romaji: 'no'),

  KanaItem(kana: 'ハ', reading: 'は', romaji: 'ha'),
  KanaItem(kana: 'ヒ', reading: 'ひ', romaji: 'hi'),
  KanaItem(kana: 'フ', reading: 'ふ', romaji: 'fu'),
  KanaItem(kana: 'ヘ', reading: 'へ', romaji: 'he'),
  KanaItem(kana: 'ホ', reading: 'ほ', romaji: 'ho'),

  KanaItem(kana: 'マ', reading: 'ま', romaji: 'ma'),
  KanaItem(kana: 'ミ', reading: 'み', romaji: 'mi'),
  KanaItem(kana: 'ム', reading: 'む', romaji: 'mu'),
  KanaItem(kana: 'メ', reading: 'め', romaji: 'me'),
  KanaItem(kana: 'モ', reading: 'も', romaji: 'mo'),

  KanaItem(kana: 'ヤ', reading: 'や', romaji: 'ya'),
  KanaItem(kana: 'ユ', reading: 'ゆ', romaji: 'yu'),
  KanaItem(kana: 'ヨ', reading: 'よ', romaji: 'yo'),
  KanaItem.empty, KanaItem.empty, // alignment spacers

  KanaItem(kana: 'ラ', reading: 'ら', romaji: 'ra'),
  KanaItem(kana: 'リ', reading: 'り', romaji: 'ri'),
  KanaItem(kana: 'ル', reading: 'る', romaji: 'ru'),
  KanaItem(kana: 'レ', reading: 'れ', romaji: 're'),
  KanaItem(kana: 'ロ', reading: 'ろ', romaji: 'ro'),

  KanaItem(kana: 'ワ', reading: 'わ', romaji: 'wa'),
  KanaItem(kana: 'ヲ', reading: 'を', romaji: 'wo'),
  KanaItem(kana: 'ン', reading: 'ん', romaji: 'n'),
  KanaItem.empty, KanaItem.empty, // alignment spacers

  // Dakuten (voiced)
  KanaItem(kana: 'ガ', reading: 'が', romaji: 'ga'),
  KanaItem(kana: 'ギ', reading: 'ぎ', romaji: 'gi'),
  KanaItem(kana: 'グ', reading: 'ぐ', romaji: 'gu'),
  KanaItem(kana: 'ゲ', reading: 'げ', romaji: 'ge'),
  KanaItem(kana: 'ゴ', reading: 'ご', romaji: 'go'),

  KanaItem(kana: 'ザ', reading: 'ざ', romaji: 'za'),
  KanaItem(kana: 'ジ', reading: 'じ', romaji: 'ji'),
  KanaItem(kana: 'ズ', reading: 'ず', romaji: 'zu'),
  KanaItem(kana: 'ゼ', reading: 'ぜ', romaji: 'ze'),
  KanaItem(kana: 'ゾ', reading: 'ぞ', romaji: 'zo'),

  KanaItem(kana: 'ダ', reading: 'だ', romaji: 'da'),
  KanaItem(kana: 'ヂ', reading: 'ぢ', romaji: 'di'),
  KanaItem(kana: 'ヅ', reading: 'づ', romaji: 'du'),
  KanaItem(kana: 'デ', reading: 'で', romaji: 'de'),
  KanaItem(kana: 'ド', reading: 'ど', romaji: 'do'),

  KanaItem(kana: 'バ', reading: 'ば', romaji: 'ba'),
  KanaItem(kana: 'ビ', reading: 'び', romaji: 'bi'),
  KanaItem(kana: 'ブ', reading: 'ぶ', romaji: 'bu'),
  KanaItem(kana: 'ベ', reading: 'べ', romaji: 'be'),
  KanaItem(kana: 'ボ', reading: 'ぼ', romaji: 'bo'),

  // Handakuten (semi-voiced)
  KanaItem(kana: 'パ', reading: 'ぱ', romaji: 'pa'),
  KanaItem(kana: 'ピ', reading: 'ぴ', romaji: 'pi'),
  KanaItem(kana: 'プ', reading: 'ぷ', romaji: 'pu'),
  KanaItem(kana: 'ペ', reading: 'ぺ', romaji: 'pe'),
  KanaItem(kana: 'ポ', reading: 'ぽ', romaji: 'po'),

  // Youon (compound katakana)
  KanaItem(kana: 'キャ', reading: 'きゃ', romaji: 'kya'),
  KanaItem(kana: 'キュ', reading: 'きゅ', romaji: 'kyu'),
  KanaItem(kana: 'キョ', reading: 'きょ', romaji: 'kyo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'シャ', reading: 'しゃ', romaji: 'sha'),
  KanaItem(kana: 'シュ', reading: 'しゅ', romaji: 'shu'),
  KanaItem(kana: 'ショ', reading: 'しょ', romaji: 'sho'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'チャ', reading: 'ちゃ', romaji: 'cha'),
  KanaItem(kana: 'チュ', reading: 'ちゅ', romaji: 'chu'),
  KanaItem(kana: 'チョ', reading: 'ちょ', romaji: 'cho'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'ニャ', reading: 'にゃ', romaji: 'nya'),
  KanaItem(kana: 'ニュ', reading: 'にゅ', romaji: 'nyu'),
  KanaItem(kana: 'ニョ', reading: 'にょ', romaji: 'nyo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'ヒャ', reading: 'ひゃ', romaji: 'hya'),
  KanaItem(kana: 'ヒュ', reading: 'ひゅ', romaji: 'hyu'),
  KanaItem(kana: 'ヒョ', reading: 'ひょ', romaji: 'hyo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'ミャ', reading: 'みゃ', romaji: 'mya'),
  KanaItem(kana: 'ミュ', reading: 'みゅ', romaji: 'myu'),
  KanaItem(kana: 'ミョ', reading: 'みょ', romaji: 'myo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'リャ', reading: 'りゃ', romaji: 'rya'),
  KanaItem(kana: 'リュ', reading: 'りゅ', romaji: 'ryu'),
  KanaItem(kana: 'リョ', reading: 'りょ', romaji: 'ryo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'ギャ', reading: 'ぎゃ', romaji: 'gya'),
  KanaItem(kana: 'ギュ', reading: 'ぎゅ', romaji: 'gyu'),
  KanaItem(kana: 'ギョ', reading: 'ぎょ', romaji: 'gyo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'ジャ', reading: 'じゃ', romaji: 'ja'),
  KanaItem(kana: 'ジュ', reading: 'じゅ', romaji: 'ju'),
  KanaItem(kana: 'ジョ', reading: 'じょ', romaji: 'jo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'ビャ', reading: 'びゃ', romaji: 'bya'),
  KanaItem(kana: 'ビュ', reading: 'びゅ', romaji: 'byu'),
  KanaItem(kana: 'ビョ', reading: 'びょ', romaji: 'byo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'ピャ', reading: 'ぴゃ', romaji: 'pya'),
  KanaItem(kana: 'ピュ', reading: 'ぴゅ', romaji: 'pyu'),
  KanaItem(kana: 'ピョ', reading: 'ぴょ', romaji: 'pyo'),
  KanaItem.empty, KanaItem.empty,
];

// ---------------------------------------------------------------------------
// Romaji list
// ---------------------------------------------------------------------------

const List<KanaItem> romajiList = [
  // Basic vowels
  KanaItem(kana: 'a', reading: 'あ', romaji: 'a'),
  KanaItem(kana: 'i', reading: 'い', romaji: 'i'),
  KanaItem(kana: 'u', reading: 'う', romaji: 'u'),
  KanaItem(kana: 'e', reading: 'え', romaji: 'e'),
  KanaItem(kana: 'o', reading: 'お', romaji: 'o'),

  // K-row
  KanaItem(kana: 'ka', reading: 'か', romaji: 'ka'),
  KanaItem(kana: 'ki', reading: 'き', romaji: 'ki'),
  KanaItem(kana: 'ku', reading: 'く', romaji: 'ku'),
  KanaItem(kana: 'ke', reading: 'け', romaji: 'ke'),
  KanaItem(kana: 'ko', reading: 'こ', romaji: 'ko'),

  // S-row
  KanaItem(kana: 'sa', reading: 'さ', romaji: 'sa'),
  KanaItem(kana: 'shi', reading: 'し', romaji: 'shi'),
  KanaItem(kana: 'su', reading: 'す', romaji: 'su'),
  KanaItem(kana: 'se', reading: 'せ', romaji: 'se'),
  KanaItem(kana: 'so', reading: 'そ', romaji: 'so'),

  // T-row
  KanaItem(kana: 'ta', reading: 'た', romaji: 'ta'),
  KanaItem(kana: 'chi', reading: 'ち', romaji: 'chi'),
  KanaItem(kana: 'tsu', reading: 'つ', romaji: 'tsu'),
  KanaItem(kana: 'te', reading: 'て', romaji: 'te'),
  KanaItem(kana: 'to', reading: 'と', romaji: 'to'),

  // N-row
  KanaItem(kana: 'na', reading: 'な', romaji: 'na'),
  KanaItem(kana: 'ni', reading: 'に', romaji: 'ni'),
  KanaItem(kana: 'nu', reading: 'ぬ', romaji: 'nu'),
  KanaItem(kana: 'ne', reading: 'ね', romaji: 'ne'),
  KanaItem(kana: 'no', reading: 'の', romaji: 'no'),

  // H-row
  KanaItem(kana: 'ha', reading: 'は', romaji: 'ha'),
  KanaItem(kana: 'hi', reading: 'ひ', romaji: 'hi'),
  KanaItem(kana: 'fu', reading: 'ふ', romaji: 'fu'),
  KanaItem(kana: 'he', reading: 'へ', romaji: 'he'),
  KanaItem(kana: 'ho', reading: 'ほ', romaji: 'ho'),

  // M-row
  KanaItem(kana: 'ma', reading: 'ま', romaji: 'ma'),
  KanaItem(kana: 'mi', reading: 'み', romaji: 'mi'),
  KanaItem(kana: 'mu', reading: 'む', romaji: 'mu'),
  KanaItem(kana: 'me', reading: 'め', romaji: 'me'),
  KanaItem(kana: 'mo', reading: 'も', romaji: 'mo'),

  // Y-row
  KanaItem(kana: 'ya', reading: 'や', romaji: 'ya'),
  KanaItem(kana: 'yu', reading: 'ゆ', romaji: 'yu'),
  KanaItem(kana: 'yo', reading: 'よ', romaji: 'yo'),
  KanaItem.empty, KanaItem.empty,

  // R-row
  KanaItem(kana: 'ra', reading: 'ら', romaji: 'ra'),
  KanaItem(kana: 'ri', reading: 'り', romaji: 'ri'),
  KanaItem(kana: 'ru', reading: 'る', romaji: 'ru'),
  KanaItem(kana: 're', reading: 'れ', romaji: 're'),
  KanaItem(kana: 'ro', reading: 'ろ', romaji: 'ro'),

  // W-row + n
  KanaItem(kana: 'wa', reading: 'わ', romaji: 'wa'),
  KanaItem(kana: 'wo', reading: 'を', romaji: 'wo'),
  KanaItem(kana: 'n', reading: 'ん', romaji: 'n'),
  KanaItem.empty, KanaItem.empty,

  // Dakuten
  KanaItem(kana: 'ga', reading: 'が', romaji: 'ga'),
  KanaItem(kana: 'gi', reading: 'ぎ', romaji: 'gi'),
  KanaItem(kana: 'gu', reading: 'ぐ', romaji: 'gu'),
  KanaItem(kana: 'ge', reading: 'げ', romaji: 'ge'),
  KanaItem(kana: 'go', reading: 'ご', romaji: 'go'),

  KanaItem(kana: 'za', reading: 'ざ', romaji: 'za'),
  KanaItem(kana: 'ji', reading: 'じ', romaji: 'ji'),
  KanaItem(kana: 'zu', reading: 'ず', romaji: 'zu'),
  KanaItem(kana: 'ze', reading: 'ぜ', romaji: 'ze'),
  KanaItem(kana: 'zo', reading: 'ぞ', romaji: 'zo'),

  KanaItem(kana: 'da', reading: 'だ', romaji: 'da'),
  KanaItem(kana: 'de', reading: 'で', romaji: 'de'),
  KanaItem(kana: 'do', reading: 'ど', romaji: 'do'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'ba', reading: 'ば', romaji: 'ba'),
  KanaItem(kana: 'bi', reading: 'び', romaji: 'bi'),
  KanaItem(kana: 'bu', reading: 'ぶ', romaji: 'bu'),
  KanaItem(kana: 'be', reading: 'べ', romaji: 'be'),
  KanaItem(kana: 'bo', reading: 'ぼ', romaji: 'bo'),

  // Handakuten
  KanaItem(kana: 'pa', reading: 'ぱ', romaji: 'pa'),
  KanaItem(kana: 'pi', reading: 'ぴ', romaji: 'pi'),
  KanaItem(kana: 'pu', reading: 'ぷ', romaji: 'pu'),
  KanaItem(kana: 'pe', reading: 'ぺ', romaji: 'pe'),
  KanaItem(kana: 'po', reading: 'ぽ', romaji: 'po'),

  // Youon
  KanaItem(kana: 'kya', reading: 'きゃ', romaji: 'kya'),
  KanaItem(kana: 'kyu', reading: 'きゅ', romaji: 'kyu'),
  KanaItem(kana: 'kyo', reading: 'きょ', romaji: 'kyo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'sha', reading: 'しゃ', romaji: 'sha'),
  KanaItem(kana: 'shu', reading: 'しゅ', romaji: 'shu'),
  KanaItem(kana: 'sho', reading: 'しょ', romaji: 'sho'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'cha', reading: 'ちゃ', romaji: 'cha'),
  KanaItem(kana: 'chu', reading: 'ちゅ', romaji: 'chu'),
  KanaItem(kana: 'cho', reading: 'ちょ', romaji: 'cho'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'nya', reading: 'にゃ', romaji: 'nya'),
  KanaItem(kana: 'nyu', reading: 'にゅ', romaji: 'nyu'),
  KanaItem(kana: 'nyo', reading: 'にょ', romaji: 'nyo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'hya', reading: 'ひゃ', romaji: 'hya'),
  KanaItem(kana: 'hyu', reading: 'ひゅ', romaji: 'hyu'),
  KanaItem(kana: 'hyo', reading: 'ひょ', romaji: 'hyo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'mya', reading: 'みゃ', romaji: 'mya'),
  KanaItem(kana: 'myu', reading: 'みゅ', romaji: 'myu'),
  KanaItem(kana: 'myo', reading: 'みょ', romaji: 'myo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'rya', reading: 'りゃ', romaji: 'rya'),
  KanaItem(kana: 'ryu', reading: 'りゅ', romaji: 'ryu'),
  KanaItem(kana: 'ryo', reading: 'りょ', romaji: 'ryo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'gya', reading: 'ぎゃ', romaji: 'gya'),
  KanaItem(kana: 'gyu', reading: 'ぎゅ', romaji: 'gyu'),
  KanaItem(kana: 'gyo', reading: 'ぎょ', romaji: 'gyo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'ja', reading: 'じゃ', romaji: 'ja'),
  KanaItem(kana: 'ju', reading: 'じゅ', romaji: 'ju'),
  KanaItem(kana: 'jo', reading: 'じょ', romaji: 'jo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'bya', reading: 'びゃ', romaji: 'bya'),
  KanaItem(kana: 'byu', reading: 'びゅ', romaji: 'byu'),
  KanaItem(kana: 'byo', reading: 'びょ', romaji: 'byo'),
  KanaItem.empty, KanaItem.empty,

  KanaItem(kana: 'pya', reading: 'ぴゃ', romaji: 'pya'),
  KanaItem(kana: 'pyu', reading: 'ぴゅ', romaji: 'pyu'),
  KanaItem(kana: 'pyo', reading: 'ぴょ', romaji: 'pyo'),
  KanaItem.empty, KanaItem.empty,
];

// ---------------------------------------------------------------------------
// Alphabet list (A-Z with Japanese names)
// ---------------------------------------------------------------------------

const List<KanaItem> alphabetList = [
  KanaItem(kana: 'A', reading: 'エー', romaji: 'a'),
  KanaItem(kana: 'B', reading: 'ビー', romaji: 'b'),
  KanaItem(kana: 'C', reading: 'シー', romaji: 'c'),
  KanaItem(kana: 'D', reading: 'ディー', romaji: 'd'),
  KanaItem(kana: 'E', reading: 'イー', romaji: 'e'),
  KanaItem(kana: 'F', reading: 'エフ', romaji: 'f'),
  KanaItem(kana: 'G', reading: 'ジー', romaji: 'g'),
  KanaItem(kana: 'H', reading: 'エイチ', romaji: 'h'),
  KanaItem(kana: 'I', reading: 'アイ', romaji: 'i'),
  KanaItem(kana: 'J', reading: 'ジェー', romaji: 'j'),
  KanaItem(kana: 'K', reading: 'ケー', romaji: 'k'),
  KanaItem(kana: 'L', reading: 'エル', romaji: 'l'),
  KanaItem(kana: 'M', reading: 'エム', romaji: 'm'),
  KanaItem(kana: 'N', reading: 'エヌ', romaji: 'n'),
  KanaItem(kana: 'O', reading: 'オー', romaji: 'o'),
  KanaItem(kana: 'P', reading: 'ピー', romaji: 'p'),
  KanaItem(kana: 'Q', reading: 'キュー', romaji: 'q'),
  KanaItem(kana: 'R', reading: 'アール', romaji: 'r'),
  KanaItem(kana: 'S', reading: 'エス', romaji: 's'),
  KanaItem(kana: 'T', reading: 'ティー', romaji: 't'),
  KanaItem(kana: 'U', reading: 'ユー', romaji: 'u'),
  KanaItem(kana: 'V', reading: 'ブイ', romaji: 'v'),
  KanaItem(kana: 'W', reading: 'ダブリュー', romaji: 'w'),
  KanaItem(kana: 'X', reading: 'エックス', romaji: 'x'),
  KanaItem(kana: 'Y', reading: 'ワイ', romaji: 'y'),
  KanaItem(kana: 'Z', reading: 'ゼット', romaji: 'z'),
];

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

List<KanaItem> getKanaList(KanaType type) {
  switch (type) {
    case KanaType.hiragana:
      return hiraganaList;
    case KanaType.katakana:
      return katakanaList;
    case KanaType.romaji:
      return romajiList;
    case KanaType.alphabet:
      return alphabetList;
  }
}

String getKanaTitle(KanaType type) {
  switch (type) {
    case KanaType.hiragana:
      return 'ひらがな';
    case KanaType.katakana:
      return 'カタカナ';
    case KanaType.romaji:
      return 'ローマ字';
    case KanaType.alphabet:
      return 'アルファベット';
  }
}
