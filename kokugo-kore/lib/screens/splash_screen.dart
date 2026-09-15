import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_core/shared_core.dart' show feedbackProvider;
import '../providers/adaptive_provider.dart';

import '../providers/badge_provider.dart';
import '../providers/coin_provider.dart';
import '../providers/daily_bonus_provider.dart';
import '../providers/learning_timer_provider.dart';
import '../providers/drawing_progress_provider.dart';
import '../providers/drawing_settings_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/sound_provider.dart';
import '../services/firebase_realtime_db.dart';
import '../providers/vocab_mastery_provider.dart';
import '../providers/premium_provider.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.5, curve: Curves.easeIn)),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.6, curve: Curves.elasticOut)),
    );
    _ctrl.forward();
    _load();
  }

  Future<void> _load() async {
    // バグ報告・改善要望フォームの送信ハンドラを登録
    // （Realtime Database の feedback/{id} へ書き込む）
    ref.read(feedbackProvider.notifier).setSubmitHandler(FirebaseRealtimeAPI.submitFeedback);
    unawaited(ref.read(feedbackProvider.notifier).retryPendingReports());

    await Future.wait([
      ref.read(profileProvider.notifier).load(),
      ref.read(progressProvider.notifier).load(),
      ref.read(badgeProvider.notifier).load(),
      ref.read(coinProvider.notifier).load(),
      ref.read(premiumProvider.notifier).load(),
      ref.read(soundProvider.notifier).load(),
      ref.read(drawingProgressProvider.notifier).load(),
      ref.read(drawingSettingsProvider.notifier).load(),
      ref.read(vocabMasteryProvider.notifier).load(),
      ref.read(dailyBonusProvider.notifier).load(),
      ref.read(adaptiveProvider.notifier).load(),
      ref.read(learningTimerProvider.notifier).load(),
      FirebaseService.signInAnonymously(),
    ]);
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;

    // アップデート通知は home_screen.dart の _checkForUpdate に一本化済み
    // （ここに以前あった別バージョンの重複した仕組みは削除した）。

    final profiles = ref.read(profileProvider).profiles;
    final currentProfile = ref.read(profileProvider).currentProfileId;

    if (profiles.isEmpty || currentProfile == null) {
      Navigator.of(context).pushReplacementNamed('/profile-selection');
    } else {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimaryColor, kPrimaryDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 大きなアプリアイコン（真ん中）
                    Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          'assets/logos/app_icon_512.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      '小学コレ！国語',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ひらがなから読解・作文まで',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 40),
                    // 組織アイコン + 組織名
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/logos/company_app_icon.jpg',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Your Wish',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
