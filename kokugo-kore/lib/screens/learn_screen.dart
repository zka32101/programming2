import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('わかる'),
        backgroundColor: const Color(0xFF3498DB),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: const [
          _KanaSection(),
          _RadicalSection(),
          _KanjiSection(),
          _StrokeOrderSection(),
          _PartsOfSpeechSection(),
          _VocabularySection(),
          _WritingRulesSection(),
          _SentenceCompositionSection(),
          _ProverbSection(),
          _IdiomSection(),
          _YojijukugoSection(),
          _SynonymAntonymSection(),
          _HaikuTankaSection(),
          _GrammarTipsSection(),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _LearnExpansionTile extends StatelessWidget {
  final String emoji;
  final String title;
  final List<Widget> children;

  const _LearnExpansionTile({
    required this.emoji,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Text(emoji, style: const TextStyle(fontSize: 22)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kTextDark,
          ),
        ),
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: children,
      ),
    );
  }
}

class _KanaSection extends StatelessWidget {
  const _KanaSection();

  @override
  Widget build(BuildContext context) {
    const hiraganaRows = [
      'あ行：あいうえお / a i u e o',
      'か行：かきくけこ / ka ki ku ke ko',
      'さ行：さしすせそ / sa shi su se so',
      'た行：たちつてと / ta chi tsu te to',
      'な行：なにぬねの / na ni nu ne no',
      'は行：はひふへほ / ha hi fu he ho',
      'ま行：まみむめも / ma mi mu me mo',
      'や行：やゆよ / ya yu yo',
      'ら行：らりるれろ / ra ri ru re ro',
      'わ行：わをん / wa wo n',
    ];

    const katakanaRows = [
      'ア行：アイウエオ / a i u e o',
      'カ行：カキクケコ / ka ki ku ke ko',
      'サ行：サシスセソ / sa shi su se so',
      'タ行：タチツテト / ta chi tsu te to',
      'ナ行：ナニヌネノ / na ni nu ne no',
      'ハ行：ハヒフヘホ / ha hi fu he ho',
      'マ行：マミムメモ / ma mi mu me mo',
      'ヤ行：ヤユヨ / ya yu yo',
      'ラ行：ラリルレロ / ra ri ru re ro',
      'ワ行：ワヲン / wa wo n',
    ];

    return _LearnExpansionTile(
      emoji: '🔤',
      title: 'ひらがな・カタカナ',
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '日本語には３つの文字があります。ひらがなとカタカナを学びましょう！',
              style: TextStyle(fontSize: 13, color: kTextMuted, height: 1.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'ひらがな',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextDark),
            ),
            const SizedBox(height: 8),
            ...hiraganaRows
                .map(
                  (row) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      row,
                      style: const TextStyle(fontSize: 14, color: kTextDark, height: 1.5),
                    ),
                  ),
                )
                .toList(),
            const SizedBox(height: 16),
            const Text(
              'カタカナ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kTextDark),
            ),
            const SizedBox(height: 8),
            ...katakanaRows
                .map(
                  (row) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      row,
                      style: const TextStyle(fontSize: 14, color: kTextDark, height: 1.5),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ],
    );
  }
}

class _RadicalSection extends StatelessWidget {
  const _RadicalSection();

  static const _radicals = [
    ('人', 'にんべん'),
    ('木', 'きへん'),
    ('水', 'さんずい'),
    ('火', 'ひへん'),
    ('土', 'つちへん'),
    ('口', 'くちへん'),
    ('心', 'こころ'),
    ('手', 'てへん'),
    ('目', 'めへん'),
    ('言', 'ごんべん'),
  ];

  @override
  Widget build(BuildContext context) {
    return _LearnExpansionTile(
      emoji: '漢',
      title: '漢字の部首',
      children: [
        const Text(
          '漢字は小さなパーツで作られています。そのパーツを部首（ぶしゅ）と言います。',
          style: TextStyle(fontSize: 13, color: kTextMuted, height: 1.5),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _radicals
              .map(
                (r) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: kAccentBlue.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kAccentBlue.withAlpha(50)),
                  ),
                  child: Text(
                    '${r.$1}（${r.$2}）',
                    style: const TextStyle(fontSize: 13, color: kTextDark),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _PartsOfSpeechSection extends StatelessWidget {
  const _PartsOfSpeechSection();

  static const _parts = [
    ('名詞（めいし）', 'ものやことの名前。例：山・犬・友だち'),
    ('動詞（どうし）', '動きや状態を表す。例：走る・食べる・ある'),
    ('形容詞（けいようし）', 'ものの様子を表す。例：大きい・楽しい・赤い'),
    ('副詞（ふくし）', '動詞や形容詞を詳しくする。例：とても・すぐ・ゆっくり'),
    ('助詞（じょし）', '言葉をつなぐ。例：は・が・を・に・で・と'),
  ];

  @override
  Widget build(BuildContext context) {
    return _LearnExpansionTile(
      emoji: '📝',
      title: '品詞（ひんし）',
      children: [
        const Text(
          '言葉はその役割によって分けられます。どんな役割を持っているか調べてみよう！',
          style: TextStyle(fontSize: 13, color: kTextMuted, height: 1.5),
        ),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _parts
              .map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.$1,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p.$2,
                        style: const TextStyle(fontSize: 13, color: kTextDark),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _WritingRulesSection extends StatelessWidget {
  const _WritingRulesSection();

  @override
  Widget build(BuildContext context) {
    return _LearnExpansionTile(
      emoji: '📖',
      title: '文章のルール',
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _RuleItem(
              title: '段落（だんらく）',
              desc: '話のまとまりのこと。新しい段落は行を変えて、最初の1マスを空けて書く。',
            ),
            _RuleItem(
              title: '句読点（くとうてん）',
              desc: '「、」（読点）は少し間を置くところ。「。」（句点）は文の終わりにつける。',
            ),
            _RuleItem(
              title: 'かぎかっこ「　」',
              desc: '会話やセリフを書くときに使う。「こんにちは」のように、話している言葉を囲む。',
            ),
          ],
        ),
      ],
    );
  }
}

class _RuleItem extends StatelessWidget {
  final String title;
  final String desc;

  const _RuleItem({required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: kAccentGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 13, color: kTextDark, height: 1.5)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 文章の作り方
// ---------------------------------------------------------------------------

class _SentenceCompositionSection extends StatelessWidget {
  const _SentenceCompositionSection();

  @override
  Widget build(BuildContext context) {
    return _LearnExpansionTile(
      emoji: '✍️',
      title: '文章の作り方',
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _RuleItem(
              title: '①はじめ・なか・おわり',
              desc: '文章は「はじめ（きっかけ）」「なか（くわしい内容）」「おわり（まとめ・気持ち）」の3つに分けて書くと読みやすいです。',
            ),
            _RuleItem(
              title: '②主語と述語をそろえる',
              desc: '「わたしは〜しました」のように、だれが（主語）・どうした（述語）をそろえて書きます。\n例：✓ ねこが走った。 ✗ ねこは走って。',
            ),
            _RuleItem(
              title: '③くわしくする言葉（修飾語）',
              desc: '「赤い」「とても」「ゆっくり」など、言葉を説明するくわしい言葉を加えると、文章が生き生きします。\n例：ねこが走った。→ 小さなねこが速く走った。',
            ),
            _RuleItem(
              title: '④つなぎ言葉',
              desc: '「そして・だから・しかし・でも・それから」などをうまく使うと、文章のながれがわかりやすくなります。',
            ),
            _RuleItem(
              title: '⑤ていねいな文末（です・ます）',
              desc: '作文では「〜です」「〜ます」で終わると丁寧な文になります。日記や報告文に向いています。',
            ),
            _RuleItem(
              title: '⑥会話文の書き方',
              desc: '「こんにちは」と言いました。のように、かぎかっこ「　」の中に言葉を入れ、行を変えて書きます。',
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 漢字の説明セクション
// ---------------------------------------------------------------------------

class _KanjiSection extends StatelessWidget {
  const _KanjiSection();

  static const _kanjiGroups = [
    ('1年生', ['日・月・火・水・木・金・土', '山・川・田・人・口・手・目・耳', '大・小・上・下・中・左・右', '一・二・三・四・五・六・七・八・九・十']),
    ('2年生', ['親・友・明・暗・晴・雨・雪・風', '東・西・南・北・朝・昼・夜・春・夏・秋・冬', '読・書・話・聞・答・問・考・思']),
    ('3年生', ['勉・強・練・習・宿・題・学・校', '心・体・食・飲・住・服・顔・声', '守・助・役・使・待・送・運・遊']),
    ('4年生', ['健・康・笑・泣・怒・悲・喜・楽', '計・算・量・重・軽・速・遅・多・少', '説・明・意・味・理・由・目・的']),
    ('5年生', ['政・治・経・済・産・業・農・工', '比・較・判・断・批・評・表・現', '確・信・仮・定・実・験・結・果']),
    ('6年生', ['憲・法・権・利・義・務・責・任', '宇・宙・科・技・進・化・革・命', '文・化・伝・統・価・値・尊・重']),
  ];

  @override
  Widget build(BuildContext context) {
    return _LearnExpansionTile(
      emoji: '漢',
      title: '学年別 漢字一覧',
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '各学年で学ぶ主な漢字です。漢字は読み方と意味をセットで覚えましょう！',
              style: TextStyle(fontSize: 13, color: kTextMuted, height: 1.5),
            ),
            const SizedBox(height: 12),
            ..._kanjiGroups.map((group) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      group.$1,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kPrimaryColor),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...group.$2.map((row) => Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 8),
                    child: Text(
                      '・$row',
                      style: const TextStyle(fontSize: 13, color: kTextDark),
                    ),
                  )),
                ],
              ),
            )),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// ことばの説明セクション
// ---------------------------------------------------------------------------

class _VocabularySection extends StatelessWidget {
  const _VocabularySection();

  static const _wordGroups = [
    ('気持ち・感情', [
      ('嬉しい（うれしい）', 'よいことがあって心が明るくなる気持ち'),
      ('悲しい（かなしい）', 'つらくて心が痛むような気持ち'),
      ('怒る（おこる）', 'いやなことや不公平なことに腹が立つ'),
      ('驚く（おどろく）', '思いがけないことに急に心が動かされる'),
      ('恥ずかしい（はずかしい）', '人に見られたくないようなことをして気まずい'),
    ]),
    ('動作・行動', [
      ('観察する（かんさつする）', 'じっくり注意してよく見ること'),
      ('比べる（くらべる）', '二つ以上のものを並べて同じところや違うところを調べること'),
      ('工夫する（くふうする）', 'よりよくなるよう考えてやり方を変えること'),
      ('協力する（きょうりょくする）', '力を合わせて一緒に取り組むこと'),
      ('説明する（せつめいする）', '相手にわかるようにくわしく話すこと'),
    ]),
    ('自然・科学', [
      ('成長（せいちょう）', '体や心が大きく、強く、豊かになること'),
      ('変化（へんか）', '形や状態が変わること'),
      ('循環（じゅんかん）', 'ぐるぐる回って元に戻ること'),
      ('生態系（せいたいけい）', '生き物と環境が関わり合っている仕組み'),
      ('環境（かんきょう）', '生き物のまわりにある自然や社会の状態'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return _LearnExpansionTile(
      emoji: '💬',
      title: 'ことばの意味',
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'よく使うことばの意味を覚えましょう！',
              style: TextStyle(fontSize: 13, color: kTextMuted, height: 1.5),
            ),
            const SizedBox(height: 12),
            ..._wordGroups.map((group) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: kAccentGreen.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      group.$1,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kAccentGreen),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...group.$2.map((word) => Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('・ ', style: TextStyle(color: kAccentGreen, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                word.$1,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextDark),
                              ),
                              Text(
                                word.$2,
                                style: const TextStyle(fontSize: 12, color: kTextMuted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            )),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// ことわざクイズ（削除済み - まなぶメニューから直接アクセス）
// ---------------------------------------------------------------------------

class _ProverbQuizSection extends StatefulWidget {
  const _ProverbQuizSection();

  @override
  State<_ProverbQuizSection> createState() => _ProverbQuizSectionState();
}

class _ProverbQuizSectionState extends State<_ProverbQuizSection> {
  static const _questions = [
    _QuizData(
      question: '「七転び八起き（ななころびやおき）」の意味は？',
      choices: ['何度転んでも起き上がる', 'ゆっくり歩くこと', '7回だけ失敗すること', '転ばないようにすること'],
      correct: 0,
      hint: 'なんど失敗してもあきらめないことです。',
    ),
    _QuizData(
      question: '「急がば回れ（いそがばまわれ）」の意味は？',
      choices: ['急ぐときは走る', '近道をさがす', '急ぐときほど確かな方法を選ぶ', 'まわり道はよくない'],
      correct: 2,
      hint: '焦って危ない近道より、確かな方法で進みましょう。',
    ),
    _QuizData(
      question: '「花より団子（はなよりだんご）」の意味は？',
      choices: ['花もだんごも好き', '見た目より実際の利益を大切にする', '花を食べる', 'だんごが一番おいしい'],
      correct: 1,
      hint: '美しい花を見るよりも、食べられる団子の方がいいということです。',
    ),
    _QuizData(
      question: '「石の上にも三年（いしのうえにもさんねん）」の意味は？',
      choices: ['石は3年で割れる', '冷たい石でも3年すわれば暖かくなる', '辛抱強く続けると成果が出る', '3年間何もしない'],
      correct: 2,
      hint: '最初は辛くても、がまんして続ければ必ずうまくいくということです。',
    ),
    _QuizData(
      question: '「猿も木から落ちる（さるもきからおちる）」の意味は？',
      choices: ['さるは木登りが下手', 'どんな名人でも失敗することがある', '木から落ちると危ない', 'さるは猫より上手'],
      correct: 1,
      hint: 'どんなに上手な人でも時には失敗することがあるということです。',
    ),
  ];

  final Map<int, int?> _selected = {};

  @override
  Widget build(BuildContext context) {
    return _LearnExpansionTile(
      emoji: '🏮',
      title: 'ことわざクイズ',
      children: [
        Column(
          children: List.generate(_questions.length, (i) {
            final q = _questions[i];
            return _QuizItem(
              index: i,
              data: q,
              selected: _selected[i],
              onSelect: (v) => setState(() => _selected[i] = v),
            );
          }),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 慣用句クイズ
// ---------------------------------------------------------------------------

class _IdiomQuizSection extends StatefulWidget {
  const _IdiomQuizSection();

  @override
  State<_IdiomQuizSection> createState() => _IdiomQuizSectionState();
}

class _IdiomQuizSectionState extends State<_IdiomQuizSection> {
  static const _questions = [
    _QuizData(
      question: '「頭が上がらない（あたまがあがらない）」の意味は？',
      choices: ['頭が重い', 'かなわないほど感謝していること', '頭を低くすること', '頭が痛い'],
      correct: 1,
      hint: '感謝していて、対等に向き合えないということです。',
    ),
    _QuizData(
      question: '「骨を折る（ほねをおる）」の意味は？',
      choices: ['骨が折れてしまう', '疲れること', 'たいへん苦労すること', '骨折りをすること'],
      correct: 2,
      hint: '一生懸命苦労して取り組むことをいいます。',
    ),
    _QuizData(
      question: '「手を貸す（てをかす）」の意味は？',
      choices: ['手をかりる', '助けること', '手を差し出す', '手をつなぐ'],
      correct: 1,
      hint: '困っている人の手伝いをすることです。',
    ),
    _QuizData(
      question: '「口が固い（くちがかたい）」の意味は？',
      choices: ['口が開かない', '話すのが苦手', '秘密を守ること', '硬い食べ物が好き'],
      correct: 2,
      hint: '秘密や話を外に漏らさないという意味です。',
    ),
    _QuizData(
      question: '「目を丸くする（めをまるくする）」の意味は？',
      choices: ['目を大きくする', 'とても驚くこと', '目が丸い形', '目を細める'],
      correct: 1,
      hint: '驚いたときに目が大きく丸くなることから来ています。',
    ),
  ];

  final Map<int, int?> _selected = {};

  @override
  Widget build(BuildContext context) {
    return _LearnExpansionTile(
      emoji: '💬',
      title: '慣用句クイズ',
      children: [
        Column(
          children: List.generate(_questions.length, (i) {
            final q = _questions[i];
            return _QuizItem(
              index: i,
              data: q,
              selected: _selected[i],
              onSelect: (v) => setState(() => _selected[i] = v),
            );
          }),
        ),
      ],
    );
  }
}

// Shared quiz data + widget
class _QuizData {
  final String question;
  final List<String> choices;
  final int correct;
  final String hint;
  const _QuizData({
    required this.question,
    required this.choices,
    required this.correct,
    required this.hint,
  });
}

class _QuizItem extends StatelessWidget {
  final int index;
  final _QuizData data;
  final int? selected;
  final void Function(int) onSelect;

  const _QuizItem({
    required this.index,
    required this.data,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final answered = selected != null;
    final correct = answered && selected == data.correct;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kBgLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q${index + 1}. ${data.question}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextDark),
          ),
          const SizedBox(height: 8),
          ...List.generate(data.choices.length, (ci) {
            final isSelected = selected == ci;
            final isCorrect = ci == data.correct;
            Color bg = Colors.white;
            Color border = Colors.grey.shade300;
            if (answered) {
              if (isCorrect) { bg = kAccentGreen.withOpacity(0.15); border = kAccentGreen; }
              else if (isSelected) { bg = kAccentRed.withOpacity(0.1); border = kAccentRed; }
            } else if (isSelected) {
              bg = kPrimaryColor.withOpacity(0.1); border = kPrimaryColor;
            }
            return GestureDetector(
              onTap: answered ? null : () => onSelect(ci),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: border),
                ),
                child: Text(
                  '${['ア', 'イ', 'ウ', 'エ'][ci]}. ${data.choices[ci]}',
                  style: const TextStyle(fontSize: 13, color: kTextDark),
                ),
              ),
            );
          }),
          if (answered) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(correct ? Icons.check_circle : Icons.cancel,
                    color: correct ? kAccentGreen : kAccentRed, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    data.hint,
                    style: TextStyle(
                      fontSize: 12,
                      color: correct ? kAccentGreen : kAccentRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ProverbSection extends StatelessWidget {
  const _ProverbSection();

  static const _proverbs = [
    ('七転び八起き（ななころびやおき）', 'なんど失敗（しっぱい）してもあきらめないこと'),
    ('石の上にも三年（いしのうえにもさんねん）', '忍耐強（にんたいづよ）く続（つづ）ければ成果（せいか）が出る'),
    ('急がば回れ（いそがばまわれ）', '急（いそ）ぐときほど確実（かくじつ）な方法（ほうほう）を選（えら）んだほうがよい'),
    ('塵も積もれば山となる（ちりもつもればやまとなる）', '小（ちい）さなことでも積（つ）み重（かさ）なれば大（おお）きくなる'),
    ('花より団子（はなよりだんご）', '見（み）た目（め）より実際（じっさい）の利益（りえき）を重（おも）んじること'),
    ('猿も木から落ちる（さるもきからおちる）', 'どんな名人（めいじん）でも失敗（しっぱい）することがある'),
    ('河童の川流れ（かっぱのかわながれ）', 'その道（みち）の名人（めいじん）でも失敗（しっぱい）することがある'),
    ('二度あることは三度ある（にどあることはさんどある）', '同（おな）じことが繰（く）り返（かえ）されやすい'),
    ('笑う門には福来たる（わらうかどにはふくきたる）', '笑（わら）いの絶（た）えない家（いえ）には幸（しあわ）せがやってくる'),
    ('早起きは三文の徳（はやおきはさんもんのとく）', '朝（あさ）早（はや）く起（お）きると良（よ）いことがある'),
  ];

  @override
  Widget build(BuildContext context) {
    return _LearnExpansionTile(
      emoji: '🏮',
      title: 'ことわざ',
      children: [
        const Text(
          'ことわざとは、昔（むかし）から伝（つた）わる短（みじか）い言葉（ことば）で、'
          '生活（せいかつ）の知恵（ちえ）や教（おし）えを表（あらわ）しています。\n'
          '意味（いみ）を覚（おぼ）えておくと日常生活（にちじょうせいかつ）で役立（やくだ）ちます！',
          style: TextStyle(fontSize: 13, color: kTextMuted, height: 1.5),
        ),
        const SizedBox(height: 12),
        Column(
          children: _proverbs
              .map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '・',
                        style: TextStyle(fontSize: 14, color: kPrimaryColor),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.$1,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: kTextDark,
                              ),
                            ),
                            Text(
                              p.$2,
                              style: const TextStyle(fontSize: 12, color: kTextMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// ─── 四字熟語 ──────────────────────────────────────────────────────────────

class _YojijukugoSection extends StatelessWidget {
  const _YojijukugoSection();

  static const _items = [
    ('一石二鳥', 'いっせきにちょう', '一つのことで二つの得をすること'),
    ('七転八起', 'しちてんはっき', '何度失敗してもあきらめずに立ち上がること'),
    ('十人十色', 'じゅうにんといろ', '人それぞれに考え方や好みがあること'),
    ('百聞不如一見', 'ひゃくぶんはいっけんにしかず', '何度聞くより一度見る方がよくわかること'),
    ('以心伝心', 'いしんでんしん', '言葉にしなくても気持ちが伝わること'),
    ('臨機応変', 'りんきおうへん', '場の状況に合わせて対応を変えること'),
    ('一期一会', 'いちごいちえ', '一生に一度だけの大切な出会い'),
    ('喜怒哀楽', 'きどあいらく', '人間が感じる喜び・怒り・悲しみ・楽しみ'),
    ('自業自得', 'じごうじとく', '自分のしたことの結果は自分で受けること'),
    ('前途多難', 'ぜんとたなん', 'これから先に多くの困難があること'),
    ('温故知新', 'おんこちしん', '古いことを学んで新しいことに活かすこと'),
    ('切磋琢磨', 'せっさたくま', 'お互いに競い合い高め合うこと'),
  ];

  @override
  Widget build(BuildContext context) {
    return _LearnExpansionTile(
      emoji: '🎴',
      title: '四字熟語（よじじゅくご）',
      children: [
        const Text(
          '4つの漢字が組み合わさった言葉。短い言葉で深い意味を表すよ！',
          style: TextStyle(fontSize: 12, color: kTextMuted),
        ),
        const SizedBox(height: 12),
        Column(
          children: _items
              .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.only(top: 6, right: 8),
                          decoration: const BoxDecoration(
                            color: kAccentPurple,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(e.$1,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: kTextDark)),
                                  const SizedBox(width: 6),
                                  Text('（${e.$2}）',
                                      style: const TextStyle(
                                          fontSize: 11, color: kTextMuted)),
                                ],
                              ),
                              Text(e.$3,
                                  style: const TextStyle(
                                      fontSize: 12, color: kTextMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ─── 類義語・対義語 ────────────────────────────────────────────────────────

class _SynonymAntonymSection extends StatelessWidget {
  const _SynonymAntonymSection();

  static const _synonyms = [
    ('大きい', 'でかい・広大な', '巨大な・広い'),
    ('小さい', 'ちっちゃい・小柄な', ''),
    ('嬉しい', 'よろこばしい・楽しい', ''),
    ('悲しい', 'つらい・かなしい', ''),
    ('始まる', 'スタートする・起こる', ''),
  ];

  static const _antonyms = [
    ('上', 'うえ', '下（した）'),
    ('前', 'まえ', '後ろ（うしろ）'),
    ('強い', 'つよい', '弱い（よわい）'),
    ('明るい', 'あかるい', '暗い（くらい）'),
    ('長い', 'ながい', '短い（みじかい）'),
    ('速い', 'はやい', '遅い（おそい）'),
    ('多い', 'おおい', '少ない（すくない）'),
    ('暑い', 'あつい', '寒い（さむい）'),
    ('厚い', 'あつい', '薄い（うすい）'),
    ('甘い', 'あまい', '辛い（からい）'),
  ];

  @override
  Widget build(BuildContext context) {
    return _LearnExpansionTile(
      emoji: '🔄',
      title: '類義語・対義語（はんたい言葉・似た言葉）',
      children: [
        const Text(
          '「対義語」は反対の意味の言葉、「類義語」は似た意味の言葉だよ。',
          style: TextStyle(fontSize: 12, color: kTextMuted),
        ),
        const SizedBox(height: 10),
        const Text('▶ 対義語（はんたいの言葉）',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: kAccentRed)),
        const SizedBox(height: 6),
        Column(
          children: _antonyms
              .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(e.$1,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: kTextDark)),
                        ),
                        const Text(' ↔ ',
                            style:
                                TextStyle(color: kAccentRed, fontSize: 13)),
                        Text(e.$3,
                            style: const TextStyle(
                                fontSize: 13, color: kTextDark)),
                      ],
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 10),
        const Text('▶ 類義語（にた意味の言葉）',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: kAccentBlue)),
        const SizedBox(height: 6),
        Column(
          children: _synonyms
              .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text(e.$1,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: kTextDark)),
                        ),
                        const Text(' → ',
                            style:
                                TextStyle(color: kAccentBlue, fontSize: 13)),
                        Expanded(
                          child: Text(e.$2,
                              style: const TextStyle(
                                  fontSize: 12, color: kTextDark)),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ─── 俳句・短歌 ───────────────────────────────────────────────────────────

class _HaikuTankaSection extends StatelessWidget {
  const _HaikuTankaSection();

  static const _haiku = [
    ('古池や　蛙飛び込む　水の音', 'ふるいけや　かわずとびこむ　みずのおと', '松尾芭蕉（まつおばしょう）'),
    ('春の海　終日（ひねもす）のたり　のたりかな', 'はるのうみ　ひねもすのたり　のたりかな', '与謝蕪村（よさぶそん）'),
    ('雪とけて　村いっぱいの　子どもかな', 'ゆきとけて　むらいっぱいの　こどもかな', '小林一茶（こばやしいっさ）'),
  ];

  @override
  Widget build(BuildContext context) {
    return _LearnExpansionTile(
      emoji: '🌸',
      title: '俳句・短歌（はいく・たんか）',
      children: [
        _RuleBox(
          color: kAccentPink,
          title: '俳句（はいく）のきまり',
          lines: const [
            '• 5・7・5 の17音でできている',
            '• 「季語（きご）」という季節を表す言葉が入る',
            '• 短い言葉で情景（じょうけい）を表現する詩',
          ],
        ),
        const SizedBox(height: 10),
        const Text('▶ 有名な俳句（ゆうめいなはいく）',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: kTextDark)),
        const SizedBox(height: 6),
        Column(
          children: _haiku
              .map((e) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kAccentPink.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.$1,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: kTextDark)),
                        Text(e.$2,
                            style: const TextStyle(
                                fontSize: 11, color: kTextMuted)),
                        Text('作者: ${e.$3}',
                            style: const TextStyle(
                                fontSize: 10, color: kTextMuted)),
                      ],
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 10),
        _RuleBox(
          color: kAccentBlue,
          title: '短歌（たんか）のきまり',
          lines: const [
            '• 5・7・5・7・7 の31音でできている',
            '• 俳句より長く、気持ちや情景を細かく表現できる',
          ],
        ),
      ],
    );
  }
}

class _RuleBox extends StatelessWidget {
  final Color color;
  final String title;
  final List<String> lines;
  const _RuleBox(
      {required this.color, required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          ...lines.map((l) => Text(l,
              style: const TextStyle(fontSize: 12, color: kTextDark))),
        ],
      ),
    );
  }
}

// ─── 文法ヒント ───────────────────────────────────────────────────────────

class _GrammarTipsSection extends StatelessWidget {
  const _GrammarTipsSection();

  static const _particles = [
    ('は', 'は', '主語を示す。例：わたし「は」学生です。'),
    ('が', 'が', '主語・対象を強調。例：ねこ「が」いる。'),
    ('を', 'を', '目的語を示す。例：ごはん「を」食べる。'),
    ('に', 'に', '場所・方向・時間。例：学校「に」行く。'),
    ('で', 'で', '場所・手段・方法。例：バス「で」行く。'),
    ('の', 'の', '所有・説明。例：わたし「の」本。'),
    ('も', 'も', '同様を示す。例：ねこ「も」いる。'),
    ('と', 'と', '並列・相手。例：友達「と」遊ぶ。'),
    ('から', 'から', '始まり・理由。例：学校「から」帰る。'),
    ('まで', 'まで', '終わり・範囲。例：夜「まで」遊ぶ。'),
  ];

  @override
  Widget build(BuildContext context) {
    return _LearnExpansionTile(
      emoji: '📖',
      title: '助詞（じょし）のつかいかた',
      children: [
        const Text(
          '助詞は言葉と言葉をつなぐ大切な言葉。正しく使うと文が伝わりやすくなるよ！',
          style: TextStyle(fontSize: 12, color: kTextMuted),
        ),
        const SizedBox(height: 10),
        Column(
          children: _particles
              .map((e) => Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: kBgLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(e.$1,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(e.$3,
                              style: const TextStyle(
                                  fontSize: 12, color: kTextDark)),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ─── 慣用句 ───────────────────────────────────────────────────────────────

class _IdiomSection extends StatelessWidget {
  const _IdiomSection();

  static const _idioms = [
    ('頭（あたま）が上（あ）がらない', 'かなわないほど感謝（かんしゃ）していること'),
    ('足（あし）を引（ひ）っ張（ぱ）る', '人（ひと）の邪魔（じゃま）をすること'),
    ('骨（ほね）を折（お）る', 'たいへん苦労（くろう）すること'),
    ('手（て）を貸（か）す', '助（たす）けること'),
    ('目（め）を丸（まる）くする', 'とても驚（おどろ）くこと'),
    ('口（くち）が固（かた）い', '秘密（ひみつ）を守（まも）ること'),
    ('耳（みみ）を傾（かたむ）ける', 'よく聞（き）くこと'),
    ('肩（かた）の荷（に）が下（お）りる', '心配（しんぱい）がなくなること'),
    ('腹（はら）を割（わ）る', '本音（ほんね）で話（はな）し合（あ）うこと'),
    ('気（き）が置（お）けない', '気（き）を使（つか）わなくてよいこと'),
  ];

  @override
  Widget build(BuildContext context) {
    return _LearnExpansionTile(
      emoji: '💬',
      title: '慣用句（かんようく）',
      children: [
        const Text(
          '慣用句（かんようく）とは、複数（ふくすう）の言葉（ことば）が組（く）み合（あ）わさって、\n'
          'もとの意味（いみ）とは違（ちが）う特別（とくべつ）な意味（いみ）を持（も）つ表現（ひょうげん）のことです。\n'
          '例：「頭（あたま）が上（あ）がらない」＝感謝（かんしゃ）していてかなわないこと',
          style: TextStyle(fontSize: 13, color: kTextMuted, height: 1.5),
        ),
        const SizedBox(height: 12),
        Column(
          children: _idioms
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '・',
                        style: TextStyle(fontSize: 14, color: kAccentBlue),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.$1,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: kTextDark,
                              ),
                            ),
                            Text(
                              item.$2,
                              style: const TextStyle(fontSize: 12, color: kTextMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// ─── 書き順セクション ─────────────────────────────────────────
class _StrokeOrderSection extends StatelessWidget {
  const _StrokeOrderSection();

  static const _rules = [
    ('① 上から下（うえからした）', '上（うえ）の部分（ぶぶん）から書（か）き始（はじ）めます。\n例：「三（さん）」は上（うえ）の横線（よこせん）から順（じゅん）に書（か）く。'),
    ('② 左から右（ひだりからみぎ）', '横方向（よこほうこう）に書（か）くときは、左側（ひだりがわ）から書（か）き始（はじ）めます。\n例：「川（かわ）」は左（ひだり）の縦線（たてせん）から。'),
    ('③ 横線が先（よこせんがさき）', '横線（よこせん）と縦線（たてせん）が交差（こうさ）する場合（ばあい）は横線（よこせん）を先（さき）に書（か）くことが多（おお）い。\n例：「十（じゅう）」は「一（いち）」を書（か）いてから「｜」。'),
    ('④ 真ん中が先（まんなかがさき）', '左右対称（さゆうたいしょう）の文字（もじ）は、真（ま）ん中（なか）から書（か）くことが多（おお）い。\n例：「小（しょう）」は真（ま）ん中（なか）の縦線（たてせん）から。'),
    ('⑤ 外側が先（そとがわがさき）', '囲（かこ）む形（かたち）は外側（そとがわ）の線（せん）を先（さき）に書（か）く。\n例：「口（くち）」は左縦線（ひだりたてせん）→ 上横線（うえよこせん）→ 右縦線（みぎたてせん）→ 下横線（したよこせん）。'),
    ('⑥ 点は最後（てんはさいご）', '「犬（いぬ）」「太（ふと）い」などの点（てん）は最後（さいご）に書（か）くことが多（おお）い。'),
  ];

  @override
  Widget build(BuildContext context) {
    return _LearnExpansionTile(
      emoji: '✏️',
      title: '書き順（かきじゅん）のルール',
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '漢字（かんじ）やひらがなの書き順（かきじゅん）には基本（きほん）のルールがあります。\n'
              '正（ただ）しい書き順（かきじゅん）で書（か）くと、きれいな字（じ）が書（か）けます！',
              style: TextStyle(fontSize: 13, color: kTextMuted, height: 1.5),
            ),
            const SizedBox(height: 12),
            ..._rules.map((r) => _RuleItem(title: r.$1, desc: r.$2)),
          ],
        ),
      ],
    );
  }
}
