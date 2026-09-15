import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vocab_mastery_provider.dart';

import '../services/ad_service.dart';
import '../providers/premium_provider.dart';
import '../theme/app_theme.dart';

class VocabQuestion {
  final String word;

  final String reading;
  final String question;
  final List<String> choices;
  final int correctIndex;
  final String explanation;
  final int grade;

  const VocabQuestion({
    required this.word,
    required this.reading,
    required this.question,
    required this.choices,
    required this.correctIndex,
    required this.explanation,
    required this.grade,
  });
}

const _vocabQuestions = [
  // ─── 1年生 ───
  VocabQuestion(
    word: '山', reading: 'やま', question: '「山」ってどういう意味？',
    choices: ['どこまでも続く平らな土地', '地面が高く盛り上がったところ', '草や木が茂る広い野原', '川の流れが作ったなだらかな谷'],
    correctIndex: 1, explanation: '「山」は地面が高く盛り上がったところです。', grade: 1,
  ),
  VocabQuestion(
    word: '川', reading: 'かわ', question: '「川」ってどういう意味？',
    choices: ['水がたまって丸くなったところ', '波が打ち寄せる広い水の場所', '地面を水が流れるところ', '地面にできたくぼみに水がたまったところ'],
    correctIndex: 2, explanation: '「川」は地面を水が流れているところです。', grade: 1,
  ),
  VocabQuestion(
    word: '花', reading: 'はな', question: '「花」ってどういう意味？',
    choices: ['植物が光を受けて緑になる部分', '植物が咲かせる色のきれいな部分', '植物が土から水を吸う部分', '植物の実の中にある小さなもの'],
    correctIndex: 1, explanation: '「花」は植物が咲かせる、色のきれいな部分です。', grade: 1,
  ),
  VocabQuestion(
    word: '学校', reading: 'がっこう', question: '「学校」ってどういう意味？',
    choices: ['子どもが自由に遊ぶ広い場所', '先生から勉強を教わる場所', '子どもの体を診てもらう場所', 'ものを作って売る建物'],
    correctIndex: 1, explanation: '「学校」は先生から勉強を教わる場所です。', grade: 1,
  ),
  VocabQuestion(
    word: '先生', reading: 'せんせい', question: '「先生」ってどういう意味？',
    choices: ['みんなと一緒に勉強している人', '知識や技術を教えてくれる人', '学校で一緒に遊ぶ仲間', '学校の外で子どもたちを守る人'],
    correctIndex: 1, explanation: '「先生」は知識や技術を教えてくれる人です。', grade: 1,
  ),
  VocabQuestion(
    word: '友だち', reading: 'ともだち', question: '「友だち」ってどういう意味？',
    choices: ['同じ学校に通っているだけの人', '仲良く付き合う人', '家族の中の兄や姉のこと', '知らない土地に住んでいる人'],
    correctIndex: 1, explanation: '「友だち」は仲良く一緒に遊んだり話したりする人です。', grade: 1,
  ),
  VocabQuestion(
    word: '家族', reading: 'かぞく', question: '「家族」ってどういう意味？',
    choices: ['となりの家に住んでいる人たち', '一緒に暮らす親や兄弟などのグループ', '同じ学校に通っている仲間', '同じ趣味を持つ仲間のグループ'],
    correctIndex: 1, explanation: '「家族」は同じ家に住む親・兄弟・姉妹などのことです。', grade: 1,
  ),
  VocabQuestion(
    word: '動物', reading: 'どうぶつ', question: '「動物」ってどういう意味？',
    choices: ['根を張って土の中から水を吸う生き物', 'いのちを持って自ら動く生き物', '葉っぱや花を咲かせる生き物', '土や岩の中で長い時間をかけてできるもの'],
    correctIndex: 1, explanation: '「動物」は生きていて、自分で動くことができる生き物です。', grade: 1,
  ),
  VocabQuestion(
    word: '音', reading: 'おと', question: '「音」ってどういう意味？',
    choices: ['目で見てわかる光や明るさのこと', '耳で感じる振動・響き', '手でさわってわかる硬さや柔らかさ', '鼻で感じる香りやにおいのこと'],
    correctIndex: 1, explanation: '「音」は耳で聞こえる音のことです。', grade: 1,
  ),
  VocabQuestion(
    word: '空', reading: 'そら', question: '「空」ってどういう意味？',
    choices: ['地面の下に広がる暗いところ', '遠くに見える緑が続く場所', '頭の上に広がる、雲や星が見えるところ', '水平線のむこうに広がる水の世界'],
    correctIndex: 2, explanation: '「空」は雲や星が見える、頭の上に広がる場所です。', grade: 1,
  ),
  VocabQuestion(
    word: '朝', reading: 'あさ', question: '「朝」ってどういう意味？',
    choices: ['太陽が空の真ん中にある時間', '太陽が昇る、1日の始まりの時間', '太陽が沈んで空が暗くなる時間', '夜が明ける前の、空が一番暗い時間'],
    correctIndex: 1, explanation: '「朝」は太陽が昇る、1日の始まりの時間帯です。', grade: 1,
  ),
  VocabQuestion(
    word: '雨', reading: 'あめ', question: '「雨」ってどういう意味？',
    choices: ['水が冷えて白い結晶になって落ちてくるもの', '雲から落ちてくる水のこと', '空気が動いて体に感じられる自然の力', '空に浮かぶ白いふわふわしたもの'],
    correctIndex: 1, explanation: '「雨」は雲から地面へ落ちてくる水のことです。', grade: 1,
  ),
  VocabQuestion(
    word: '色', reading: 'いろ', question: '「色」ってどういう意味？',
    choices: ['物の丸・四角などの外側の輪郭', '赤・青・黄などの目で見えるもの', '物のでこぼこや手触りの感じ', '物から出る音の高さや大きさ'],
    correctIndex: 1, explanation: '「色」は赤・青・黄など、目で感じる光の性質です。', grade: 1,
  ),
  VocabQuestion(
    word: '石', reading: 'いし', question: '「石」ってどういう意味？',
    choices: ['木がくさって柔らかくなったもの', '地面にある硬い固まり', '水が固まってできた透明なかたまり', '砂が集まって少し固くなったもの'],
    correctIndex: 1, explanation: '「石」は地面にある硬い固まりのことです。', grade: 1,
  ),
  VocabQuestion(
    word: '絵', reading: 'え', question: '「絵」ってどういう意味？',
    choices: ['文章のこと', '形や色で描き表したもの', '写真のこと', '文字のこと'],
    correctIndex: 1, explanation: '「絵」は線や色で物や人などを描き表したものです。', grade: 1,
  ),
  // ─── 2年生 ───
  VocabQuestion(
    word: '親切', reading: 'しんせつ', question: '「親切」ってどういう意味？',
    choices: ['意地悪なこと', '人に優しくして助けること', '遠慮すること', '楽しむこと'],
    correctIndex: 1, explanation: '「親切」は人に優しくして、助けてあげることです。', grade: 2,
  ),
  VocabQuestion(
    word: '正直', reading: 'しょうじき', question: '「正直」ってどういう意味？',
    choices: ['うそをつくこと', '本当のことをそのまま言うこと', '秘密を守ること', '約束を忘れること'],
    correctIndex: 1, explanation: '「正直」は本当のことをそのまま言うことです。', grade: 2,
  ),
  VocabQuestion(
    word: '元気', reading: 'げんき', question: '「元気」ってどういう意味？',
    choices: ['病気なこと', '体も心も活き活きとしていること', '眠いこと', '疲れていること'],
    correctIndex: 1, explanation: '「元気」は体も心も活き活きと健康な状態のことです。', grade: 2,
  ),
  VocabQuestion(
    word: '大切', reading: 'たいせつ', question: '「大切」ってどういう意味？',
    choices: ['どうでもよいこと', 'とても重要で、粗末にしてはいけないこと', '古いこと', '遠いこと'],
    correctIndex: 1, explanation: '「大切」はとても重要で、粗末にしてはいけないことです。', grade: 2,
  ),
  VocabQuestion(
    word: '言葉', reading: 'ことば', question: '「言葉」ってどういう意味？',
    choices: ['絵のこと', '人が気持ちや考えを伝えるための音や文字', '数字のこと', '楽器の音'],
    correctIndex: 1, explanation: '「言葉」は人が考えや気持ちを伝えるための音や文字です。', grade: 2,
  ),
  VocabQuestion(
    word: '気持ち', reading: 'きもち', question: '「気持ち」ってどういう意味？',
    choices: ['体の動き', '心の中で感じること（うれしい・悲しいなど）', '考えること', '行動すること'],
    correctIndex: 1, explanation: '「気持ち」はうれしい・悲しいなど、心で感じることです。', grade: 2,
  ),
  VocabQuestion(
    word: '力', reading: 'ちから', question: '「力」ってどういう意味？',
    choices: ['弱さのこと', '何かをする能力や体の強さ', '速さのこと', '大きさのこと'],
    correctIndex: 1, explanation: '「力」は物を動かしたり、行動を起こすためのエネルギーです。', grade: 2,
  ),
  VocabQuestion(
    word: '笑顔', reading: 'えがお', question: '「笑顔」ってどういう意味？',
    choices: ['怒った顔', '笑っているときの明るい表情', '泣いた顔', '眠った顔'],
    correctIndex: 1, explanation: '「笑顔」は笑っているときの明るくて楽しそうな顔の表情です。', grade: 2,
  ),
  VocabQuestion(
    word: '思いやり', reading: 'おもいやり', question: '「思いやり」ってどういう意味？',
    choices: ['自分だけを考えること', '相手の気持ちを考えて接すること', '意地悪すること', '無視すること'],
    correctIndex: 1, explanation: '「思いやり」は相手の立場や気持ちを考えて優しく接することです。', grade: 2,
  ),
  VocabQuestion(
    word: '勉強', reading: 'べんきょう', question: '「勉強」ってどういう意味？',
    choices: ['遊ぶこと', '知識や技術を身につけるために学ぶこと', '休むこと', '食べること'],
    correctIndex: 1, explanation: '「勉強」は学校や家で知識や技術を学ぶことです。', grade: 2,
  ),
  VocabQuestion(
    word: '礼儀', reading: 'れいぎ', question: '「礼儀」ってどういう意味？',
    choices: ['ルールを破ること', '相手に対する正しいふるまいやマナー', '自由なこと', '楽しむこと'],
    correctIndex: 1, explanation: '「礼儀」は相手に敬意を示す正しいふるまいやマナーのことです。', grade: 2,
  ),
  VocabQuestion(
    word: '運動', reading: 'うんどう', question: '「運動」ってどういう意味？',
    choices: ['座っていること', '体を動かすこと', '眠ること', '考えること'],
    correctIndex: 1, explanation: '「運動」は体を動かして健康を保つことです。', grade: 2,
  ),
  VocabQuestion(
    word: '喜び', reading: 'よろこび', question: '「喜び」ってどういう意味？',
    choices: ['悲しい気持ち', '嬉しいと感じる気持ち', '怒りの気持ち', '怖い気持ち'],
    correctIndex: 1, explanation: '「喜び」は嬉しいと感じる、とても良い気持ちのことです。', grade: 2,
  ),
  VocabQuestion(
    word: '悲しみ', reading: 'かなしみ', question: '「悲しみ」ってどういう意味？',
    choices: ['嬉しい気持ち', '辛く、心が痛むような気持ち', '怒りの気持ち', '楽しい気持ち'],
    correctIndex: 1, explanation: '「悲しみ」は辛く心が痛むような、暗い気持ちのことです。', grade: 2,
  ),
  VocabQuestion(
    word: '誕生日', reading: 'たんじょうび', question: '「誕生日」ってどういう意味？',
    choices: ['記念日のこと', '生まれた年の同じ日', '結婚した日', '卒業した日'],
    correctIndex: 1, explanation: '「誕生日」はその人が生まれた日と同じ日のことです。', grade: 2,
  ),
  // ─── 3年生 ───
  VocabQuestion(
    word: '集中', reading: 'しゅうちゅう', question: '「集中」ってどういう意味？',
    choices: ['あちこちに広がること', '一つのことに力を注ぐこと', 'みんなで集まること', '何もしないこと'],
    correctIndex: 1, explanation: '「集中」は、一つのことに意識や力をまとめて向けることです。', grade: 3,
  ),
  VocabQuestion(
    word: '努力', reading: 'どりょく', question: '「努力」ってどういう意味？',
    choices: ['ゆっくり休むこと', 'すぐにあきらめること', '目標に向けてがんばること', '他の人を手伝うこと'],
    correctIndex: 2, explanation: '「努力」は、目標を達成するためにがんばり続けることです。', grade: 3,
  ),
  VocabQuestion(
    word: '協力', reading: 'きょうりょく', question: '「協力」ってどういう意味？',
    choices: ['一人でやること', 'みんなで力を合わせること', '競い合うこと', '邪魔をすること'],
    correctIndex: 1, explanation: '「協力」は、力を合わせて一緒に取り組むことです。', grade: 3,
  ),
  VocabQuestion(
    word: '感動', reading: 'かんどう', question: '「感動」ってどういう意味？',
    choices: ['退屈なこと', '心が強く動かされること', '怒ること', '悲しむこと'],
    correctIndex: 1, explanation: '「感動」は心が強く動かされて、感じ入ることです。', grade: 3,
  ),
  VocabQuestion(
    word: '約束', reading: 'やくそく', question: '「約束」ってどういう意味？',
    choices: ['忘れること', '二人以上で守ることを決めること', '一人で決めること', '関係ないこと'],
    correctIndex: 1, explanation: '「約束」は二人以上でこうすると決めて、守ることです。', grade: 3,
  ),
  VocabQuestion(
    word: '信頼', reading: 'しんらい', question: '「信頼」ってどういう意味？',
    choices: ['疑うこと', '信じて頼りにすること', '無視すること', '反対すること'],
    correctIndex: 1, explanation: '「信頼」は相手を信じて頼りにすることです。', grade: 3,
  ),
  VocabQuestion(
    word: '挑戦', reading: 'ちょうせん', question: '「挑戦」ってどういう意味？',
    choices: ['逃げること', 'むずかしいことに向かっていくこと', 'やめること', '失敗すること'],
    correctIndex: 1, explanation: '「挑戦」は難しいことに立ち向かって取り組むことです。', grade: 3,
  ),
  VocabQuestion(
    word: '目標', reading: 'もくひょう', question: '「目標」ってどういう意味？',
    choices: ['過去のこと', 'これを達成しようという目指す点', '今していること', 'どうでもよいこと'],
    correctIndex: 1, explanation: '「目標」はこれを達成しようと定めた目印のことです。', grade: 3,
  ),
  VocabQuestion(
    word: '成長', reading: 'せいちょう', question: '「成長」ってどういう意味？',
    choices: ['小さくなること', '大きくなり、強くなること', '止まること', '戻ること'],
    correctIndex: 1, explanation: '「成長」は体や心が大きく、強く、豊かになることです。', grade: 3,
  ),
  VocabQuestion(
    word: '感謝', reading: 'かんしゃ', question: '「感謝」ってどういう意味？',
    choices: ['悲しむこと', 'ありがたいと思うこと', '反省すること', '怒ること'],
    correctIndex: 1, explanation: '「感謝」は、してもらったことに対してありがたいと思う気持ちです。', grade: 3,
  ),
  VocabQuestion(
    word: '勇気', reading: 'ゆうき', question: '「勇気」ってどういう意味？',
    choices: ['逃げ出す気持ち', '怖くても前に進む強い心', '怒る気持ち', '笑う気持ち'],
    correctIndex: 1, explanation: '「勇気」は、怖いことや難しいことでも立ち向かう強い心のことです。', grade: 3,
  ),
  VocabQuestion(
    word: '計画', reading: 'けいかく', question: '「計画」ってどういう意味？',
    choices: ['でたらめにやること', '目標を達成するための手順や方法を考えること', '今すぐやること', '過去のこと'],
    correctIndex: 1, explanation: '「計画」は目標を達成するために、手順や方法を事前に考えることです。', grade: 3,
  ),
  VocabQuestion(
    word: '方法', reading: 'ほうほう', question: '「方法」ってどういう意味？',
    choices: ['できないこと', '物事を行うためのやり方・手段', '結果のこと', '目標のこと'],
    correctIndex: 1, explanation: '「方法」は物事を達成するためのやり方や手段です。', grade: 3,
  ),
  VocabQuestion(
    word: '理由', reading: 'りゆう', question: '「理由」ってどういう意味？',
    choices: ['結果のこと', '何かがそうなったわけ・原因', '目的のこと', '感想のこと'],
    correctIndex: 1, explanation: '「理由」は何かがそうなった原因やわけのことです。', grade: 3,
  ),
  VocabQuestion(
    word: '役割', reading: 'やくわり', question: '「役割」ってどういう意味？',
    choices: ['仕事を断ること', 'グループや社会の中で担当する仕事や責任', '自由にすること', '何もしないこと'],
    correctIndex: 1, explanation: '「役割」は集団の中で自分が担当する仕事や責任のことです。', grade: 3,
  ),
  VocabQuestion(
    word: '種類', reading: 'しゅるい', question: '「種類」ってどういう意味？',
    choices: ['数のこと', '性質や形が似たものをまとめたグループ', '大きさのこと', '重さのこと'],
    correctIndex: 1, explanation: '「種類」は性質や特徴が似たものをまとめた分類のことです。', grade: 3,
  ),
  VocabQuestion(
    word: '順番', reading: 'じゅんばん', question: '「順番」ってどういう意味？',
    choices: ['でたらめな順序', '決められた並び方・順序', '速さのこと', '大きさのこと'],
    correctIndex: 1, explanation: '「順番」は決められたルールで並ぶ順序のことです。', grade: 3,
  ),
  VocabQuestion(
    word: '友情', reading: 'ゆうじょう', question: '「友情」ってどういう意味？',
    choices: ['一人でいること', '戦う気持ち', '友だちとの絆や思いやり', '遊ぶこと'],
    correctIndex: 2, explanation: '「友情」は、友だち同士の間にある強い絆や思いやりの気持ちです。', grade: 3,
  ),
  VocabQuestion(
    word: '相談', reading: 'そうだん', question: '「相談」ってどういう意味？',
    choices: ['一人で決めること', '悩みや問題を人と話し合うこと', '自分で考えること', '忘れること'],
    correctIndex: 1, explanation: '「相談」は悩みや問題について誰かと話し合って考えることです。', grade: 3,
  ),
  VocabQuestion(
    word: '準備', reading: 'じゅんび', question: '「準備」ってどういう意味？',
    choices: ['後始末すること', '何かをするために前もって用意すること', '結果を見ること', 'あきらめること'],
    correctIndex: 1, explanation: '「準備」は何かをするために前もって必要なものを用意することです。', grade: 3,
  ),
  // ─── 4年生 ───
  VocabQuestion(
    word: '想像', reading: 'そうぞう', question: '「想像」ってどういう意味？',
    choices: ['実際に見ること', '忘れること', 'まだないことを心の中で思い描くこと', '絵を描くこと'],
    correctIndex: 2, explanation: '「想像」は、実際には見ていないことを頭の中で思い浮かべることです。', grade: 4,
  ),
  VocabQuestion(
    word: '経験', reading: 'けいけん', question: '「経験」ってどういう意味？',
    choices: ['未来のこと', '実際にやってみて身につけること', '教科書で勉強すること', '夢を見ること'],
    correctIndex: 1, explanation: '「経験」は、実際に体験してみて学ぶことです。', grade: 4,
  ),
  VocabQuestion(
    word: '完成', reading: 'かんせい', question: '「完成」ってどういう意味？',
    choices: ['始まること', '途中で止まること', '全てが完ぺきに仕上がること', '壊れること'],
    correctIndex: 2, explanation: '「完成」は、ものや工事などが全て仕上がって、完ぺきになることです。', grade: 4,
  ),
  VocabQuestion(
    word: '希望', reading: 'きぼう', question: '「希望」ってどういう意味？',
    choices: ['悲しい気持ち', 'こうなってほしいと願う気持ち', '不安な気持ち', '怒る気持ち'],
    correctIndex: 1, explanation: '「希望」は、こうなってほしい、こうしたいという明るい願いです。', grade: 4,
  ),
  VocabQuestion(
    word: '工夫', reading: 'くふう', question: '「工夫」ってどういう意味？',
    choices: ['失敗すること', 'もっと良い方法を考えること', '壊すこと', '止めること'],
    correctIndex: 1, explanation: '「工夫」は、もっと良くするために、知恵を尽くして考えることです。', grade: 4,
  ),
  VocabQuestion(
    word: '忍耐', reading: 'にんたい', question: '「忍耐」ってどういう意味？',
    choices: ['すぐあきらめること', '苦しくても我慢して耐えること', '楽しいこと', '速いこと'],
    correctIndex: 1, explanation: '「忍耐」は苦しいことや辛いことを我慢して耐えることです。', grade: 4,
  ),
  VocabQuestion(
    word: '尊重', reading: 'そんちょう', question: '「尊重」ってどういう意味？',
    choices: ['軽く扱うこと', 'たいせつにして重んじること', '無視すること', '笑うこと'],
    correctIndex: 1, explanation: '「尊重」は価値があると認めて、大切に扱うことです。', grade: 4,
  ),
  VocabQuestion(
    word: '発見', reading: 'はっけん', question: '「発見」ってどういう意味？',
    choices: ['忘れること', '今まで知られていなかったことを見つけること', '作ること', '壊すこと'],
    correctIndex: 1, explanation: '「発見」は今まで知られていなかったことや、探していたものを見つけることです。', grade: 4,
  ),
  VocabQuestion(
    word: '影響', reading: 'えいきょう', question: '「影響」ってどういう意味？',
    choices: ['無関係なこと', 'あるものが他のものに及ぼす作用', '直接関係ないこと', '変わらないこと'],
    correctIndex: 1, explanation: '「影響」はあるものが他のものに及ぼす働きかけのことです。', grade: 4,
  ),
  VocabQuestion(
    word: '探求', reading: 'たんきゅう', question: '「探求」ってどういう意味？',
    choices: ['あきらめること', 'ものごとを深く追い求めること', '逃げること', '遊ぶこと'],
    correctIndex: 1, explanation: '「探求」はものごとを深く追い求めて調べることです。', grade: 4,
  ),
  VocabQuestion(
    word: '観察', reading: 'かんさつ', question: '「観察」ってどういう意味？',
    choices: ['想像すること', 'じっくりよく見て調べること', '絵をかくこと', '説明すること'],
    correctIndex: 1, explanation: '「観察」は、物事をじっくりとよく見て詳しく調べることです。', grade: 4,
  ),
  VocabQuestion(
    word: '判断', reading: 'はんだん', question: '「判断」ってどういう意味？',
    choices: ['迷い続けること', 'よく考えてどうするかを決めること', '何も決めないこと', '他の人に任せること'],
    correctIndex: 1, explanation: '「判断」はよく考えて物事の良し悪しや正しさを決めることです。', grade: 4,
  ),
  VocabQuestion(
    word: '選択', reading: 'せんたく', question: '「選択」ってどういう意味？',
    choices: ['全部受け入れること', '複数の中から選ぶこと', '全部断ること', '考えないこと'],
    correctIndex: 1, explanation: '「選択」は複数の選択肢の中から自分で選ぶことです。', grade: 4,
  ),
  VocabQuestion(
    word: '実行', reading: 'じっこう', question: '「実行」ってどういう意味？',
    choices: ['考えるだけ', '計画したことを実際にやること', 'やめること', '延期すること'],
    correctIndex: 1, explanation: '「実行」は計画や決めたことを実際に行動に移すことです。', grade: 4,
  ),
  VocabQuestion(
    word: '改善', reading: 'かいぜん', question: '「改善」ってどういう意味？',
    choices: ['悪くすること', '悪いところを直して良くすること', '何もしないこと', '壊すこと'],
    correctIndex: 1, explanation: '「改善」は悪いところや問題点を直して良くすることです。', grade: 4,
  ),
  VocabQuestion(
    word: '提案', reading: 'ていあん', question: '「提案」ってどういう意味？',
    choices: ['反対すること', '考えやアイデアを出して勧めること', '断ること', '無視すること'],
    correctIndex: 1, explanation: '「提案」は自分の考えやアイデアを出して皆に勧めることです。', grade: 4,
  ),
  VocabQuestion(
    word: '自然', reading: 'しぜん', question: '「自然」ってどういう意味？',
    choices: ['人工的なこと', '山・川・木などの人間が作らないもの', '都会のこと', '機械のこと'],
    correctIndex: 1, explanation: '「自然」は人間が作らない山・川・森・空などのことです。', grade: 4,
  ),
  VocabQuestion(
    word: '責任', reading: 'せきにん', question: '「責任」ってどういう意味？',
    choices: ['他の人のせいにすること', 'やったことに対して果たすべき義務', '逃げること', '忘れること'],
    correctIndex: 1, explanation: '「責任」は自分がしたことや役目について、果たさなくてはいけない務めです。', grade: 4,
  ),
  VocabQuestion(
    word: '説明', reading: 'せつめい', question: '「説明」ってどういう意味？',
    choices: ['黙っていること', '相手にわかるよう理由や内容を話すこと', '隠すこと', '無視すること'],
    correctIndex: 1, explanation: '「説明」は相手がよく理解できるように内容や理由を話すことです。', grade: 4,
  ),
  VocabQuestion(
    word: '記録', reading: 'きろく', question: '「記録」ってどういう意味？',
    choices: ['忘れること', '後で見返せるように残すこと', '消すこと', '変えること'],
    correctIndex: 1, explanation: '「記録」は後で見返せるように、文字や映像などに残すことです。', grade: 4,
  ),
  // ─── 5年生 ───
  VocabQuestion(
    word: '達成', reading: 'たっせい', question: '「達成」ってどういう意味？',
    choices: ['途中でやめること', '失敗すること', '目標をやり遂げること', '迷うこと'],
    correctIndex: 2, explanation: '「達成」は、目指していた目標をついに成し遂げることです。', grade: 5,
  ),
  VocabQuestion(
    word: '困難', reading: 'こんなん', question: '「困難」ってどういう意味？',
    choices: ['楽しいこと', '簡単なこと', 'むずかしくて大変なこと', '速いこと'],
    correctIndex: 2, explanation: '「困難」は、解決するのが難しい問題や大変な状況のことです。', grade: 5,
  ),
  VocabQuestion(
    word: '解決', reading: 'かいけつ', question: '「解決」ってどういう意味？',
    choices: ['問題をつくること', '問題をうまくかたづけること', '問題を増やすこと', '問題から逃げること'],
    correctIndex: 1, explanation: '「解決」は、問題や疑問などをうまく処理して片づけることです。', grade: 5,
  ),
  VocabQuestion(
    word: '比較', reading: 'ひかく', question: '「比較」ってどういう意味？',
    choices: ['一つだけ見ること', '二つ以上のものを見比べること', '大きさを測ること', '数を数えること'],
    correctIndex: 1, explanation: '「比較」は、二つ以上のものを並べて違いや共通点を調べることです。', grade: 5,
  ),
  VocabQuestion(
    word: '継続', reading: 'けいぞく', question: '「継続」ってどういう意味？',
    choices: ['止めること', 'ずっと続けること', '変わること', '速くすること'],
    correctIndex: 1, explanation: '「継続」は、ずっと同じ状態が続くこと、続けることです。', grade: 5,
  ),
  VocabQuestion(
    word: '複雑', reading: 'ふくざつ', question: '「複雑」ってどういう意味？',
    choices: ['単純なこと', 'いろいろな要素が入り組んでいること', '簡単なこと', '少ないこと'],
    correctIndex: 1, explanation: '「複雑」はいろいろな要素が入り組んでいてわかりにくいことです。', grade: 5,
  ),
  VocabQuestion(
    word: '矛盾', reading: 'むじゅん', question: '「矛盾」ってどういう意味？',
    choices: ['一致していること', '二つのことが食い違って両立しないこと', '同じであること', '正しいこと'],
    correctIndex: 1, explanation: '「矛盾」は二つのことが食い違って、両立しないことです。', grade: 5,
  ),
  VocabQuestion(
    word: '効率', reading: 'こうりつ', question: '「効率」ってどういう意味？',
    choices: ['無駄が多いこと', '少ない労力・時間で大きな成果を得る度合い', '失敗すること', '遅いこと'],
    correctIndex: 1, explanation: '「効率」は少ない労力や時間で大きな成果を上げる度合いのことです。', grade: 5,
  ),
  VocabQuestion(
    word: '対策', reading: 'たいさく', question: '「対策」ってどういう意味？',
    choices: ['問題を無視すること', '問題に対して対処するための方法', '問題を作ること', '諦めること'],
    correctIndex: 1, explanation: '「対策」は問題や困難に対処するために考える手段・方法です。', grade: 5,
  ),
  VocabQuestion(
    word: '課題', reading: 'かだい', question: '「課題」ってどういう意味？',
    choices: ['簡単なこと', '取り組まなければならない問題や仕事', '終わったこと', '関係ないこと'],
    correctIndex: 1, explanation: '「課題」は解決しなければならない問題や、与えられた仕事です。', grade: 5,
  ),
  VocabQuestion(
    word: '成果', reading: 'せいか', question: '「成果」ってどういう意味？',
    choices: ['努力しないこと', '努力の結果として得られた良い結果', '失敗のこと', '過程のこと'],
    correctIndex: 1, explanation: '「成果」は努力や取り組みの結果として生まれた良い結果です。', grade: 5,
  ),
  VocabQuestion(
    word: '過程', reading: 'かてい', question: '「過程」ってどういう意味？',
    choices: ['結果のこと', '物事が進んでいく途中の段階や経過', '失敗のこと', '準備のこと'],
    correctIndex: 1, explanation: '「過程」は目標に向かって進んでいく途中の段階や経過のことです。', grade: 5,
  ),
  VocabQuestion(
    word: '権利', reading: 'けんり', question: '「権利」ってどういう意味？',
    choices: ['やってはいけないこと', '人が当然持っている資格や力', '義務のこと', '罰のこと'],
    correctIndex: 1, explanation: '「権利」は人が当然持っている、何かをできる資格や力のことです。', grade: 5,
  ),
  VocabQuestion(
    word: '義務', reading: 'ぎむ', question: '「義務」ってどういう意味？',
    choices: ['自由にできること', '必ずしなければならないこと', '権利のこと', 'やりたいこと'],
    correctIndex: 1, explanation: '「義務」は必ずしなければならない、果たすべき責任のことです。', grade: 5,
  ),
  VocabQuestion(
    word: '創造', reading: 'そうぞう', question: '「創造」ってどういう意味？',
    choices: ['コピーすること', '今までにないものを新しく作り出すこと', '壊すこと', '真似すること'],
    correctIndex: 1, explanation: '「創造」は今までになかった新しいものや考えを作り出すことです。', grade: 5,
  ),
  VocabQuestion(
    word: '発展', reading: 'はってん', question: '「発展」ってどういう意味？',
    choices: ['縮小すること', 'より良く・大きく・進歩していくこと', '変わらないこと', 'なくなること'],
    correctIndex: 1, explanation: '「発展」は物事がより良くなり、大きく進歩していくことです。', grade: 5,
  ),
  VocabQuestion(
    word: '改革', reading: 'かいかく', question: '「改革」ってどういう意味？',
    choices: ['変えないこと', '古いものを良くするために大きく変えること', '壊すこと', '元に戻すこと'],
    correctIndex: 1, explanation: '「改革」は古い制度や仕組みを良くするために大きく変えることです。', grade: 5,
  ),
  VocabQuestion(
    word: '活躍', reading: 'かつやく', question: '「活躍」ってどういう意味？',
    choices: ['休むこと', '生き生きと力を発揮して活動すること', '怠けること', '邪魔すること'],
    correctIndex: 1, explanation: '「活躍」は持てる力を十分に発揮して活発に活動することです。', grade: 5,
  ),
  VocabQuestion(
    word: '貢献', reading: 'こうけん', question: '「貢献」ってどういう意味？',
    choices: ['邪魔すること', '社会や人のために役立つこと', '自分のためだけにすること', '断ること'],
    correctIndex: 1, explanation: '「貢献」は社会や組織、人のために力を尽くして役立つことです。', grade: 5,
  ),
  VocabQuestion(
    word: '分析', reading: 'ぶんせき', question: '「分析」ってどういう意味？',
    choices: ['まとめること', '物事を細かく分けて調べること', '全体を見ること', '感じること'],
    correctIndex: 1, explanation: '「分析」は物事を細かく分けて、それぞれを詳しく調べることです。', grade: 5,
  ),
  // ─── 6年生 ───
  VocabQuestion(
    word: '論理', reading: 'ろんり', question: '「論理」ってどういう意味？',
    choices: ['気持ちで考えること', 'でたらめに話すこと', '筋道を立てて考えること', '声を大きくすること'],
    correctIndex: 2, explanation: '「論理」は、物事を順序立てて筋道を通して考えることです。', grade: 6,
  ),
  VocabQuestion(
    word: '批判', reading: 'ひはん', question: '「批判」ってどういう意味？',
    choices: ['ほめること', '物事の良し悪しを考えて意見を言うこと', '無視すること', '真似すること'],
    correctIndex: 1, explanation: '「批判」は、物事の良い点・悪い点を考えて、意見や評価を述べることです。', grade: 6,
  ),
  VocabQuestion(
    word: '評価', reading: 'ひょうか', question: '「評価」ってどういう意味？',
    choices: ['笑うこと', '褒めること', '値打ちや程度を決めること', '批判すること'],
    correctIndex: 2, explanation: '「評価」は、ものや人の値打ち・程度を判断して、値をつけることです。', grade: 6,
  ),
  VocabQuestion(
    word: '概念', reading: 'がいねん', question: '「概念」ってどういう意味？',
    choices: ['具体的な物のこと', 'ものごとの全体的なとらえ方・考え方', '細かいことのみ', '見た目だけのこと'],
    correctIndex: 1, explanation: '「概念」はものごとの全体的なとらえ方や考え方のことです。', grade: 6,
  ),
  VocabQuestion(
    word: '哲学', reading: 'てつがく', question: '「哲学」ってどういう意味？',
    choices: ['スポーツのこと', '人生や世界の本質について深く考える学問', '料理のこと', '計算のこと'],
    correctIndex: 1, explanation: '「哲学」は人生や世界の本質・意味について深く考える学問のことです。', grade: 6,
  ),
  VocabQuestion(
    word: '平和', reading: 'へいわ', question: '「平和」ってどういう意味？',
    choices: ['戦いが多いこと', '争いやもめごとがなく、おだやかな状態', '競争すること', '力が強いこと'],
    correctIndex: 1, explanation: '「平和」は争いや戦争がなく、穏やかで安心できる状態のことです。', grade: 6,
  ),
  VocabQuestion(
    word: '自由', reading: 'じゆう', question: '「自由」ってどういう意味？',
    choices: ['縛られること', '自分の思い通りに行動できること', '制限が多いこと', '他人が決めること'],
    correctIndex: 1, explanation: '「自由」は他から制限されず、自分の思い通りに行動できることです。', grade: 6,
  ),
  VocabQuestion(
    word: '平等', reading: 'びょうどう', question: '「平等」ってどういう意味？',
    choices: ['差をつけること', '差別なく、全員が同じ扱いを受けること', '強い人が優先されること', '特別な人が得をすること'],
    correctIndex: 1, explanation: '「平等」は差別なく、みんなが同じ権利や扱いを受けることです。', grade: 6,
  ),
  VocabQuestion(
    word: '多様性', reading: 'たようせい', question: '「多様性」ってどういう意味？',
    choices: ['みんな同じであること', 'いろいろな種類や考え方が存在すること', '一種類しかないこと', '少ないこと'],
    correctIndex: 1, explanation: '「多様性」は様々な種類・考え方・文化が存在し、それを尊重することです。', grade: 6,
  ),
  VocabQuestion(
    word: '伝統', reading: 'でんとう', question: '「伝統」ってどういう意味？',
    choices: ['新しいこと', '昔から受け継がれてきた習慣や文化', '外国のこと', '現代のこと'],
    correctIndex: 1, explanation: '「伝統」は昔から今まで大切に受け継がれてきた習慣や文化のことです。', grade: 6,
  ),
  VocabQuestion(
    word: '文化', reading: 'ぶんか', question: '「文化」ってどういう意味？',
    choices: ['建物のこと', '人間が長い時間をかけて作り上げた生活や芸術などの総体', '食べ物のこと', '言語だけのこと'],
    correctIndex: 1, explanation: '「文化」は人間が生活の中で作り上げた習慣・芸術・学問などの総体です。', grade: 6,
  ),
  VocabQuestion(
    word: '知識', reading: 'ちしき', question: '「知識」ってどういう意味？',
    choices: ['技術のこと', '学習や経験で身についた情報や理解', '感情のこと', '行動のこと'],
    correctIndex: 1, explanation: '「知識」は学習や経験を通じて身につけた情報や理解のことです。', grade: 6,
  ),
  VocabQuestion(
    word: '未来', reading: 'みらい', question: '「未来」ってどういう意味？',
    choices: ['過去のこと', '今よりも後に来る時間', '現在のこと', '昔のこと'],
    correctIndex: 1, explanation: '「未来」は今よりも後に来る、これからの時間のことです。', grade: 6,
  ),
  VocabQuestion(
    word: '情報', reading: 'じょうほう', question: '「情報」ってどういう意味？',
    choices: ['感情のこと', '判断や行動に役立つ知らせや内容', '意見のこと', '物のこと'],
    correctIndex: 1, explanation: '「情報」は判断や行動に役立つ知らせや内容のことです。', grade: 6,
  ),
  VocabQuestion(
    word: '継承', reading: 'けいしょう', question: '「継承」ってどういう意味？',
    choices: ['捨てること', '受け継いで次に渡すこと', '忘れること', '変えること'],
    correctIndex: 1, explanation: '「継承」は先人から受け継いで、次の人に伝えていくことです。', grade: 6,
  ),
  // ─── 追加語彙 1年生 ───
  VocabQuestion(
    word: '木', reading: 'き', question: '「木」ってどういう意味？',
    choices: ['草のこと', '地面に根を張り、幹や枝がある植物', '岩のこと', '土のこと'],
    correctIndex: 1, explanation: '「木」は地面に根を張り、幹や葉がある大きな植物です。', grade: 1,
  ),
  VocabQuestion(
    word: '日', reading: 'ひ', question: '「日」（ひ）ってどういう意味？',
    choices: ['月のこと', '太陽のこと、または一日のこと', '星のこと', '空のこと'],
    correctIndex: 1, explanation: '「日」は太陽のことや、一日（いちにち）のことを表します。', grade: 1,
  ),
  VocabQuestion(
    word: '手', reading: 'て', question: '「手」ってどういう意味？',
    choices: ['足のこと', '顔のこと', '腕の先にある、指がついている部分', '背中のこと'],
    correctIndex: 2, explanation: '「手」は腕の先にある、指がついた部分のことです。', grade: 1,
  ),
  VocabQuestion(
    word: '目', reading: 'め', question: '「目」ってどういう意味？',
    choices: ['口のこと', '耳のこと', '鼻のこと', 'ものを見る器官'],
    correctIndex: 3, explanation: '「目」はものを見るための体の器官です。', grade: 1,
  ),
  VocabQuestion(
    word: '虫', reading: 'むし', question: '「虫」ってどういう意味？',
    choices: ['魚のこと', '小さな体と足を持つ生き物', '鳥のこと', '植物のこと'],
    correctIndex: 1, explanation: '「虫」はカブトムシやチョウのような小さな生き物です。', grade: 1,
  ),
  VocabQuestion(
    word: '土', reading: 'つち', question: '「土」ってどういう意味？',
    choices: ['水のこと', '空気のこと', '地面を作っている粒の細かいもの', '岩のこと'],
    correctIndex: 2, explanation: '「土」は地面を作っている、粒の細かいやわらかいものです。', grade: 1,
  ),
  // ─── 追加語彙 2年生 ───
  VocabQuestion(
    word: '仲良し', reading: 'なかよし', question: '「仲良し」ってどういう意味？',
    choices: ['けんかすること', 'お互いに親しく、良い関係であること', '知らない人のこと', '遠くにいること'],
    correctIndex: 1, explanation: '「仲良し」はお互いに親しく、仲の良い関係のことです。', grade: 2,
  ),
  VocabQuestion(
    word: '助け合い', reading: 'たすけあい', question: '「助け合い」ってどういう意味？',
    choices: ['競い合うこと', 'お互いに助け合うこと', '一人でがんばること', '無視すること'],
    correctIndex: 1, explanation: '「助け合い」はみんながお互いに助け合うことです。', grade: 2,
  ),
  VocabQuestion(
    word: '声', reading: 'こえ', question: '「声」ってどういう意味？',
    choices: ['目で感じるもの', '口や喉から出る音', '手で感じるもの', '鼻で感じるもの'],
    correctIndex: 1, explanation: '「声」は口や喉から出る音のことです。', grade: 2,
  ),
  VocabQuestion(
    word: '楽しみ', reading: 'たのしみ', question: '「楽しみ」ってどういう意味？',
    choices: ['悲しい気持ち', '嫌な気持ち', 'うれしくて気持ちがわくわくすること', '怖い気持ち'],
    correctIndex: 2, explanation: '「楽しみ」は何かをうれしく、わくわくして待つ気持ちです。', grade: 2,
  ),
  VocabQuestion(
    word: '怒り', reading: 'おこり', question: '「怒り」ってどういう意味？',
    choices: ['嬉しい気持ち', 'ひどく腹が立つ気持ち', '悲しい気持ち', '楽しい気持ち'],
    correctIndex: 1, explanation: '「怒り」は腹が立ってむかっとする気持ちです。', grade: 2,
  ),
  VocabQuestion(
    word: '涙', reading: 'なみだ', question: '「涙」ってどういう意味？',
    choices: ['汗のこと', '悲しいときや嬉しいときに目から出る水', '雨のこと', '水のこと'],
    correctIndex: 1, explanation: '「涙」は悲しいときや嬉しいとき、目からこぼれる水のことです。', grade: 2,
  ),
  VocabQuestion(
    word: '返事', reading: 'へんじ', question: '「返事」ってどういう意味？',
    choices: ['先に話しかけること', '呼ばれたり聞かれたりしたことに答えること', '無視すること', '断ること'],
    correctIndex: 1, explanation: '「返事」は呼ばれたり聞かれたりしたことに答えることです。', grade: 2,
  ),
  // ─── 追加語彙 3年生 ───
  VocabQuestion(
    word: '観点', reading: 'かんてん', question: '「観点」ってどういう意味？',
    choices: ['見た目のこと', '物事を見たり考えたりする立場や角度', '景色のこと', '点数のこと'],
    correctIndex: 1, explanation: '「観点」は物事をどういう立場・角度から見るかということです。', grade: 3,
  ),
  VocabQuestion(
    word: '場面', reading: 'ばめん', question: '「場面」ってどういう意味？',
    choices: ['面積のこと', 'ある時・場所での出来事のひとこま', '地面のこと', '地図のこと'],
    correctIndex: 1, explanation: '「場面」は物語や出来事のある一場面のことです。', grade: 3,
  ),
  VocabQuestion(
    word: '整理', reading: 'せいり', question: '「整理」ってどういう意味？',
    choices: ['散らかすこと', 'ものや考えをきちんと並べてまとめること', '捨てること', '増やすこと'],
    correctIndex: 1, explanation: '「整理」はものや情報をきちんと並べて使いやすくすることです。', grade: 3,
  ),
  VocabQuestion(
    word: '変化', reading: 'へんか', question: '「変化」ってどういう意味？',
    choices: ['変わらないこと', '物事が別の状態に変わること', 'お金のこと', '時間のこと'],
    correctIndex: 1, explanation: '「変化」は物事の状態が別の状態に変わることです。', grade: 3,
  ),
  VocabQuestion(
    word: '原因', reading: 'げんいん', question: '「原因」ってどういう意味？',
    choices: ['結果のこと', 'ある出来事が起こったわけ・もとになること', '目的のこと', '解決策のこと'],
    correctIndex: 1, explanation: '「原因」はある出来事が起こった理由やきっかけのことです。', grade: 3,
  ),
  VocabQuestion(
    word: '様子', reading: 'ようす', question: '「様子」ってどういう意味？',
    choices: ['時間のこと', '物事の見た目や状況', '大きさのこと', '重さのこと'],
    correctIndex: 1, explanation: '「様子」は物事や人の状況・見た目・ありさまのことです。', grade: 3,
  ),
  VocabQuestion(
    word: '関係', reading: 'かんけい', question: '「関係」ってどういう意味？',
    choices: ['無関係のこと', '二つ以上のものがお互いに影響し合うつながり', '距離のこと', '大きさのこと'],
    correctIndex: 1, explanation: '「関係」は人やものがお互いに関わり合っているつながりのことです。', grade: 3,
  ),
  VocabQuestion(
    word: '報告', reading: 'ほうこく', question: '「報告」ってどういう意味？',
    choices: ['隠すこと', '知らせるべきことを相手に伝えること', '叱ること', '忘れること'],
    correctIndex: 1, explanation: '「報告」は調べた結果やことの経過を相手に知らせることです。', grade: 3,
  ),
  VocabQuestion(
    word: '表現', reading: 'ひょうげん', question: '「表現」ってどういう意味？',
    choices: ['隠すこと', '考えや気持ちを言葉・絵・音などで表すこと', '黙ること', '忘れること'],
    correctIndex: 1, explanation: '「表現」は心の中にあることを言葉や絵などで外に出すことです。', grade: 3,
  ),
  VocabQuestion(
    word: '特長', reading: 'とくちょう', question: '「特長」ってどういう意味？',
    choices: ['弱点のこと', 'その人やものが特別に優れている点', '長さのこと', '欠点のこと'],
    correctIndex: 1, explanation: '「特長」はそのものが特に優れた点や特徴のことです。', grade: 3,
  ),
  // ─── 追加語彙 4年生 ───
  VocabQuestion(
    word: '調査', reading: 'ちょうさ', question: '「調査」ってどういう意味？',
    choices: ['片付けること', '物事を詳しく調べること', '忘れること', '諦めること'],
    correctIndex: 1, explanation: '「調査」は事実や状況などを詳しく調べることです。', grade: 4,
  ),
  VocabQuestion(
    word: '主張', reading: 'しゅちょう', question: '「主張」ってどういう意味？',
    choices: ['黙ること', '自分の意見・考えをはっきり述べること', '反省すること', '諦めること'],
    correctIndex: 1, explanation: '「主張」は自分の考えや意見をはっきりと述べることです。', grade: 4,
  ),
  VocabQuestion(
    word: '意見', reading: 'いけん', question: '「意見」ってどういう意味？',
    choices: ['命令のこと', 'ある物事についての自分の考えや判断', '事実のこと', '命令すること'],
    correctIndex: 1, explanation: '「意見」は物事についての自分の考えや判断のことです。', grade: 4,
  ),
  VocabQuestion(
    word: '総合', reading: 'そうごう', question: '「総合」ってどういう意味？',
    choices: ['一つだけ取り出すこと', 'いくつかのものをまとめて一つにすること', 'バラバラにすること', '分けること'],
    correctIndex: 1, explanation: '「総合」はいくつかのものや要素をまとめて全体にすることです。', grade: 4,
  ),
  VocabQuestion(
    word: '向上', reading: 'こうじょう', question: '「向上」ってどういう意味？',
    choices: ['悪くなること', 'より良くなること・レベルが上がること', '変わらないこと', '元に戻ること'],
    correctIndex: 1, explanation: '「向上」は技術や能力などがより良くなることです。', grade: 4,
  ),
  VocabQuestion(
    word: '実験', reading: 'じっけん', question: '「実験」ってどういう意味？',
    choices: ['想像すること', '仮説を確かめるために実際に試してみること', '読むこと', '聞くこと'],
    correctIndex: 1, explanation: '「実験」は考えや仮説が正しいか確かめるために実際に試すことです。', grade: 4,
  ),
  VocabQuestion(
    word: '連携', reading: 'れんけい', question: '「連携」ってどういう意味？',
    choices: ['一人でやること', '複数の人や組織が協力してつながること', '競い合うこと', '別々にやること'],
    correctIndex: 1, explanation: '「連携」は複数の人や組織がつながって協力し合うことです。', grade: 4,
  ),
  VocabQuestion(
    word: '分担', reading: 'ぶんたん', question: '「分担」ってどういう意味？',
    choices: ['一人ですべてやること', '仕事や役割を分けて担うこと', '断ること', '怠けること'],
    correctIndex: 1, explanation: '「分担」は仕事や役割をみんなで分けて受け持つことです。', grade: 4,
  ),
  VocabQuestion(
    word: '共有', reading: 'きょうゆう', question: '「共有」ってどういう意味？',
    choices: ['独占すること', '複数の人で一緒に使ったり持ったりすること', '捨てること', '隠すこと'],
    correctIndex: 1, explanation: '「共有」は複数の人が一緒に使ったり持ったりすることです。', grade: 4,
  ),
  VocabQuestion(
    word: '反省', reading: 'はんせい', question: '「反省」ってどういう意味？',
    choices: ['自慢すること', '自分の行動や考えを振り返り改めること', '繰り返すこと', '無視すること'],
    correctIndex: 1, explanation: '「反省」は自分の言動を振り返り、悪いところを改めようとすることです。', grade: 4,
  ),
  // ─── 追加語彙 5年生 ───
  VocabQuestion(
    word: '展望', reading: 'てんぼう', question: '「展望」ってどういう意味？',
    choices: ['過去を振り返ること', '広く見渡すこと、または将来の見通し', '目を閉じること', '諦めること'],
    correctIndex: 1, explanation: '「展望」は広い視野で将来を見通すことです。', grade: 5,
  ),
  VocabQuestion(
    word: '推測', reading: 'すいそく', question: '「推測」ってどういう意味？',
    choices: ['確かめること', '根拠をもとにおしはかること', '忘れること', '見ること'],
    correctIndex: 1, explanation: '「推測」はいくつかの根拠から、答えをおしはかることです。', grade: 5,
  ),
  VocabQuestion(
    word: '提唱', reading: 'ていしょう', question: '「提唱」ってどういう意味？',
    choices: ['黙ること', '新しい考えや説を唱えること', '反対すること', '従うこと'],
    correctIndex: 1, explanation: '「提唱」は新しい考えや主義を皆の前で唱えることです。', grade: 5,
  ),
  VocabQuestion(
    word: '段階', reading: 'だんかい', question: '「段階」ってどういう意味？',
    choices: ['一度に全部すること', '物事が進む一つひとつの区切りやステップ', '結果のこと', '終わりのこと'],
    correctIndex: 1, explanation: '「段階」は物事が進む際の一つひとつの区切り・ステップのことです。', grade: 5,
  ),
  VocabQuestion(
    word: '循環', reading: 'じゅんかん', question: '「循環」ってどういう意味？',
    choices: ['一度で終わること', 'ぐるぐる回り続けること', '止まること', '一方向にだけ進むこと'],
    correctIndex: 1, explanation: '「循環」はものごとが一定の流れでぐるぐると繰り返されることです。', grade: 5,
  ),
  VocabQuestion(
    word: '持続可能', reading: 'じぞくかのう', question: '「持続可能」ってどういう意味？',
    choices: ['すぐに終わること', '長く続けていけること・維持できること', 'やめること', '変えること'],
    correctIndex: 1, explanation: '「持続可能」は環境や資源を守りながら、ずっと続けられることです。', grade: 5,
  ),
  VocabQuestion(
    word: '協調', reading: 'きょうちょう', question: '「協調」ってどういう意味？',
    choices: ['争うこと', 'お互いに歩み寄り、うまくやっていくこと', '一人で行動すること', '断ること'],
    correctIndex: 1, explanation: '「協調」はお互いに協力し、調和しながらうまく行動することです。', grade: 5,
  ),
  VocabQuestion(
    word: '推進', reading: 'すいしん', question: '「推進」ってどういう意味？',
    choices: ['止めること', '物事を前に進めること・積極的に進めること', '戻すこと', '壊すこと'],
    correctIndex: 1, explanation: '「推進」は物事を積極的に進めていくことです。', grade: 5,
  ),
  VocabQuestion(
    word: '発揮', reading: 'はっき', question: '「発揮」ってどういう意味？',
    choices: ['隠すこと', '持っている力や能力を十分に出すこと', '休むこと', '失うこと'],
    correctIndex: 1, explanation: '「発揮」は持っている力や才能を存分に出すことです。', grade: 5,
  ),
  VocabQuestion(
    word: '原則', reading: 'げんそく', question: '「原則」ってどういう意味？',
    choices: ['例外のこと', '行動の基本となるルールや考え方', '細かい決まりのこと', 'いつでも変えられること'],
    correctIndex: 1, explanation: '「原則」は物事を行うときの基本となるルールや考え方です。', grade: 5,
  ),
  // ─── 追加語彙 6年生 ───
  VocabQuestion(
    word: '奉仕', reading: 'ほうし', question: '「奉仕」ってどういう意味？',
    choices: ['自分のためだけに行動すること', '見返りを求めず人や社会のために尽くすこと', 'お金をもらうこと', '休むこと'],
    correctIndex: 1, explanation: '「奉仕」は報酬を求めず、他の人や社会のために力を尽くすことです。', grade: 6,
  ),
  VocabQuestion(
    word: '変革', reading: 'へんかく', question: '「変革」ってどういう意味？',
    choices: ['変えないこと', '物事を大きく変えること・根本から改めること', '少しだけ変えること', '元に戻すこと'],
    correctIndex: 1, explanation: '「変革」は旧来の仕組みや状況を根本的に大きく変えることです。', grade: 6,
  ),
  VocabQuestion(
    word: '尊厳', reading: 'そんげん', question: '「尊厳」ってどういう意味？',
    choices: ['馬鹿にすること', 'すべての人が持つ尊くて侵されない価値', '威張ること', '批判すること'],
    correctIndex: 1, explanation: '「尊厳」はすべての人間が生まれながらに持つ、尊重されるべき価値のことです。', grade: 6,
  ),
  VocabQuestion(
    word: '国際', reading: 'こくさい', question: '「国際」ってどういう意味？',
    choices: ['国内のこと', '複数の国の間に関係すること', '一つの国だけのこと', '地域のこと'],
    correctIndex: 1, explanation: '「国際」は複数の国の間に関わる事柄のことです。', grade: 6,
  ),
  VocabQuestion(
    word: '持続', reading: 'じぞく', question: '「持続」ってどういう意味？',
    choices: ['すぐやめること', '同じ状態や行動をずっと続けること', '一度だけすること', '変えること'],
    correctIndex: 1, explanation: '「持続」は同じ状態や行動をずっと続けることです。', grade: 6,
  ),
  VocabQuestion(
    word: '発信', reading: 'はっしん', question: '「発信」ってどういう意味？',
    choices: ['受け取ること', '情報や考えを外に向けて送り出すこと', '隠すこと', '黙ること'],
    correctIndex: 1, explanation: '「発信」は自分の情報や考えを外に向けて積極的に伝えることです。', grade: 6,
  ),
  VocabQuestion(
    word: '共存', reading: 'きょうぞん', question: '「共存」ってどういう意味？',
    choices: ['争うこと', '異なるものが一緒に仲良く存在すること', '一方が消えること', '競い合うこと'],
    correctIndex: 1, explanation: '「共存」は異なる存在がお互いを認め合いながら一緒に存在することです。', grade: 6,
  ),
  VocabQuestion(
    word: '道徳', reading: 'どうとく', question: '「道徳」ってどういう意味？',
    choices: ['法律のこと', '人として正しく生きるための行動基準', '罰則のこと', 'ルールを破ること'],
    correctIndex: 1, explanation: '「道徳」は人として正しく行動するための価値観や判断基準です。', grade: 6,
  ),
  VocabQuestion(
    word: '正義', reading: 'せいぎ', question: '「正義」ってどういう意味？',
    choices: ['力のあること', '正しくて公平なこと・道義にかなっていること', '間違いのこと', '弱さのこと'],
    correctIndex: 1, explanation: '「正義」は人として正しく公平であることや、そういう考えのことです。', grade: 6,
  ),
  VocabQuestion(
    word: '倫理', reading: 'りんり', question: '「倫理」ってどういう意味？',
    choices: ['法律のこと', '人がどう生きるべきかについての考え方・道徳的な基準', '規則のこと', '罰則のこと'],
    correctIndex: 1, explanation: '「倫理」は人がどう行動すべきかについての道徳的な考え方です。', grade: 6,
  ),
  // ─── さらに追加 2年生 ───
  VocabQuestion(
    word: '心配', reading: 'しんぱい', question: '「心配」ってどういう意味？',
    choices: ['安心すること', 'うまくいくか不安で気になること', '怒ること', '忘れること'],
    correctIndex: 1, explanation: '「心配」はうまくいくかどうか不安に思う気持ちです。', grade: 2,
  ),
  VocabQuestion(
    word: '失敗', reading: 'しっぱい', question: '「失敗」ってどういう意味？',
    choices: ['成功すること', 'やろうとしたことがうまくいかないこと', '練習すること', '準備すること'],
    correctIndex: 1, explanation: '「失敗」はやろうとしたことがうまくいかなかったことです。', grade: 2,
  ),
  VocabQuestion(
    word: '安心', reading: 'あんしん', question: '「安心」ってどういう意味？',
    choices: ['不安なこと', '心配がなくて気持ちが落ち着くこと', '怖いこと', '焦ること'],
    correctIndex: 1, explanation: '「安心」は心配がなくて気持ちが落ち着いている状態です。', grade: 2,
  ),
  // ─── さらに追加 3年生 ───
  VocabQuestion(
    word: '自信', reading: 'じしん', question: '「自信」ってどういう意味？',
    choices: ['不安なこと', '自分の能力を信じる気持ち', '他人を信じること', '諦める気持ち'],
    correctIndex: 1, explanation: '「自信」は自分の能力や判断を信じる気持ちです。', grade: 3,
  ),
  VocabQuestion(
    word: '速さ', reading: 'はやさ', question: '「速さ」ってどういう意味？',
    choices: ['重さのこと', 'どのくらい速いかという度合い', '大きさのこと', '長さのこと'],
    correctIndex: 1, explanation: '「速さ」はどのくらい速く動くかを表す度合いです。', grade: 3,
  ),
  VocabQuestion(
    word: '協同', reading: 'きょうどう', question: '「協同」ってどういう意味？',
    choices: ['一人でやること', '複数の人が力を合わせて取り組むこと', '競い合うこと', '休むこと'],
    correctIndex: 1, explanation: '「協同」は複数の人が協力して一緒に取り組むことです。', grade: 3,
  ),
  VocabQuestion(
    word: '発表', reading: 'はっぴょう', question: '「発表」ってどういう意味？',
    choices: ['隠すこと', '調べたことや考えを人の前で伝えること', '諦めること', '書くこと'],
    correctIndex: 1, explanation: '「発表」は調べたことや考えを大勢の前で伝えることです。', grade: 3,
  ),
  VocabQuestion(
    word: '比べる', reading: 'くらべる', question: '「比べる」ってどういう意味？',
    choices: ['一つだけ見ること', '二つ以上のものを並べて違いや共通点を調べること', '覚えること', '計算すること'],
    correctIndex: 1, explanation: '「比べる」は二つ以上のものを並べて、違いや共通点を調べることです。', grade: 3,
  ),
  // ─── さらに追加 4年生 ───
  VocabQuestion(
    word: '問題点', reading: 'もんだいてん', question: '「問題点」ってどういう意味？',
    choices: ['良い点のこと', '解決が必要な課題や疑問', '点数のこと', '目標のこと'],
    correctIndex: 1, explanation: '「問題点」は解決しなければならない疑問や課題のことです。', grade: 4,
  ),
  VocabQuestion(
    word: '努力家', reading: 'どりょくか', question: '「努力家」ってどういう意味？',
    choices: ['すぐあきらめる人', 'いつも一生懸命努力する人', '才能がある人', '楽をする人'],
    correctIndex: 1, explanation: '「努力家」はいつも諦めずに一生懸命頑張る人のことです。', grade: 4,
  ),
  VocabQuestion(
    word: '机上', reading: 'きじょう', question: '「机上の空論」の「机上」とはどういう意味？',
    choices: ['実際の現場', '実際には役立たない、頭の中だけの考え', '机の下', '勉強すること'],
    correctIndex: 1, explanation: '「机上」は机の上という意味で、実際には使えない理論のことを「机上の空論」といいます。', grade: 4,
  ),
  VocabQuestion(
    word: '伝達', reading: 'でんたつ', question: '「伝達」ってどういう意味？',
    choices: ['隠すこと', '情報や命令を相手に伝えること', '待つこと', '忘れること'],
    correctIndex: 1, explanation: '「伝達」は情報や命令などを相手にきちんと伝えることです。', grade: 4,
  ),
  // ─── さらに追加 5年生 ───
  VocabQuestion(
    word: '矛盾点', reading: 'むじゅんてん', question: '「矛盾点」ってどういう意味？',
    choices: ['一致している部分', 'つじつまが合わない部分・食い違っているところ', '正しい部分', '良い点'],
    correctIndex: 1, explanation: '「矛盾点」はつじつまが合わない、食い違っている部分のことです。', grade: 5,
  ),
  VocabQuestion(
    word: '客観的', reading: 'きゃっかんてき', question: '「客観的」ってどういう意味？',
    choices: ['自分の気持ちだけで見ること', '個人の感情に左右されず、公平に見ること', '感情的なこと', '主観的なこと'],
    correctIndex: 1, explanation: '「客観的」は個人の感情に左右されず、公平・中立に見ることです。', grade: 5,
  ),
  VocabQuestion(
    word: '根拠', reading: 'こんきょ', question: '「根拠」ってどういう意味？',
    choices: ['感情のこと', '主張や考えを支える理由や証拠', '結果のこと', '想像のこと'],
    correctIndex: 1, explanation: '「根拠」は主張や意見を支えるための理由や証拠のことです。', grade: 5,
  ),
  VocabQuestion(
    word: '積極性', reading: 'せっきょくせい', question: '「積極性」ってどういう意味？',
    choices: ['消極的なこと', '自分から進んでやろうとする性質', '受け身なこと', '諦めること'],
    correctIndex: 1, explanation: '「積極性」は自分から進んで行動しようとする姿勢・性質です。', grade: 5,
  ),
  // ─── さらに追加 6年生 ───
  VocabQuestion(
    word: '連帯', reading: 'れんたい', question: '「連帯」ってどういう意味？',
    choices: ['バラバラになること', '複数の人が目的を共有して結びつくこと', '競い合うこと', '一人でやること'],
    correctIndex: 1, explanation: '「連帯」は複数の人が共通の目的で強く結びつき、協力することです。', grade: 6,
  ),
  VocabQuestion(
    word: '民主主義', reading: 'みんしゅしゅぎ', question: '「民主主義」ってどういう意味？',
    choices: ['一人が決めること', '国民が政治に参加し、主権を持つという考え方', '王様が決めること', '軍が決めること'],
    correctIndex: 1, explanation: '「民主主義」は国民が主権を持ち、政治に参加する考え方です。', grade: 6,
  ),
  VocabQuestion(
    word: '包容力', reading: 'ほうようりょく', question: '「包容力」ってどういう意味？',
    choices: ['厳しくすること', '他の人の欠点や違いを受け入れる、おおらかな心の広さ', '批判すること', '無視すること'],
    correctIndex: 1, explanation: '「包容力」は人の欠点や違いをも受け入れられる、心の広さのことです。', grade: 6,
  ),
  VocabQuestion(
    word: '責任感', reading: 'せきにんかん', question: '「責任感」ってどういう意味？',
    choices: ['他人のせいにする気持ち', '自分の役割・義務を果たそうとする強い気持ち', '逃げる気持ち', '忘れる気持ち'],
    correctIndex: 1, explanation: '「責任感」は自分の役割や義務をしっかり果たそうとする気持ちです。', grade: 6,
  ),
  VocabQuestion(
    word: '革新', reading: 'かくしん', question: '「革新」ってどういう意味？',
    choices: ['変えないこと', '古いものを新しく改め、新しいものを生み出すこと', '守ること', '壊すこと'],
    correctIndex: 1, explanation: '「革新」は古い仕組みや考えを新しく改め、創造することです。', grade: 6,
  ),
  // ─── 最終追加バッチ ───
  VocabQuestion(
    word: '海', reading: 'うみ', question: '「海」ってどういう意味？',
    choices: ['川のこと', '地球上の広大な水の塊', '湖のこと', '池のこと'],
    correctIndex: 1, explanation: '「海」は地球の表面の大部分を占める広大な塩水の水域です。', grade: 1,
  ),
  VocabQuestion(
    word: '雪', reading: 'ゆき', question: '「雪」ってどういう意味？',
    choices: ['雨のこと', '水蒸気が冷えて白い結晶になって空から落ちてくるもの', '霧のこと', '風のこと'],
    correctIndex: 1, explanation: '「雪」は空から降る白くて冷たい氷の結晶です。', grade: 1,
  ),
  VocabQuestion(
    word: '春', reading: 'はる', question: '「春」ってどういう意味？',
    choices: ['夏のこと', '冬のこと', '秋のこと', '桜が咲き、暖かくなる季節'],
    correctIndex: 3, explanation: '「春」は冬が終わり暖かくなって、花が咲き始める季節です。', grade: 1,
  ),
  VocabQuestion(
    word: '夏', reading: 'なつ', question: '「夏」ってどういう意味？',
    choices: ['寒い季節', '1年で最も暑い季節', '花が咲く季節', '葉が落ちる季節'],
    correctIndex: 1, explanation: '「夏」は1年の中で最も気温が高く暑い季節です。', grade: 1,
  ),
  VocabQuestion(
    word: '冬', reading: 'ふゆ', question: '「冬」ってどういう意味？',
    choices: ['最も暑い季節', '花が咲く季節', '1年で最も寒い季節', '緑が多い季節'],
    correctIndex: 2, explanation: '「冬」は1年の中で最も気温が低く寒い季節です。', grade: 1,
  ),
  VocabQuestion(
    word: '工作', reading: 'こうさく', question: '「工作」ってどういう意味？',
    choices: ['掃除すること', '材料を使って物を作ること', '読むこと', '書くこと'],
    correctIndex: 1, explanation: '「工作」は木や紙などの材料を使って物を作ることです。', grade: 2,
  ),
  VocabQuestion(
    word: '根性', reading: 'こんじょう', question: '「根性」ってどういう意味？',
    choices: ['怠け心', '困難に負けない強い精神力', '弱い気持ち', '逃げる気持ち'],
    correctIndex: 1, explanation: '「根性」は苦しくても諦めない、強い精神力のことです。', grade: 3,
  ),
  VocabQuestion(
    word: '実力', reading: 'じつりょく', question: '「実力」ってどういう意味？',
    choices: ['見せかけの力', '実際に持っている本当の能力', '練習の結果', '運のこと'],
    correctIndex: 1, explanation: '「実力」は実際に持っている、本当の能力や力のことです。', grade: 3,
  ),
  VocabQuestion(
    word: '感情', reading: 'かんじょう', question: '「感情」ってどういう意味？',
    choices: ['考えること', '喜び・悲しみ・怒り・恐れなどの心の動き', '行動すること', '記憶すること'],
    correctIndex: 1, explanation: '「感情」は喜び・悲しみ・怒り・恐れなどの心の動きです。', grade: 3,
  ),
  VocabQuestion(
    word: '確認', reading: 'かくにん', question: '「確認」ってどういう意味？',
    choices: ['忘れること', 'ことがらが正しいかどうか確かめること', '想像すること', '作ること'],
    correctIndex: 1, explanation: '「確認」は物事が正しいか、間違いがないか確かめることです。', grade: 4,
  ),
  VocabQuestion(
    word: '保護', reading: 'ほご', question: '「保護」ってどういう意味？',
    choices: ['傷つけること', '守って危険から遠ざけること', '無視すること', '批判すること'],
    correctIndex: 1, explanation: '「保護」は危険や害から守ることです。', grade: 4,
  ),
  VocabQuestion(
    word: '優先', reading: 'ゆうせん', question: '「優先」ってどういう意味？',
    choices: ['後回しにすること', '他のものより先に扱うこと', '同じ順番にすること', '遅らせること'],
    correctIndex: 1, explanation: '「優先」は他よりも先に扱うことです。', grade: 4,
  ),
  VocabQuestion(
    word: '推論', reading: 'すいろん', question: '「推論」ってどういう意味？',
    choices: ['確かめること', '情報をもとに論理的に考えて結論を出すこと', '感じること', '見ること'],
    correctIndex: 1, explanation: '「推論」はある情報をもとに論理的に考えて結論を導くことです。', grade: 5,
  ),
  VocabQuestion(
    word: '仮説', reading: 'かせつ', question: '「仮説」ってどういう意味？',
    choices: ['確実な事実', 'まだ証明されていない、仮の説明や考え', 'すでに証明された理論', '間違いのこと'],
    correctIndex: 1, explanation: '「仮説」はまだ証明されていない、仮に立てた説明や考えです。', grade: 5,
  ),
  VocabQuestion(
    word: '検証', reading: 'けんしょう', question: '「検証」ってどういう意味？',
    choices: ['想像すること', '事実や主張が正しいかどうか実際に確かめること', '黙ること', '断ること'],
    correctIndex: 1, explanation: '「検証」は主張や事実が正しいかどうか調べて確かめることです。', grade: 5,
  ),
  VocabQuestion(
    word: '貢献度', reading: 'こうけんど', question: '「貢献度」ってどういう意味？',
    choices: ['サボった量', 'どれだけ役に立ったかという度合い', '評価のこと', '失敗の度合い'],
    correctIndex: 1, explanation: '「貢献度」は社会や組織に対してどれほど役立ったかを表す度合いです。', grade: 5,
  ),
  VocabQuestion(
    word: '主権', reading: 'しゅけん', question: '「主権」ってどういう意味？',
    choices: ['他の国に従うこと', '国を治める最高の権力・または国民が持つ権力', '弱い権利のこと', '地方の権利のこと'],
    correctIndex: 1, explanation: '「主権」は国の政治を決める最高の権力で、民主主義では国民が持ちます。', grade: 6,
  ),
  VocabQuestion(
    word: '批評', reading: 'ひひょう', question: '「批評」ってどういう意味？',
    choices: ['ほめるだけ', '物事の良し悪しを考えて意見や評価を述べること', '無視すること', '感じること'],
    correctIndex: 1, explanation: '「批評」は物事をよく考えて、良い点・悪い点を述べることです。', grade: 6,
  ),
  VocabQuestion(
    word: '継続性', reading: 'けいぞくせい', question: '「継続性」ってどういう意味？',
    choices: ['すぐやめること', 'ずっと続けられる性質', '変化すること', '一度だけのこと'],
    correctIndex: 1, explanation: '「継続性」は物事をずっと続けられる性質のことです。', grade: 6,
  ),
  VocabQuestion(
    word: '共感', reading: 'きょうかん', question: '「共感」ってどういう意味？',
    choices: ['無視すること', '他人の気持ちや考えを自分のこととして感じること', '反対すること', '批判すること'],
    correctIndex: 1, explanation: '「共感」は他の人の感じ方や考えを自分のことのように感じることです。', grade: 6,
  ),

  // ─── 追加語彙：生活・感情・道徳 ───
  VocabQuestion(
    word: '挨拶', reading: 'あいさつ', question: '「挨拶」ってどういう意味？',
    choices: ['叱ること', '人に会ったときに言葉や行動で礼儀を示すこと', '贈り物をすること', '命令すること'],
    correctIndex: 1, explanation: '「挨拶」は「おはよう」「こんにちは」など、人に会ったときに礼儀を示すことです。', grade: 2,
  ),
  VocabQuestion(
    word: '規則', reading: 'きそく', question: '「規則」ってどういう意味？',
    choices: ['自由に決めること', '守るべき決まりやルール', '感想のこと', '願いのこと'],
    correctIndex: 1, explanation: '「規則」はみんなが守るべき決まりやルールのことです。', grade: 3,
  ),
  VocabQuestion(
    word: '緊張', reading: 'きんちょう', question: '「緊張」ってどういう意味？',
    choices: ['リラックスすること', '心や体がこわばって落ち着かない状態', '眠ること', '笑うこと'],
    correctIndex: 1, explanation: '「緊張」は心や体がこわばって、落ち着かない状態のことです。', grade: 3,
  ),
  VocabQuestion(
    word: '感謝', reading: 'かんしゃ', question: '「感謝」ってどういう意味？',
    choices: ['怒ること', 'ありがたいと思う気持ち・お礼の気持ち', '忘れること', '無視すること'],
    correctIndex: 1, explanation: '「感謝」は人からしてもらったことを「ありがたい」と思う気持ちです。', grade: 2,
  ),
  VocabQuestion(
    word: '協力', reading: 'きょうりょく', question: '「協力」ってどういう意味？',
    choices: ['一人でやること', '力を合わせて一緒に取り組むこと', '争うこと', '邪魔すること'],
    correctIndex: 1, explanation: '「協力」はみんなで力を合わせて一緒に取り組むことです。', grade: 3,
  ),
  VocabQuestion(
    word: '誠実', reading: 'せいじつ', question: '「誠実」ってどういう意味？',
    choices: ['うそをつくこと', '正直で、まじめに物事に取り組む様子', '自慢すること', 'さぼること'],
    correctIndex: 1, explanation: '「誠実」は正直で、まじめに人や物事に向き合う様子のことです。', grade: 4,
  ),
  VocabQuestion(
    word: '思いやり', reading: 'おもいやり', question: '「思いやり」ってどういう意味？',
    choices: ['自分だけ考えること', '相手の気持ちを想像して親切にすること', '競争すること', '批判すること'],
    correctIndex: 1, explanation: '「思いやり」は相手の気持ちや状況を想像して、親切にすることです。', grade: 2,
  ),
  VocabQuestion(
    word: '反省', reading: 'はんせい', question: '「反省」ってどういう意味？',
    choices: ['ほめること', '自分の行動を振り返って悪かったところを考えること', '繰り返すこと', '楽しむこと'],
    correctIndex: 1, explanation: '「反省」は自分のしたことを振り返り、良くなかったところを直そうと考えることです。', grade: 3,
  ),
  VocabQuestion(
    word: '役割', reading: 'やくわり', question: '「役割」ってどういう意味？',
    choices: ['遊びの種類', 'その人が担当する仕事や責任', '休む理由', '食事のこと'],
    correctIndex: 1, explanation: '「役割」はその人が担当する仕事や、果たすべき責任のことです。', grade: 4,
  ),
  VocabQuestion(
    word: '平和', reading: 'へいわ', question: '「平和」ってどういう意味？',
    choices: ['戦争が起きている状態', '争いや戦争がなく、穏やかな状態', '混乱すること', '対立すること'],
    correctIndex: 1, explanation: '「平和」は争いや戦争がなく、穏やかで安定した状態のことです。', grade: 3,
  ),
  VocabQuestion(
    word: '自信', reading: 'じしん', question: '「自信」ってどういう意味？',
    choices: ['自分を信じられない気持ち', '自分の力や行動を信じる気持ち', '他人を褒めること', '勉強すること'],
    correctIndex: 1, explanation: '「自信」は自分の力や行動に対して「きっとできる」と信じる気持ちです。', grade: 3,
  ),
  VocabQuestion(
    word: '想像', reading: 'そうぞう', question: '「想像」ってどういう意味？',
    choices: ['実際に見ること', '頭の中でいろいろなことを思い描くこと', '記録すること', '計算すること'],
    correctIndex: 1, explanation: '「想像」は実際には見ていないことを頭の中で思い描くことです。', grade: 3,
  ),
  VocabQuestion(
    word: '希望', reading: 'きぼう', question: '「希望」ってどういう意味？',
    choices: ['悲しむこと', '将来こうなりたいという望みや願い', '諦めること', '記録すること'],
    correctIndex: 1, explanation: '「希望」は将来こうありたい、こうなりたいという望みや願いのことです。', grade: 3,
  ),
  VocabQuestion(
    word: '表現', reading: 'ひょうげん', question: '「表現」ってどういう意味？',
    choices: ['隠すこと', '気持ちや考えを言葉・絵・動作などで表すこと', '計算すること', '解くこと'],
    correctIndex: 1, explanation: '「表現」は気持ちや考えを、言葉・絵・音楽・動作などで表すことです。', grade: 4,
  ),
  VocabQuestion(
    word: '環境', reading: 'かんきょう', question: '「環境」ってどういう意味？',
    choices: ['学校のこと', '人や生き物を取り囲む外側の状況や条件', '友達のこと', '食べ物のこと'],
    correctIndex: 1, explanation: '「環境」は人や生き物の周りにある、生活に影響する自然や社会の状況のことです。', grade: 4,
  ),
];

// ランタイム問題クラス（選択肢シャッフル済み）
class _RuntimeVQ {
  final VocabQuestion original;
  final List<String> shuffledChoices;
  final int shuffledCorrectIndex;

  _RuntimeVQ({
    required this.original,
    required this.shuffledChoices,
    required this.shuffledCorrectIndex,
  });

  static _RuntimeVQ from(VocabQuestion q) {
    final correct = q.choices[q.correctIndex];
    final shuffled = List.of(q.choices)..shuffle(math.Random());
    return _RuntimeVQ(
      original: q,
      shuffledChoices: shuffled,
      shuffledCorrectIndex: shuffled.indexOf(correct),
    );
  }
}

const _questionsPerRound = 10;

class VocabularyScreen extends ConsumerStatefulWidget {
  const VocabularyScreen({super.key});

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen>
    with SingleTickerProviderStateMixin {
  List<_RuntimeVQ> _round = [];
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _score = 0;
  bool _finished = false;
  late AnimationController _feedbackCtrl;
  late Animation<double> _feedbackAnim;

  _RuntimeVQ get _current => _round.isEmpty ? _RuntimeVQ.from(_vocabQuestions[0]) : _round[_currentIndex];
  bool get _isCorrect => _selectedAnswer == _current.shuffledCorrectIndex;

  List<_RuntimeVQ> _buildQueue(VocabMasteryState mastery) {
    final unmastered = _vocabQuestions
        .where((q) => !mastery.isMastered(q.word))
        .toList();
    final pool = unmastered.isEmpty ? List.of(_vocabQuestions) : unmastered;
    pool.shuffle(math.Random());
    pool.sort((a, b) => a.grade.compareTo(b.grade));
    pool.shuffle(math.Random());
    pool.sort((a, b) => a.grade.compareTo(b.grade));
    return pool.take(_questionsPerRound).map(_RuntimeVQ.from).toList();
  }

  @override
  void initState() {
    super.initState();
    _feedbackCtrl = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _feedbackAnim = CurvedAnimation(parent: _feedbackCtrl, curve: Curves.elasticOut);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mastery = ref.read(vocabMasteryProvider);
      setState(() => _round = _buildQueue(mastery));
    });
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
      if (_isCorrect) {
        _score++;
        ref.read(vocabMasteryProvider.notifier).recordCorrect(_current.original.word);
      }
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
    final mastery = ref.read(vocabMasteryProvider);
    setState(() {
      _round = _buildQueue(mastery);
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

    final total = _round.isEmpty ? 1 : _round.length;
    final masteryState = ref.watch(vocabMasteryProvider);
    final masteredCount = _vocabQuestions.where((q) => masteryState.isMastered(q.word)).length;
    final progress = total == 0 ? 0.0 : (_currentIndex + (_answered ? 1 : 0)) / total;

    return Scaffold(
      appBar: AppBar(
        title: Text('ことば (マスター済: $masteredCount / ${_vocabQuestions.length})'),
        backgroundColor: kAccentOrange,
        automaticallyImplyLeading: false,
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
                  _buildWordCard(),
                  const SizedBox(height: 20),
                  ...List.generate(_current.shuffledChoices.length, (i) {
                    return _VocabChoiceButton(
                      text: _current.shuffledChoices[i],
                      index: i,
                      selected: _selectedAnswer,
                      correct: _answered ? _current.shuffledCorrectIndex : null,
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
                        backgroundColor: _isCorrect ? kAccentGreen : kAccentOrange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        _currentIndex < total - 1 ? '次へ →' : '結果を見る！',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
              Text(
                '問題 $current / $total',
                style: const TextStyle(color: kTextMuted, fontSize: 12),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: kAccentOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(kAccentOrange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard() {
    final q = _current.original;
    final gradeGroup = gradeGroupOf(q.grade);
    final gc = gradeColor(gradeGroup);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: gc.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${q.grade}年生',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: gc,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            q.word,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: kTextDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            q.reading,
            style: const TextStyle(fontSize: 16, color: kTextMuted),
          ),
          const SizedBox(height: 16),
          Text(
            q.question,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: kTextDark,
            ),
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
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _current.original.explanation,
            style: const TextStyle(fontSize: 14, color: kTextDark, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final total = _round.isEmpty ? 1 : _round.length;
    final pct = (_score / total * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ことば'),
        backgroundColor: kAccentOrange,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                pct >= 80 ? '🎉' : pct >= 50 ? '😊' : '😅',
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),
              const Text(
                '結果',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$_score / $total 問正解',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: kAccentOrange,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$pct%',
                style: const TextStyle(fontSize: 20, color: kTextMuted),
              ),
              const SizedBox(height: 24),
              Text(
                pct >= 80
                    ? 'すばらしい！言葉の達人だね！'
                    : pct >= 50
                        ? 'よくがんばったね！もう一度チャレンジ！'
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
                    backgroundColor: kAccentOrange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'もう一度チャレンジ！',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kAccentOrange),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'メニューに戻る',
                    style: TextStyle(fontSize: 16, color: kAccentOrange),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VocabChoiceButton extends StatelessWidget {
  final String text;
  final int index;
  final int? selected;
  final int? correct;
  final VoidCallback onTap;

  const _VocabChoiceButton({
    required this.text,
    required this.index,
    required this.selected,
    required this.correct,
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
      borderColor = kAccentOrange;
      bgColor = kAccentOrange.withAlpha(20);
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
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (trailingIcon != null) trailingIcon,
            ],
          ),
        ),
      ),
    );
  }
}
