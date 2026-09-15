// lib/widgets/premium_gate.dart
// Wraps a feature screen so it's only reachable during the free trial or
// with an active premium subscription. After the trial ends, shows an
// upsell screen instead of the feature (same "star/PRO" visual language as
// StageCard's premium lock).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/premium_provider.dart';
import '../theme/app_theme.dart';

class PremiumGate extends ConsumerWidget {
  final String featureName;
  final String featureEmoji;
  final Widget child;

  const PremiumGate({
    super.key,
    required this.featureName,
    required this.featureEmoji,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premium = ref.watch(premiumProvider);

    if (premium.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (premium.isPremium || premium.isTrialActive) {
      return child;
    }
    return PremiumLockedScreen(featureName: featureName, featureEmoji: featureEmoji);
  }
}

class PremiumLockedScreen extends StatelessWidget {
  final String featureName;
  final String featureEmoji;
  const PremiumLockedScreen({super.key, required this.featureName, required this.featureEmoji});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(featureName),
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(featureEmoji, style: const TextStyle(fontSize: 40)),
                ),
              ),
              const SizedBox(height: 8),
              const Icon(Icons.star, color: kPrimaryColor, size: 28),
              const SizedBox(height: 16),
              Text(
                '$featureNameは\nプレミアム限定機能です',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kTextDark),
              ),
              const SizedBox(height: 10),
              const Text(
                '無料の2週間トライアルは終了しました。\nプレミアムに登録すると、すべての機能が使い放題になります。',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: kTextMuted, height: 1.5),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed('/upgrade'),
                  icon: const Icon(Icons.star),
                  label: const Text('プレミアムプランを見る'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('もどる', style: TextStyle(color: kTextMuted)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
