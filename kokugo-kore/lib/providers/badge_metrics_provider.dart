import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _learningMinutesKey = 'learning_minutes_total';
const _friendInvitesKey = 'friend_invites_count';
const _multiplayerWinsKey = 'multiplayer_wins_count';
const _topTenRankerKey = 'is_top_ten_ranker';

/// バッジ獲得のための追加メトリクスを管理するプロバイダー
class BadgeMetricsNotifier extends Notifier<BadgeMetrics> {
  @override
  BadgeMetrics build() => BadgeMetrics.empty;

  /// SharedPreferencesから復元
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    state = BadgeMetrics(
      learningMinutes: prefs.getInt(_learningMinutesKey) ?? 0,
      friendInvites: prefs.getInt(_friendInvitesKey) ?? 0,
      multiplayerWins: prefs.getInt(_multiplayerWinsKey) ?? 0,
      isTopTenRanker: prefs.getBool(_topTenRankerKey) ?? false,
    );
  }

  /// 学習時間を加算（秒単位で記録）
  Future<void> addLearningTime(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    final minutes = (seconds / 60).toInt();
    final newTotal = state.learningMinutes + minutes;

    await prefs.setInt(_learningMinutesKey, newTotal);
    state = state.copyWith(learningMinutes: newTotal);
  }

  /// 友人招待数を増やす
  Future<void> incrementFriendInvites() async {
    final prefs = await SharedPreferences.getInstance();
    final newCount = state.friendInvites + 1;

    await prefs.setInt(_friendInvitesKey, newCount);
    state = state.copyWith(friendInvites: newCount);
  }

  /// マルチプレイ勝利数を増やす
  Future<void> incrementMultiplayerWins() async {
    final prefs = await SharedPreferences.getInstance();
    final newCount = state.multiplayerWins + 1;

    await prefs.setInt(_multiplayerWinsKey, newCount);
    state = state.copyWith(multiplayerWins: newCount);
  }

  /// トップ10ランカーステータスを設定
  Future<void> setTopTenRanker(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_topTenRankerKey, value);
    state = state.copyWith(isTopTenRanker: value);
  }

  /// クリア（テスト用）
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_learningMinutesKey);
    await prefs.remove(_friendInvitesKey);
    await prefs.remove(_multiplayerWinsKey);
    await prefs.remove(_topTenRankerKey);
    state = BadgeMetrics.empty;
  }
}

/// バッジ獲得メトリクスのデータ構造
class BadgeMetrics {
  final int learningMinutes;
  final int friendInvites;
  final int multiplayerWins;
  final bool isTopTenRanker;

  const BadgeMetrics({
    required this.learningMinutes,
    required this.friendInvites,
    required this.multiplayerWins,
    required this.isTopTenRanker,
  });

  static const empty = BadgeMetrics(
    learningMinutes: 0,
    friendInvites: 0,
    multiplayerWins: 0,
    isTopTenRanker: false,
  );

  BadgeMetrics copyWith({
    int? learningMinutes,
    int? friendInvites,
    int? multiplayerWins,
    bool? isTopTenRanker,
  }) =>
      BadgeMetrics(
        learningMinutes: learningMinutes ?? this.learningMinutes,
        friendInvites: friendInvites ?? this.friendInvites,
        multiplayerWins: multiplayerWins ?? this.multiplayerWins,
        isTopTenRanker: isTopTenRanker ?? this.isTopTenRanker,
      );
}

final badgeMetricsProvider = NotifierProvider<BadgeMetricsNotifier, BadgeMetrics>(
  BadgeMetricsNotifier.new,
);
