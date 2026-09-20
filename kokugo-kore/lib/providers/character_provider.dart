import 'package:shared_core/shared_core.dart';
import '../data/kokugo_characters.dart';

/// 国語コレ！キャラクター進捗 Notifier
///
/// shared_core の [BaseCharacterNotifier] を継承し、キャラ一覧と
/// SharedPreferences のキーだけをアプリ固有にする。
class CharacterNotifier extends BaseCharacterNotifier {
  @override
  List<BaseCharacter> get characterList => kKokugoCharacters;

  @override
  String get storageKey => 'kokugo_char_states';
}
