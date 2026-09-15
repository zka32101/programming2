import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../models/promoted_app.dart';

/// Remote Config 繧ｭ繝ｼ縲ょ､縺ｯ PromotedApp.toJson() 縺ｮ驟榊・繧・JSON 繧ｨ繝ｳ繧ｳ繝ｼ繝峨＠縺溘ｂ縺ｮ縲・
/// 蜈ｨ繧｢繝励Μ蜈ｱ騾壹・繧ｭ繝ｼ縺ｧ縲√・繝ｼ繝医ヵ繧ｩ繝ｪ繧ｪ蜈ｨ菴薙・邏ｹ莉句呵｣懊ｒ1縺､縺ｮJSON驟榊・縺ｫ縺ｾ縺ｨ繧√※驟堺ｿ｡縺吶ｋ縲・
/// 蜷・い繝励Μ縺ｯ currentAppId 縺ｧ閾ｪ蛻・ｒ髯､螟悶＠縲…urrentCategory 縺ｧ縲悟酔縺倥す繝ｪ繝ｼ繧ｺ縲阪↓邨槭ｊ霎ｼ繧縲・
///
/// 萓・
/// [
///   {"id":"com.apps.shougakukore.sansu","name":"邂玲焚繧ｳ繝ｬ・・,"tagline":"...",
///    "iconUrl":"...","storeUrl":"...","category":"蟆丞ｭｦ繧ｳ繝ｬ"},
///   {"id":"com.apps.nihonryoudodefense","name":"譌･譛ｬ鬆伜悄繝・ぅ繝輔ぉ繝ｳ繧ｹ","tagline":"...",
///    "iconUrl":"...","storeUrl":"...","category":"繝代ぜ繝ｫ繝ｻ繧ｲ繝ｼ繝"}
/// ]
const kCrossPromoRemoteConfigKey = 'cross_promo_apps';

/// 繧｢繝励Μ蜀・け繝ｭ繧ｹ繝励Ο繝｢繝ｼ繧ｷ繝ｧ繝ｳ逕ｨ縺ｮ邏ｹ莉九Μ繧ｹ繝医ｒ Firebase Remote Config 縺九ｉ蜿門ｾ励☆繧九し繝ｼ繝薙せ縲・
class CrossPromoService {
  CrossPromoService._();

  static FirebaseRemoteConfig? _remoteConfig;

  /// 繧｢繝励Μ襍ｷ蜍墓凾縺ｫ荳蠎ｦ蜻ｼ縺ｶ縲ょ､ｱ謨励＠縺ｦ繧ゆｾ句､悶ｒ謚輔￡縺壹∽ｻ･髯阪・遨ｺ繝ｪ繧ｹ繝医→縺励※謇ｱ縺・・
  static Future<void> init() async {
    try {
      final rc = FirebaseRemoteConfig.instance;
      await rc.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 6),
        ),
      );
      await rc.setDefaults(const {kCrossPromoRemoteConfigKey: '[]'});
      await rc.fetchAndActivate();
      _remoteConfig = rc;
    } catch (_) {
      _remoteConfig = null;
    }
  }

  /// 邏ｹ莉句ｯｾ雎｡縺ｮ繧｢繝励Μ荳隕ｧ繧定ｿ斐☆縲・
  /// - [currentAppId] 縺ｨ荳閾ｴ縺吶ｋ繧ｨ繝ｳ繝医Μ縺ｯ閾ｪ繧｢繝励Μ縺ｪ縺ｮ縺ｧ蟶ｸ縺ｫ髯､螟悶☆繧九・
  /// - [currentCategory] 繧呈ｸ｡縺吶→縲∝酔縺・category 縺ｮ繧｢繝励Μ縺縺代↓邨槭ｊ霎ｼ繧
  ///   ・茨ｼ昴碁｡樔ｼｼ縺吶ｋ繧｢繝励Μ縲阪ｒ邏ｹ莉具ｼ峨Ｏull 縺ｾ縺溘・遨ｺ譁・ｭ励↑繧臥ｵ槭ｊ霎ｼ縺ｾ縺壼・莉ｶ蟇ｾ雎｡縲・
  static List<PromotedApp> getPromotedApps({
    required String currentAppId,
    String? currentCategory,
  }) {
    final raw = _remoteConfig?.getString(kCrossPromoRemoteConfigKey) ?? '[]';
    return parseApps(raw, currentAppId: currentAppId, currentCategory: currentCategory);
  }

  /// Remote Config 縺ｮ逕櫟SON譁・ｭ怜・縺九ｉ [PromotedApp] 荳隕ｧ繧堤ｵ・∩遶九※繧狗ｴ皮ｲ矩未謨ｰ縲・
  /// Firebase 蛻晄悄蛹悶↑縺励〒繝ｭ繧ｸ繝・け蜊倅ｽ薙ｒ繝・せ繝医〒縺阪ｋ繧医≧蛻・屬縺励※縺・ｋ縲・
  static List<PromotedApp> parseApps(
    String rawJson, {
    required String currentAppId,
    String? currentCategory,
  }) {
    final normalizedCurrentId = _stripDebugSuffix(currentAppId);
    try {
      final decoded = jsonDecode(rawJson) as List<dynamic>;
      return decoded
          .cast<Map<String, dynamic>>()
          .map(PromotedApp.fromJson)
          .where((app) => app.id != normalizedCurrentId && app.storeUrl.isNotEmpty)
          .where((app) =>
              currentCategory == null ||
              currentCategory.isEmpty ||
              app.category == currentCategory)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  /// 繝・ヰ繝・げ繝薙Ν繝峨・ applicationIdSuffix (".debug" 縺ｪ縺ｩ) 縺御ｻ倥＞縺溷挨繝代ャ繧ｱ繝ｼ繧ｸ蜷阪〒
  /// 螳溯｡後＆繧後ｋ縺溘ａ縲ヽemote Config 縺ｫ逋ｻ骭ｲ縺輔ｌ縺滓悽逡ｪID縺ｨ譁・ｭ怜・縺御ｸ閾ｴ縺励↑縺・・
  /// 閾ｪ蟾ｱ邏ｹ莉具ｼ郁・繧｢繝励Μ縺瑚・蛻・・霄ｫ縺ｮ邏ｹ莉九Μ繧ｹ繝医↓蜃ｺ縺ｦ縺励∪縺・ｼ峨ｒ髦ｲ縺舌◆繧√・
  /// 譌｢遏･縺ｮ繝・ヰ繝・げ繧ｵ繝輔ぅ繝・け繧ｹ繧呈ｯ碑ｼ・燕縺ｫ蜿悶ｊ髯､縺上・
  static const _debugSuffixes = ['.debug', '.dev'];

  static String _stripDebugSuffix(String appId) {
    for (final suffix in _debugSuffixes) {
      if (appId.endsWith(suffix)) {
        return appId.substring(0, appId.length - suffix.length);
      }
    }
    return appId;
  }
}

