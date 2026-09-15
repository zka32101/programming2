// lib/widgets/banner_ad_widget.dart
// バナー広告ウィジェット（無料ユーザー向け）

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../providers/premium_provider.dart';

import '../services/ad_service.dart';

class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    final premium = ref.read(premiumProvider);
    if (!premium.isPremium && !premium.isTrialActive) {
      _loadBanner();
    }
  }

  void _loadBanner() {
    final banner = AdService.createBanner(
      onLoaded: () {
        if (mounted) setState(() => _isLoaded = true);
      },
      onFailed: () {
        // ad_service.dart の onAdFailedToLoad が既にこの broken ad を
        // dispose 済みなので、参照を破棄しておく（mounted判定に関わらず）。
        // これをしないと、この後 dispose() が同じインスタンスを二重に
        // dispose してクラッシュ/エラーログの原因になる。
        _bannerAd = null;
        if (mounted) setState(() => _isLoaded = false);
      },
    );
    banner.load();
    _bannerAd = banner;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final premium = ref.watch(premiumProvider);
    if (premium.isPremium || premium.isTrialActive || !_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }
    return Container(
      height: _bannerAd!.size.height.toDouble(),
      color: Colors.white,
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
