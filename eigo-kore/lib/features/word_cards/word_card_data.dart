/// えいたんご カード用の純データ。
class WordCard {
  final String english;
  final String japanese;
  final String image; // asset path
  final String category;
  const WordCard(this.english, this.japanese, this.image, [this.category = 'どうぶつ']);
}

const String wordCardRewardSticker = 'assets/word_cards/sticker_star.webp';

WordCard _a(String en, String ja, [String cat = 'どうぶつ']) =>
    WordCard(en, ja, 'assets/word_cards/$en.webp', cat);

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
]);

final List<WordCard> allWordCards =
    List.unmodifiable([...animalWordCards, ...fruitWordCards, ...vehicleWordCards]);
