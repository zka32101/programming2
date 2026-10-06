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
        _section(context, 'はじめに',
            '小学コレ！国語（以下「本アプリ」）は、Your Wishが提供する小学生向け国語学習アプリです。\n\n最終更新日：2026年6月15日'),
        _h2(context, '1. 収集する情報'),
        _h3(context, '自動的に収集される情報'),
        _bullet(context, '匿名ユーザーID：Firebase Authenticationによる匿名IDです。個人を特定する情報は含まれません。'),
        _bullet(context, '学習進捗データ：クリアしたステージ、正解数、連続学習日数、取得バッジ。'),
        _bullet(context, 'デバイス情報：OSバージョン、デバイスモデル（クラッシュ報告のみ）。'),
        _h3(context, '任意で入力する情報'),
        _bullet(context, '学年選択：1〜6年生の選択。本アプリ内でのみ使用します。'),
        _h2(context, '2. 情報の利用目的'),
        _bullet(context, '学習進捗の保存・表示'),
        _bullet(context, 'アプリの改善とバグ修正'),
        _bullet(context, 'カスタマーサポートの提供'),
        _bullet(context, '不正利用の防止'),
        _h2(context, '3. 情報の第三者提供'),
        _body(context, '当社は、以下の場合を除き、ユーザーの情報を第三者に提供しません。'),
        _bullet(context, 'ユーザーの同意がある場合'),
        _bullet(context, '法令に基づく開示が必要な場合'),
        _bullet(context, '生命・財産の保護のために必要な場合'),
        _h2(context, '4. 利用する外部サービス'),
        _body(context, '本アプリは以下の外部サービスを利用しています：'),
        _bullet(context, 'Firebase（Google LLC）：匿名認証・クラッシュ分析'),
        _bullet(context, 'Google Play Billing：アプリ内課金'),
        _body(context, '詳細：https://policies.google.com/privacy'),
        _h2(context, '5. 子どもの個人情報について'),
        _body(context, '本アプリは小学生を対象としています。当社は13歳未満の児童から意図的に個人情報を収集しません。本アプリでは氏名・メールアドレス・住所等の個人情報の入力を求めません。'),
        _h2(context, '6. データの保存と削除'),
        _bullet(context, '学習データは端末のローカルストレージに保存されます。'),
        _bullet(context, 'アプリをアンインストールすることで、ローカルデータは削除されます。'),
        _bullet(context, 'Firebaseデータの削除ご希望の場合は下記メールにご連絡ください。'),
        _h2(context, '7. 本ポリシーの変更'),
        _body(context, '当社は本プライバシーポリシーを随時更新することがあります。重要な変更がある場合はアプリ内でお知らせします。'),
        _h2(context, '8. お問い合わせ'),
        _bullet(context, '開発者：Your Wish'),
        _bullet(context, 'メール：funvestment1@gmail.com'),
        const SizedBox(height: 32),
        const Text(
          '本プライバシーポリシーは日本法に準拠します。',
          style: TextStyle(color: kTextMuted, fontSize: 12),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _section(BuildContext context, String title, String body) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.strongText)),
      const SizedBox(height: 8),
      Text(body, style: TextStyle(fontSize: 14, height: 1.6, color: context.strongText)),
      const SizedBox(height: 20),
    ],
  );

  Widget _h2(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kPrimaryDark)),
  );

  Widget _h3(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 4),
    child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.strongText)),
  );

  Widget _body(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: TextStyle(fontSize: 14, height: 1.6, color: context.strongText)),
  );

  Widget _bullet(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(left: 12, bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
        Expanded(child: Text(text, style: TextStyle(fontSize: 14, height: 1.5, color: context.strongText))),
      ],
    ),
  );
}
