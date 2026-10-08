import 'dart:async';

import 'package:flutter/material.dart';
import '../widgets/branded_splash.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../providers/vocab_mastery_provider.dart';
import '../providers/premium_provider.dart';
import '../services/firebase_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.5, curve: Curves.easeIn)),
    );
    _ctrl.forward();
    _load();
  }

  Future<void> _load() async {
    // TODO: feedbackProvider と FirebaseRealtimeAPI.submitFeedback を Phase 4 で実装

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
      backgroundColor: kSplashBackground,
      body: FadeTransition(opacity: _fadeAnim, child: const BrandedSplashBody()),
    );
  }
}
