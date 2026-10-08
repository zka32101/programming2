import 'package:flutter/material.dart';

/// 起動画面の見た目（アプリ画像+シリーズロゴ+組織ロゴの一枚）。
/// 背景は白固定（ダークモードでも変えない）。SplashScreen から使う。
const Color kSplashBackground = Color(0xFFFFFFFF);
const Color kSplashProgressColor = Color(0xFF263250);

const String kSplashAppIconAsset = 'assets/branding/app_icon.png';
const String kSplashSeriesLogoAsset = 'assets/branding/series_logo.png';
const String kSplashOrgLogoAsset = 'assets/branding/yourwish_logo.png';

class BrandedSplashBody extends StatelessWidget {
  const BrandedSplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: kSplashBackground,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        kSplashAppIconAsset,
                        width: 168,
                        height: 168,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: kSplashProgressColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Image.asset(kSplashSeriesLogoAsset, width: 260, fit: BoxFit.contain),
            const SizedBox(height: 16),
            Image.asset(kSplashOrgLogoAsset, height: 84, fit: BoxFit.contain),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
