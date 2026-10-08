import 'package:flutter/material.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/branded_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.3, 1.0)),
    );
    _ctrl.forward();
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    // サービス初期化(Firebase/通知/コイン)は main() で完了済み。ここは表示時間のみ待つ。
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    // プロフィールがあればホーム、無ければプロフィール選択(従来の '/' の分岐を維持)
    final profiles = ref.read(userProfilesProvider);
    final currentUserId = ref.read(currentUserIdProvider);
    final hasProfiles = profiles.isNotEmpty && currentUserId != null;
    Navigator.of(context)
        .pushReplacementNamed(hasProfiles ? '/home' : '/profile-select');
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
      body: FadeTransition(opacity: _fade, child: const BrandedSplashBody()),
    );
  }
}
