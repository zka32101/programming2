/// ランキング関連のモデルクラス

/// 学生のランキングデータ
class StudentRankingData {
  final String studentId;
  final String studentName;
  final int score; // バッジ数またはポイント
  final int rank; // グループ内順位
  final DateTime startedAt; // アプリ登録日
  final int birthYear; // 生年（学年自動計算用）
  final DateTime? acquiredAt; // 最後に獲得した日

  StudentRankingData({
    required this.studentId,
    required this.studentName,
    required this.score,
    required this.rank,
    required this.startedAt,
    required this.birthYear,
    this.acquiredAt,
  });

  /// 現在の学年を自動計算（4月1日に学年が上がる）
  /// 日本の学年制度: 4月1日が新年度開始
  int get currentGrade {
    return _calculateGrade(birthYear, DateTime.now());
  }

  /// 指定の日時における学年を計算
  int getGradeAt(DateTime dateTime) {
    return _calculateGrade(birthYear, dateTime);
  }

  /// 学年計算ロジック
  /// birthYear: 生年
  /// dateTime: 計算対象の日時
  /// 戻り値: 1〜6年生（超過した場合は6を返す）
  static int _calculateGrade(int birthYear, DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month;

    // 4月より前の場合は前年度
    if (month < 4) {
      year--;
    }

    int grade = year - birthYear;

    // 6年生が上限（中学進学）
    if (grade > 6) {
      return 6;
    } else if (grade < 1) {
      return 1;
    }

    return grade;
  }

  /// プライバシー保護用：ユーザー名を匿名化
  /// 形式: "学生001" など
  String get displayName => 'ユーザー $studentId'.replaceFirst('student_', '');

  /// ランキング表示用の名前を取得
  /// [isNamePublic] が true の場合は本名、false の場合は匿名化
  String getDisplayName({bool isNamePublic = false}) {
    return isNamePublic ? studentName : displayName;
  }

  @override
  String toString() =>
      'StudentRankingData(id: $studentId, name: $studentName, rank: $rank, score: $score, grade: $currentGrade)';
}

/// ランキング表示のフィルター設定
class RankingFilter {
  final RankingGroupBy groupBy;
  final DateTime? startDateRange;
  final int? specificGrade;

  RankingFilter({
    this.groupBy = RankingGroupBy.all,
    this.startDateRange,
    this.specificGrade,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankingFilter &&
          runtimeType == other.runtimeType &&
          groupBy == other.groupBy &&
          startDateRange == other.startDateRange &&
          specificGrade == other.specificGrade;

  @override
  int get hashCode =>
      groupBy.hashCode ^ startDateRange.hashCode ^ specificGrade.hashCode;
}

/// ランキングのグループ化方法
enum RankingGroupBy {
  all,
  byGrade,
  byStartDate,
  byStartDateAndGrade,
}

extension RankingGroupByLabel on RankingGroupBy {
  String get label {
    switch (this) {
      case RankingGroupBy.all:
        return 'すべて';
      case RankingGroupBy.byGrade:
        return '学年別';
      case RankingGroupBy.byStartDate:
        return '開始月別';
      case RankingGroupBy.byStartDateAndGrade:
        return '学年×開始月';
    }
  }
}
