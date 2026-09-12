import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

/// Cloud Functions 実行ロジック（Phase 4.17）
class CloudFunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// 週次レポート生成を Cloud Functions で実行
  Future<Map<String, dynamic>> generateWeeklyReport(String userId) async {
    try {
      final callable = _functions.httpsCallable('generateWeeklyReport');
      final result = await callable.call({'userId': userId});
      return Map<String, dynamic>.from(result.data ?? {});
    } catch (e) {
      debugPrint('Error generating weekly report: $e');
      return {};
    }
  }

  /// 月次レポート生成を Cloud Functions で実行
  Future<Map<String, dynamic>> generateMonthlyReport(String userId) async {
    try {
      final callable = _functions.httpsCallable('generateMonthlyReport');
      final result = await callable.call({'userId': userId});
      return Map<String, dynamic>.from(result.data ?? {});
    } catch (e) {
      debugPrint('Error generating monthly report: $e');
      return {};
    }
  }

  /// ランキング集計を Cloud Functions で実行
  Future<Map<String, dynamic>> updateRankings(String subject) async {
    try {
      final callable = _functions.httpsCallable('updateRankings');
      final result = await callable.call({'subject': subject});
      return Map<String, dynamic>.from(result.data ?? {});
    } catch (e) {
      debugPrint('Error updating rankings: $e');
      return {};
    }
  }
}
