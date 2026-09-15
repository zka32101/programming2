import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/models/ranking_model.dart';

void main() {
  group('RankingModel Tests', () {
    test('StudentRankingData creates instance correctly', () {
      final now = DateTime.now();
      final student = StudentRankingData(
        studentId: 'student_1',
        studentName: '田中 太郎',
        score: 15,
        rank: 1,
        startedAt: now,
        birthYear: 2021,
        acquiredAt: now,
      );

      expect(student.studentId, 'student_1');
      expect(student.studentName, '田中 太郎');
      expect(student.score, 15);
      expect(student.rank, 1);
      expect(student.birthYear, 2021);
      expect(student.acquiredAt, now);
    });

    test('StudentRankingData toString works', () {
      final student = StudentRankingData(
        studentId: 'student_1',
        studentName: '田中 太郎',
        score: 15,
        rank: 1,
        startedAt: DateTime(2026, 1, 15),
        birthYear: 2021,
      );

      final string = student.toString();
      expect(string, contains('student_1'));
      expect(string, contains('田中 太郎'));
      expect(string, contains('rank: 1'));
      expect(string, contains('score: 15'));
      expect(string, contains('grade:'));
    });

    test('RankingFilter creates instance correctly', () {
      final filter = RankingFilter(
        groupBy: RankingGroupBy.byGrade,
        specificGrade: 5,
      );

      expect(filter.groupBy, RankingGroupBy.byGrade);
      expect(filter.specificGrade, 5);
      expect(filter.startDateRange, isNull);
    });

    test('RankingFilter equality works', () {
      final filter1 = RankingFilter(
        groupBy: RankingGroupBy.byGrade,
        specificGrade: 5,
      );
      final filter2 = RankingFilter(
        groupBy: RankingGroupBy.byGrade,
        specificGrade: 5,
      );
      final filter3 = RankingFilter(
        groupBy: RankingGroupBy.byStartDate,
        specificGrade: 5,
      );

      expect(filter1, filter2);
      expect(filter1, isNot(filter3));
    });

    test('RankingFilter hash code works', () {
      final filter1 = RankingFilter(
        groupBy: RankingGroupBy.byGrade,
        specificGrade: 5,
      );
      final filter2 = RankingFilter(
        groupBy: RankingGroupBy.byGrade,
        specificGrade: 5,
      );

      expect(filter1.hashCode, filter2.hashCode);
    });

    test('RankingGroupBy.all label is correct', () {
      expect(RankingGroupBy.all.label, 'すべて');
    });

    test('RankingGroupBy.byGrade label is correct', () {
      expect(RankingGroupBy.byGrade.label, '学年別');
    });

    test('RankingGroupBy.byStartDate label is correct', () {
      expect(RankingGroupBy.byStartDate.label, '開始月別');
    });

    test('RankingGroupBy.byStartDateAndGrade label is correct', () {
      expect(
        RankingGroupBy.byStartDateAndGrade.label,
        '学年×開始月',
      );
    });

    test('StudentRankingData with minimal parameters', () {
      final student = StudentRankingData(
        studentId: 'student_1',
        studentName: '田中 太郎',
        score: 10,
        rank: 1,
        startedAt: DateTime(2026, 1, 1),
        birthYear: 2021,
      );

      expect(student.acquiredAt, isNull);
    });

    test('StudentRankingData currentGrade calculates correctly on April 1st or later', () {
      // 2026年9月1日、2021年生まれ = 5年生
      final student = StudentRankingData(
        studentId: 'student_1',
        studentName: '田中 太郎',
        score: 10,
        rank: 1,
        startedAt: DateTime(2026, 1, 1),
        birthYear: 2021,
      );

      final gradeOn20260901 = student.getGradeAt(DateTime(2026, 9, 1));
      expect(gradeOn20260901, 5);
    });

    test('StudentRankingData currentGrade updates on April 1st', () {
      final student = StudentRankingData(
        studentId: 'student_1',
        studentName: '田中 太郎',
        score: 10,
        rank: 1,
        startedAt: DateTime(2026, 1, 1),
        birthYear: 2021,
      );

      // 3月31日は4年生
      final gradeOn20270331 = student.getGradeAt(DateTime(2027, 3, 31));
      expect(gradeOn20270331, 5);

      // 4月1日は5年生
      final gradeOn20270401 = student.getGradeAt(DateTime(2027, 4, 1));
      expect(gradeOn20270401, 6);
    });

    test('StudentRankingData currentGrade caps at 6th grade', () {
      final student = StudentRankingData(
        studentId: 'student_1',
        studentName: '田中 太郎',
        score: 10,
        rank: 1,
        startedAt: DateTime(2026, 1, 1),
        birthYear: 2020,
      );

      // 2026年9月1日、2020年生まれ = 6年生（卒業）
      final gradeOn20260901 = student.getGradeAt(DateTime(2026, 9, 1));
      expect(gradeOn20260901, 6);

      // 2027年9月1日でも6年生を超えないように
      final gradeOn20270901 = student.getGradeAt(DateTime(2027, 9, 1));
      expect(gradeOn20270901, 6);
    });

    test('RankingFilter with default groupBy', () {
      final filter = RankingFilter();

      expect(filter.groupBy, RankingGroupBy.all);
      expect(filter.startDateRange, isNull);
      expect(filter.specificGrade, isNull);
    });
  });
}
