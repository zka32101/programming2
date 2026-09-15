import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プライバシーポリシー'),
        backgroundColor: kPrimaryColor,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: _PolicyContent(),
      ),
    );
  }
}

class _PolicyContent extends StatelessWidget {
  const _PolicyContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section('はじめに',
            '小学コレ！国語（以下「本アプリ」）は、Your Wishが提供する小学生向け国語学習アプリです。\n\n最終更新日：2026年6月15日'),
        _h2('1. 収集する情報'),
        _h3('自動的に収集される情報'),
        _bullet('匿名ユーザーID：Firebase Authenticationによる匿名IDです。個人を特定する情報は含まれません。'),
        _bullet('学習進捗データ：クリアしたステージ、正解数、連続学習日数、取得バッジ。'),
        _bullet('デバイス情報：OSバージョン、デバイスモデル（クラッシュ報告のみ）。'),
        _h3('任意で入力する情報'),
        _bullet('学年選択：1〜6年生の選択。本アプリ内でのみ使用します。'),
        _h2('2. 情報の利用目的'),
        _bullet('学習進捗の保存・表示'),
        _bullet('アプリの改善とバグ修正'),
        _bullet('カスタマーサポートの提供'),
        _bullet('不正利用の防止'),
        _h2('3. 情報の第三者提供'),
        _body('当社は、以下の場合を除き、ユーザーの情報を第三者に提供しません。'),
        _bullet('ユーザーの同意がある場合'),
        _bullet('法令に基づく開示が必要な場合'),
        _bullet('生命・財産の保護のために必要な場合'),
        _h2('4. 利用する外部サービス'),
        _body('本アプリは以下の外部サービスを利用しています：'),
        _bullet('Firebase（Google LLC）：匿名認証・クラッシュ分析'),
        _bullet('Google Play Billing：アプリ内課金'),
        _body('詳細：https://policies.google.com/privacy'),
        _h2('5. 子どもの個人情報について'),
        _body('本アプリは小学生を対象としています。当社は13歳未満の児童から意図的に個人情報を収集しません。本アプリでは氏名・メールアドレス・住所等の個人情報の入力を求めません。'),
        _h2('6. データの保存と削除'),
        _bullet('学習データは端末のローカルストレージに保存されます。'),
        _bullet('アプリをアンインストールすることで、ローカルデータは削除されます。'),
        _bullet('Firebaseデータの削除ご希望の場合は下記メールにご連絡ください。'),
        _h2('7. 本ポリシーの変更'),
        _body('当社は本プライバシーポリシーを随時更新することがあります。重要な変更がある場合はアプリ内でお知らせします。'),
        _h2('8. お問い合わせ'),
        _bullet('開発者：Your Wish'),
        _bullet('メール：funvestment1@gmail.com'),
        const SizedBox(height: 32),
        const Text(
          '本プライバシーポリシーは日本法に準拠します。',
          style: TextStyle(color: kTextMuted, fontSize: 12),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _section(String title, String body) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kTextDark)),
      const SizedBox(height: 8),
      Text(body, style: const TextStyle(fontSize: 14, height: 1.6, color: kTextDark)),
      const SizedBox(height: 20),
    ],
  );

  Widget _h2(String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kPrimaryDark)),
  );

  Widget _h3(String text) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 4),
    child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextDark)),
  );

  Widget _body(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 14, height: 1.6, color: kTextDark)),
  );

  Widget _bullet(String text) => Padding(
    padding: const EdgeInsets.only(left: 12, bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14, height: 1.5, color: kTextDark))),
      ],
    ),
  );
}
