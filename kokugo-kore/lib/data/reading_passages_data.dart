// lib/data/reading_passages_data.dart
// 読解力強化トレーニング用のコンテンツ（6記事ぶん）。
// lib/models/reading_passage_model.dart のfreezedモデルを使用。

import '../models/reading_passage_model.dart';

const List<ReadingPassage> readingPassages = [
  ReadingPassage(
    passageId: 'hiragana_history',
    title: 'ひらがなの歴史',
    author: '小学コレ！国語 編集部',
    grade: 1,
    difficulty: 'basic',
    estimatedReadingTimeSeconds: 300,
    genre: '民俗',
    wordCount: 420,
    vocabularyList: ['女文字', '流れるような形', '書きやすい'],
    content: '''
ひらがなの歴史

ひらがなは、日本語を書くために、中国の文字である漢字から生まれた独自の文字です。

ひらがなが生まれた背景

古い時代の日本では、文字がありませんでした。中国から漢字が伝わってくると、日本人はこの漢字を使って日本語を書くようになりました。

しかし、漢字は複雑で、覚えるのに時間がかかります。そこで、人々は、漢字の一部を使って、もっと簡単に書ける文字を作ることにしました。これがひらがなです。

ひらがなの誕生

ひらがなは、9世紀ごろに誕生したと考えられています。最初に使ったのは、女性や一般の人々でした。当時、学問の世界では、漢文が使われ、ひらがなは「女文字」と呼ばれていました。

ひらがなの特徴

ひらがなには、いくつかの特徴があります。

1. 書きやすい
ひらがなは、漢字のように複雑な形をしていません。少ない線で書くことができます。

2. 発音がはっきりしている
ひらがなの文字は、それぞれ一つの音を表しています。

3. 流れるような形
ひらがなの文字は、丸みを帯びた形をしていて、流れるように見えます。

ひらがなの活躍

時代が進むと、ひらがなはもっと多くの場面で使われるようになりました。

• 物語や詩を書くのに使われました
• 手紙の文章で使われました
• やがて、子どもの教育にも使われるようになりました

現代のひらがな

今では、ひらがなは日本語を書く時に、とても大切な役割をしています。

子どもたちが学校で一番最初に習う文字は、ひらがなです。漢字を学ぶ時も、ひらがなで読み方を示します。

ひらがなは、日本文化を代表する文字の一つになりました。
''',
  ),
  ReadingPassage(
    passageId: 'mukashibanashi',
    title: 'むかし話の力',
    author: '小学コレ！国語 編集部',
    grade: 2,
    difficulty: 'basic',
    estimatedReadingTimeSeconds: 360,
    genre: '文学',
    wordCount: 430,
    vocabularyList: ['口づたえ', '教訓', '登場人物'],
    content: '''
むかし話の力

「ももたろう」や「うらしまたろう」など、むかし話を聞いたことがありますか？むかし話は、昔から人々の間で語りつがれてきた物語です。

むかし話はどう伝わってきたか

むかしは、今のように本がたくさんある時代ではありませんでした。おじいさんやおばあさんが、子どもたちに口で語って聞かせることで、物語が伝えられてきました。これを「口づたえ」といいます。

むかし話に込められた教訓

むかし話には、多くの場合、大切な教えが込められています。「うそをついてはいけない」「がんばれば良いことがある」「やさしさを忘れてはいけない」など、生きていくうえで大切なことを、おもしろい物語を通して教えてくれます。

むかし話の登場人物

むかし話には、桃太郎のような勇気ある主人公や、意地悪な鬼、動物の姿をした仲間たちなど、さまざまな登場人物が出てきます。こうした登場人物の行動を通して、読む人は「正しいこと」と「悪いこと」を自然に学ぶことができます。

今に伝わるむかし話

今では、むかし話は絵本やアニメにもなり、多くの子どもたちに親しまれています。時代が変わっても、むかし話が持つ教訓や面白さは、今の私たちの心にも届いています。
''',
  ),
  ReadingPassage(
    passageId: 'kanji_origin',
    title: '漢字の成り立ち',
    author: '小学コレ！国語 編集部',
    grade: 3,
    difficulty: 'standard',
    estimatedReadingTimeSeconds: 480,
    genre: '歴史',
    wordCount: 480,
    vocabularyList: ['甲骨文字', '象形文字', '形声文字'],
    content: '''
漢字の成り立ち

漢字は、今からおよそ3000年以上前、中国で生まれた文字です。日本には4世紀から5世紀ごろ、中国や朝鮮半島から伝わってきたと考えられています。

漢字ができるまで

大昔の中国では、亀の甲羅や動物の骨に、うらないの記録を刻んでいました。この文字を「甲骨文字」といい、漢字のもとになったといわれています。

漢字の4つの成り立ち方

漢字には、できかたによって、いくつかの種類があります。

1. 象形文字（しょうけいもじ）
ものの形をそのまま絵のようにえがいた文字です。「山」「川」「木」などがこれにあたります。

2. 指事文字（しじもじ）
形のないことがらを、点や線で表した文字です。「上」「下」「一」などです。

3. 会意文字（かいいもじ）
2つ以上の漢字を組み合わせて、新しい意味を作った文字です。「休」は「人」が「木」のそばで休むようすを表しています。

4. 形声文字（けいせいもじ）
意味を表す部分と、音を表す部分を組み合わせた文字です。実は、漢字の多くはこの形声文字です。

日本に伝わった漢字

日本に伝わった漢字は、日本語の発音に合わせて読み方が加えられ、さらにひらがな・カタカナが作られるもとにもなりました。今では、漢字は日本語になくてはならない文字になっています。
''',
  ),
  ReadingPassage(
    passageId: 'reading_effect',
    title: '読書の効果',
    author: '小学コレ！国語 編集部',
    grade: 4,
    difficulty: 'standard',
    estimatedReadingTimeSeconds: 420,
    genre: '科学',
    wordCount: 460,
    vocabularyList: ['想像力', '集中力', '共感力'],
    content: '''
読書の効果

本を読むことには、たくさんの良い効果があると言われています。読書が、わたしたちの脳やこころにどのようなえいきょうをあたえるのか、見てみましょう。

言葉の力が育つ

本をたくさん読むと、知らなかった言葉に出会う機会が増えます。新しい言葉を覚えることで、自分の気持ちや考えを、より正確に伝えられるようになります。

想像力が豊かになる

物語を読むとき、わたしたちは頭の中で場面や登場人物の様子を思いうかべます。この作業をくり返すことで、想像する力がきたえられます。映像を見るのとはちがい、読書は自分の頭で情景を作り出す点が特徴です。

集中する力が身につく

本を読んでいる間、わたしたちは物語の世界に入りこみ、集中しています。この習慣が、勉強やほかの活動での集中力にもつながると考えられています。

人の気持ちを理解する力

物語の登場人物の気持ちを想像しながら読むことで、他の人の気持ちを思いやる力が育つといわれています。これは「共感力」と呼ばれ、友だちとの関係を築くうえでも大切な力です。

読書を習慣に

こうした効果は、一度にたくさん読んでも身につくものではありません。毎日少しずつ、読書を続けることが、いちばんの近道です。
''',
  ),
  ReadingPassage(
    passageId: 'language_culture',
    title: '言葉と文化',
    author: '小学コレ！国語 編集部',
    grade: 5,
    difficulty: 'advanced',
    estimatedReadingTimeSeconds: 600,
    genre: '文化',
    wordCount: 520,
    vocabularyList: ['季語', '敬語', 'もったいない'],
    content: '''
言葉と文化

わたしたちが使う言葉には、その国や地域の文化が深く関わっています。日本語には、日本ならではの自然や暮らしを表す、独特な言葉がたくさんあります。

季節を表す言葉

日本語には、季節の移り変わりを細やかに表す言葉が数多くあります。「春一番」「五月晴れ」「小春日和」など、四季のある日本の気候から生まれた言葉です。俳句で使われる「季語」も、この文化を代表するものの一つです。

敬語という文化

日本語には、相手への敬意を表す「敬語」という仕組みがあります。目上の人と話すときや、初めて会う人と話すときに敬語を使うのは、相手を大切に思う気持ちを言葉で表す、日本の文化の一つといえます。

言葉から見える価値観

「もったいない」ということばは、物を大切にする日本人の考え方をよく表していると、海外でも注目されています。このように、ある言葉があるかないかによって、その国の人々が何を大切にしているかが見えてくることがあります。

言葉は文化とともに変わる

時代が変わると、新しい言葉が生まれたり、使われなくなる言葉もあります。それでも、言葉の奥には、その時代・その土地に生きる人々の考え方や暮らしが映し出されています。言葉を学ぶことは、文化を学ぶことでもあるのです。
''',
  ),
  ReadingPassage(
    passageId: 'media_literacy',
    title: '情報を読み解く',
    author: '小学コレ！国語 編集部',
    grade: 6,
    difficulty: 'advanced',
    estimatedReadingTimeSeconds: 720,
    genre: 'スキル',
    wordCount: 500,
    vocabularyList: ['事実', '意見', 'メディアリテラシー'],
    content: '''
情報を読み解く

インターネットやテレビ、新聞など、わたしたちの周りには、たくさんの情報があふれています。その中から正しい情報を見分ける力は、これからの時代にますます大切になります。

事実と意見を区別する

文章を読むときは、それが「事実」なのか「意見」なのかを見分けることが大切です。「実験の結果、〇〇であることがわかった」というのは事実ですが、「〇〇するべきだと思う」というのは、書いた人の意見です。両方を混同すると、正しく情報を理解できません。

情報の出どころを確かめる

「だれが」「いつ」発信した情報なのかを確かめることも重要です。出どころがはっきりしない情報や、古い情報をそのまま信じてしまうと、まちがった判断をしてしまうことがあります。

一つの情報だけで決めつけない

一つの記事や意見だけを読んで、それがすべて正しいと思い込むのは危険です。同じできごとについて、いくつかの情報を比べて読むことで、より正確な理解に近づくことができます。

情報を読み解く力を育てよう

情報を正しく読み解く力は、「メディアリテラシー」と呼ばれます。この力は、一度に身につくものではなく、日ごろから「これは本当かな？」と考えながら文章を読む習慣によって、少しずつ育っていきます。
''',
  ),
];

ReadingPassage? findPassage(String passageId) {
  for (final p in readingPassages) {
    if (p.passageId == passageId) return p;
  }
  return null;
}

// ---------------------------------------------------------------------------
// 理解度クイズ（各記事5問の読解確認 + 1問の構造確認、questionType別）
// ---------------------------------------------------------------------------

const List<ComprehensionQuestion> comprehensionQuestions = [
  // --- ひらがなの歴史 ---
  ComprehensionQuestion(
    questionId: 'hiragana_history_q1',
    passageId: 'hiragana_history',
    questionType: 'detail',
    questionText: 'ひらがなはいつごろに誕生したと考えられていますか？',
    choices: ['7世紀ごろ', '9世紀ごろ', '11世紀ごろ', '13世紀ごろ'],
    correctAnswer: '9世紀ごろ',
    explanation: '本文に「ひらがなは、9世紀ごろに誕生したと考えられています」とあります。',
    difficultyScore: 2,
  ),
  ComprehensionQuestion(
    questionId: 'hiragana_history_q2',
    passageId: 'hiragana_history',
    questionType: 'detail',
    questionText: 'ひらがなを最初に使った人たちは、誰ですか？',
    choices: ['皇帝', '学者', '女性や一般の人々', '僧侶'],
    correctAnswer: '女性や一般の人々',
    explanation: '本文に「最初に使ったのは、女性や一般の人々でした」とあります。',
    difficultyScore: 2,
  ),
  ComprehensionQuestion(
    questionId: 'hiragana_history_q3',
    passageId: 'hiragana_history',
    questionType: 'detail',
    questionText: 'ひらがなの特徴として述べられていないものはどれですか？',
    choices: ['書きやすい', '複雑な形をしている', '発音がはっきりしている', '流れるような形'],
    correctAnswer: '複雑な形をしている',
    explanation: '本文では「漢字のように複雑な形をしていません」と説明されています。',
    difficultyScore: 3,
  ),
  ComprehensionQuestion(
    questionId: 'hiragana_history_q4',
    passageId: 'hiragana_history',
    questionType: 'detail',
    questionText: 'ひらがなが使われた場面として述べられていないものはどれですか？',
    choices: ['物語や詩を書くのに', '手紙の文章で', '数学の計算に', '子どもの教育に'],
    correctAnswer: '数学の計算に',
    explanation: '本文で挙げられているのは「物語や詩」「手紙」「子どもの教育」の3つです。',
    difficultyScore: 3,
  ),
  ComprehensionQuestion(
    questionId: 'hiragana_history_q5',
    passageId: 'hiragana_history',
    questionType: 'summary',
    questionText: 'この記事で最も伝えたい考えは何ですか？',
    choices: [
      'ひらがなは複雑な文字である',
      'ひらがなは日本語を書く時に大切な役割がある',
      'ひらがなは昔より使われていない',
      'ひらがなは女性のためだけの文字である',
    ],
    correctAnswer: 'ひらがなは日本語を書く時に大切な役割がある',
    explanation: '記事全体を通して、ひらがなの誕生から現代までの役割の大きさが説明されています。',
    difficultyScore: 4,
  ),
  ComprehensionQuestion(
    questionId: 'hiragana_history_q6',
    passageId: 'hiragana_history',
    questionType: 'structure',
    questionText: 'この記事の文章構成を表す言葉はどれですか？',
    choices: ['起承転結', '問題提起→説明→まとめ', '時系列順', '比較対比'],
    correctAnswer: '時系列順',
    explanation: '誕生の背景→誕生→特徴→活躍→現代、という時間の流れで説明されています。',
    difficultyScore: 5,
  ),

  // --- むかし話の力 ---
  ComprehensionQuestion(
    questionId: 'mukashibanashi_q1',
    passageId: 'mukashibanashi',
    questionType: 'detail',
    questionText: 'むかし話は、どのようにして人々に伝えられてきましたか？',
    choices: ['学校の授業で', '口で語って聞かせることで', 'テレビ番組で', '新聞記事で'],
    correctAnswer: '口で語って聞かせることで',
    explanation: '本文に「口で語って聞かせることで、物語が伝えられてきました」とあります。',
    difficultyScore: 2,
  ),
  ComprehensionQuestion(
    questionId: 'mukashibanashi_q2',
    passageId: 'mukashibanashi',
    questionType: 'vocabulary',
    questionText: '「口づたえ」とはどういう意味ですか？',
    choices: ['本で読んで伝えること', '口で語って伝えること', '手紙で伝えること', '絵で伝えること'],
    correctAnswer: '口で語って伝えること',
    explanation: '本文で「口で語って聞かせることで…これを『口づたえ』といいます」と説明されています。',
    difficultyScore: 2,
  ),
  ComprehensionQuestion(
    questionId: 'mukashibanashi_q3',
    passageId: 'mukashibanashi',
    questionType: 'detail',
    questionText: 'むかし話に込められているものとして述べられていないものはどれですか？',
    choices: ['うそをついてはいけないという教え', 'やさしさを忘れないという教え', '算数の計算方法', 'がんばれば良いことがあるという教え'],
    correctAnswer: '算数の計算方法',
    explanation: '本文で挙げられているのはすべて「生きていくうえで大切なこと」についての教訓です。',
    difficultyScore: 3,
  ),
  ComprehensionQuestion(
    questionId: 'mukashibanashi_q4',
    passageId: 'mukashibanashi',
    questionType: 'detail',
    questionText: '登場人物の行動を通して、読む人は何を学ぶことができますか？',
    choices: ['漢字の書き方', '正しいことと悪いこと', '外国の言葉', '計算のしかた'],
    correctAnswer: '正しいことと悪いこと',
    explanation: '本文に「読む人は『正しいこと』と『悪いこと』を自然に学ぶことができます」とあります。',
    difficultyScore: 3,
  ),
  ComprehensionQuestion(
    questionId: 'mukashibanashi_q5',
    passageId: 'mukashibanashi',
    questionType: 'summary',
    questionText: 'この記事で最も伝えたい考えは何ですか？',
    choices: [
      'むかし話は古くて意味がない',
      'むかし話には教訓や面白さがあり、今も心に届いている',
      'むかし話は絵本にしかならない',
      'むかし話は難しくて子どもには理解できない',
    ],
    correctAnswer: 'むかし話には教訓や面白さがあり、今も心に届いている',
    explanation: '最後の段落で「むかし話が持つ教訓や面白さは、今の私たちの心にも届いています」とまとめられています。',
    difficultyScore: 4,
  ),
  ComprehensionQuestion(
    questionId: 'mukashibanashi_q6',
    passageId: 'mukashibanashi',
    questionType: 'structure',
    questionText: 'この記事の文章構成を表す言葉はどれですか？',
    choices: ['話題提示→説明→まとめ', '結論を先に述べる', '比較対比', '原因と結果のみ'],
    correctAnswer: '話題提示→説明→まとめ',
    explanation: 'むかし話とは何かを示したあと、伝わり方・教訓・登場人物を説明し、最後にまとめています。',
    difficultyScore: 5,
  ),

  // --- 漢字の成り立ち ---
  ComprehensionQuestion(
    questionId: 'kanji_origin_q1',
    passageId: 'kanji_origin',
    questionType: 'detail',
    questionText: '漢字は、いつごろ、どこで生まれた文字ですか？',
    choices: ['約3000年以上前、中国', '約1000年前、日本', '約500年前、朝鮮半島', '約100年前、中国'],
    correctAnswer: '約3000年以上前、中国',
    explanation: '本文に「漢字は、今からおよそ3000年以上前、中国で生まれた文字です」とあります。',
    difficultyScore: 3,
  ),
  ComprehensionQuestion(
    questionId: 'kanji_origin_q2',
    passageId: 'kanji_origin',
    questionType: 'vocabulary',
    questionText: '「甲骨文字」とは何に記された文字ですか？',
    choices: ['木の板', '紙', '亀の甲羅や動物の骨', '石碑'],
    correctAnswer: '亀の甲羅や動物の骨',
    explanation: '本文に「亀の甲羅や動物の骨に、うらないの記録を刻んでいました」とあります。',
    difficultyScore: 3,
  ),
  ComprehensionQuestion(
    questionId: 'kanji_origin_q3',
    passageId: 'kanji_origin',
    questionType: 'detail',
    questionText: '「山」「川」「木」のように、ものの形をそのまま絵のようにえがいた文字を何といいますか？',
    choices: ['指事文字', '会意文字', '形声文字', '象形文字'],
    correctAnswer: '象形文字',
    explanation: '本文に「象形文字（しょうけいもじ）ものの形をそのまま絵のようにえがいた文字」とあります。',
    difficultyScore: 4,
  ),
  ComprehensionQuestion(
    questionId: 'kanji_origin_q4',
    passageId: 'kanji_origin',
    questionType: 'detail',
    questionText: '漢字の多くをしめる成り立ち方はどれですか？',
    choices: ['象形文字', '指事文字', '会意文字', '形声文字'],
    correctAnswer: '形声文字',
    explanation: '本文に「実は、漢字の多くはこの形声文字です」とあります。',
    difficultyScore: 4,
  ),
  ComprehensionQuestion(
    questionId: 'kanji_origin_q5',
    passageId: 'kanji_origin',
    questionType: 'summary',
    questionText: 'この記事で最も伝えたい考えは何ですか？',
    choices: [
      '漢字は最近作られた文字である',
      '漢字にはさまざまな成り立ちがあり、日本語にとって大切な文字になった',
      '漢字は日本で生まれた文字である',
      '漢字は今ではあまり使われていない',
    ],
    correctAnswer: '漢字にはさまざまな成り立ちがあり、日本語にとって大切な文字になった',
    explanation: '漢字の起源から4つの成り立ち、日本での定着までが説明されています。',
    difficultyScore: 5,
  ),
  ComprehensionQuestion(
    questionId: 'kanji_origin_q6',
    passageId: 'kanji_origin',
    questionType: 'structure',
    questionText: 'この記事の文章構成を表す言葉はどれですか？',
    choices: ['比較対比', '起源→種類の説明→日本への広まり', '意見→反論', '結論のみ'],
    correctAnswer: '起源→種類の説明→日本への広まり',
    explanation: '漢字の起源、4つの成り立ち方の分類説明、日本に伝わった経緯の順で書かれています。',
    difficultyScore: 6,
  ),

  // --- 読書の効果 ---
  ComprehensionQuestion(
    questionId: 'reading_effect_q1',
    passageId: 'reading_effect',
    questionType: 'detail',
    questionText: '本をたくさん読むと、どのような力が育つと述べられていますか？',
    choices: ['計算する力', '言葉の力', '走る力', '絵をかく力'],
    correctAnswer: '言葉の力',
    explanation: '本文に「言葉の力が育つ」という見出しで説明されています。',
    difficultyScore: 3,
  ),
  ComprehensionQuestion(
    questionId: 'reading_effect_q2',
    passageId: 'reading_effect',
    questionType: 'vocabulary',
    questionText: '「共感力」とは、どのような力のことですか？',
    choices: ['計算する力', '他の人の気持ちを思いやる力', '速く読む力', '暗記する力'],
    correctAnswer: '他の人の気持ちを思いやる力',
    explanation: '本文に「他の人の気持ちを思いやる力が育つ…これは『共感力』と呼ばれ」とあります。',
    difficultyScore: 3,
  ),
  ComprehensionQuestion(
    questionId: 'reading_effect_q3',
    passageId: 'reading_effect',
    questionType: 'detail',
    questionText: '映像を見ることと読書のちがいとして述べられていることは何ですか？',
    choices: [
      '読書は自分の頭で情景を作り出す点が特徴',
      '映像の方が想像力が育つ',
      '読書は集中力が必要ない',
      '映像と読書に違いはない',
    ],
    correctAnswer: '読書は自分の頭で情景を作り出す点が特徴',
    explanation: '本文に「映像を見るのとはちがい、読書は自分の頭で情景を作り出す点が特徴です」とあります。',
    difficultyScore: 4,
  ),
  ComprehensionQuestion(
    questionId: 'reading_effect_q4',
    passageId: 'reading_effect',
    questionType: 'detail',
    questionText: '読書の効果を身につけるために大切なことは何ですか？',
    choices: ['一度にたくさん読むこと', '毎日少しずつ続けること', '難しい本だけ読むこと', '早く読み終えること'],
    correctAnswer: '毎日少しずつ続けること',
    explanation: '本文に「毎日少しずつ、読書を続けることが、いちばんの近道です」とあります。',
    difficultyScore: 3,
  ),
  ComprehensionQuestion(
    questionId: 'reading_effect_q5',
    passageId: 'reading_effect',
    questionType: 'summary',
    questionText: 'この記事で最も伝えたい考えは何ですか？',
    choices: [
      '読書には良い効果がたくさんあり、続けることが大切だ',
      '読書は難しいので子どもには向かない',
      '映像の方が読書より優れている',
      '読書は一度にたくさんした方がよい',
    ],
    correctAnswer: '読書には良い効果がたくさんあり、続けることが大切だ',
    explanation: '複数の効果を紹介したあと、最後に「続けることが近道」とまとめられています。',
    difficultyScore: 5,
  ),
  ComprehensionQuestion(
    questionId: 'reading_effect_q6',
    passageId: 'reading_effect',
    questionType: 'structure',
    questionText: 'この記事の文章構成を表す言葉はどれですか？',
    choices: ['複数の効果を列挙→まとめ', '結論を先に述べる', '時系列順', '対立する2つの意見'],
    correctAnswer: '複数の効果を列挙→まとめ',
    explanation: '「言葉の力」「想像力」「集中力」「共感力」と効果を並べ、最後に習慣化の大切さをまとめています。',
    difficultyScore: 5,
  ),

  // --- 言葉と文化 ---
  ComprehensionQuestion(
    questionId: 'language_culture_q1',
    passageId: 'language_culture',
    questionType: 'detail',
    questionText: '「春一番」「五月晴れ」のような言葉は、何から生まれた言葉ですか？',
    choices: ['外国の文化', '四季のある日本の気候', '学校の授業', 'インターネット'],
    correctAnswer: '四季のある日本の気候',
    explanation: '本文に「四季のある日本の気候から生まれた言葉です」とあります。',
    difficultyScore: 4,
  ),
  ComprehensionQuestion(
    questionId: 'language_culture_q2',
    passageId: 'language_culture',
    questionType: 'vocabulary',
    questionText: '「敬語」とは、どのようなことを表す言葉づかいですか？',
    choices: ['相手への敬意', '季節の変化', '物を大切にする気持ち', '外国とのちがい'],
    correctAnswer: '相手への敬意',
    explanation: '本文に「相手への敬意を表す『敬語』という仕組み」とあります。',
    difficultyScore: 4,
  ),
  ComprehensionQuestion(
    questionId: 'language_culture_q3',
    passageId: 'language_culture',
    questionType: 'detail',
    questionText: '「もったいない」という言葉は、どのような考え方を表していますか？',
    choices: ['物を大切にする考え方', '早く行動する考え方', '敬語を使う考え方', '季節を楽しむ考え方'],
    correctAnswer: '物を大切にする考え方',
    explanation: '本文に「物を大切にする日本人の考え方をよく表している」とあります。',
    difficultyScore: 4,
  ),
  ComprehensionQuestion(
    questionId: 'language_culture_q4',
    passageId: 'language_culture',
    questionType: 'detail',
    questionText: '時代が変わると、言葉についてどのようなことが起こりますか？',
    choices: [
      '新しい言葉が生まれたり、使われなくなる言葉もある',
      'すべての言葉が永遠に変わらない',
      '敬語がなくなる',
      '季節の言葉だけが増える',
    ],
    correctAnswer: '新しい言葉が生まれたり、使われなくなる言葉もある',
    explanation: '本文に「時代が変わると、新しい言葉が生まれたり、使われなくなる言葉もあります」とあります。',
    difficultyScore: 4,
  ),
  ComprehensionQuestion(
    questionId: 'language_culture_q5',
    passageId: 'language_culture',
    questionType: 'summary',
    questionText: 'この記事で最も伝えたい考えは何ですか？',
    choices: [
      '言葉には文化や価値観が映し出されており、言葉を学ぶことは文化を学ぶことでもある',
      '日本語は世界一むずかしい言葉である',
      '敬語は使わない方がよい',
      '季節の言葉は今では使われていない',
    ],
    correctAnswer: '言葉には文化や価値観が映し出されており、言葉を学ぶことは文化を学ぶことでもある',
    explanation: '最後の段落に「言葉を学ぶことは、文化を学ぶことでもあるのです」とまとめられています。',
    difficultyScore: 6,
  ),
  ComprehensionQuestion(
    questionId: 'language_culture_q6',
    passageId: 'language_culture',
    questionType: 'structure',
    questionText: 'この記事の文章構成を表す言葉はどれですか？',
    choices: ['具体例を複数示してから一般化する', '時系列順', '起承転結の物語形式', '結論のみを述べる'],
    correctAnswer: '具体例を複数示してから一般化する',
    explanation: '季節の言葉・敬語・「もったいない」という具体例を挙げてから、最後に一般的な考えをまとめています。',
    difficultyScore: 7,
  ),

  // --- 情報を読み解く ---
  ComprehensionQuestion(
    questionId: 'media_literacy_q1',
    passageId: 'media_literacy',
    questionType: 'vocabulary',
    questionText: '「〇〇するべきだと思う」という文は、事実と意見のどちらですか？',
    choices: ['事実', '意見', 'どちらでもない', '両方'],
    correctAnswer: '意見',
    explanation: '本文に「『〇〇するべきだと思う』というのは、書いた人の意見です」とあります。',
    difficultyScore: 5,
  ),
  ComprehensionQuestion(
    questionId: 'media_literacy_q2',
    passageId: 'media_literacy',
    questionType: 'detail',
    questionText: '情報を確かめるときに大切なこととして述べられていないものはどれですか？',
    choices: ['だれが発信したか確かめる', 'いつの情報か確かめる', '一つの情報だけで決めつけない', 'できるだけ早く広める'],
    correctAnswer: 'できるだけ早く広める',
    explanation: '本文で述べられているのは「出どころを確かめる」「複数の情報を比べる」ことの大切さです。',
    difficultyScore: 5,
  ),
  ComprehensionQuestion(
    questionId: 'media_literacy_q3',
    passageId: 'media_literacy',
    questionType: 'detail',
    questionText: '一つの情報だけで判断することが危険なのはなぜですか？',
    choices: [
      '文章が長くなるから',
      'それがすべて正しいと思い込んでしまうから',
      '読むのに時間がかかるから',
      '情報が古くなるから',
    ],
    correctAnswer: 'それがすべて正しいと思い込んでしまうから',
    explanation: '本文に「それがすべて正しいと思い込むのは危険です」とあります。',
    difficultyScore: 5,
  ),
  ComprehensionQuestion(
    questionId: 'media_literacy_q4',
    passageId: 'media_literacy',
    questionType: 'vocabulary',
    questionText: '情報を正しく読み解く力のことを、何と呼びますか？',
    choices: ['メディアリテラシー', 'コミュニケーション力', '読解速度', '記憶力'],
    correctAnswer: 'メディアリテラシー',
    explanation: '本文に「この力は、『メディアリテラシー』と呼ばれます」とあります。',
    difficultyScore: 5,
  ),
  ComprehensionQuestion(
    questionId: 'media_literacy_q5',
    passageId: 'media_literacy',
    questionType: 'summary',
    questionText: 'この記事で最も伝えたい考えは何ですか？',
    choices: [
      'あふれる情報の中から正しい情報を見分ける力を、日ごろから育てることが大切だ',
      'インターネットの情報はすべて正しい',
      '新聞やテレビの情報だけを信じればよい',
      '情報はできるだけ多く集めればよい',
    ],
    correctAnswer: 'あふれる情報の中から正しい情報を見分ける力を、日ごろから育てることが大切だ',
    explanation: '最後の段落に「日ごろから…考えながら文章を読む習慣によって、少しずつ育っていきます」とあります。',
    difficultyScore: 6,
  ),
  ComprehensionQuestion(
    questionId: 'media_literacy_q6',
    passageId: 'media_literacy',
    questionType: 'structure',
    questionText: 'この記事の文章構成を表す言葉はどれですか？',
    choices: ['問題提起→複数の視点からの説明→まとめ', '時系列順', '起承転結の物語形式', '一つの体験談のみ'],
    correctAnswer: '問題提起→複数の視点からの説明→まとめ',
    explanation: '情報があふれる現状を示したあと、「事実と意見」「出どころ」「複数比較」の3つの視点から説明し、最後にまとめています。',
    difficultyScore: 7,
  ),
];

List<ComprehensionQuestion> comprehensionQuestionsFor(String passageId) =>
    comprehensionQuestions.where((q) => q.passageId == passageId).toList();

// ---------------------------------------------------------------------------
// 要約問題（各記事1セット・4択）
// ---------------------------------------------------------------------------

const List<SummaryQuestionSet> summaryQuestionSets = [
  SummaryQuestionSet(
    setId: 'hiragana_history_summary',
    passageId: 'hiragana_history',
    summaryOptions: [
      'ひらがなは9世紀ごろに誕生し、女性や一般の人々が使い始めた、漢字から生まれた日本語の文字である。',
      'ひらがなは中国の漢字から生まれた複雑な文字で、現代でも学者しか使わない特別な文字である。',
      'ひらがなは20世紀に政府が作った文字で、漢字の代わりとして使われるようになった。',
      'ひらがなは子どもたちのために作られた文字で、大人は使わない簡単な文字である。',
    ],
    correctSummary: 'ひらがなは9世紀ごろに誕生し、女性や一般の人々が使い始めた、漢字から生まれた日本語の文字である。',
    explanation: '正しい要約は「誰が・いつ・何を・どのように」という要素を含みます。ひらがなは①漢字から生まれ、②9世紀ごろ誕生し、③女性や一般の人々が使い始め、④日本語を書く文字として広まりました。',
  ),
  SummaryQuestionSet(
    setId: 'mukashibanashi_summary',
    passageId: 'mukashibanashi',
    summaryOptions: [
      'むかし話は口づたえで伝えられてきた物語で、教訓や登場人物を通して大切なことを学べる。',
      'むかし話は最近本として出版されるようになった、新しい種類の物語である。',
      'むかし話は大人だけが楽しむための難しい物語である。',
      'むかし話には教訓はなく、ただ面白いだけの話である。',
    ],
    correctSummary: 'むかし話は口づたえで伝えられてきた物語で、教訓や登場人物を通して大切なことを学べる。',
    explanation: 'むかし話が「口づたえ」で受け継がれてきたこと、教訓が込められていること、登場人物を通して学べることの3点が要約に含まれている必要があります。',
  ),
  SummaryQuestionSet(
    setId: 'kanji_origin_summary',
    passageId: 'kanji_origin',
    summaryOptions: [
      '漢字は約3000年以上前に中国で生まれ、成り立ちの種類とともに日本に伝わり定着した文字である。',
      '漢字は日本で生まれ、その後中国に伝わった文字である。',
      '漢字は1つの成り立ち方しかない、単純な文字である。',
      '漢字は現代になってから作られた、新しい文字である。',
    ],
    correctSummary: '漢字は約3000年以上前に中国で生まれ、成り立ちの種類とともに日本に伝わり定着した文字である。',
    explanation: '漢字の起源（中国・約3000年前）、成り立ちの種類（象形・指事・会意・形声）、日本への伝来という要素をおさえた要約が正解です。',
  ),
  SummaryQuestionSet(
    setId: 'reading_effect_summary',
    passageId: 'reading_effect',
    summaryOptions: [
      '読書には言葉の力・想像力・集中力・共感力を育てる効果があり、毎日少しずつ続けることが大切だ。',
      '読書は時間のむだなので、映像を見る方がよい。',
      '読書の効果は一度にたくさん読めばすぐに身につく。',
      '読書は集中力を下げてしまうので注意が必要である。',
    ],
    correctSummary: '読書には言葉の力・想像力・集中力・共感力を育てる効果があり、毎日少しずつ続けることが大切だ。',
    explanation: '本文で紹介された4つの効果と、最後の「習慣化」というまとめの両方を含む要約が正解です。',
  ),
  SummaryQuestionSet(
    setId: 'language_culture_summary',
    passageId: 'language_culture',
    summaryOptions: [
      '日本語には季節や敬意、価値観を表す言葉があり、言葉には文化が深く関わっている。',
      '日本語は他の国の言葉と比べて特別なところがない。',
      '敬語は現代では使われなくなった古い習慣である。',
      '言葉と文化には、まったく関係がない。',
    ],
    correctSummary: '日本語には季節や敬意、価値観を表す言葉があり、言葉には文化が深く関わっている。',
    explanation: '季節の言葉・敬語・価値観を表す言葉という3つの具体例と、「言葉と文化の関わり」という主題の両方を含む要約が正解です。',
  ),
  SummaryQuestionSet(
    setId: 'media_literacy_summary',
    passageId: 'media_literacy',
    summaryOptions: [
      '情報があふれる時代には、事実と意見を区別し、出どころを確かめ、複数の情報を比べる力が大切だ。',
      'インターネットの情報はすべて信じてよい。',
      '情報を読み解く力は、一度身につければ二度と失われない。',
      '新聞の情報だけが正しく、他の情報はすべて誤りである。',
    ],
    correctSummary: '情報があふれる時代には、事実と意見を区別し、出どころを確かめ、複数の情報を比べる力が大切だ。',
    explanation: '本文で挙げられた3つのポイント（事実と意見の区別・出どころの確認・複数比較）を含む要約が正解です。',
  ),
];

SummaryQuestionSet? summaryFor(String passageId) {
  for (final s in summaryQuestionSets) {
    if (s.passageId == passageId) return s;
  }
  return null;
}

// ---------------------------------------------------------------------------
// 表現・語彙問題（各記事2問）
// ---------------------------------------------------------------------------

const List<ExpressionQuestion> expressionQuestions = [
  ExpressionQuestion(
    questionId: 'hiragana_history_e1',
    passageId: 'hiragana_history',
    phrase: '女文字',
    meaningOptions: ['女性が好む文字', '女性が主に使っていた文字', '女性が作った文字', '女性にしか読めない文字'],
    correctMeaning: '女性が主に使っていた文字',
    contextExplanation: '当時、学問の世界では漢文（男性が使う文字）が使われ、ひらがなは主に女性や一般の人々が使う文字として「女文字」と呼ばれていました。',
  ),
  ExpressionQuestion(
    questionId: 'hiragana_history_e2',
    passageId: 'hiragana_history',
    phrase: '流れるような形',
    meaningOptions: ['水のように青い', '丸みを帯びた形をしているから', '書くのが速いから', '長い線が多いから'],
    correctMeaning: '丸みを帯びた形をしているから',
    contextExplanation: 'ひらがなの文字は角ばっておらず、丸みを帯びた曲線で構成されているため「流れるような形」と表現されています。',
  ),
  ExpressionQuestion(
    questionId: 'mukashibanashi_e1',
    passageId: 'mukashibanashi',
    phrase: '口づたえ',
    meaningOptions: ['本を読んで伝えること', '口で語って伝えること', '手紙を書いて伝えること', '絵を描いて伝えること'],
    correctMeaning: '口で語って伝えること',
    contextExplanation: '本がまだ広まっていなかった時代、おじいさんやおばあさんが子どもに口で語って物語を伝えていた方法を指します。',
  ),
  ExpressionQuestion(
    questionId: 'mukashibanashi_e2',
    passageId: 'mukashibanashi',
    phrase: '教訓',
    meaningOptions: ['楽しい出来事', '生きるうえで大切な教え', '登場人物の名前', '物語のタイトル'],
    correctMeaning: '生きるうえで大切な教え',
    contextExplanation: 'むかし話には「うそをついてはいけない」など、人が生きていくうえで大切な教えが込められていることを指しています。',
  ),
  ExpressionQuestion(
    questionId: 'kanji_origin_e1',
    passageId: 'kanji_origin',
    phrase: '甲骨文字',
    meaningOptions: ['紙に書かれた文字', '亀の甲羅や動物の骨に刻まれた文字', '石に彫られた文字', '木の板に書かれた文字'],
    correctMeaning: '亀の甲羅や動物の骨に刻まれた文字',
    contextExplanation: '大昔の中国で、うらないの記録として亀の甲羅や動物の骨に刻まれていた文字で、漢字のもとになったと考えられています。',
  ),
  ExpressionQuestion(
    questionId: 'kanji_origin_e2',
    passageId: 'kanji_origin',
    phrase: '形声文字',
    meaningOptions: [
      'ものの形をそのまま絵にした文字',
      '点や線で形のないことを表した文字',
      '意味を表す部分と音を表す部分を組み合わせた文字',
      '2つの漢字を組み合わせて新しい意味にした文字',
    ],
    correctMeaning: '意味を表す部分と音を表す部分を組み合わせた文字',
    contextExplanation: '漢字の多くはこの形声文字で、部首（意味）とつくり（音）を組み合わせて作られています。',
  ),
  ExpressionQuestion(
    questionId: 'reading_effect_e1',
    passageId: 'reading_effect',
    phrase: '想像力',
    meaningOptions: ['計算する力', '頭の中で場面を思いうかべる力', '速く読む力', '正確に暗記する力'],
    correctMeaning: '頭の中で場面を思いうかべる力',
    contextExplanation: '物語を読むときに場面や登場人物の様子を頭の中で思いうかべる作業をくり返すことで育つ力です。',
  ),
  ExpressionQuestion(
    questionId: 'reading_effect_e2',
    passageId: 'reading_effect',
    phrase: '共感力',
    meaningOptions: ['他の人の気持ちを思いやる力', '早く読む力', '文字を覚える力', '大きな声で話す力'],
    correctMeaning: '他の人の気持ちを思いやる力',
    contextExplanation: '登場人物の気持ちを想像しながら読むことで育つ、友だちとの関係づくりにも大切な力です。',
  ),
  ExpressionQuestion(
    questionId: 'language_culture_e1',
    passageId: 'language_culture',
    phrase: '季語',
    meaningOptions: ['敬語の一種', '俳句などで使われる季節を表す言葉', '外国から来た言葉', '古い言葉づかい'],
    correctMeaning: '俳句などで使われる季節を表す言葉',
    contextExplanation: '「春一番」のような季節の移り変わりを表す言葉のうち、俳句で使われるものを季語と呼びます。',
  ),
  ExpressionQuestion(
    questionId: 'language_culture_e2',
    passageId: 'language_culture',
    phrase: 'もったいない',
    meaningOptions: ['物を大切にする気持ちを表す言葉', '敬意を表す言葉', '季節を表す言葉', '外国の言葉'],
    correctMeaning: '物を大切にする気持ちを表す言葉',
    contextExplanation: '物を大切にする日本人の考え方をよく表す言葉として、海外でも注目されています。',
  ),
  ExpressionQuestion(
    questionId: 'media_literacy_e1',
    passageId: 'media_literacy',
    phrase: 'メディアリテラシー',
    meaningOptions: ['情報を早く伝える力', '情報を正しく読み解く力', '情報をたくさん集める力', '情報を作る力'],
    correctMeaning: '情報を正しく読み解く力',
    contextExplanation: 'あふれる情報の中から正しいものを見分け、事実と意見を区別する力のことです。',
  ),
  ExpressionQuestion(
    questionId: 'media_literacy_e2',
    passageId: 'media_literacy',
    phrase: '出どころ',
    meaningOptions: ['情報を発信した人や場所', '情報の長さ', '情報が書かれた文字数', '情報を読む速さ'],
    correctMeaning: '情報を発信した人や場所',
    contextExplanation: '「だれが」「いつ」発信したかという情報の発信元のことを指し、これを確かめることが正しい情報の判断に役立ちます。',
  ),
];

List<ExpressionQuestion> expressionQuestionsFor(String passageId) =>
    expressionQuestions.where((q) => q.passageId == passageId).toList();

// ---------------------------------------------------------------------------
// 文章構造分析（各記事1件）
// ---------------------------------------------------------------------------

const List<TextStructureAnalysis> textStructureAnalyses = [
  TextStructureAnalysis(
    analysisId: 'hiragana_history_structure',
    passageId: 'hiragana_history',
    paragraphs: [
      '導入：ひらがなは漢字から生まれた独自の文字であることを示す',
      '背景：文字がなかった時代に漢字が伝わってきた経緯を説明する',
      '誕生：9世紀ごろ、女性や一般の人々が使い始めたことを説明する',
      '特徴：書きやすさ・発音・形という3つの特徴を説明する',
      '活躍：物語・手紙・教育など使われる場面が広がったことを説明する',
      'まとめ：現代におけるひらがなの役割を述べる',
    ],
    mainPoints: ['文字がなかった日本に漢字が伝わる', 'ひらがなが9世紀ごろに誕生', '書きやすく発音がはっきりした特徴', '使われる場面が広がる', '現代でも大切な役割を持つ'],
    climax: 'ひらがなが「女文字」と呼ばれながらも誕生し、独自の特徴を持つ文字として確立した部分',
    resolution: '現代において、ひらがなが日本語を書くうえで欠かせない文字になったというまとめ',
    characterDescriptions: {},
  ),
  TextStructureAnalysis(
    analysisId: 'mukashibanashi_structure',
    passageId: 'mukashibanashi',
    paragraphs: [
      '導入：むかし話の例を挙げて話題を示す',
      '伝わり方：口づたえで受け継がれてきたことを説明する',
      '教訓：むかし話に込められた教えを説明する',
      '登場人物：勇気ある主人公や敵役を通して学べることを説明する',
      'まとめ：現代でも親しまれ、心に届いていることを述べる',
    ],
    mainPoints: ['むかし話とは何か', '口づたえで伝わってきた', '教訓が込められている', '登場人物から学べる', '今も心に届いている'],
    climax: '登場人物の行動を通して「正しいこと」と「悪いこと」を自然に学べるという部分',
    resolution: '時代が変わっても、むかし話の教訓や面白さが今の私たちに届いているというまとめ',
    characterDescriptions: {
      'ゆうかんな主人公': '桃太郎のように、困難に立ち向かう勇気を持つキャラクター',
      'いじわるな敵役': '鬼のように、主人公と対立する存在',
    },
  ),
  TextStructureAnalysis(
    analysisId: 'kanji_origin_structure',
    passageId: 'kanji_origin',
    paragraphs: [
      '導入：漢字が中国で生まれ日本に伝わったことを示す',
      '起源：甲骨文字が漢字のもとになったことを説明する',
      '分類①〜④：象形・指事・会意・形声という4つの成り立ちを説明する',
      'まとめ：日本に伝わり、ひらがな・カタカナのもとにもなったことを述べる',
    ],
    mainPoints: ['漢字は約3000年以上前に中国で誕生', '甲骨文字がもとになった', '4種類の成り立ち方がある', '日本に伝わり定着した'],
    climax: '漢字には象形・指事・会意・形声という4つの異なる成り立ち方があるという分類の説明部分',
    resolution: '漢字が日本語になくてはならない文字になったというまとめ',
    characterDescriptions: {},
  ),
  TextStructureAnalysis(
    analysisId: 'reading_effect_structure',
    passageId: 'reading_effect',
    paragraphs: [
      '導入：読書には良い効果があることを示す',
      '効果①：言葉の力が育つことを説明する',
      '効果②：想像力が豊かになることを説明する',
      '効果③：集中する力が身につくことを説明する',
      '効果④：人の気持ちを理解する力が育つことを説明する',
      'まとめ：毎日少しずつ続けることの大切さを述べる',
    ],
    mainPoints: ['読書には複数の良い効果がある', '言葉・想像力・集中力・共感力が育つ', '効果は続けることで身につく'],
    climax: '読書がもたらす4つの効果（言葉の力・想像力・集中力・共感力）がすべて説明される部分',
    resolution: '効果を身につけるには毎日少しずつ続けることが一番の近道だというまとめ',
    characterDescriptions: {},
  ),
  TextStructureAnalysis(
    analysisId: 'language_culture_structure',
    passageId: 'language_culture',
    paragraphs: [
      '導入：言葉には文化が深く関わっていることを示す',
      '具体例①：季節を表す言葉を紹介する',
      '具体例②：敬語という文化を紹介する',
      '具体例③：「もったいない」という言葉から見える価値観を紹介する',
      'まとめ：言葉を学ぶことは文化を学ぶことでもあると述べる',
    ],
    mainPoints: ['言葉には文化が関わっている', '季節・敬語・価値観の3つの具体例', '言葉は文化とともに変わっていく'],
    climax: '「もったいない」という一つの言葉から、日本人の価値観が見えてくるという部分',
    resolution: '言葉を学ぶことは文化を学ぶことでもある、という結論',
    characterDescriptions: {},
  ),
  TextStructureAnalysis(
    analysisId: 'media_literacy_structure',
    passageId: 'media_literacy',
    paragraphs: [
      '導入：情報があふれる時代であることを示す',
      '視点①：事実と意見を区別することの大切さを説明する',
      '視点②：情報の出どころを確かめることの大切さを説明する',
      '視点③：一つの情報だけで決めつけないことの大切さを説明する',
      'まとめ：メディアリテラシーは日ごろの習慣で育つと述べる',
    ],
    mainPoints: ['情報があふれる時代である', '事実と意見の区別', '出どころの確認', '複数の情報を比較する', '日ごろの習慣で育つ力'],
    climax: '事実と意見を混同すると正しく情報を理解できない、という警告の部分',
    resolution: 'メディアリテラシーは、日ごろから疑問を持って読む習慣によって少しずつ育つというまとめ',
    characterDescriptions: {},
  ),
];

TextStructureAnalysis? structureFor(String passageId) {
  for (final s in textStructureAnalyses) {
    if (s.passageId == passageId) return s;
  }
  return null;
}
