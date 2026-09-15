import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/premium_provider.dart';

import '../services/ad_service.dart';
import '../theme/app_theme.dart';

class ProverbQuestion {
  final String proverb;
  final String reading;
  final String question;
  final List<String> choices;
  final int correctIndex;
  final String explanation;

  const ProverbQuestion({
    required this.proverb,
    required this.reading,
    required this.question,
    required this.choices,
    required this.correctIndex,
    required this.explanation,
  });
}

const _proverbQuestions = [
  ProverbQuestion(
    proverb: '七転び八起き',
    reading: 'ななころびやおき',
    question: 'このことわざの意味は？',
    choices: ['何度転んでも起き上がる', 'ゆっくり歩くこと', '7回だけ失敗すること', '転ばないようにすること'],
    correctIndex: 0,
    explanation: 'なんど失敗してもあきらめず、立ち上がり続けることです。',
  ),
  ProverbQuestion(
    proverb: '急がば回れ',
    reading: 'いそがばまわれ',
    question: 'このことわざの意味は？',
    choices: ['急ぐときは走る', '近道をさがす', '急ぐときほど確かな方法を選ぶ', 'まわり道はよくない'],
    correctIndex: 2,
    explanation: '焦って危ない近道より、確かな方法で進みましょう。',
  ),
  ProverbQuestion(
    proverb: '花より団子',
    reading: 'はなよりだんご',
    question: 'このことわざの意味は？',
    choices: ['花もだんごも好き', '見た目より実際の利益を大切にする', '花を食べる', 'だんごが一番おいしい'],
    correctIndex: 1,
    explanation: '美しい花を見るよりも、食べられる団子の方がいいということです。',
  ),
  ProverbQuestion(
    proverb: '石の上にも三年',
    reading: 'いしのうえにもさんねん',
    question: 'このことわざの意味は？',
    choices: ['石は3年で割れる', '冷たい石でも3年すわれば暖かくなる', '辛抱強く続けると成果が出る', '3年間何もしない'],
    correctIndex: 2,
    explanation: '最初は辛くても、がまんして続ければ必ずうまくいくということです。',
  ),
  ProverbQuestion(
    proverb: '猿も木から落ちる',
    reading: 'さるもきからおちる',
    question: 'このことわざの意味は？',
    choices: ['さるは木登りが下手', 'どんな名人でも失敗することがある', '木から落ちると危ない', 'さるは猫より上手'],
    correctIndex: 1,
    explanation: 'どんなに上手な人でも時には失敗することがあるということです。',
  ),
  ProverbQuestion(
    proverb: '塵も積もれば山となる',
    reading: 'ちりもつもればやまとなる',
    question: 'このことわざの意味は？',
    choices: ['ゴミは山に捨てる', '小さなことでも積み重なれば大きくなる', '山はゴミでできている', '少しでも捨ててはいけない'],
    correctIndex: 1,
    explanation: '小さなことでも、積み重ねていけば大きな成果になるということです。',
  ),
  ProverbQuestion(
    proverb: '笑う門には福来たる',
    reading: 'わらうかどにはふくきたる',
    question: 'このことわざの意味は？',
    choices: ['笑うことは体に悪い', '笑いの絶えない家には幸せがやってくる', '門を笑ってはいけない', '福は鬼が運ぶ'],
    correctIndex: 1,
    explanation: '明るく笑いが絶えない家庭には、自然と幸運がやってくるということです。',
  ),
  ProverbQuestion(
    proverb: '早起きは三文の徳',
    reading: 'はやおきはさんもんのとく',
    question: 'このことわざの意味は？',
    choices: ['朝は寝ていた方がいい', '朝早く起きると良いことがある', '朝早く起きると三円もらえる', '早起きは体に悪い'],
    correctIndex: 1,
    explanation: '朝早く起きる習慣は、心身ともに良い影響があるということです。',
  ),
  ProverbQuestion(
    proverb: '二度あることは三度ある',
    reading: 'にどあることはさんどある',
    question: 'このことわざの意味は？',
    choices: ['2回しか失敗しない', '同じことが繰り返されやすい', '3回が一番多い', '2度目はない'],
    correctIndex: 1,
    explanation: '一度起きたことは、また同じことが起こりやすいという意味です。',
  ),
  ProverbQuestion(
    proverb: '河童の川流れ',
    reading: 'かっぱのかわながれ',
    question: 'このことわざの意味は？',
    choices: ['河童は川が好き', 'その道の名人でも失敗することがある', '川を流れると気持ちいい', '河童は泳ぎが下手'],
    correctIndex: 1,
    explanation: 'どんなに得意なことでも、時には失敗することがあるということです。',
  ),
  ProverbQuestion(
    proverb: '三人寄れば文殊の知恵',
    reading: 'さんにんよればもんじゅのちえ',
    question: 'このことわざの意味は？',
    choices: ['三人は多すぎる', 'みんなで考えると良い知恵が出る', '文殊は賢い神様', '三人以上は集まれない'],
    correctIndex: 1,
    explanation: 'たとえ平凡な人でも、三人集まって知恵を出し合えば良い考えが生まれるということです。',
  ),
  ProverbQuestion(
    proverb: '井の中の蛙大海を知らず',
    reading: 'いのなかのかわずたいかいをしらず',
    question: 'このことわざの意味は？',
    choices: ['カエルは海が嫌い', '自分の狭い世界だけで満足している人のこと', '井戸に海水を入れてはいけない', 'カエルは目が悪い'],
    correctIndex: 1,
    explanation: '狭い世界しか知らず、広い世界のことを知らない人のことをいいます。',
  ),
  ProverbQuestion(
    proverb: '好きこそものの上手なれ',
    reading: 'すきこそもののじょうずなれ',
    question: 'このことわざの意味は？',
    choices: ['好きなことは教えてもらわなくても上手になる', '上手な人はみんな好きなことをしている', '好きなことはすぐ上手くなる', '好きでなければ上手になれない'],
    correctIndex: 0,
    explanation: '好きなことは自然と熱中するので、自然に上達するということです。',
  ),
  ProverbQuestion(
    proverb: '案ずるより産むが易し',
    reading: 'あんずるよりうむがやすし',
    question: 'このことわざの意味は？',
    choices: ['子どもを産むことは簡単', '心配するよりも実際にやってみた方が楽なことが多い', '考えることが一番大切', '産むことが一番難しい'],
    correctIndex: 1,
    explanation: 'あれこれ心配するより、実際にやってみると案外簡単なことが多いということです。',
  ),
  ProverbQuestion(
    proverb: '備えあれば憂いなし',
    reading: 'そなえあればうれいなし',
    question: 'このことわざの意味は？',
    choices: ['準備は必要ない', 'しっかり準備しておけば、いざという時に安心できる', '心配することが準備になる', '憂いがなければ備えなくていい'],
    correctIndex: 1,
    explanation: '日頃からきちんと準備しておけば、困ったときも安心できるということです。',
  ),
  // 追加ことわざ
  ProverbQuestion(
    proverb: '口は災いのもと',
    reading: 'くちはわざわいのもと',
    question: 'このことわざの意味は？',
    choices: ['口は大切にしよう', '不用意な発言が災難を招くことがある', '口が大きいと食べすぎる', '言葉は美しい'],
    correctIndex: 1,
    explanation: '不注意な言葉が、思わぬ災いを引き起こすことがあるという意味です。',
  ),
  ProverbQuestion(
    proverb: '時は金なり',
    reading: 'ときはかねなり',
    question: 'このことわざの意味は？',
    choices: ['時計はお金で買える', '時間はお金と同じくらい大切なもの', '金はいつでも手に入る', '時間は無駄にしていい'],
    correctIndex: 1,
    explanation: '時間はお金のように貴重なものなので、無駄にしてはいけないという意味です。',
  ),
  ProverbQuestion(
    proverb: '百聞は一見にしかず',
    reading: 'ひゃくぶんはいっけんにしかず',
    question: 'このことわざの意味は？',
    choices: ['百回聞けばわかる', '実際に自分の目で見ることが一番確かだ', '聞くことより見ることが大切', '一度だけ見れば十分'],
    correctIndex: 1,
    explanation: '何百回聞くよりも、一度自分の目で見る方がよくわかるということです。',
  ),
  ProverbQuestion(
    proverb: '類は友を呼ぶ',
    reading: 'るいはともをよぶ',
    question: 'このことわざの意味は？',
    choices: ['友達はたくさん呼ぼう', '似た者同士は自然と集まる', '友達を呼ぶには似た趣味が必要', '違う人と友達になれない'],
    correctIndex: 1,
    explanation: '性格や考えが似た者同士は、自然と集まってくるということです。',
  ),
  ProverbQuestion(
    proverb: '棚からぼた餅',
    reading: 'たなからぼたもち',
    question: 'このことわざの意味は？',
    choices: ['棚からものが落ちてくる', '思いがけない幸運が来ること', '棚はしっかり作ろう', 'ぼた餅は棚に置いておく'],
    correctIndex: 1,
    explanation: '何もしなくても思いがけない幸運や良いことが起こることです。',
  ),
  ProverbQuestion(
    proverb: '立つ鳥跡を濁さず',
    reading: 'たつとりあとをにごさず',
    question: 'このことわざの意味は？',
    choices: ['鳥は飛ぶのが好き', '立ち去るときは後をきれいにしていくべき', '水を濁してはいけない', '鳥は跡を残さない'],
    correctIndex: 1,
    explanation: '去り際は、その場をきちんと整えてから去るべきという意味です。',
  ),
  ProverbQuestion(
    proverb: '終わりよければすべてよし',
    reading: 'おわりよければすべてよし',
    question: 'このことわざの意味は？',
    choices: ['最後まであきらめない', '最後がうまくいけば途中の失敗も気にしなくていい', 'すべてを完璧にしよう', '終わりが悪ければやり直し'],
    correctIndex: 1,
    explanation: '途中に問題があっても、最終的に良い結果になれば良いということです。',
  ),
  ProverbQuestion(
    proverb: '遠くの親戚より近くの他人',
    reading: 'とおくのしんせきよりちかくのたにん',
    question: 'このことわざの意味は？',
    choices: ['親戚より他人の方が大切', '遠くにいる親戚は役に立たない', '緊急のときは近くにいる他人の方が助けになる', '他人と仲良くしよう'],
    correctIndex: 2,
    explanation: '緊急のときは遠くの親戚より、近くにいる人の方が頼りになるということです。',
  ),
  ProverbQuestion(
    proverb: '泣きっ面に蜂',
    reading: 'なきっつらにはち',
    question: 'このことわざの意味は？',
    choices: ['泣いていると蜂が来る', '悪いことが重なってさらにつらくなること', '蜂は泣いている人が好き', '泣いていると危ない'],
    correctIndex: 1,
    explanation: 'つらいことがあった上に、さらに悪いことが重なることを表します。',
  ),
  ProverbQuestion(
    proverb: '勝って兜の緒を締めよ',
    reading: 'かってかぶとのおをしめよ',
    question: 'このことわざの意味は？',
    choices: ['勝ったら休もう', '勝っても油断せず、さらに気を引き締めよ', '兜はしっかり締めよう', '戦いは慎重に'],
    correctIndex: 1,
    explanation: '成功したときほど、油断せずに気を引き締めることが大切だという意味です。',
  ),
  ProverbQuestion(
    proverb: '郷に入っては郷に従え',
    reading: 'ごうにいってはごうにしたがえ',
    question: 'このことわざの意味は？',
    choices: ['どこへ行っても自分流でいい', 'その土地やグループのやり方に合わせることが大切', '田舎の方が好き', '故郷を大切にしよう'],
    correctIndex: 1,
    explanation: '新しい場所に行ったら、その場所の習慣やルールに従うことが大切という意味です。',
  ),
  ProverbQuestion(
    proverb: '思い立ったが吉日',
    reading: 'おもいたったがきちじつ',
    question: 'このことわざの意味は？',
    choices: ['吉日を選んで始めよう', 'やろうと思ったら今すぐ始めるのが良い', '考えてから行動しよう', '縁起の良い日に始めよう'],
    correctIndex: 1,
    explanation: '何かをしようと思ったら、今日が一番良い日だということです。すぐに始めましょう。',
  ),
  ProverbQuestion(
    proverb: '転ばぬ先の杖',
    reading: 'ころばぬさきのつえ',
    question: 'このことわざの意味は？',
    choices: ['転んでも杖があれば大丈夫', '失敗する前から準備や用心をしておくこと', '杖は大切な道具', '転んでも立ち上がれる'],
    correctIndex: 1,
    explanation: '事故や失敗が起きないよう、前もってしっかり準備をしておくことの大切さを表します。',
  ),
  ProverbQuestion(
    proverb: '鬼に金棒',
    reading: 'おににかなぼう',
    question: 'このことわざの意味は？',
    choices: ['鬼は怖い', '強い人がさらに強い力を持つこと', '金棒は重い', '鬼退治に使う'],
    correctIndex: 1,
    explanation: 'もとから強い人や優れた人が、さらに力を持つことを表します。',
  ),
  ProverbQuestion(
    proverb: '蛙の子は蛙',
    reading: 'かえるのこはかえる',
    question: 'このことわざの意味は？',
    choices: ['カエルは水が好き', '子どもは親に似るもの', 'カエルの子はオタマジャクシ', '親子は仲良し'],
    correctIndex: 1,
    explanation: '子どもの能力や性格は、親に似るということを表します。',
  ),
  ProverbQuestion(
    proverb: '千里の道も一歩から',
    reading: 'せんりのみちもいっぽから',
    question: 'このことわざの意味は？',
    choices: ['遠い道のりは歩かない', 'どんな大きな目標も、小さな一歩から始まる', '千里は遠すぎる', '一歩は小さい'],
    correctIndex: 1,
    explanation: 'どんなに遠い道のりも最初の一歩から始まるように、大きな目標も小さな努力の積み重ねが大切です。',
  ),
  ProverbQuestion(
    proverb: '捨てる神あれば拾う神あり',
    reading: 'すてるかみあればひろうかみあり',
    question: 'このことわざの意味は？',
    choices: ['神様はいろんなことをする', '見捨てる人がいれば、助けてくれる人も必ずいる', '神様を大切に', 'ものを捨てるときは丁寧に'],
    correctIndex: 1,
    explanation: '一つの縁が切れても、必ず助けてくれる別の縁があるということです。',
  ),
  ProverbQuestion(
    proverb: '身から出たさび',
    reading: 'みからでたさび',
    question: 'このことわざの意味は？',
    choices: ['体が錆びてしまう', '自分の行いの結果は自分で受けるもの', '鉄は錆びやすい', '体は大切に'],
    correctIndex: 1,
    explanation: '自分の悪い行いが原因で苦しむことを表します。自業自得ということです。',
  ),
  ProverbQuestion(
    proverb: '蒔かぬ種は生えぬ',
    reading: 'まかぬたねははえぬ',
    question: 'このことわざの意味は？',
    choices: ['種は土にまこう', '努力しなければ良い結果は得られない', '植物は種から育つ', '種は大切に保管しよう'],
    correctIndex: 1,
    explanation: '何もしなければ、望む結果は得られないという意味です。努力することが大切です。',
  ),
  ProverbQuestion(
    proverb: '頭隠して尻隠さず',
    reading: 'あたまかくしてしりかくさず',
    question: 'このことわざの意味は？',
    choices: ['頭だけ隠せばいい', '一部を隠しても、全体は見えてしまっている', '隠れるのが下手', '尻を隠すことが大切'],
    correctIndex: 1,
    explanation: '悪いことを隠しているつもりでも、実は丸わかりになっているという意味です。',
  ),
  ProverbQuestion(
    proverb: '人のふり見て我がふり直せ',
    reading: 'ひとのふりみてわがふりなおせ',
    question: 'このことわざの意味は？',
    choices: ['他人を見習おう', '他人の行動を見て、自分の行動を見直すきっかけにしよう', '良い人を見習う', '他人の真似をしよう'],
    correctIndex: 1,
    explanation: '他人の良い点・悪い点を見て、自分自身の言動を振り返り改善しようという意味です。',
  ),
  ProverbQuestion(
    proverb: '習うより慣れよ',
    reading: 'ならうよりなれよ',
    question: 'このことわざの意味は？',
    choices: ['習うことが大切', '教わるよりも、実際にやってみて身につける方が効果的', 'ならうことはやめよう', '慣れるには時間がかかる'],
    correctIndex: 1,
    explanation: '習うことも大切ですが、実際に体験して慣れていく方が身につくという意味です。',
  ),
  ProverbQuestion(
    proverb: '桃栗三年柿八年',
    reading: 'ももくりさんねんかきはちねん',
    question: 'このことわざの意味は？',
    choices: ['果物は時間がかかる', '何事も成果が出るまでには時間がかかるもの', '桃と栗は3年でなる', '柿は食べるのに8年かかる'],
    correctIndex: 1,
    explanation: '何事も結果が出るまでには相応の時間がかかるということを表します。',
  ),
  ProverbQuestion(
    proverb: '朱に交われば赤くなる',
    reading: 'しゅにまじわればあかくなる',
    question: 'このことわざの意味は？',
    choices: ['赤い色は染まりやすい', '付き合う人によって良くも悪くも影響を受けるもの', '朱色は美しい', '赤い服を着よう'],
    correctIndex: 1,
    explanation: '人は付き合う人物の影響を受け、良くも悪くも変わっていくという意味です。',
  ),
  ProverbQuestion(
    proverb: '三つ子の魂百まで',
    reading: 'みつごのたましいひゃくまで',
    question: 'このことわざの意味は？',
    choices: ['三つ子は長生きする', '幼いころに身についた性格は一生変わらない', '子どものころが一番大切', '百歳まで元気でいよう'],
    correctIndex: 1,
    explanation: '幼いころに形成された性格や習慣は、大人になっても変わらないということです。',
  ),
  ProverbQuestion(
    proverb: '木を見て森を見ず',
    reading: 'きをみてもりをみず',
    question: 'このことわざの意味は？',
    choices: ['木を大切にしよう', '細かいことに気をとられて、全体が見えなくなること', '森には木がたくさんある', '木よりも森が大切'],
    correctIndex: 1,
    explanation: '細かいことに集中するあまり、全体を見渡せなくなることを表します。',
  ),
  ProverbQuestion(
    proverb: '一寸先は闇',
    reading: 'いっすんさきはやみ',
    question: 'このことわざの意味は？',
    choices: ['暗い場所は危ない', '未来のことはどうなるかわからない', '夜は明るくしよう', '先を読むのは難しい'],
    correctIndex: 1,
    explanation: 'ほんの少し先でも何が起こるかわからない、未来は不確かなものだという意味です。',
  ),
  ProverbQuestion(
    proverb: '魚心あれば水心',
    reading: 'うおごころあればみずごころ',
    question: 'このことわざの意味は？',
    choices: ['魚は水が好き', '相手が好意を示せば、こちらも好意で応じる', '水の中には魚がいる', '魚と水は仲良し'],
    correctIndex: 1,
    explanation: '相手が思いやりを見せてくれれば、こちらも同じように応じるということです。',
  ),
  ProverbQuestion(
    proverb: '渡る世間に鬼はなし',
    reading: 'わたるせけんにおにはなし',
    question: 'このことわざの意味は？',
    choices: ['鬼は世間にいない', '世の中には思いやりのある人がたくさんいる', '世間は怖い場所ではない', '鬼退治は必要ない'],
    correctIndex: 1,
    explanation: '世の中は冷たい人ばかりではなく、親切にしてくれる人も多いということです。',
  ),
  ProverbQuestion(
    proverb: '花も実もある',
    reading: 'はなもみもある',
    question: 'このことわざの意味は？',
    choices: ['花と実は両方大切', '見た目も内容も充実していること', '花には実がなる', '実のある話をしよう'],
    correctIndex: 1,
    explanation: '見た目が美しいだけでなく、内容も充実していることを表します。',
  ),
  ProverbQuestion(
    proverb: '鬼のいぬ間に洗濯',
    reading: 'おにのいぬまにせんたく',
    question: 'このことわざの意味は？',
    choices: ['鬼が来たら洗濯しよう', '怖い人がいない間にのびのびする', '鬼がいないと安心', '洗濯は一人でしよう'],
    correctIndex: 1,
    explanation: '厳しい人や怖い人がいない間に、自由にのびのびするということを表します。',
  ),
  ProverbQuestion(
    proverb: '空き樽は音が高い',
    reading: 'あきたるはおとがたかい',
    question: 'このことわざの意味は？',
    choices: ['空の樽は軽い', '実力のない人ほど口だけが達者', '空の樽は丈夫', '音が高いものは値段が高い'],
    correctIndex: 1,
    explanation: '実力や知識が乏しい人ほど、よく喋るという意味です。',
  ),
  ProverbQuestion(
    proverb: '虎穴に入らずんば虎子を得ず',
    reading: 'こけつにいらずんばこじをえず',
    question: 'このことわざの意味は？',
    choices: ['虎は危ない', '危険を冒さなければ、大きな成果は得られない', '虎の子は可愛い', '虎の穴には入らない'],
    correctIndex: 1,
    explanation: '危険を恐れずに挑戦しなければ、大きな成功や成果は得られないという意味です。',
  ),
  ProverbQuestion(
    proverb: '七難隠す',
    reading: 'しちなんかくす',
    question: '「笑顔は七難隠す」このことわざの意味は？',
    choices: ['笑顔は七つの秘密がある', '笑顔でいると、多少の欠点も目立たなくなる', '七回笑うと隠れる', '難しいことを隠す'],
    correctIndex: 1,
    explanation: '笑顔の人は多少の欠点があっても気にならない、愛嬌は大切だという意味です。',
  ),
  ProverbQuestion(
    proverb: '腹が立ったら百数えよ',
    reading: 'はらがたったらひゃくかぞえよ',
    question: 'このことわざの意味は？',
    choices: ['100まで数えれば怒りが正しい', '怒ったときは、冷静になるまで落ち着くこと', '百回数えると元気になる', '腹が立ったら走ろう'],
    correctIndex: 1,
    explanation: '腹が立ったときはすぐに行動せず、冷静になるまで待つことが大切だという意味です。',
  ),
];

// ランタイム問題クラス（選択肢シャッフル済み）
class _RuntimeQ {
  final String proverb;
  final String reading;
  final String question;
  final List<String> choices;
  final int correctIndex;
  final String explanation;

  _RuntimeQ({
    required this.proverb,
    required this.reading,
    required this.question,
    required this.choices,
    required this.correctIndex,
    required this.explanation,
  });

  static _RuntimeQ from(ProverbQuestion q) {
    final correct = q.choices[q.correctIndex];
    final shuffled = List.of(q.choices)..shuffle(math.Random());
    return _RuntimeQ(
      proverb: q.proverb,
      reading: q.reading,
      question: q.question,
      choices: shuffled,
      correctIndex: shuffled.indexOf(correct),
      explanation: q.explanation,
    );
  }
}

const _questionsPerRound = 10;

class ProverbQuizScreen extends ConsumerStatefulWidget {
  const ProverbQuizScreen({super.key});

  @override
  ConsumerState<ProverbQuizScreen> createState() => _ProverbQuizScreenState();
}

class _ProverbQuizScreenState extends ConsumerState<ProverbQuizScreen>
    with SingleTickerProviderStateMixin {
  late List<_RuntimeQ> _round;
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _score = 0;
  bool _finished = false;
  late AnimationController _feedbackCtrl;
  late Animation<double> _feedbackAnim;

  _RuntimeQ get _current => _round[_currentIndex];
  bool get _isCorrect => _selectedAnswer == _current.correctIndex;

  List<_RuntimeQ> _buildRound() {
    final pool = List.of(_proverbQuestions)..shuffle(math.Random());
    return pool.take(_questionsPerRound).map(_RuntimeQ.from).toList();
  }

  @override
  void initState() {
    super.initState();
    _round = _buildRound();
    _feedbackCtrl = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _feedbackAnim = CurvedAnimation(parent: _feedbackCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  void _onChoiceTap(int index) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (_isCorrect) _score++;
    });
    _feedbackCtrl.forward(from: 0);
  }

  void _onNext() {
    if (_currentIndex < _round.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
      _feedbackCtrl.reset();
    } else {
      setState(() => _finished = true);
      final premium = ref.read(premiumProvider);
      if (!premium.isPremium && !premium.isTrialActive) AdService.showInterstitial();
    }
  }

  void _restart() {
    setState(() {
      _round = _buildRound();
      _currentIndex = 0;
      _selectedAnswer = null;
      _answered = false;
      _score = 0;
      _finished = false;
    });
    _feedbackCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return _buildResult();

    final total = _round.length;
    final progress = (_currentIndex + (_answered ? 1 : 0)) / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ことわざクイズ'),
        backgroundColor: kAccentTeal,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
        children: [
          _buildProgressBar(progress, _currentIndex + 1, total),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProverbCard(),
                  const SizedBox(height: 20),
                  ...List.generate(_current.choices.length, (i) {
                    return QuizChoiceButton(
                      text: _current.choices[i],
                      index: i,
                      selected: _selectedAnswer,
                      correct: _answered ? _current.correctIndex : null,
                      accentColor: kAccentTeal,
                      onTap: () => _onChoiceTap(i),
                    );
                  }),
                  if (_answered) ...[
                    const SizedBox(height: 16),
                    ScaleTransition(
                      scale: _feedbackAnim,
                      child: _buildFeedback(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCorrect ? kAccentGreen : kAccentTeal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        _currentIndex < total - 1 ? '次へ →' : '結果を見る！',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress, int current, int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('問題 $current / $total',
                  style: const TextStyle(color: kTextMuted, fontSize: 12)),
              Text('${(progress * 100).round()}%',
                  style: const TextStyle(
                      color: kAccentTeal, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(kAccentTeal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProverbCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          const Text('🏮', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 12),
          Text(
            _current.proverb,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kTextDark),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            '（${_current.reading}）',
            style: const TextStyle(fontSize: 14, color: kTextMuted),
          ),
          const SizedBox(height: 16),
          Text(
            _current.question,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kTextDark),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedback() {
    final color = _isCorrect ? kAccentGreen : kAccentRed;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isCorrect ? '✅ 正解！すごい！' : '❌ 不正解',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            _current.explanation,
            style: const TextStyle(fontSize: 14, color: kTextDark, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final total = _round.length;
    final pct = (_score / total * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ことわざクイズ'),
        backgroundColor: kAccentTeal,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(pct >= 80 ? '🎉' : pct >= 50 ? '😊' : '😅',
                  style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              const Text('結果', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kTextDark)),
              const SizedBox(height: 12),
              Text('$_score / $total 問正解',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: kAccentTeal)),
              const SizedBox(height: 8),
              Text('$pct%', style: const TextStyle(fontSize: 20, color: kTextMuted)),
              const SizedBox(height: 24),
              Text(
                pct >= 80 ? 'すばらしい！ことわざの達人だね！'
                    : pct >= 50 ? 'よくがんばったね！もう一度チャレンジ！'
                    : 'もっと練習してみよう！',
                style: const TextStyle(fontSize: 16, color: kTextDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _restart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentTeal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('もう一度チャレンジ！',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kAccentTeal),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('メニューに戻る',
                      style: TextStyle(fontSize: 16, color: kAccentTeal)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared choice button (used by proverb and idiom quizzes)
// ---------------------------------------------------------------------------

// ignore: library_private_types_in_public_api
class QuizChoiceButton extends StatelessWidget {
  final String text;
  final int index;
  final int? selected;
  final int? correct;
  final Color accentColor;
  final VoidCallback onTap;

  const QuizChoiceButton({
    required this.text,
    required this.index,
    required this.selected,
    required this.correct,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.grey.shade300;
    Color bgColor = Colors.white;
    Color textColor = kTextDark;
    Widget? trailingIcon;

    if (correct != null) {
      if (index == correct) {
        borderColor = kAccentGreen;
        bgColor = kAccentGreen.withAlpha(20);
        textColor = kAccentGreen;
        trailingIcon = const Icon(Icons.check_circle, color: kAccentGreen);
      } else if (index == selected && index != correct) {
        borderColor = kAccentRed;
        bgColor = kAccentRed.withAlpha(15);
        textColor = kAccentRed;
        trailingIcon = const Icon(Icons.cancel, color: kAccentRed);
      }
    } else if (selected == index) {
      borderColor = accentColor;
      bgColor = accentColor.withAlpha(20);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: borderColor.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: TextStyle(
                      color: borderColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(text,
                    style: TextStyle(fontSize: 15, color: textColor, fontWeight: FontWeight.w500)),
              ),
              if (trailingIcon != null) trailingIcon,
            ],
          ),
        ),
      ),
    );
  }
}
