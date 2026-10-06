import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/models/ranking_model.dart';
import 'package:kokugo_kore/services/ranking_service.dart';

List<StudentRankingData> _sample() => [
      StudentRankingData(
        studentId: 's1',
        studentName: '田中 太郎',
        score: 15,
        rank: 1,
        startedAt: DateTime(2026, 1, 15),
        birthYear: 2021,
        acquiredAt: DateTime(2026, 8, 20),
      ),
      StudentRankingData(
        studentId: 's2',
        studentName: '山田 花子',
        score: 13,
        rank: 2,
        startedAt: DateTime(2026, 2, 10),
        birthYear: 2021,
        acquiredAt: DateTime(2026, 8, 18),
      ),
      StudentRankingData(
        studentId: 's3',
        studentName: '佐藤 次郎',
        score: 12,
        rank: 3,
        startedAt: DateTime(2026, 1, 5),
        birthYear: 2019,
        acquiredAt: DateTime(2026, 8, 15),
      ),
    ];

void main() {
  group('RankingService Tests', () {
    late RankingService rankingService;

    setUp(() {
      // Firebase 非依存にするため、取得元を固定データに差し替える
      rankingService = RankingService(studentDataLoader: () async => _sample());
    });

    test('getStudentRankings returns list of students sorted by score', () async {
      final filter = RankingFilter(groupBy: RankingGroupBy.all);
      final rankings = await rankingService.getStudentRankings(filter);

      expect(rankings.isNotEmpty, true);
      expect(rankings.length, greaterThan(0));

      // スコアでソートされているか確認
      for (int i = 0; i < rankings.length - 1; i++) {
        expect(rankings[i].score >= rankings[i + 1].score, true);
      }
    });

    test('getGroupedRankings groups by grade', () async {
      final filter = RankingFilter(groupBy: RankingGroupBy.byGrade);
      final grouped = await rankingService.getGroupedRankings(filter);

      expect(grouped.isNotEmpty, true);

      // グループキーに「年生」が含まれるか確認
      for (final key in grouped.keys) {
        expect(key, contains('年生'));
      }
    });

    test('getGroupedRankings groups by start date', () async {
      final filter = RankingFilter(groupBy: RankingGroupBy.byStartDate);
      final grouped = await rankingService.getGroupedRankings(filter);

      expect(grouped.isNotEmpty, true);

      // グループキーに「年」と「月」が含まれるか確認
      for (final key in grouped.keys) {
        expect(key, contains('年'));
        expect(key, contains('月'));
      }
    });

    test('getGroupedRankings groups by grade and start date', () async {
      final filter = RankingFilter(groupBy: RankingGroupBy.byStartDateAndGrade);
      final grouped = await rankingService.getGroupedRankings(filter);

      expect(grouped.isNotEmpty, true);

      // グループキーに「年生」と「開始」が含まれるか確認
      for (final key in grouped.keys) {
        expect(key, contains('年生'));
        expect(key, contains('開始'));
      }
    });

    test('getGroupedRankings all groups have non-empty lists', () async {
      final filter = RankingFilter(groupBy: RankingGroupBy.byGrade);
      final grouped = await rankingService.getGroupedRankings(filter);

      for (final students in grouped.values) {
        expect(students.isNotEmpty, true);
      }
    });

    test('getStudentRank returns correct rank for existing student', () async {
      final filter = RankingFilter(groupBy: RankingGroupBy.all);
      final rankings = await rankingService.getStudentRankings(filter);
      final firstStudentId = rankings.first.studentId;

      final rank = await rankingService.getStudentRank(firstStudentId, filter);

      expect(rank, 1);
    });

    test('getStudentRank returns null for non-existing student', () async {
      final filter = RankingFilter(groupBy: RankingGroupBy.all);

      final rank = await rankingService.getStudentRank('non_existing_id', filter);

      expect(rank, isNull);
    });

    test('getStudentRankings returns data with valid StudentRankingData objects',
        () async {
      final filter = RankingFilter(groupBy: RankingGroupBy.all);
      final rankings = await rankingService.getStudentRankings(filter);

      for (final student in rankings) {
        expect(student.studentId.isNotEmpty, true);
        expect(student.studentName.isNotEmpty, true);
        expect(student.score, greaterThanOrEqualTo(0));
        expect(student.rank, greaterThan(0));
        expect(student.currentGrade, greaterThan(0));
        expect(student.currentGrade, lessThanOrEqualTo(6));
      }
    });

    test('getGroupedRankings all returns single group named "全体"', () async {
      final filter = RankingFilter(groupBy: RankingGroupBy.all);
      final grouped = await rankingService.getGroupedRankings(filter);

      expect(grouped.containsKey('全体'), true);
      expect(grouped.length, 1);
    });

    test('getStudentRankings by grade is sorted by grade ascending', () async {
      final filter = RankingFilter(groupBy: RankingGroupBy.byGrade);
      final grouped = await rankingService.getGroupedRankings(filter);

      final grades = grouped.keys
          .map((key) => int.parse(key.replaceAll(RegExp(r'[^\d]'), '')))
          .toList();

      for (int i = 0; i < grades.length - 1; i++) {
        expect(grades[i] <= grades[i + 1], true);
      }
    });

    test('falls back to sample data when Firebase is unavailable', () async {
      // 取得元を差し替えない場合、テスト環境では Firebase 未初期化 → フォールバック
      final service = RankingService();
      final rankings = await service
          .getStudentRankings(RankingFilter(groupBy: RankingGroupBy.all));

      expect(rankings, isNotEmpty);
    });
  });
}
