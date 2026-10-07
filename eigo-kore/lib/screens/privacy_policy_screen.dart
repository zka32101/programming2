import 'package:flutter/material.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import '../design_system/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プライバシーポリシー'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.allPaddingMd,
        child: SelectableText(
          '''英語コレ！プライバシーポリシー

最終更新日: 2026年10月7日

1. 収集する情報
・マイク（音声）: スピーキング練習で、端末の音声認識機能を使って発音を判定します。音声データをこのアプリが保存したり、運営者のサーバーへ送信したりすることはありません（音声認識は端末のOSが提供する機能を利用します）。
・学習データ: スコア、クリア状況、学習日などは、お使いの端末内に保存されます。
・アカウント: 本アプリは氏名・メールアドレス・住所などの個人情報の入力を求めません。
・購入情報: 有料プランの購入・管理は Google Play と、課金管理サービス RevenueCat を通じて行われ、これらの事業者が購入に必要な情報を取り扱います。

2. 利用目的
学習機能の提供、学習成績の表示、有料プランの提供・確認のために利用します。

3. 第三者への提供
法令に基づく場合を除き、収集した情報を第三者へ提供することはありません。ただし上記のとおり、購入手続きは Google Play および RevenueCat のプライバシーポリシーに従って処理されます。

4. 広告について
本アプリには広告を表示しません。

5. お子様の利用について
保護者の方は、お子様がご利用になる前に、この内容をご確認ください。

6. お問い合わせ
Google Play のストアページに記載の連絡先、またはアプリ内の「バグ報告・ご意見」からご連絡ください。

7. 変更について
本ポリシーを変更する場合は、アプリ内またはストアページでお知らせします。''',
          style: AppTypography.bodySmall.copyWith(height: 1.7, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
