/// えいたんご カード用の純データ。
class WordCard {
  final String english;
  final String japanese;
  final String image; // asset path
  final String category;
  const WordCard(this.english, this.japanese, this.image, [this.category = 'どうぶつ']);
}

const String wordCardRewardSticker = 'assets/word_cards/sticker_star.webp';

WordCard _a(String en, String ja, [String cat = 'どうぶつ', String? file]) =>
    WordCard(en, ja, 'assets/word_cards/${file ?? en}.webp', cat);

final List<WordCard> animalWordCards = List.unmodifiable([
  _a('cat', 'ねこ'),
  _a('dog', 'いぬ'),
  _a('rabbit', 'うさぎ'),
  _a('bird', 'とり'),
  _a('fish', 'さかな'),
  _a('elephant', 'ぞう'),
  _a('lion', 'ライオン'),
  _a('monkey', 'さる'),
  _a('panda', 'パンダ'),
  _a('horse', 'うま'),
  _a('cow', 'うし'),
  _a('pig', 'ぶた'),
]);

final List<WordCard> fruitWordCards = List.unmodifiable([
  _a('strawberry', 'いちご', 'くだもの'),
  _a('grapes', 'ぶどう', 'くだもの'),
  _a('orange', 'オレンジ', 'くだもの'),
  _a('lemon', 'レモン', 'くだもの'),
  _a('peach', 'もも', 'くだもの'),
  _a('pineapple', 'パイナップル', 'くだもの'),
  _a('cherry', 'さくらんぼ', 'くだもの'),
  _a('watermelon', 'すいか', 'くだもの'),
]);

final List<WordCard> vehicleWordCards = List.unmodifiable([
  _a('car', 'くるま', 'のりもの'),
  _a('bus', 'バス', 'のりもの'),
  _a('train', 'でんしゃ', 'のりもの'),
  _a('airplane', 'ひこうき', 'のりもの'),
  _a('ship', 'ふね', 'のりもの'),
  _a('bicycle', 'じてんしゃ', 'のりもの'),
]);

final List<WordCard> foodWordCards = List.unmodifiable([
  _a('apple', 'りんご', 'たべもの'),
  _a('banana', 'バナナ', 'たべもの'),
  _a('bread', 'パン', 'たべもの'),
  _a('rice ball', 'おにぎり', 'たべもの', 'onigiri'),
  _a('milk', 'ぎゅうにゅう', 'たべもの'),
  _a('egg', 'たまご', 'たべもの'),
  _a('cake', 'ケーキ', 'たべもの'),
  _a('ice cream', 'アイスクリーム', 'たべもの', 'icecream'),
]);

final List<WordCard> schoolWordCards = List.unmodifiable([
  _a('pencil', 'えんぴつ', 'がっきゅうのどうぐ'),
  _a('book', 'ほん', 'がっきゅうのどうぐ'),
  _a('bag', 'かばん', 'がっきゅうのどうぐ'),
  _a('eraser', 'けしゴム', 'がっきゅうのどうぐ'),
  _a('scissors', 'はさみ', 'がっきゅうのどうぐ'),
  _a('clock', 'とけい', 'がっきゅうのどうぐ'),
]);

final List<WordCard> weatherWordCards = List.unmodifiable([
  _a('sunny', 'はれ', 'てんき'),
  _a('cloudy', 'くもり', 'てんき'),
  _a('rainy', 'あめ', 'てんき'),
  _a('snowy', 'ゆき', 'てんき'),
  _a('windy', 'かぜ', 'てんき'),
  _a('thunder', 'かみなり', 'てんき'),
  _a('rainbow', 'にじ', 'てんき'),
  _a('typhoon', 'たいふう', 'てんき'),
]);

final List<WordCard> colorWordCards = List.unmodifiable([
  _a('red', 'あか', 'いろ', 'color_red'),
  _a('blue', 'あお', 'いろ', 'color_blue'),
  _a('yellow', 'きいろ', 'いろ', 'color_yellow'),
  _a('green', 'みどり', 'いろ', 'color_green'),
  _a('pink', 'ピンク', 'いろ', 'color_pink'),
  _a('purple', 'むらさき', 'いろ', 'color_purple'),
  _a('orange', 'オレンジ', 'いろ', 'color_orange'),
  _a('black', 'くろ', 'いろ', 'color_black'),
  _a('white', 'しろ', 'いろ', 'color_white'),
  _a('brown', 'ちゃいろ', 'いろ', 'color_brown'),
]);

final List<WordCard> allWordCards = List.unmodifiable([
  ...animalWordCards,
  ...fruitWordCards,
  ...vehicleWordCards,
  ...foodWordCards,
  ...schoolWordCards,
  ...weatherWordCards,
  ...colorWordCards,
]);
