import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/providers/premium_provider.dart';
import 'package:shared_core/widgets/premium_gate_widget.dart';

import '../theme/app_theme.dart';

/// AI漢字相談スクリーン（プレミアム限定機能）
///
/// ユーザーが漢字について質問でき、AIが回答を提供します
class AIKanjiConsultationScreen extends ConsumerStatefulWidget {
  const AIKanjiConsultationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AIKanjiConsultationScreen> createState() =>
      _AIKanjiConsultationScreenState();
}

class _AIKanjiConsultationScreenState
    extends ConsumerState<AIKanjiConsultationScreen> {
  late TextEditingController _questionController;
  bool _isLoading = false;
  String? _response;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _submitQuestion() async {
    if (_questionController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = null;
    });

    try {
      // TODO: Claude API へのリクエスト実装
      // 実装時に CloudFunctions 経由で API キーを隠蔽します
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _response =
            '「${_questionController.text}」という質問ですね。\n\n'
            'この漢字についての説明をここに表示します。\n\n'
            'プレミアム会員向けのAI相談機能です。';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _response = 'エラーが発生しました：$e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final premiumState = ref.watch(premiumProvider);

    // プレミアムゲーティング
    if (!premiumState.isSubscribed) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('AI漢字相談'),
          elevation: 0,
          backgroundColor: kPrimaryColor,
        ),
        body: PremiumGateWidget(
          featureName: 'AI漢字相談',
          onPremiumAccess: () {
            // TODO: 購読フローへ遷移
          },
          child: Container(),
        ),
      );
    }

    // プレミアム会員向けコンテンツ
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI漢字相談'),
        elevation: 0,
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 説明テキスト
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '📖 わからない漢字について、AIがわかりやすく説明します。',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 質問入力欄
              Text(
                '漢字について質問する',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _questionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '例：「漢字」の意味は何ですか？',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),

              // 送信ボタン
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitQuestion,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: Text(_isLoading ? '送信中...' : '送信'),
                ),
              ),
              const SizedBox(height: 32),

              // AIからの回答
              if (_response != null) ...[
                Text(
                  'AIからの回答',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    _response!,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // 使用例
              _buildExampleCard(
                context,
                '質問例',
                '「勉強」という漢字について教えてください',
              ),
              const SizedBox(height: 12),
              _buildExampleCard(
                context,
                '質問例',
                '「火」という漢字の成り立ちは？',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExampleCard(BuildContext context, String title, String example) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            example,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
