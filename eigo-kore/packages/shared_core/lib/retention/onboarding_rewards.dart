import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/coin_provider.dart';
import '../utils/date_key.dart';

/// 初回 7 日間の報酬 1 日分。
class OnboardingReward {
  final int day; // 1-7
  final int coins;
  final String title;
  final String description;

  /// 称号・キャラ・バッジなどアプリ側で付与するもののID（任意）
  final String? itemId;

  const OnboardingReward({
    required this.day,
    required this.coins,
    required this.title,
    required this.description,
    this.itemId,
  });
}

/// Day3・Day7 の離脱が大きいため、この 2 日を特に厚くしている。
const List<OnboardingReward> kOnboardingRewards = [
  OnboardingReward(day: 1, coins: 50, title: 'はじめの一歩', description: 'アプリをはじめてくれてありがとう！'),
  OnboardingReward(day: 2, coins: 50, title: '2日目もがんばった', description: '2日連続で遊んでくれたね'),
  OnboardingReward(day: 3, coins: 150, title: '3日坊主をこえた', description: '3日目のごほうび。レアなアイテム入り！', itemId: 'onboarding_day3'),
  OnboardingReward(day: 4, coins: 60, title: '4日目', description: 'ちょっとずつ強くなってるよ'),
  OnboardingReward(day: 5, coins: 80, title: '5日目', description: 'もう学習名人に近づいてる！'),
  OnboardingReward(day: 6, coins: 80, title: 'あと1日', description: '明日はとくべつなごほうび！'),
  OnboardingReward(day: 7, coins: 300, title: '1週間マスター', description: '7日間おつかれさま！特別な称号をプレゼント', itemId: 'onboarding_day7'),
];

/// 取り逃した報酬を遡って受け取れる最終日（初回起動から数えた日数）。
const kOnboardingGraceDays = 14;

const _firstKey = 'sc_onboarding_first_date';
const _claimedKey = 'sc_onboarding_claimed';

class OnboardingState {
  final DateTime? firstLaunchDate;
  final Set<int> claimedDays;
  final DateTime today;

  const OnboardingState({
    this.firstLaunchDate,
    this.claimedDays = const {},
    required this.today,
  });

  /// 初回起動日を 1 日目とした今日の日数（未起動は 0）。
  int get dayNumber => firstLaunchDate == null
      ? 0
      : calendarDaysBetween(firstLaunchDate!, today) + 1;

  /// 全部受け取り済み、または受け取り期限（14 日目）を過ぎたか。
  bool get isFinished =>
      claimedDays.length >= kOnboardingRewards.length ||
      dayNumber > kOnboardingGraceDays;

  /// 今受け取れる日（取り逃した日も 14 日目までは遡って受け取れる）。
  List<OnboardingReward> get claimable => dayNumber > kOnboardingGraceDays
      ? const []
      : [
          for (final r in kOnboardingRewards)
            if (r.day <= dayNumber && !claimedDays.contains(r.day)) r
        ];

  OnboardingState copyWith({
    DateTime? firstLaunchDate,
    Set<int>? claimedDays,
    DateTime? today,
  }) =>
      OnboardingState(
        firstLaunchDate: firstLaunchDate ?? this.firstLaunchDate,
        claimedDays: claimedDays ?? this.claimedDays,
        today: today ?? this.today,
      );
}

/// 初回 7 日間オンボーディング報酬。
///
/// 起動時に `load()`、ホームに `OnboardingRewardBanner` 等で [claimable] を出し、
/// タップで `claim(day)` する。コインは内部で `coinProvider` に加算する。
/// 称号・キャラなど [OnboardingReward.itemId] の付与は呼び出し側で行う。
class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => OnboardingState(today: DateTime.now());

  Future<void> load({DateTime? now}) async {
    final today = now ?? DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    var first = parseDateKey(prefs.getString(_firstKey));
    if (first == null) {
      first = DateTime(today.year, today.month, today.day);
      await prefs.setString(_firstKey, dateKeyOf(first));
    }
    final claimed = (prefs.getStringList(_claimedKey) ?? [])
        .map(int.tryParse)
        .whereType<int>()
        .toSet();
    state = OnboardingState(
        firstLaunchDate: first, claimedDays: claimed, today: today);
  }

  /// [day] の報酬を受け取る。受け取れない場合は null。
  /// [multiplier] は A/B テスト用のコイン倍率。
  Future<OnboardingReward?> claim(int day, {double multiplier = 1.0}) async {
    final target = state.claimable.where((r) => r.day == day);
    if (target.isEmpty) return null;
    final reward = target.first;

    final claimed = {...state.claimedDays, day};
    state = state.copyWith(claimedDays: claimed);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _claimedKey, claimed.map((d) => '$d').toList());
    await ref
        .read(coinProvider.notifier)
        .addCoins((reward.coins * multiplier).round());
    return reward;
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
        OnboardingNotifier.new);
