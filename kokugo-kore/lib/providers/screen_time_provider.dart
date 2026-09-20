import 'package:shared_core/shared_core.dart';

/// 国語コレ！利用時間制限（スクリーンタイム管理）Notifier。
///
/// shared_core の [BaseScreenTimeNotifier] を継承し、ストレージキーのみ
/// アプリ固有にする。`main.dart` の ProviderContainer で注入する。
class ScreenTimeNotifier extends BaseScreenTimeNotifier {
  @override
  String get storageKey => 'kokugo_screen_time';
}
