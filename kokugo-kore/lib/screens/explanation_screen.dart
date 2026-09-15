import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ExplanationScreen extends StatelessWidget {
  final String title;
  final String emoji;
  final String content;

  const ExplanationScreen({
    super.key,
    required this.title,
    required this.emoji,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$emoji $title'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kPrimaryColor.withAlpha(20),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kPrimaryColor.withAlpha(80)),
              ),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: kTextDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final explanations = {
  'ひらがな': ExplanationItem(
    emoji: 'あ',
    title: 'ひらがな',
    content: '''ひらがなは、日本語の音を表す文字です。

【学習のポイント】
• 全部で46字あります
• 「あいうえお」から始まります
• ひらがなは「や行」や「わ行」などの行ごとに覚えます
• 小学1年生で全部習います

【使い方】
ひらがなは日本語のほぼすべての単語を書くことができます。
例：「わたし」「ねこ」「あさ」

【練習のコツ】
毎日書く練習をすると、すぐに覚えられます。
正しい書き順を意識することが大切です。''',
  ),
  'カタカナ': ExplanationItem(
    emoji: 'ア',
    title: 'カタカナ',
    content: '''カタカナは、主に外国の言葉を日本語で書く時に使う文字です。

【学習のポイント】
• 全部で46字あります
• ひらがなと同じ数と順序です
• 外国の言葉（外来語）を書きます
• 小学1年生で習い始めます

【使い方の例】
• 「コンピューター」（computer）
• 「テレビ」（television）
• 「アメリカ」（America）
• 「パン」（bread）

【ひらがなとの違い】
• ひらがな：日本語の言葉、文字の流れが曲線的
• カタカナ：外国の言葉、文字の線が直線的''',
  ),
  'かんじ': ExplanationItem(
    emoji: '漢',
    title: '漢字',
    content: '''漢字は、中国から伝わった文字で、意味を持つ文字です。

【学習のポイント】
• 小学6年間で1026字を学びます
• 漢字には「音読み」（おんよみ）と「訓読み」（くんよみ）があります
• 1学年で約160字ずつ習います

【学年別に習う漢字】
• 1年生：80字
• 2年生：160字
• 3年生：200字
• 4年生：200字
• 5年生：193字
• 6年生：193字

【上手に覚えるコツ】
• 意味を理解しながら覚える
• 何度も書いて練習する
• 熟語として一緒に覚える
• 部首（ぶしゅ）に注目する''',
  ),
  'ことわざ': ExplanationItem(
    emoji: '🏮',
    title: 'ことわざ',
    content: '''ことわざは、昔からずっと言い伝えられてきた、知恵や教えが詰まった短い言葉です。

【特ちょう】
• 動物や自然が出てくることが多い
• 教えや戒めが込められている
• 大人も子どもも使う
• とても古い言葉が多い

【よく使われることわざの例】
• 「犬も歩けば棒に当たる」→いろいろ経験していると思わぬことが起きる
• 「蛙の子は蛙」→親が○○なら、子も似た性質を持つ
• 「転ばぬ先の杖」→危険が起きる前に対策する
• 「一寸先は闇」→先のことは誰にもわからない

【学習のポイント】
ことわざの意味を理解して、いつ使うかを考えながら覚えることが大切です。''',
  ),
  '慣用句': ExplanationItem(
    emoji: '💬',
    title: '慣用句',
    content: '''慣用句は、複数の単語が一緒に使われて、全体で別の意味になる言葉です。

【特ちょう】
• 2語以上の言葉の組み合わせ
• 本来の意味とは違う意味になる
• よく会話や文章で使われる
• 日本語ならではの表現が多い

【よく使われる慣用句の例】
• 「顔を立てる」→相手の気持ちや立場を尊重する
• 「手を組む」→協力する、一緒に何かをする
• 「耳に入る」→聞こえてくる、知る
• 「目を通す」→見る、読む
• 「足を洗う」→やめる、辞める

【学習のポイント】
文字通りの意味ではなく、慣用句全体の意味を覚えることが大切です。
実際の文章でどう使われているか見て学ぶのが効果的です。''',
  ),
  '四字熟語': ExplanationItem(
    emoji: '㈠',
    title: '四字熟語',
    content: '''四字熟語は、4つの漢字から成る成語で、意味のある表現です。

【特ちょう】
• 4つの漢字で構成されている
• 1つの漢字が1つの意味を持つ
• 中国の古い文献が出典のことが多い
• 大事な教えや戒めが込められている

【学習に役立つ四字熟語の例】
• 「一生懸命」（いっしょうけんめい）→全力を尽くす
• 「七転八起」（しちてんはっき）→何度失敗しても立ち上がる
• 「初心忘るべからず」（しょしんわするべからず）→最初の気持ちを忘れずに
• 「百聞は一見に如かず」（ひゃくぶんはいっけんにしかず）→聞くより見るほうが確か

【学習のポイント】
4つの漢字それぞれの意味と、全体の意味を一緒に学ぶのが効果的です。''',
  ),
  '同音異義語': ExplanationItem(
    emoji: '🔀',
    title: '同音異義語',
    content: '''同音異義語は、読み方は同じだけど、意味と書き方が違う言葉です。

【特ちょう】
• 音（読み方）は同じ
• 意味が全く違う
• 漢字で書くと区別できる
• 日本語ならではの特徴

【よくある同音異義語の例】
• 「橋」（はし）→川などを渡る建造物
• 「橋」（はし）→食べ物の端
• 「箸」（はし）→食べ物をつかむ道具

• 「生」（い）→生まれる、活きている
• 「生」（い）→生の魚（ナマモノ）

• 「季節」（きせつ）→春・夏・秋・冬
• 「記説」（きせつ）→説や主張（使わない場合もある）

【学習のポイント】
同音異義語は文脈で意味が変わることがあるので、
文章の中で使い分けることが大切です。''',
  ),
  '類義語・反対語': ExplanationItem(
    emoji: '⇄',
    title: '類義語・反対語',
    content: '''類義語と反対語は、言葉と言葉の意味の関係を表します。

【類義語（るいぎご）】
似ている意味の言葉です。

• 「美しい」と「綺麗」
• 「嬉しい」と「楽しい」
• 「走る」と「急ぐ」
• 「友達」と「仲間」

【反対語（はんたいご）】
反対の意味の言葉です。

• 「大きい」と「小さい」
• 「上」と「下」
• 「好き」と「嫌い」
• 「始まる」と「終わる」

【学習のポイント】
• 類義語は微妙に意味が違うことに注目する
• 反対語は絶対的な反対と相対的な反対がある
• 同じ言葉でも、使う場面で類義語・反対語が変わることもある
• 文脈から言葉の意味を読み取る力をつけることが大切''',
  ),
  '文法': ExplanationItem(
    emoji: '📖',
    title: '文法',
    content: '''文法は、日本語を正しく使うためのルール・きまりです。

【主な文法の学習項目】
• 品詞（ひんし）：言葉の種類
  - 名詞：人・物・事柄の名前
  - 動詞：動き・作用を表す言葉
  - 形容詞：様子や状態を表す言葉
  - 副詞：動きや状態をくわしく説明する言葉

• 文の成分：
  - 主語：「だれが」「何が」
  - 述語：「どうする」「どんなだ」
  - 修飾語：主語や述語をくわしく説明する言葉

• 敬語（けいご）：
  - 丁寧語：相手に敬意を表す（～です、～ます）
  - 尊敬語：相手や他人を高く扱う言葉
  - 謙譲語：自分や身内を低く扱う言葉

【学習のコツ】
• 実際の文章を読みながら文法を学ぶ
• 短い文から始めて、長い文へと進む
• 何度も声に出して読む
• 自分で文を作る練習をする''',
  ),
};

class ExplanationItem {
  final String emoji;
  final String title;
  final String content;

  ExplanationItem({
    required this.emoji,
    required this.title,
    required this.content,
  });
}
