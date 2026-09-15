import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _gradeKey = 'selected_grade';

class GradeNotifier extends Notifier<int> {
  bool _isFirstLaunch = false;

  bool get isFirstLaunch => _isFirstLaunch;

  @override
  int build() => 0;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_gradeKey);
    _isFirstLaunch = saved == null;
    state = saved ?? 0;
  }

  Future<void> setGrade(int grade) async {
    state = grade;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_gradeKey, grade);
  }
}

final gradeProvider = NotifierProvider<GradeNotifier, int>(GradeNotifier.new);
