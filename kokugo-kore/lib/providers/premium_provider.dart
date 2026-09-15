import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _premiumKey = 'is_premium';
const _trialStartKey = 'trial_start_date';
const _trialDays = 14;

/// Google Play 商品ID（コンソールで設定する）
const kProductIdMonthly = 'kokugo-premium-monthly';
const kProductIdYearly = 'kokugo-premium-annual';

/// 無料で遊べる最大ステージ番号
const kFreeStageLimit = 3;

/// 購入試行の最終結果。`success: true` は purchaseStream が実際に
/// purchased/restored ステータスを返した（＝課金が確定した）ことを意味する。
/// リクエストが起動できただけの段階ではこのオブジェクトはまだ返らない
/// （_purchase が内部で完了/失敗/キャンセル/タイムアウトまで待つため）。
class PurchaseAttemptResult {
  final bool success;
  final String? errorMessage;

  const PurchaseAttemptResult._(this.success, this.errorMessage);

  factory PurchaseAttemptResult.success() =>
      const PurchaseAttemptResult._(true, null);

  factory PurchaseAttemptResult.failure(String message) =>
      PurchaseAttemptResult._(false, message);
}

class PremiumState {
  final bool isPremium;
  final bool isTrialActive;
  final int trialDaysLeft;
  final bool isLoading;

  const PremiumState({
    this.isPremium = false,
    this.isTrialActive = false,
    this.trialDaysLeft = 0,
    this.isLoading = true,
  });

  bool canAccessStage(int stageNumber) =>
      isPremium || isTrialActive || stageNumber <= kFreeStageLimit;

  PremiumState copyWith({
    bool? isPremium,
    bool? isTrialActive,
    int? trialDaysLeft,
    bool? isLoading,
  }) {
    return PremiumState(
      isPremium: isPremium ?? this.isPremium,
      isTrialActive: isTrialActive ?? this.isTrialActive,
      trialDaysLeft: trialDaysLeft ?? this.trialDaysLeft,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PremiumNotifier extends Notifier<PremiumState> {
  StreamSubscription<List<PurchaseDetails>>? _sub;
  // 進行中の購入/復元リクエストの完了を待つためのCompleter。
  // productIdごとに1件のみ（同時に同じ商品を二重購入させない導線はUI側で行うが、
  // ここでも古いCompleterが残らないよう常に置き換える）。
  final Map<String, Completer<PurchaseAttemptResult>> _pending = {};
  Completer<bool>? _pendingRestore;

  @override
  PremiumState build() => const PremiumState();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final isPremium = prefs.getBool(_premiumKey) ?? false;

    // トライアル判定
    final trialStartStr = prefs.getString(_trialStartKey);
    bool isTrialActive = false;
    int daysLeft = 0;

    if (trialStartStr == null) {
      // 初回起動 → トライアル開始（タイムゾーンに依存しないようUTCで保存）
      final today = DateTime.now().toUtc().toIso8601String();
      await prefs.setString(_trialStartKey, today);
      isTrialActive = true;
      daysLeft = _trialDays;
    } else {
      final trialStart = DateTime.tryParse(trialStartStr);
      if (trialStart != null) {
        // 端末の時計が巻き戻された場合でもトライアルが延び続けないよう、
        // 経過日数の下限を0にクランプする。
        final elapsed = DateTime.now()
            .toUtc()
            .difference(trialStart.toUtc())
            .inDays
            .clamp(0, _trialDays);
        daysLeft = _trialDays - elapsed;
        isTrialActive = daysLeft > 0;
      }
    }

    state = PremiumState(
      isPremium: isPremium,
      isTrialActive: isTrialActive && !isPremium,
      trialDaysLeft: daysLeft > 0 ? daysLeft : 0,
      isLoading: false,
    );

    // Google Play 購入状態をリッスン
    _listenPurchases();
  }

  void _listenPurchases() {
    _sub?.cancel();
    _sub = InAppPurchase.instance.purchaseStream.listen(
      (purchases) {
        for (final p in purchases) {
          switch (p.status) {
            case PurchaseStatus.purchased:
            case PurchaseStatus.restored:
              if (p.productID == kProductIdMonthly ||
                  p.productID == kProductIdYearly) {
                _setPremium(true);
                InAppPurchase.instance.completePurchase(p);
              }
              _resolvePending(p.productID, PurchaseAttemptResult.success());
              _pendingRestore?.complete(true);
              _pendingRestore = null;
              break;
            case PurchaseStatus.error:
              _resolvePending(
                p.productID,
                PurchaseAttemptResult.failure(
                  p.error?.message ?? '購入処理でエラーが発生しました。',
                ),
              );
              break;
            case PurchaseStatus.canceled:
              _resolvePending(
                p.productID,
                PurchaseAttemptResult.failure('購入がキャンセルされました。'),
              );
              break;
            case PurchaseStatus.pending:
              // まだ処理中。purchaseStreamの次のイベントを待つ。
              break;
          }
        }
      },
      onError: (_) {},
    );
  }

  void _resolvePending(String productId, PurchaseAttemptResult result) {
    final completer = _pending.remove(productId);
    if (completer != null && !completer.isCompleted) {
      completer.complete(result);
    }
  }

  Future<void> _setPremium(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, value);
    state = state.copyWith(isPremium: value, isTrialActive: false, isLoading: false);
  }

  /// 月額プランを購入
  Future<PurchaseAttemptResult> purchaseMonthly() => _purchase(kProductIdMonthly);

  /// 年額プランを購入
  Future<PurchaseAttemptResult> purchaseYearly() => _purchase(kProductIdYearly);

  Future<PurchaseAttemptResult> _purchase(String productId) async {
    try {
      final available = await InAppPurchase.instance.isAvailable();
      if (!available) {
        return PurchaseAttemptResult.failure(
          '購入機能が利用できません。Google Playストアアプリにログインしているか確認してください。',
        );
      }

      final response =
          await InAppPurchase.instance.queryProductDetails({productId});
      if (response.productDetails.isEmpty) {
        return PurchaseAttemptResult.failure(
          '商品情報を取得できませんでした（$productId）。Play Console側の商品設定・審査状況、'
          'またはこのビルドの署名がストア掲載と一致しているかを確認してください。',
        );
      }

      final completer = Completer<PurchaseAttemptResult>();
      _pending[productId] = completer;

      final param = PurchaseParam(
        productDetails: response.productDetails.first,
      );
      final launched =
          await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
      if (!launched) {
        _pending.remove(productId);
        return PurchaseAttemptResult.failure('購入処理を開始できませんでした。もう一度お試しください。');
      }

      // purchaseStreamが実際に purchased/error/canceled を返すまで待つ。
      // 万一何のイベントも届かない場合に備えてタイムアウトも設ける。
      return await completer.future.timeout(
        const Duration(minutes: 3),
        onTimeout: () {
          _pending.remove(productId);
          return PurchaseAttemptResult.failure(
            '購入処理がタイムアウトしました。通信状況を確認し、もう一度お試しください。',
          );
        },
      );
    } catch (e) {
      _pending.remove(productId);
      return PurchaseAttemptResult.failure('購入処理でエラーが発生しました: $e');
    }
  }

  /// 購入の復元。実際に復元されたかどうかを呼び出し側に返す
  /// （何も復元対象がない場合は一定時間待った後 false を返す）。
  Future<bool> restorePurchases() async {
    final completer = Completer<bool>();
    _pendingRestore = completer;
    await InAppPurchase.instance.restorePurchases();
    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        if (identical(_pendingRestore, completer)) _pendingRestore = null;
        return false;
      },
    );
  }

  void cancelSubscription() {
    _sub?.cancel();
  }
}

final premiumProvider =
    NotifierProvider<PremiumNotifier, PremiumState>(PremiumNotifier.new);

/// Google Playから取得した実際の商品情報（価格は端末の地域・税設定に応じて
/// ストア側でローカライズされた文字列）。取得失敗時はnullを返し、呼び出し側で
/// フォールバック表示にする。
final premiumProductsProvider =
    FutureProvider<Map<String, ProductDetails>>((ref) async {
  final available = await InAppPurchase.instance.isAvailable();
  if (!available) return {};

  final response = await InAppPurchase.instance
      .queryProductDetails({kProductIdMonthly, kProductIdYearly});
  return {for (final p in response.productDetails) p.id: p};
});
