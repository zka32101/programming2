import 'package:flutter/foundation.dart';

/// パフォーマンス計測ユーティリティ
class PerformanceProfiler {
  static final _instance = PerformanceProfiler._internal();

  factory PerformanceProfiler() {
    return _instance;
  }

  PerformanceProfiler._internal();

  final Map<String, List<PerformanceMetric>> _metrics = {};

  /// 処理時間を計測して記録
  Future<T> measure<T>(
    String label,
    Future<T> Function() function,
  ) async {
    final stopwatch = Stopwatch()..start();

    try {
      final result = await function();
      stopwatch.stop();

      _recordMetric(
        label,
        stopwatch.elapsedMilliseconds.toDouble(),
        PerformanceStatus.success,
      );

      return result;
    } catch (e) {
      stopwatch.stop();

      _recordMetric(
        label,
        stopwatch.elapsedMilliseconds.toDouble(),
        PerformanceStatus.error,
        error: e.toString(),
      );

      rethrow;
    }
  }

  /// 同期処理の時間を計測
  T measureSync<T>(
    String label,
    T Function() function,
  ) {
    final stopwatch = Stopwatch()..start();

    try {
      final result = function();
      stopwatch.stop();

      _recordMetric(
        label,
        stopwatch.elapsedMilliseconds.toDouble(),
        PerformanceStatus.success,
      );

      return result;
    } catch (e) {
      stopwatch.stop();

      _recordMetric(
        label,
        stopwatch.elapsedMilliseconds.toDouble(),
        PerformanceStatus.error,
        error: e.toString(),
      );

      rethrow;
    }
  }

  /// メトリクスを記録
  void _recordMetric(
    String label,
    double duration,
    PerformanceStatus status, {
    String? error,
  }) {
    final metric = PerformanceMetric(
      label: label,
      durationMs: duration,
      status: status,
      timestamp: DateTime.now(),
      error: error,
    );

    _metrics.putIfAbsent(label, () => []).add(metric);

    if (kDebugMode) {
      debugPrint(
        '⏱️ $label: ${duration.toStringAsFixed(2)}ms '
        '(${status.name})',
      );
    }
  }

  /// ラベルの統計情報を取得
  PerformanceStats? getStats(String label) {
    final metrics = _metrics[label];
    if (metrics == null || metrics.isEmpty) return null;

    final durations = metrics.map((m) => m.durationMs).toList();
    durations.sort();

    final successCount = metrics.where((m) => m.status == PerformanceStatus.success).length;
    final errorCount = metrics.where((m) => m.status == PerformanceStatus.error).length;

    return PerformanceStats(
      label: label,
      count: metrics.length,
      averageDurationMs: durations.reduce((a, b) => a + b) / durations.length,
      minDurationMs: durations.first,
      maxDurationMs: durations.last,
      medianDurationMs: durations[durations.length ~/ 2],
      successCount: successCount,
      errorCount: errorCount,
    );
  }

  /// すべての統計情報を表示
  void printReport() {
    if (kDebugMode) {
      debugPrint('\n╔════════════════════════════════════════╗');
      debugPrint('║     Performance Report                 ║');
      debugPrint('╚════════════════════════════════════════╝\n');

      for (final label in _metrics.keys) {
        final stats = getStats(label);
        if (stats != null) {
          debugPrint('''
📊 $label
  Count: ${stats.count} calls
  Avg: ${stats.averageDurationMs.toStringAsFixed(2)}ms
  Min: ${stats.minDurationMs.toStringAsFixed(2)}ms
  Max: ${stats.maxDurationMs.toStringAsFixed(2)}ms
  Median: ${stats.medianDurationMs.toStringAsFixed(2)}ms
  Success: ${stats.successCount} | Error: ${stats.errorCount}
''');
        }
      }
    }
  }

  /// メトリクスをクリア
  void clear() {
    _metrics.clear();
  }

  /// 特定のラベルのメトリクスをクリア
  void clearLabel(String label) {
    _metrics.remove(label);
  }
}

/// パフォーマンスメトリクス
class PerformanceMetric {
  final String label;
  final double durationMs;
  final PerformanceStatus status;
  final DateTime timestamp;
  final String? error;

  PerformanceMetric({
    required this.label,
    required this.durationMs,
    required this.status,
    required this.timestamp,
    this.error,
  });
}

/// パフォーマンス統計
class PerformanceStats {
  final String label;
  final int count;
  final double averageDurationMs;
  final double minDurationMs;
  final double maxDurationMs;
  final double medianDurationMs;
  final int successCount;
  final int errorCount;

  PerformanceStats({
    required this.label,
    required this.count,
    required this.averageDurationMs,
    required this.minDurationMs,
    required this.maxDurationMs,
    required this.medianDurationMs,
    required this.successCount,
    required this.errorCount,
  });

  /// パフォーマンスが良好かどうか判定
  bool isHealthy({
    double maxAverageMs = 100.0,
    double maxMaxMs = 300.0,
  }) {
    return averageDurationMs <= maxAverageMs && maxDurationMs <= maxMaxMs;
  }
}

/// パフォーマンスステータス
enum PerformanceStatus {
  success,
  error,
}

/// グローバルプロファイラーインスタンス
final profiler = PerformanceProfiler();
