import 'package:shared_core/shared_core.dart';

// 16体の国語キャラクター（新設計 2026-06-06）
// 読む・書く・聞く・話す + 感情・記号表現キャラクター
const List<BaseCharacter> kKokugoCharacters = [
  // ── Tier 1（基礎・小1-2年相当）4体 ─────────────────────────────────
  BaseCharacter(
    id: 'honhon', name: 'ホンホン', emoji: '📖', tier: 1, unlockAt: 1,
    subject: '読書の基本',
    backstory: 'ホンホンは本（ほん）が大好き（だいすき）な妖精（ようせい）。\n'
        '世界中（せかいじゅう）の物語（ものがたり）を知っていて、\n'
        '「本を読むと、誰か（だれか）の冒険（ぼうけん）に参加（さんか）できるんだよ！」\n'
        'ホンホンと一緒（いっしょ）に、読む喜び（よろこび）を発見（はっけん）しよう。',
    stampPhrases: ['本読めた！', '面白い！', 'ホンホンと読もう', 'また読みたい',
      '物語すき', 'ありがとう！', 'また明日も', '一緒に冒険しよう'],
    imageAsset: 'assets/characters/01_honhon.png',
    levelImages: {2: 'assets/character_levels/01_honhon_lv2_1.jpg', 3: 'assets/character_levels/01_honhon_lv3_1.jpg', 5: 'assets/characters_lvmax/honhon_lvmax.jpg'},
  ),
  BaseCharacter(
    id: 'penpen', name: 'ペンペン', emoji: '✏️', tier: 1, unlockAt: 3,
    subject: '書く基本',
    backstory: 'ペンペンは書くことが大好き（だいすき）なペンの精（せい）。\n'
        'どんな文字（もじ）でも美しく（うつくしく）書ける魔法（まほう）を持っていて、\n'
        '「想い（おもい）を文字にすると、ずっと残る（のこる）んだよ！」\n'
        'ペンペンと一緒（いっしょ）に、書く楽しさを感じてね。',
    stampPhrases: ['書けた！', '上手だね', 'ペンペンと書こう', '気持ちいい',
      '文字がすき', 'ありがとう！', 'また書こう', '想いを込めて'],
    imageAsset: 'assets/characters/02_penpen.png',
    levelImages: {2: 'assets/character_levels/02_penpen_lv2_1.jpg', 3: 'assets/character_levels/02_penpen_lv3_1.jpg', 5: 'assets/characters_lvmax/penpen_lvmax.jpg'},
  ),
  BaseCharacter(
    id: 'kiku', name: 'キクくん', emoji: '👂', tier: 1, unlockAt: 5,
    subject: '聞く力',
    backstory: 'キクくんは耳（みみ）がとても良い聞き上手（ききじょうず）。\n'
        'どんな小さな音（おと）も逃さない（のがさない）守り手（まもりて）で、\n'
        '「よく聞くと、相手（あいて）の気持ち（きもち）が分かる（わかる）んだよ！」\n'
        'キクくんと一緒（いっしょ）に、聞く喜び（よろこび）を発見（はっけん）しよう。',
    stampPhrases: ['よく聞けた！', '理解できた', 'キクくんと学ぼう', '気づいたよ',
      '聞くって大切', 'ありがとう！', 'また聞こう', '相手を理解しよう'],
    imageAsset: 'assets/characters/05_kiku.png',
    levelImages: {2: 'assets/character_levels/05_kikukun_lv2_1.jpg', 3: 'assets/character_levels/05_kikukun_lv3_1.jpg', 5: 'assets/characters_lvmax/kiku_lvmax.jpg'},
  ),
  BaseCharacter(
    id: 'yomu', name: 'ヨムくん', emoji: '📚', tier: 1, unlockAt: 8,
    subject: '読解力',
    backstory: 'ヨムくんは読む魔法使い（まほうつかい）。\n'
        '難しい（むずかしい）文章（ぶんしょう）も簡単（かんたん）に読み解ける（よみとける）力（ちから）を持ってて、\n'
        '「筋道（すじみち）を辿ると（たどると）、全部（ぜんぶ）わかるんだよ！」\n'
        'ヨムくんと一緒（いっしょ）に、読み解く力（ちから）を身につけよう。',
    stampPhrases: ['読み解けた！', 'わかった！', 'ヨムくんと読もう', 'すっきり',
      '読解楽しい', 'ありがとう！', 'また読もう', '筋道を見つけよう'],
    imageAsset: 'assets/characters/06_yomu.png',
    levelImages: {2: 'assets/character_levels/06_yomukun_lv2_1.jpg', 3: 'assets/character_levels/06_yomukun_lv3_1.jpg', 5: 'assets/characters_lvmax/yomu_lvmax.jpg'},
  ),
  // ── Tier 2（応用・小2-3年相当）4体 ─────────────────────────────────
  BaseCharacter(
    id: 'jisyon', name: 'ジション', emoji: '📖', tier: 2, unlockAt: 12,
    subject: '言葉の意味',
    backstory: 'ジションは辞書（じしょ）の番人（ばんにん）。\n'
        '世界中（せかいじゅう）の言葉（ことば）の意味（いみ）を知っていて、\n'
        '「言葉の意味を知ると、使える（つかえる）言葉が増える（ふえる）んだよ！」\n'
        'ジションと一緒（いっしょ）に、言葉の世界（せかい）を広げよう（ひろげよう）。',
    stampPhrases: ['言葉わかった！', '意味がわかった', 'ジションと学ぼう', 'なるほど！',
      '言葉すき', 'ありがとう！', 'また教えてね', '言葉は宝もの'],
    imageAsset: 'assets/characters/03_jisyon.png',
    levelImages: {2: 'assets/character_levels/03_jishin_lv2_1.jpg', 3: 'assets/character_levels/03_jishin_lv3_1.jpg', 5: 'assets/characters_lvmax/jisyon_lvmax.jpg'},
  ),
  BaseCharacter(
    id: 'kaku', name: 'カクちゃん', emoji: '✍️', tier: 2, unlockAt: 16,
    subject: '創作力',
    backstory: 'カクちゃんは創作（そうさく）の魔法使い（まほうつかい）。\n'
        'あらゆる文章（ぶんしょう）を書く技（わざ）を持っていて、\n'
        '「心（こころ）に浮かんだ（うかんだ）ことを言葉（ことば）にすると、物語（ものがたり）ができるんだよ！」\n'
        'カクちゃんと一緒（いっしょ）に、創作の喜び（よろこび）を味わおう（あじわおう）。',
    stampPhrases: ['作品できた！', 'いい話だね', 'カクちゃんと書こう', '素敵だ！',
      '創作楽しい', 'ありがとう！', 'また書こう', '想像力を広げよう'],
    imageAsset: 'assets/characters/07_kaku.png',
    levelImages: {2: 'assets/character_levels/07_kakuchan_lv2_1.jpg', 3: 'assets/character_levels/07_kakuchan_lv3_1.jpg', 5: 'assets/characters_lvmax/kaku_lvmax.jpg'},
  ),
  BaseCharacter(
    id: 'hanasu', name: 'ハナすん', emoji: '💬', tier: 2, unlockAt: 20,
    subject: '話す力',
    backstory: 'ハナすんは話し上手（はなしじょうず）な伝え手（つたえて）。\n'
        '難しいこと（むずかしいこと）も分かりやすく話せる力（ちから）を持ってて、\n'
        '「相手（あいて）を思いながら話すと、心（こころ）が通じ合う（つうじあう）んだよ！」\n'
        'ハナすんと一緒（いっしょ）に、話す力（ちから）を磨こう（みがこう）。',
    stampPhrases: ['上手に話せた！', '相手が笑った', 'ハナすんと話そう', '通じたね',
      '話すって楽しい', 'ありがとう！', 'また話そう', '心を込めて話そう'],
    imageAsset: 'assets/characters/08_hanasu.png',
    levelImages: {2: 'assets/character_levels/08_hanasun_lv2_1.jpg', 3: 'assets/character_levels/08_hanasun_lv3_1.jpg', 5: 'assets/characters_lvmax/hanasu_lvmax.jpg'},
  ),
  BaseCharacter(
    id: 'kangaeru', name: 'カンガエル', emoji: '🤔', tier: 2, unlockAt: 24,
    subject: '思考力',
    backstory: 'カンガエルはじっくり考える思想家（しそうか）。\n'
        '複雑な（ふくざつな）ことも筋道立てて（すじみちたてて）考えられる力（ちから）を持ってて、\n'
        '「なぜ？と問い続ける（といつづける）と、真実（しんじつ）が見えるんだよ！」\n'
        'カンガエルと一緒（いっしょ）に、考える深さ（ふかさ）を磨こう（みがこう）。',
    stampPhrases: ['理由がわかった！', 'なるほど！', 'カンガエルと考えよう', 'ああ！',
      '思考楽しい', 'ありがとう！', 'また考えよう', '問いかけてみよう'],
    imageAsset: 'assets/characters/09_kangaeru.png',
    levelImages: {2: 'assets/character_levels/09_kangaeru_lv2_1.jpg', 3: 'assets/character_levels/09_kangaeru_lv3_1.jpg', 5: 'assets/characters_lvmax/kangaeru_lvmax.jpg'},
  ),
  // ── Tier 3（高度・小3-4年相当）4体 ─────────────────────────────────
  BaseCharacter(
    id: 'maru', name: 'マルちゃん', emoji: '。', tier: 3, unlockAt: 28,
    subject: '句点の魔法',
    backstory: 'マルちゃんは文（ぶん）を終わらせる句点（くてん）の妖精（ようせい）。\n'
        '「。」で文が完成（かんせい）することを知っていて、\n'
        '「一文（いちぶん）が終わると、新しい気持ち（きもち）で次（つぎ）が始まるんだよ！」\n'
        'マルちゃんと一緒（いっしょ）に、文の区切り（くぎり）の大切さ（たいせつさ）を学ぼう（まなぼう）。',
    stampPhrases: ['句点打てた！', '文がまとまった', 'マルちゃんと書こう', 'すっきり',
      '句点って大事', 'ありがとう！', 'また書こう', '文を完成させよう'],
    imageAsset: 'assets/characters/13_maru.png',
    levelImages: {2: 'assets/character_levels/13_maruchan_lv2_1.jpg', 3: 'assets/character_levels/13_maruchan_lv3_1.jpg', 5: 'assets/characters_lvmax/maru_lvmax.jpg'},
  ),
  BaseCharacter(
    id: 'koma', name: 'コマちゃん', emoji: '、', tier: 3, unlockAt: 32,
    subject: '読点の力',
    backstory: 'コマちゃんは文を区切る（くぎる）読点（とうてん）の精（せい）。\n'
        '「、」で読みやすさが変わる（かわる）ことを知ってて、\n'
        '「ちょっと休みを入れると、読みやすくなるんだよ！」\n'
        'コマちゃんと一緒（いっしょ）に、読点の使い方（つかいかた）を極めよう（きわめよう）。',
    stampPhrases: ['読点打てた！', '読みやすい！', 'コマちゃんと書こう', 'いい流れ',
      '読点って大事', 'ありがとう！', 'また書こう', 'リズムを作ろう'],
    imageAsset: 'assets/characters/14_koma.png',
    levelImages: {2: 'assets/character_levels/14_mojiin_lv2_1.jpg', 3: 'assets/character_levels/14_mojiin_lv3_1.jpg', 5: 'assets/characters_lvmax/koma_lvmax.jpg'},
  ),
  BaseCharacter(
    id: 'kagi', name: 'カギくん', emoji: '「」', tier: 3, unlockAt: 36,
    subject: '括弧の世界',
    backstory: 'カギくんは会話（かいわ）を包む（つつむ）括弧（かっこ）の王様（おうさま）。\n'
        '「」で会話と地の文（じのぶん）を分ける大切さ（たいせつさ）を知ってて、\n'
        '「括弧があると、誰（だれ）が話してるかはっきりするんだよ！」\n'
        'カギくんと一緒（いっしょ）に、会話表現（かいわひょうげん）をマスターしよう。',
    stampPhrases: ['括弧つけた！', '会話が活き活き', 'カギくんと書こう', 'はっきり！',
      '括弧って楽しい', 'ありがとう！', 'また書こう', '会話を活かそう'],
    imageAsset: 'assets/characters/15_kagi.png',
    levelImages: {2: 'assets/character_levels/15_kagikun_lv2_1.jpg', 3: 'assets/character_levels/15_kagikun_lv3_1.jpg', 5: 'assets/characters_lvmax/kagi_lvmax.jpg'},
  ),
  BaseCharacter(
    id: 'kuesu', name: 'クエスちゃん', emoji: '？', tier: 3, unlockAt: 40,
    subject: '疑問符の力',
    backstory: 'クエスちゃんは質問（しつもん）を促す（うながす）疑問符（ぎもんふ）の姫（ひめ）。\n'
        '「？」で読み手（よみて）の興味（きょうみ）が引き出される（ひきだされる）ことを知ってて、\n'
        '「問いかけると、相手（あいて）も考えるようになるんだよ！」\n'
        'クエスちゃんと一緒（いっしょ）に、問い（とい）の力（ちから）を発見（はっけん）しよう。',
    stampPhrases: ['疑問符つけた！', 'いい質問！', 'クエスちゃんと書こう', 'わくわく',
      '疑問符すき', 'ありがとう！', 'また書こう', '問いを大切にしよう'],
    imageAsset: 'assets/characters/16_kuesu.png',
    levelImages: {2: 'assets/character_levels/16_kuesu_chan_lv2_1.jpg', 3: 'assets/character_levels/16_kuesu_chan_lv3_1.jpg', 5: 'assets/characters_lvmax/kuesu_lvmax.jpg'},
  ),
  // ── Tier 4（完成・小4-6年相当）4体 ─────────────────────────────────
  BaseCharacter(
    id: 'warau', name: 'ワラウん', emoji: '😄', tier: 4, unlockAt: 44,
    subject: '笑い・楽しさ',
    backstory: 'ワラウんは笑顔（えがお）の魔法使い（まほうつかい）。\n'
        '「笑顔で読むと、言葉（ことば）がもっと心（こころ）に響く（ひびく）んだよ！」\n'
        '勉強（べんきょう）が辛い（つらい）時もワラウんがいれば、\n'
        'ワラウんと一緒（いっしょ）に、学ぶ喜び（よろこび）を見つけ出そう（みつけだそう）。',
    stampPhrases: ['楽しい！', 'またやりたい', 'ワラウんと学ぼう', 'いい気分',
      '勉強すき', 'ありがとう！', 'また笑おう', 'この喜びを忘れずに'],
    imageAsset: 'assets/characters/10_warau.png',
    levelImages: {2: 'assets/character_levels/10_waraun_lv2_1.jpg', 3: 'assets/character_levels/10_waraun_lv3_1.jpg', 5: 'assets/characters_lvmax/warau_lvmax.jpg'},
  ),
  BaseCharacter(
    id: 'naku', name: 'ナクちゃん', emoji: '😢', tier: 4, unlockAt: 47,
    subject: '共感・感動',
    backstory: 'ナクちゃんは感動（かんどう）を感じる感情（かんじょう）の妖精（ようせい）。\n'
        '「涙（なみだ）が出るほど感動する物語（ものがたり）もあるんだよ！」\n'
        'つらい時も、感動する時も、ナクちゃんがいると、\n'
        'ナクちゃんと一緒（いっしょ）に、心（こころ）で言葉（ことば）を感じよう。',
    stampPhrases: ['感動した！', '涙が出た', 'ナクちゃんと読もう', 'いい話だ',
      '物語深い', 'ありがとう！', 'また感動しよう', '心で感じる'],
    imageAsset: 'assets/characters/11_naku.png',
    levelImages: {5: 'assets/characters_lvmax/naku_lvmax.jpg'},
  ),
  BaseCharacter(
    id: 'odoroku', name: 'オドロクん', emoji: '😲', tier: 4, unlockAt: 50,
    subject: '驚き・発見',
    backstory: 'オドロクんは驚き（おどろき）を感じる発見（はっけん）の精（せい）。\n'
        '「予想（よそう）と違う（ちがう）展開（てんかい）が待ってるんだよ！」\n'
        'どんな驚きも、新しい（あたらしい）視点（してん）をくれるから、\n'
        'オドロクんと一緒（いっしょ）に、知らない世界（せかい）を冒険（ぼうけん）しよう。',
    stampPhrases: ['びっくりした！', '予想外だ', 'オドロクんと読もう', 'えっ！',
      '発見楽しい', 'ありがとう！', 'また新しい発見', '視点を広げよう'],
    imageAsset: 'assets/characters/12_odoroku.png',
    levelImages: {2: 'assets/character_levels/12_odorokukunn_lv2_1.jpg', 3: 'assets/character_levels/12_odorokukunn_lv3_1.jpg', 5: 'assets/characters_lvmax/odoroku_lvmax.jpg'},
  ),
];

const Map<String, String> kKokugoCharactersLvMax = {
  'honhon': 'assets/characters_lvmax/honhon_lvmax.jpg',
  'penpen': 'assets/characters_lvmax/penpen_lvmax.jpg',
  'kiku': 'assets/characters_lvmax/kiku_lvmax.jpg',
  'yomu': 'assets/characters_lvmax/yomu_lvmax.jpg',
  'jisyon': 'assets/characters_lvmax/jisyon_lvmax.jpg',
  'kaku': 'assets/characters_lvmax/kaku_lvmax.jpg',
  'hanasu': 'assets/characters_lvmax/hanasu_lvmax.jpg',
  'kangaeru': 'assets/characters_lvmax/kangaeru_lvmax.jpg',
  'maru': 'assets/characters_lvmax/maru_lvmax.jpg',
  'koma': 'assets/characters_lvmax/koma_lvmax.jpg',
  'kagi': 'assets/characters_lvmax/kagi_lvmax.jpg',
  'kuesu': 'assets/characters_lvmax/kuesu_lvmax.jpg',
  'warau': 'assets/characters_lvmax/warau_lvmax.jpg',
  'naku': 'assets/characters_lvmax/naku_lvmax.jpg',
  'odoroku': 'assets/characters_lvmax/odoroku_lvmax.jpg',
};
