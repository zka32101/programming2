import 'package:shared_core/shared_core.dart';

/// 国語コレ！ショップアイテム装着状態 Notifier。
///
/// shared_core の [BaseEquippedItemsNotifier] を継承し、
/// SharedPreferences の名前空間をアプリ固有にする。
class EquippedItemsNotifier extends BaseEquippedItemsNotifier {
  @override
  String get storageKey => 'kokugo_equipped_items';
}
