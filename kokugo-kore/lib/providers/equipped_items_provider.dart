import 'package:shared_core/shared_core.dart' show BaseEquippedItemsNotifier;

/// 国語コレ固有のショップアイテム装着ノティファイア。
/// main.dart で equippedItemsProvider をこれで上書きする:
/// ```dart
/// equippedItemsProvider.overrideWith(EquippedItemsNotifier.new)
/// ```
class EquippedItemsNotifier extends BaseEquippedItemsNotifier {
  @override
  String get storageKey => 'kokugo_equipped_items_v1';

}
