import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final analyticsProvider = StateNotifierProvider<AnalyticsNotifier, ProgressAnalytics?>((ref) {
  return AnalyticsNotifier();

import '../models/analytics_model.dart';
import '../services/firebase_realtime_db.dart';

});

final learningPaceProvider = StateNotifierProvider<LearningPaceNotifier, LearningPaceData?>((ref) {
  return LearningPaceNotifier();
});

class AnalyticsNotifier extends StateNotifier<ProgressAnalytics?> {
  AnalyticsNotifier() : super(null);

  /// Save daily stats and update analytics
  Future<void> recordDailyStats(
    String userId, {
    required int questsCompleted,
    required int correctAnswers,
    required int totalAnswers,
    required int coinsEarned,
    required int studyMinutes,
    required Map<String, dynamic> categoryStats,
  }) async {
    try {
      final today = DateTime.now();
      final dateStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final dailyStats = DailyStats(
        date: dateStr,
        questsCompleted: questsCompleted,
        correctAnswers: correctAnswers,
        totalAnswers: totalAnswers,
        coinsEarned: coinsEarned,
        studyMinutes: studyMinutes,
        categoryStats: categoryStats,
      );

      await FirebaseRealtimeAPI.saveDailyStats(userId, dailyStats);
    } catch (e) {
      debugPrint('❌ Error recording daily stats: $e');
      rethrow;
    }
  }

  /// Load analytics from Firebase
  Future<void> loadAnalytics(String userId) async {
    try {
      FirebaseRealtimeAPI.getAnalyticsStream(userId).listen((analytics) {
        state = analytics;
      });
    } catch (e) {
      debugPrint('❌ Error loading analytics: $e');
    }
  }

  /// Get accuracy for a specific category
  double getCategoryAccuracy(String categoryId) {
    if (state == null) return 0.0;
    final mastery = state!.categoryMastery[categoryId];
    if (mastery == null) return 0.0;
    return (mastery.correctCount / mastery.totalCount.clamp(1, double.maxFinite));
  }

  /// Calculate average accuracy for last N days
  Future<double> getAverageAccuracyLastDays(int days) async {
    if (state == null) return 0.0;

    final today = DateTime.now();
    double totalAccuracy = 0;
    int daysWithData = 0;

    for (int i = 0; i < days; i++) {
      final date = today.subtract(Duration(days: i));
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final dailyStats = state!.dailyHistory.where((s) => s.date == dateStr).firstOrNull;
      if (dailyStats != null && dailyStats.totalAnswers > 0) {
        totalAccuracy += (dailyStats.correctAnswers / dailyStats.totalAnswers);
        daysWithData++;
      }
    }

    return daysWithData > 0 ? totalAccuracy / daysWithData : 0.0;
  }

  /// Get total study time in hours for this week
  Future<int> getWeeklyStudyHours() async {
    if (state == null) return 0;
    int totalMinutes = 0;

    for (final stats in state!.dailyHistory) {
      totalMinutes += stats.studyMinutes;
    }

    return (totalMinutes / 60).toInt();
  }

  /// Get improvement trend (comparing last week to previous week)
  Future<double> getImprovementTrend() async {
    if (state == null) return 0.0;

    final lastWeekAvg = await getAverageAccuracyLastDays(7);
    final previousWeekAvg = await getAverageAccuracyLastDays(14);

    if (previousWeekAvg == 0) return 0.0;
    return ((lastWeekAvg - previousWeekAvg) / previousWeekAvg) * 100;
  }

  /// Predict mastery level based on recent practice
  double predictMasteryLevel(String categoryId) {
    if (state == null) return 0.0;
    final mastery = state!.categoryMastery[categoryId];
    if (mastery == null) return 0.0;

    final current = mastery.masteryLevel;
    final recent = mastery.recentScores.isNotEmpty
        ? (mastery.recentScores.reduce((a, b) => a + b) / mastery.recentScores.length) / 100
        : 0.0;

    return (current + recent) / 2;
  }

  /// Calculate monthly statistics for a specific month (YYYY-MM)
  MonthlyStats? calculateMonthlyStats(String month) {
    if (state == null) return null;

    final targetYear = int.parse(month.split('-')[0]);
    final targetMonth = int.parse(month.split('-')[1]);

    // Filter daily stats for this month
    final monthlyDailyStats = state!.dailyHistory.where((s) {
      final date = DateTime.parse(s.date);
      return date.year == targetYear && date.month == targetMonth;
    }).toList();

    if (monthlyDailyStats.isEmpty) return null;

    int totalQuests = 0;
    int totalCorrect = 0;
    int totalAnswers = 0;
    int totalMinutes = 0;
    int totalCoins = 0;
    final Map<String, dynamic> categoryStats = {};

    for (final daily in monthlyDailyStats) {
      totalQuests += daily.questsCompleted;
      totalCorrect += daily.correctAnswers;
      totalAnswers += daily.totalAnswers;
      totalMinutes += daily.studyMinutes;
      totalCoins += daily.coinsEarned;

      // Aggregate category stats
      daily.categoryStats.forEach((catId, catData) {
        if (!categoryStats.containsKey(catId)) {
          categoryStats[catId] = {'correct': 0, 'total': 0};
        }
        categoryStats[catId]['correct'] += catData['correct'] as int? ?? 0;
        categoryStats[catId]['total'] += catData['total'] as int? ?? 0;
      });
    }

    // Calculate accuracy rate for each category
    categoryStats.forEach((catId, stats) {
      if (stats['total'] > 0) {
        stats['accuracy'] = stats['correct'] / stats['total'];
      } else {
        stats['accuracy'] = 0.0;
      }
    });

    final accuracyRate = totalAnswers > 0 ? totalCorrect / totalAnswers : 0.0;

    return MonthlyStats(
      month: month,
      totalQuestsCompleted: totalQuests,
      totalCorrectAnswers: totalCorrect,
      totalAnswers: totalAnswers,
      accuracyRate: accuracyRate,
      totalStudyMinutes: totalMinutes,
      totalCoinsEarned: totalCoins,
      studyDaysCount: monthlyDailyStats.length,
      categoryStats: categoryStats,
    );
  }

  /// Get monthly stats for last N months
  List<MonthlyStats> getMonthlyStatsList(int months) {
    if (state == null) return [];

    final monthlyStatsList = <MonthlyStats>[];
    final now = DateTime.now();

    for (int i = 0; i < months; i++) {
      final date = DateTime(now.year, now.month - i, 1);
      final monthStr = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      final monthly = calculateMonthlyStats(monthStr);
      if (monthly != null) {
        monthlyStatsList.add(monthly);
      }
    }

    return monthlyStatsList;
  }
}

class LearningPaceNotifier extends StateNotifier<LearningPaceData?> {
  LearningPaceNotifier() : super(null);

  /// Analyze learning pace and provide recommendations
  Future<LearningPaceData> analyzeLearningPace(
    String userId,
    int averageQuestsPerDay,
    int inconsistencyDays,
  ) async {
    try {
      // Calculate recommended pace based on performance
      final recommendedDaily = _calculateRecommendedPace(averageQuestsPerDay);
      final consistencyScore = _calculateConsistencyScore(inconsistencyDays);

      final paceData = LearningPaceData(
        userId: userId,
        recommendedQuestsPerDay: recommendedDaily,
        averageQuestsPerDay: averageQuestsPerDay,
        inconsistencyDays: inconsistencyDays,
        studyConsistencyScore: consistencyScore,
        nextCheckDate: DateTime.now().add(const Duration(days: 7)),
      );

      state = paceData;
      return paceData;
    } catch (e) {
      debugPrint('❌ Error analyzing learning pace: $e');
      rethrow;
    }
  }

  /// Calculate recommended pace
  int _calculateRecommendedPace(int currentAverage) {
    // Recomm recommendation logic:
    // - If very consistent (20+ quests/day), increase to 25
    // - If moderate (10-19), maintain 15
    // - If low (< 10), recommend 10
    if (currentAverage >= 20) {
      return 25;
    } else if (currentAverage >= 10) {
      return 15;
    } else {
      return 10;
    }
  }

  /// Calculate consistency score (0.0 ~ 1.0)
  double _calculateConsistencyScore(int inconsistencyDays) {
    // Out of 30-day period, calculate consistency
    final consistency = ((30 - inconsistencyDays) / 30).clamp(0.0, 1.0);
    return consistency;
  }

  /// Get personalized recommendations based on pace
  List<String> getRecommendations(LearningPaceData pace) {
    final recommendations = <String>[];

    if (pace.studyConsistencyScore < 0.5) {
      recommendations.add('毎日の学習を心がけてみてください。');
    }

    if (pace.averageQuestsPerDay < pace.recommendedQuestsPerDay) {
      recommendations.add(
        '現在 ${pace.averageQuestsPerDay} 問/日ですが、${pace.recommendedQuestsPerDay} 問/日を目安に進めてみてください。',
      );
    }

    if (pace.studyConsistencyScore >= 0.8) {
      recommendations.add('毎日の学習が習慣化されており、素晴らしいです！');
    }

    return recommendations;
  }

  /// Load pace data from local storage
  Future<void> loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pacingString = prefs.getString('learning_pace_data');
      if (pacingString != null) {
        final json = jsonDecode(pacingString) as Map<String, dynamic>;
        state = LearningPaceData.fromJson(json);
      }
    } catch (e) {
      debugPrint('❌ Error loading pace data: $e');
    }
  }

  /// Save pace data to local storage
  Future<void> saveToPreferences(LearningPaceData pace) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(pace.toJson());
      await prefs.setString('learning_pace_data', json);
      await prefs.setString('last_pace_check', DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('❌ Error saving pace data: $e');
    }
  }
}
