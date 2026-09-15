import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/premium_provider.dart';

import '../services/ad_service.dart';
import '../theme/app_theme.dart';
import 'proverb_quiz_screen.dart' show QuizChoiceButton;

class IdiomQuestion {
  final String idiom;

  final String reading;
  final String question;
  final List<String> choices;
  final int correctIndex;
  final String explanation;

  const IdiomQuestion({
    required this.idiom,
    required this.reading,
    required this.question,
    required this.choices,
    required this.correctIndex,
    required this.explanation,
  });
}

const _idiomQuestions = [
  IdiomQuestion(
    idiom: '頭が上がらない',
    reading: 'あたまがあがらない',
    question: 'この慣用句の意味は？',
    choices: ['頭が重い', 'かなわないほど感謝していること', '頭を低くすること', '頭が痛い'],
    correctIndex: 1,
    explanation: '感謝していて、対等に向き合えないということです。',
  ),
  IdiomQuestion(
    idiom: '骨を折る',
    reading: 'ほねをおる',
    question: 'この慣用句の意味は？',
    choices: ['骨が折れてしまう', '疲れること', 'たいへん苦労すること', '骨折りをすること'],
    correctIndex: 2,
    explanation: '一生懸命苦労して取り組むことをいいます。',
  ),
  IdiomQuestion(
    idiom: '手を貸す',
    reading: 'てをかす',
    question: 'この慣用句の意味は？',
    choices: ['手をかりる', '助けること', '手を差し出す', '手をつなぐ'],
    correctIndex: 1,
    explanation: '困っている人の手伝いをすることです。',
  ),
  IdiomQuestion(
    idiom: '口が固い',
    reading: 'くちがかたい',
    question: 'この慣用句の意味は？',
    choices: ['口が開かない', '話すのが苦手', '秘密を守ること', '硬い食べ物が好き'],
    correctIndex: 2,
    explanation: '秘密や話を外に漏らさないという意味です。',
  ),
  IdiomQuestion(
    idiom: '目を丸くする',
    reading: 'めをまるくする',
    question: 'この慣用句の意味は？',
    choices: ['目を大きくする', 'とても驚くこと', '目が丸い形', '目を細める'],
    correctIndex: 1,
    explanation: '驚いたときに目が大きく丸くなることから来ています。',
  ),
  IdiomQuestion(
    idiom: '足を引っ張る',
    reading: 'あしをひっぱる',
    question: 'この慣用句の意味は？',
    choices: ['足を引っ張って遊ぶ', '人の邪魔をすること', '足が遅いこと', '走るのをやめさせる'],
    correctIndex: 1,
    explanation: '他の人の活動や進歩の邪魔をすることです。',
  ),
  IdiomQuestion(
    idiom: '耳を傾ける',
    reading: 'みみをかたむける',
    question: 'この慣用句の意味は？',
    choices: ['耳が曲がる', 'よく聞くこと', '耳が痛い', '耳を動かす'],
    correctIndex: 1,
    explanation: '注意深く聞くこと、真剣に聞くことです。',
  ),
  IdiomQuestion(
    idiom: '肩の荷が下りる',
    reading: 'かたのにがおりる',
    question: 'この慣用句の意味は？',
    choices: ['荷物を下ろす', '体が楽になる', '心配がなくなって気が楽になること', '肩が痛くなくなる'],
    correctIndex: 2,
    explanation: '重い責任や心配事がなくなって、気が楽になることです。',
  ),
  IdiomQuestion(
    idiom: '腹を割る',
    reading: 'はらをわる',
    question: 'この慣用句の意味は？',
    choices: ['お腹を開ける', '本音で話し合うこと', 'お腹がすくこと', '怒ること'],
    correctIndex: 1,
    explanation: 'かくし立てせずに、本当の気持ちを正直に話し合うことです。',
  ),
  IdiomQuestion(
    idiom: '気が置けない',
    reading: 'きがおけない',
    question: 'この慣用句の意味は？',
    choices: ['気をつけなくていい', '気を使わなくてよいこと', '気持ちが落ち着かない', '気が短いこと'],
    correctIndex: 1,
    explanation: '遠慮したり気を使ったりしなくていい、心から打ち解けられる仲のことです。',
  ),
  IdiomQuestion(
    idiom: '二の足を踏む',
    reading: 'にのあしをふむ',
    question: 'この慣用句の意味は？',
    choices: ['二歩だけ歩く', 'ためらってなかなか進めないこと', '足が痛い', '二人で歩くこと'],
    correctIndex: 1,
    explanation: '決断できずに、ためらって前に進めないことです。',
  ),
  IdiomQuestion(
    idiom: '顔から火が出る',
    reading: 'かおからひがでる',
    question: 'この慣用句の意味は？',
    choices: ['熱が出る', 'とても恥ずかしいこと', '顔が赤くなる病気', '顔が熱い'],
    correctIndex: 1,
    explanation: 'とても恥ずかしくて、顔が真っ赤になることをいいます。',
  ),
  IdiomQuestion(
    idiom: '胸を張る',
    reading: 'むねをはる',
    question: 'この慣用句の意味は？',
    choices: ['胸を広げる', '自信を持って堂々とすること', '胸が痛い', '胸を叩く'],
    correctIndex: 1,
    explanation: '誇りを持ち、自信をもって堂々とした態度をとることです。',
  ),
  IdiomQuestion(
    idiom: '水に流す',
    reading: 'みずにながす',
    question: 'この慣用句の意味は？',
    choices: ['川に流す', '過去のことをなかったことにする', '水で洗う', '流れに乗る'],
    correctIndex: 1,
    explanation: '過去のいざこざや恨みなどをすべて忘れて、許すことです。',
  ),
  IdiomQuestion(
    idiom: '猫の手も借りたい',
    reading: 'ねこのてもかりたい',
    question: 'この慣用句の意味は？',
    choices: ['猫が好き', 'とても忙しくて誰でも手伝ってほしいこと', '猫を飼いたい', '手がない'],
    correctIndex: 1,
    explanation: 'あまりにも忙しくて、誰でも助けてほしいという状態です。',
  ),
  // 追加慣用句
  IdiomQuestion(
    idiom: '目から鱗が落ちる',
    reading: 'めからうろこがおちる',
    question: 'この慣用句の意味は？',
    choices: ['目が痛い', 'あることをきっかけに、急に物事がよく理解できるようになること', '目が良くなる', '魚を食べる'],
    correctIndex: 1,
    explanation: 'それまでわからなかったことが、急によくわかるようになることです。',
  ),
  IdiomQuestion(
    idiom: '腕を磨く',
    reading: 'うでをみがく',
    question: 'この慣用句の意味は？',
    choices: ['腕の傷を治す', '技術や能力を高めるために努力すること', '腕を洗う', '腕が光る'],
    correctIndex: 1,
    explanation: '技術や腕前を上げるために一生懸命練習・努力することです。',
  ),
  IdiomQuestion(
    idiom: '鼻が高い',
    reading: 'はながたかい',
    question: 'この慣用句の意味は？',
    choices: ['鼻が大きい', '誇りを持って得意になること', '鼻が長い', '高いところにいる'],
    correctIndex: 1,
    explanation: '自慢できることがあって、得意になっていることです。',
  ),
  IdiomQuestion(
    idiom: '口がうまい',
    reading: 'くちがうまい',
    question: 'この慣用句の意味は？',
    choices: ['食べ物がうまい', '言葉巧みに人をあやつること', '話すのが得意', '口が達者'],
    correctIndex: 1,
    explanation: '言葉巧みに人を説得したり、おべっかを言うのが上手なことです。',
  ),
  IdiomQuestion(
    idiom: '耳が痛い',
    reading: 'みみがいたい',
    question: 'この慣用句の意味は？',
    choices: ['耳が病気', '自分の弱点を突かれて聞くのがつらいこと', '音がうるさい', '耳の調子が悪い'],
    correctIndex: 1,
    explanation: '自分の欠点や失敗をずばり言われて、聞くのがつらいことです。',
  ),
  IdiomQuestion(
    idiom: '胸がいっぱい',
    reading: 'むねがいっぱい',
    question: 'この慣用句の意味は？',
    choices: ['食べすぎた', '感動や喜びで心があふれること', '胸が重い', '心が満腹'],
    correctIndex: 1,
    explanation: '感動や喜び・悲しみなどで、心があふれんばかりになることです。',
  ),
  IdiomQuestion(
    idiom: '腹が立つ',
    reading: 'はらがたつ',
    question: 'この慣用句の意味は？',
    choices: ['お腹が痛い', '怒ること', 'お腹が空く', 'お腹が動く'],
    correctIndex: 1,
    explanation: '怒りを感じることです。腹は昔から感情の中心と考えられていました。',
  ),
  IdiomQuestion(
    idiom: '気が短い',
    reading: 'きがみじかい',
    question: 'この慣用句の意味は？',
    choices: ['気分がよくない', 'すぐに怒りやすいこと', '集中力がない', '気持ちが小さい'],
    correctIndex: 1,
    explanation: 'ちょっとしたことですぐにイライラして怒りやすいことです。',
  ),
  IdiomQuestion(
    idiom: '頭が切れる',
    reading: 'あたまがきれる',
    question: 'この慣用句の意味は？',
    choices: ['頭が痛い', '頭が良くて、素早く考えられること', '頭を使いすぎ', '切れ者'],
    correctIndex: 1,
    explanation: '頭が良くて、ものごとを素早く判断・理解できることです。',
  ),
  IdiomQuestion(
    idiom: '手を抜く',
    reading: 'てをぬく',
    question: 'この慣用句の意味は？',
    choices: ['手を引っこ抜く', '手が空く', 'いい加減にやること・手を省くこと', '手術をする'],
    correctIndex: 2,
    explanation: 'やるべきことをちゃんとやらず、いい加減にすませることです。',
  ),
  IdiomQuestion(
    idiom: '足が棒になる',
    reading: 'あしがぼうになる',
    question: 'この慣用句の意味は？',
    choices: ['足が怪我をする', '歩きすぎて足がひどく疲れること', '足が硬くなる', '棒を持って歩く'],
    correctIndex: 1,
    explanation: 'たくさん歩いたりして、足がひどく疲れてしまうことです。',
  ),
  IdiomQuestion(
    idiom: '目が届く',
    reading: 'めがとどく',
    question: 'この慣用句の意味は？',
    choices: ['目が遠くまで見える', '細かいところまで注意が行き届くこと', '目線が届く', '監視すること'],
    correctIndex: 1,
    explanation: '細かいところまで注意して、ちゃんと見ていることです。',
  ),
  IdiomQuestion(
    idiom: '口をはさむ',
    reading: 'くちをはさむ',
    question: 'この慣用句の意味は？',
    choices: ['口で挟む', '人の会話に割り込んで口を出すこと', '口を閉じる', '話を聞く'],
    correctIndex: 1,
    explanation: '他人の会話に割り込んで、自分の意見を言うことです。',
  ),
  IdiomQuestion(
    idiom: '気が長い',
    reading: 'きがながい',
    question: 'この慣用句の意味は？',
    choices: ['気持ちが続く', '辛抱強くじっくり待てること', '気分が良い', '長く考える'],
    correctIndex: 1,
    explanation: 'イライラせずに、じっくり辛抱強く待つことができることです。',
  ),
  IdiomQuestion(
    idiom: '肩を並べる',
    reading: 'かたをならべる',
    question: 'この慣用句の意味は？',
    choices: ['肩を寄せ合う', '同じくらいの力や地位になること', '肩を並べて歩く', '肩が同じ高さになる'],
    correctIndex: 1,
    explanation: '同じくらいの実力や立場になることを表します。',
  ),
  IdiomQuestion(
    idiom: '首を縦に振る',
    reading: 'くびをたてにふる',
    question: 'この慣用句の意味は？',
    choices: ['首を動かす', '賛成・承諾すること', '首を横に振る反対', '首が疲れる'],
    correctIndex: 1,
    explanation: 'うなずくことで、賛成・承諾することを表します。',
  ),
  IdiomQuestion(
    idiom: '腰が重い',
    reading: 'こしがおもい',
    question: 'この慣用句の意味は？',
    choices: ['腰が痛い', 'なかなか行動しようとしないこと', '腰が疲れている', '体が重い'],
    correctIndex: 1,
    explanation: 'なかなか動き出せず、行動するのが遅いことです。',
  ),
  IdiomQuestion(
    idiom: '胸を打つ',
    reading: 'むねをうつ',
    question: 'この慣用句の意味は？',
    choices: ['胸を叩く', '心に強く感動を与えること', '胸が痛い', '胸を押す'],
    correctIndex: 1,
    explanation: 'とても感動的で、心に強く響くことです。',
  ),
  IdiomQuestion(
    idiom: '顔が広い',
    reading: 'かおがひろい',
    question: 'この慣用句の意味は？',
    choices: ['顔が大きい', '知り合いが多く、人脈があること', '顔が見える範囲が広い', '顔が平べったい'],
    correctIndex: 1,
    explanation: '知り合いが多く、いろんな人とのつながりがあることです。',
  ),
  IdiomQuestion(
    idiom: '首が回らない',
    reading: 'くびがまわらない',
    question: 'この慣用句の意味は？',
    choices: ['首が痛い', '借金が多くて生活が苦しいこと', '首が曲がらない', '首を動かせない'],
    correctIndex: 1,
    explanation: '負債や借金などがあって、身動きが取れないほど苦しい状況です。',
  ),
  IdiomQuestion(
    idiom: '手を焼く',
    reading: 'てをやく',
    question: 'この慣用句の意味は？',
    choices: ['手が火傷をする', '手がかかって困ること', '料理をする', '手が熱い'],
    correctIndex: 1,
    explanation: 'うまく扱えずに困ることや、手がかかって苦労することです。',
  ),
  IdiomQuestion(
    idiom: '目を光らせる',
    reading: 'めをひからせる',
    question: 'この慣用句の意味は？',
    choices: ['目が光る病気', '鋭く監視・注意すること', '目が輝く', '目が眩しい'],
    correctIndex: 1,
    explanation: '鋭い目つきで注意深く見張ることです。',
  ),
  IdiomQuestion(
    idiom: '気が合う',
    reading: 'きがあう',
    question: 'この慣用句の意味は？',
    choices: ['気分が一致する', '性格や考え方が似ていて、仲良くなれること', '気持ちが合わさる', '相性が良い'],
    correctIndex: 1,
    explanation: '性格や好みが似ていて、一緒にいると居心地が良い関係です。',
  ),
  IdiomQuestion(
    idiom: '手が空く',
    reading: 'てがあく',
    question: 'この慣用句の意味は？',
    choices: ['手が開く', '仕事が終わってひまになること', '手が軽くなる', '手が空っぽ'],
    correctIndex: 1,
    explanation: '仕事や作業が終わって、時間に余裕ができることです。',
  ),
  IdiomQuestion(
    idiom: '肝が据わる',
    reading: 'きもがすわる',
    question: 'この慣用句の意味は？',
    choices: ['肝臓が丈夫', '何があっても動じない、度胸があること', '肝が強い', '落ち着いている'],
    correctIndex: 1,
    explanation: 'どんな困難な場面でも、動じることなく落ち着いていられることです。',
  ),
  IdiomQuestion(
    idiom: '目鼻がつく',
    reading: 'めはながつく',
    question: 'この慣用句の意味は？',
    choices: ['顔の形ができる', '物事の見通しや方向性が決まること', '目と鼻が近い', '物事が始まる'],
    correctIndex: 1,
    explanation: 'まだ形になっていないものが、だんだん形になってきて見通しが立つことです。',
  ),
  IdiomQuestion(
    idiom: '頭を抱える',
    reading: 'あたまをかかえる',
    question: 'この慣用句の意味は？',
    choices: ['頭が痛い', '悩んで困ること', '頭を守る', '深く考える'],
    correctIndex: 1,
    explanation: '難しい問題や悩みで、どうすればいいかわからず困ることです。',
  ),
  IdiomQuestion(
    idiom: '目をかける',
    reading: 'めをかける',
    question: 'この慣用句の意味は？',
    choices: ['目を閉じる', '特別に目をかけて世話をすること', '目が届く', '眼鏡をかける'],
    correctIndex: 1,
    explanation: '目をかけて面倒を見ること、特別に引き立てることです。',
  ),
  IdiomQuestion(
    idiom: '声を大にする',
    reading: 'こえをおおにする',
    question: 'この慣用句の意味は？',
    choices: ['大声で話す', '強く主張すること・はっきり言うこと', '声が大きい', '叫ぶ'],
    correctIndex: 1,
    explanation: '強く主張したり、はっきりと声に出して言うことです。',
  ),
  IdiomQuestion(
    idiom: '手放しで喜ぶ',
    reading: 'てばなしでよろこぶ',
    question: 'この慣用句の意味は？',
    choices: ['手を放して喜ぶ', '何のためらいもなく、純粋に喜ぶこと', '拍手して喜ぶ', '遠慮なく喜ぶ'],
    correctIndex: 1,
    explanation: '遠慮やためらいがなく、素直に喜ぶことです。',
  ),
  IdiomQuestion(
    idiom: '目に余る',
    reading: 'めにあまる',
    question: 'この慣用句の意味は？',
    choices: ['目がひどく疲れる', 'あまりにもひどくて見ていられないこと', '目が余分にある', '目を使いすぎ'],
    correctIndex: 1,
    explanation: 'あまりにもひどすぎて、見ていられないほどであることです。',
  ),
  IdiomQuestion(
    idiom: '足を洗う',
    reading: 'あしをあらう',
    question: 'この慣用句の意味は？',
    choices: ['足をきれいにする', '悪い仕事や付き合いをやめること', '足を清める', '清潔にする'],
    correctIndex: 1,
    explanation: '悪い世界や仕事から足を洗って、きっぱり縁を切ることです。',
  ),
  IdiomQuestion(
    idiom: '骨身を惜しまず',
    reading: 'ほねみをおしまず',
    question: 'この慣用句の意味は？',
    choices: ['骨を大切に', '自分の体を惜しまず、一生懸命に努力すること', '骨が折れる', '身を削る'],
    correctIndex: 1,
    explanation: '体が疲れることも気にせず、一生懸命に頑張ることです。',
  ),
  IdiomQuestion(
    idiom: '口を割る',
    reading: 'くちをわる',
    question: 'この慣用句の意味は？',
    choices: ['口を怪我する', '秘密や隠していることを白状すること', '口が開く', '話し合いをする'],
    correctIndex: 1,
    explanation: '隠していたことや秘密を、しゃべってしまうことです。',
  ),
  IdiomQuestion(
    idiom: '腕が鳴る',
    reading: 'うでがなる',
    question: 'この慣用句の意味は？',
    choices: ['腕が骨折する', '実力を発揮したくて意気込むこと', '腕が疲れる', '腕を動かす'],
    correctIndex: 1,
    explanation: '自分の腕前を見せたくて、うずうず張り切っていることです。',
  ),
];

// ランタイム問題クラス（選択肢シャッフル済み）
class _RuntimeQ {
  final String idiom;
  final String reading;
  final String question;
  final List<String> choices;
  final int correctIndex;
  final String explanation;

  _RuntimeQ({
    required this.idiom,
    required this.reading,
    required this.question,
    required this.choices,
    required this.correctIndex,
    required this.explanation,
  });

  static _RuntimeQ from(IdiomQuestion q) {
    final correct = q.choices[q.correctIndex];
    final shuffled = List.of(q.choices)..shuffle(math.Random());
    return _RuntimeQ(
      idiom: q.idiom,
      reading: q.reading,
      question: q.question,
      choices: shuffled,
      correctIndex: shuffled.indexOf(correct),
      explanation: q.explanation,
    );
  }
}

const _questionsPerRound = 10;

class IdiomQuizScreen extends ConsumerStatefulWidget {
  const IdiomQuizScreen({super.key});

  @override
  ConsumerState<IdiomQuizScreen> createState() => _IdiomQuizScreenState();
}

class _IdiomQuizScreenState extends ConsumerState<IdiomQuizScreen>
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
    final pool = List.of(_idiomQuestions)..shuffle(math.Random());
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
        title: const Text('慣用句クイズ'),
        backgroundColor: const Color(0xFF2980B9),
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
                  _buildIdiomCard(),
                  const SizedBox(height: 20),
                  ...List.generate(_current.choices.length, (i) {
                    return QuizChoiceButton(
                      text: _current.choices[i],
                      index: i,
                      selected: _selectedAnswer,
                      correct: _answered ? _current.correctIndex : null,
                      accentColor: const Color(0xFF2980B9),
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
                        backgroundColor: _isCorrect ? kAccentGreen : const Color(0xFF2980B9),
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
                  style: const TextStyle(color: Color(0xFF2980B9), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2980B9)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdiomCard() {
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
          const Text('🗣️', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 12),
          Text(
            _current.idiom,
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
        title: const Text('慣用句クイズ'),
        backgroundColor: const Color(0xFF2980B9),
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
              const Text('結果',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kTextDark)),
              const SizedBox(height: 12),
              Text('$_score / $total 問正解',
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2980B9))),
              const SizedBox(height: 8),
              Text('$pct%', style: const TextStyle(fontSize: 20, color: kTextMuted)),
              const SizedBox(height: 24),
              Text(
                pct >= 80
                    ? 'すばらしい！慣用句の達人だね！'
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
                    backgroundColor: const Color(0xFF2980B9),
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
                    side: const BorderSide(color: Color(0xFF2980B9)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('メニューに戻る',
                      style: TextStyle(fontSize: 16, color: Color(0xFF2980B9))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
