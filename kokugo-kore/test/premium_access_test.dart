import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/providers/premium_provider.dart';

void main() {
  const trial = PremiumState(isTrialActive: true, trialDaysLeft: 14, isLoading: false);
  const expired = PremiumState(isLoading: false);
  const premium = PremiumState(isPremium: true, isLoading: false);

  test('trial active: nothing locked', () {
    expect(trial.hasFullAccess, isTrue);
    expect(trial.isStageOrderLocked(previousCleared: false), isFalse);
    expect(trial.showsPremiumLock(true), isFalse);
    expect(trial.canAccessStage(99), isTrue);
  });

  test('expired non-premium: locked / gated', () {
    expect(expired.hasFullAccess, isFalse);
    expect(expired.isStageOrderLocked(previousCleared: false), isTrue);
    expect(expired.isStageOrderLocked(previousCleared: true), isFalse);
    expect(expired.showsPremiumLock(true), isTrue);
    expect(expired.showsPremiumLock(false), isFalse);
    expect(expired.canAccessStage(99), isFalse);
  });

  test('premium: nothing locked', () {
    expect(premium.isStageOrderLocked(previousCleared: false), isFalse);
    expect(premium.showsPremiumLock(true), isFalse);
    expect(premium.canAccessStage(99), isTrue);
  });
}
