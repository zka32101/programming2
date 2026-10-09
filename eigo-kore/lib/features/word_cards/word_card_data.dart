/// えいたんご カード用の純データ。
class WordCard {
  final String english;
  final String japanese;
  final String image; // asset path
  const WordCard(this.english, this.japanese, this.image);
}

const String wordCardRewardSticker = 'assets/word_cards/sticker_star.webp';

WordCard _a(String en, String ja) => WordCard(en, ja, 'assets/word_cards/$en.webp');

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
