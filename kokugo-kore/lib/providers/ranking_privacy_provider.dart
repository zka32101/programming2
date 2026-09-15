import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _privacyKey = 'ranking_name_public';
const _privacyDialogShownKey = 'ranking_privacy_dialog_shown';

/// ランキング表示のプライバシー設定
class RankingPrivacyState {
  final bool isNamePublic; // ユーザー名を公開するか
  final bool dialogShown; // プライバシーダイアログを表示済みか

  const RankingPrivacyState({
    this.isNamePublic = false,
    this.dialogShown = false,
  });

  RankingPrivacyState copyWith({
    bool? isNamePublic,
    bool? dialogShown,
  }) {
    return RankingPrivacyState(
      isNamePublic: isNamePublic ?? this.isNamePublic,
      dialogShown: dialogShown ?? this.dialogShown,
    );
  }

  /// ユーザー名公開許可ダイアログを表示すべきか判定
  /// - まだ表示していない かつ
  /// - ユーザー名が非公開の場合に true を返す
  bool shouldShowPrivacyDialog() {
    return !dialogShown && !isNamePublic;
  }
}

/// ランキング表示プライバシー設定を管理
class RankingPrivacyNotifier extends Notifier<RankingPrivacyState> {
  @override
  RankingPrivacyState build() => const RankingPrivacyState();

  /// 初期化: SharedPreferences から設定を読み込む
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final isNamePublic = prefs.getBool(_privacyKey) ?? false;
    final dialogShown = prefs.getBool(_privacyDialogShownKey) ?? false;

    state = RankingPrivacyState(
      isNamePublic: isNamePublic,
      dialogShown: dialogShown,
    );
  }

  /// プライバシー設定を更新
  /// [isPublic]: true = ユーザー名を公開、false = 匿名表示
  Future<void> setNamePublic(bool isPublic) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_privacyKey, isPublic);
    state = state.copyWith(isNamePublic: isPublic);
  }

  /// プライバシーダイアログを表示済みにマーク
  Future<void> markDialogShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_privacyDialogShownKey, true);
    state = state.copyWith(dialogShown: true);
  }

  /// プライバシー設定のリセット（開発/テスト用）
  Future<void> resetPrivacySettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_privacyKey);
    await prefs.remove(_privacyDialogShownKey);
    state = const RankingPrivacyState();
  }

  /// ユーザー名公開許可ダイアログを表示すべきか判定
  /// - まだ表示していない かつ
  /// - ユーザー名が非公開の場合に true を返す
  bool shouldShowPrivacyDialog() {
    return !state.dialogShown && !state.isNamePublic;
  }
}

final rankingPrivacyProvider =
    NotifierProvider<RankingPrivacyNotifier, RankingPrivacyState>(
  RankingPrivacyNotifier.new,
);

/// ランキング表示用のプライバシー設定（読み取り専用）
final rankingNamePublicProvider = Provider<bool>((ref) {
  return ref.watch(rankingPrivacyProvider).isNamePublic;
});

/// プライバシーダイアログ表示判定
final rankingPrivacyDialogProvider = Provider<bool>((ref) {
  final privacy = ref.watch(rankingPrivacyProvider);
  return privacy.shouldShowPrivacyDialog();
});
