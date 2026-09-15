import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/reading_passages_data.dart';
import '../models/reading_passage_model.dart';
import '../theme/app_theme.dart';

class SummaryTrainingScreen extends ConsumerStatefulWidget {
  final String passageId;

  final String passageTitle;

  const SummaryTrainingScreen({
    super.key,
    required this.passageId,
    required this.passageTitle,
  });

  @override
  ConsumerState<SummaryTrainingScreen> createState() => _SummaryTrainingScreenState();
}

class _SummaryTrainingScreenState extends ConsumerState<SummaryTrainingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _selectedSummaryIndex;
  bool _summaryAnswered = false;
  int? _selectedExpression;
  bool _expressionAnswered = false;
  int _currentExpressionQ = 0;
  int? _selectedStructureAnswer;
  bool _structureAnswered = false;

  late final SummaryQuestionSet? _summarySet = summaryFor(widget.passageId);
  late final List<ExpressionQuestion> _expressionQuestions = expressionQuestionsFor(widget.passageId);
  late final TextStructureAnalysis? _structure = structureFor(widget.passageId);
  late final ComprehensionQuestion? _structureQuestion = _findStructureQuestion(widget.passageId);

  static ComprehensionQuestion? _findStructureQuestion(String passageId) {
    final matches = comprehensionQuestionsFor(passageId).where((q) => q.questionType == 'structure');
    return matches.isEmpty ? null : matches.first;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.passageTitle, overflow: TextOverflow.ellipsis),
        backgroundColor: kPrimaryColor,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '📝 要約'),
            Tab(text: '🔑 表現'),
            Tab(text: '🗺️ 構造'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(),
          _buildExpressionTab(),
          _buildStructureTab(),
        ],
      ),
    );
  }

  // ─── 要約タブ ──────────────────────────────
  Widget _buildSummaryTab() {
    final set = _summarySet;
    if (set == null) {
      return const Center(child: Text('要約問題が見つかりませんでした', style: TextStyle(color: kTextMuted)));
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('📝 要約問題', 'この記事の内容を正しく要約しているのはどれですか？'),
          const SizedBox(height: 20),
          if (!_summaryAnswered) ...[
            ...List.generate(set.summaryOptions.length, (i) => _buildSummaryOption(set, i)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedSummaryIndex != null ? () => setState(() => _summaryAnswered = true) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('答える', style: TextStyle(color: Colors.white)),
              ),
            ),
          ] else ...[
            _buildSummaryResult(set),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryOption(SummaryQuestionSet set, int index) {
    final isSelected = _selectedSummaryIndex == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => setState(() => _selectedSummaryIndex = index),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.white,
            border: Border.all(color: isSelected ? kPrimaryColor : Colors.grey.shade300, width: isSelected ? 2 : 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isSelected ? kPrimaryColor : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(String.fromCharCode(65 + index),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(set.summaryOptions[index], style: const TextStyle(fontSize: 13, height: 1.6))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryResult(SummaryQuestionSet set) {
    final isCorrect = _selectedSummaryIndex != null &&
        set.summaryOptions[_selectedSummaryIndex!] == set.correctSummary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
            border: Border.all(color: isCorrect ? Colors.green : Colors.red, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Text(isCorrect ? '✓' : '✗',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isCorrect ? Colors.green : Colors.red)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(isCorrect ? '正解です！上手に要約できています。' : '不正解です。記事全体の内容を確認しましょう。',
                    style: TextStyle(fontSize: 13, color: isCorrect ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('解説', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(set.explanation, style: const TextStyle(fontSize: 12, height: 1.7)),
        ),
      ],
    );
  }

  // ─── 表現タブ ──────────────────────────────
  Widget _buildExpressionTab() {
    if (_expressionQuestions.isEmpty) {
      return const Center(child: Text('表現問題が見つかりませんでした', style: TextStyle(color: kTextMuted)));
    }
    if (_currentExpressionQ >= _expressionQuestions.length) {
      return _buildExpressionComplete();
    }

    final q = _expressionQuestions[_currentExpressionQ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('🔑 表現・語彙問題', '文章中の言葉の意味を考えましょう。'),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text('「${q.phrase}」とはどういう意味ですか？',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, height: 1.5)),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            q.meaningOptions.length,
            (i) => _buildExpressionOption(q, i),
          ),
          const SizedBox(height: 20),
          if (!_expressionAnswered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedExpression != null ? () => setState(() => _expressionAnswered = true) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('答える', style: TextStyle(color: Colors.white)),
              ),
            )
          else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(q.contextExplanation, style: const TextStyle(fontSize: 12, height: 1.6, color: kTextMuted)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() {
                  _currentExpressionQ++;
                  _selectedExpression = null;
                  _expressionAnswered = false;
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  _currentExpressionQ < _expressionQuestions.length - 1 ? '次の問題へ' : '完了',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpressionOption(ExpressionQuestion q, int index) {
    final isSelected = _selectedExpression == index;
    final correctIndex = q.meaningOptions.indexOf(q.correctMeaning);
    Color borderColor = Colors.grey.shade300;
    Color? bgColor;

    if (_expressionAnswered) {
      if (index == correctIndex) {
        borderColor = Colors.green;
        bgColor = Colors.green.shade50;
      } else if (isSelected) {
        borderColor = Colors.red;
        bgColor = Colors.red.shade50;
      }
    } else if (isSelected) {
      borderColor = kPrimaryColor;
      bgColor = Colors.blue.shade50;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: _expressionAnswered ? null : () => setState(() => _selectedExpression = index),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor ?? Colors.white,
            border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(6)),
                child: Center(
                  child: Text(String.fromCharCode(65 + index),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(q.meaningOptions[index], style: const TextStyle(fontSize: 13))),
              if (_expressionAnswered && index == correctIndex)
                const Icon(Icons.check_circle, color: Colors.green, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpressionComplete() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text('表現問題クリア！', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('全問回答しました', style: TextStyle(color: kTextMuted)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() {
                _currentExpressionQ = 0;
                _selectedExpression = null;
                _expressionAnswered = false;
              }),
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
              child: const Text('もう一度', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 構造タブ ──────────────────────────────
  Widget _buildStructureTab() {
    final structure = _structure;
    if (structure == null) {
      return const Center(child: Text('構造分析が見つかりませんでした', style: TextStyle(color: kTextMuted)));
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('🗺️ 文章構造の分析', '記事がどんな構成で書かれているかを確認しましょう。'),
          const SizedBox(height: 20),
          _buildStructureMap(structure),
          const SizedBox(height: 20),
          _buildHighlightBox('🎯 もっとも大切な部分', structure.climax, Colors.orange),
          const SizedBox(height: 10),
          _buildHighlightBox('✅ まとめ・結論', structure.resolution, Colors.teal),
          const SizedBox(height: 24),
          const Text('各段落の役割', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildParagraphRoles(structure),
          if (structure.characterDescriptions.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text('登場人物のタイプ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildCharacterDescriptions(structure),
          ],
          if (_structureQuestion != null) ...[
            const SizedBox(height: 24),
            const Text('構造確認問題', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildStructureQuestion(_structureQuestion!),
          ],
        ],
      ),
    );
  }

  Widget _buildStructureMap(TextStructureAnalysis structure) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          for (int i = 0; i < structure.mainPoints.length; i++) ...[
            if (i > 0) _buildStructureArrow(),
            _buildStructureNode(i + 1, structure.mainPoints[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildStructureNode(int index, String content) {
    const colors = [Colors.blue, Colors.purple, Colors.orange, Colors.green, Colors.teal, Colors.red];
    final color = colors[(index - 1) % colors.length];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text('$index', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(content, style: const TextStyle(fontSize: 12, color: kTextMuted))),
        ],
      ),
    );
  }

  Widget _buildStructureArrow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(child: Icon(Icons.arrow_downward, color: Colors.grey.shade400, size: 18)),
    );
  }

  Widget _buildHighlightBox(String label, String content, MaterialColor color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color.shade800)),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 12, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildParagraphRoles(TextStructureAnalysis structure) {
    return Column(
      children: structure.paragraphs.asMap().entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('${e.key + 1}', style: const TextStyle(fontSize: 10, color: kPrimaryColor, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(e.value, style: const TextStyle(fontSize: 11, color: kTextMuted, height: 1.5))),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCharacterDescriptions(TextStructureAnalysis structure) {
    return Column(
      children: structure.characterDescriptions.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purple.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.key, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple.shade700)),
                const SizedBox(height: 2),
                Text(e.value, style: const TextStyle(fontSize: 11, color: kTextMuted)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStructureQuestion(ComprehensionQuestion question) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question.questionText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...question.choices.asMap().entries.map((e) {
            final isSelected = _selectedStructureAnswer == e.key;
            final isCorrectChoice = e.value == question.correctAnswer;
            Color borderColor = Colors.purple.shade200;
            Color bg = Colors.white;
            if (_structureAnswered) {
              if (isCorrectChoice) {
                borderColor = Colors.green;
                bg = Colors.green.shade50;
              } else if (isSelected) {
                borderColor = Colors.red;
                bg = Colors.red.shade50;
              }
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: _structureAnswered
                    ? null
                    : () => setState(() {
                          _selectedStructureAnswer = e.key;
                          _structureAnswered = true;
                        }),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(color: Colors.purple.shade100, borderRadius: BorderRadius.circular(4)),
                        child: Center(
                          child: Text(String.fromCharCode(65 + e.key),
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purple.shade700)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(e.value, style: const TextStyle(fontSize: 12))),
                      if (_structureAnswered && isCorrectChoice)
                        const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (_structureAnswered) ...[
            const SizedBox(height: 8),
            Text(question.explanation, style: const TextStyle(fontSize: 11, color: kTextMuted, height: 1.5)),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: kTextMuted)),
      ],
    );
  }
}
