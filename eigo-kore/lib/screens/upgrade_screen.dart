import '../design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/premium_provider.dart';

/// プレミアム購読画面（月額¥300 / 年額¥2,400、小学コレシリーズ共通価格）。
class UpgradeScreen extends ConsumerStatefulWidget {
  const UpgradeScreen({super.key});

  @override
  ConsumerState<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends ConsumerState<UpgradeScreen> {
  bool _busy = false;

  Future<void> _run(Future<bool> Function() action, String successMessage,
      String failureMessage) async {
    if (_busy) return;
    setState(() => _busy = true);
    final ok = await action();
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? successMessage : failureMessage)),
    );
    if (ok) Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final premium = ref.watch(premiumProvider);
    final notifier = ref.read(premiumProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌟 プレミアム'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.allPaddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              ),
              child: Column(
                children: [
                  const Text('🎤', style: TextStyle(fontSize: 48)),
                  AppSpacing.verticalSpacerXs,
                  Text(
                    '英語コレ！を\nずっと使おう',
                    style: AppTypography.headlineLarge
                        .copyWith(color: AppColors.textWhite, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.verticalSpacerXs,
                  Text(
                    premium.isPremium
                        ? 'プレミアム会員です。ありがとうございます！'
                        : premium.isTrialActive
                            ? '無料期間 のこり${premium.trialDaysLeft}日'
                            : '無料期間は終了しました',
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.textWhite),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            AppSpacing.verticalSpacerLg,
            if (!premium.isPremium) ...[
              _PlanTile(
                title: '年額プラン',
                price: '¥2,400 / 年',
                note: '月あたり¥200 · おとく',
                recommended: true,
                onTap: _busy
                    ? null
                    : () => _run(notifier.purchaseYearly, 'ご購入ありがとうございます！',
                        '購入できませんでした'),
              ),
              AppSpacing.verticalSpacerXs,
              _PlanTile(
                title: '月額プラン',
                price: '¥300 / 月',
                note: 'いつでも解約できます',
                onTap: _busy
                    ? null
                    : () => _run(notifier.purchaseMonthly, 'ご購入ありがとうございます！',
                        '購入できませんでした'),
              ),
              AppSpacing.verticalSpacerMd,
            ],
            TextButton(
              onPressed: _busy
                  ? null
                  : () => _run(notifier.restorePurchases, '購入を復元しました',
                      '復元できる購入が見つかりませんでした'),
              child: const Text('購入を復元'),
            ),
            if (_busy)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Center(child: CircularProgressIndicator()),
              ),
            AppSpacing.verticalSpacerMd,
            Text(
              '初回起動から14日間は全機能を無料でお使いいただけます。'
              '購読は Google Play の定期購入で、期間終了の24時間前までに解約しない限り自動更新されます。'
              '解約は Google Play の「定期購入」からいつでもできます。',
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textMuted, height: 1.5),
            ),
            AppSpacing.verticalSpacerXxl,
          ],
        ),
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  final String title;
  final String price;
  final String note;
  final bool recommended;
  final VoidCallback? onTap;

  const _PlanTile({
    required this.title,
    required this.price,
    required this.note,
    required this.onTap,
    this.recommended = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: recommended ? AppColors.accentOrange : AppColors.primary.withAlpha(60),
          width: recommended ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.allPaddingLg,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(title, style: AppTypography.labelLarge),
                        if (recommended) ...[
                          const SizedBox(width: 8),
                          Text('おすすめ',
                              style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.accentOrange,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ],
                    ),
                    Text(note,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
              Text(price,
                  style: AppTypography.labelLarge
                      .copyWith(color: AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }
}
