import 'package:shared_core/shared_core.dart';
import '../data/sansu_characters.dart';

/// 算数コレ固有のキャラクターノティファイア。
/// main.dart で characterStateProvider をこれで上書きする:
/// ```dart
/// characterStateProvider.overrideWith(CharacterNotifier.new)
/// ```
class CharacterNotifier extends BaseCharacterNotifier {
  @override
  List<BaseCharacter> get characterList => kSansuCharacters;

  @override
  String get storageKey => 'sansu_char_states';
}
