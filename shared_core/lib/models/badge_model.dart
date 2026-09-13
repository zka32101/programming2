// 小学コレシリーズ共通バッジシステム
// 全教科で共有可能な統一バッジモデル

enum BadgeCategory { streak, score, content1, content2, special, kanji, reading, writing, grammar, vocab, character }

class BadgeModel {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final BadgeCategory category;
  final int requiredCount;

  const BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.category,
    required this.requiredCount,
  });
}

class EarnedBadge {
  final BadgeModel badge;
  final DateTime earnedAt;
  const EarnedBadge({required this.badge, required this.earnedAt});
}

// 全バッジ定義（各教科共通）
const allBadges = [
  // ─── Streak Category ───
  BadgeModel(
    id: 'streak_3',
    title: '3日連続！',
    description: '3日連続で学習した',
    emoji: '🔥',
    category: BadgeCategory.streak,
    requiredCount: 3,
  ),
  BadgeModel(
    id: 'streak_7',
    title: '7日連続！',
    description: '1週間毎日学習した',
    emoji: '⚡',
    category: BadgeCategory.streak,
    requiredCount: 7,
  ),
  BadgeModel(
    id: 'streak_14',
    title: '2週間達成！',
    description: '14日連続で学習した',
    emoji: '🌟',
    category: BadgeCategory.streak,
    requiredCount: 14,
  ),
  BadgeModel(
    id: 'streak_30',
    title: '継続力マスター',
    description: '30日連続で学習した',
    emoji: '🏆',
    category: BadgeCategory.streak,
    requiredCount: 30,
  ),
  BadgeModel(
    id: 'streak_60',
    title: '2ヶ月マスター',
    description: '60日連続で学習した',
    emoji: '💎',
    category: BadgeCategory.streak,
    requiredCount: 60,
  ),
  BadgeModel(
    id: 'streak_100',
    title: '100日継承者',
    description: '100日連続で学習した',
    emoji: '👑',
    category: BadgeCategory.streak,
    requiredCount: 100,
  ),

  // ─── Score Category ───
  BadgeModel(
    id: 'score_first',
    title: 'はじめてのクリア',
    description: 'ステージを初めてクリア',
    emoji: '🎯',
    category: BadgeCategory.score,
    requiredCount: 1,
  ),
  BadgeModel(
    id: 'perfect_score',
    title: '満点！',
    description: 'ステージで全問正解した',
    emoji: '💯',
    category: BadgeCategory.score,
    requiredCount: 1,
  ),
  BadgeModel(
    id: 'quiz_total_100',
    title: '100問突破！',
    description: 'クイズで累計100問正解',
    emoji: '✨',
    category: BadgeCategory.score,
    requiredCount: 100,
  ),
  BadgeModel(
    id: 'quiz_total_500',
    title: '500問マスター',
    description: 'クイズで累計500問正解',
    emoji: '🔥',
    category: BadgeCategory.score,
    requiredCount: 500,
  ),
  BadgeModel(
    id: 'perfect_3',
    title: '完璧！3連続満点',
    description: '連続3回の満点達成',
    emoji: '⭐',
    category: BadgeCategory.score,
    requiredCount: 3,
  ),

  // ─── Kanji Category ───
  BadgeModel(
    id: 'kanji_first',
    title: 'はじめての漢字',
    description: '漢字クイズを初めてクリア',
    emoji: '📖',
    category: BadgeCategory.kanji,
    requiredCount: 1,
  ),
  BadgeModel(
    id: 'kanji_10',
    title: '漢字博士',
    description: '漢字クイズを10問正解',
    emoji: '🎓',
    category: BadgeCategory.kanji,
    requiredCount: 10,
  ),

  // ─── Reading Category ───
  BadgeModel(
    id: 'reading_first',
    title: 'はじめての読解',
    description: '読解クイズを初めてクリア',
    emoji: '📚',
    category: BadgeCategory.reading,
    requiredCount: 1,
  ),
  BadgeModel(
    id: 'reading_10',
    title: '記事読者',
    description: '読解クイズで10問達成',
    emoji: '🔍',
    category: BadgeCategory.reading,
    requiredCount: 10,
  ),

  // ─── Writing Category ───
  BadgeModel(
    id: 'writing_first',
    title: 'はじめての筆！',
    description: '「かく」機能で初めて合格',
    emoji: '✏️',
    category: BadgeCategory.writing,
    requiredCount: 1,
  ),
  BadgeModel(
    id: 'writing_10',
    title: 'ペン職人',
    description: '「かく」機能で10回合格',
    emoji: '🖊️',
    category: BadgeCategory.writing,
    requiredCount: 10,
  ),
  BadgeModel(
    id: 'writing_all',
    title: '全文字制覇',
    description: 'ひらがな・カタカナ・漢字すべて習得',
    emoji: '🎌',
    category: BadgeCategory.writing,
    requiredCount: 1,
  ),

  // ─── Grammar Category ───
  BadgeModel(
    id: 'grammar_first',
    title: '文法初級者',
    description: '文法クイズで初めて達成',
    emoji: '📝',
    category: BadgeCategory.grammar,
    requiredCount: 1,
  ),
  BadgeModel(
    id: 'grammar_master',
    title: '文法マスター',
    description: '全5文法カテゴリをマスター',
    emoji: '🎓',
    category: BadgeCategory.grammar,
    requiredCount: 1,
  ),

  // ─── Vocab Category ───
  BadgeModel(
    id: 'vocab_first',
    title: 'ことばの旅開始',
    description: '語彙クイズで初めて達成',
    emoji: '📖',
    category: BadgeCategory.vocab,
    requiredCount: 1,
  ),
  BadgeModel(
    id: 'vocab_master',
    title: 'ことば博士',
    description: '50問以上の語彙を習得',
    emoji: '📚',
    category: BadgeCategory.vocab,
    requiredCount: 50,
  ),

  // ─── Character Category ───
  BadgeModel(
    id: 'character_3',
    title: 'キャラクター3体目',
    description: 'キャラを3体解放',
    emoji: '🌟',
    category: BadgeCategory.character,
    requiredCount: 3,
  ),
  BadgeModel(
    id: 'character_lv_max',
    title: 'キャラレベル最大！',
    description: 'キャラをレベルMAXに育成',
    emoji: '⭐',
    category: BadgeCategory.character,
    requiredCount: 1,
  ),

  // ─── Special Category ───
  BadgeModel(
    id: 'badge_collector',
    title: 'バッジコレクター',
    description: '10個以上のバッジを獲得',
    emoji: '🎁',
    category: BadgeCategory.special,
    requiredCount: 10,
  ),
  BadgeModel(
    id: 'stage_20',
    title: '20ステージクリア',
    description: 'ストーリーを20ステージ進めた',
    emoji: '🌈',
    category: BadgeCategory.special,
    requiredCount: 20,
  ),
  BadgeModel(
    id: 'stage_30',
    title: '30ステージクリア',
    description: 'ストーリーを30ステージ進めた',
    emoji: '🚀',
    category: BadgeCategory.special,
    requiredCount: 30,
  ),
];
