import 'package:characters/characters.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/promoted_app.dart';
import '../services/cross_promo_service.dart';

/// 「他のアプリもチェック！」セクション。設定画面などに置く想定。
///
/// Remote Config から取得した [PromotedApp] 一覧を横スクロールのカードで表示する。
/// 紹介対象が0件（未配信・取得失敗・同カテゴリのアプリなし）の場合は何も表示しない。
///
/// アプリ固有のデザイントークンには依存せず、`Theme.of(context)` の
/// ColorScheme / TextTheme のみを使う。どのアプリにドロップインしても
/// そのアプリのテーマに自然に馴染む。
class CrossPromoSection extends StatelessWidget {
  const CrossPromoSection({
    super.key,
    required this.currentAppId,
    this.currentCategory,
    this.title = '他のアプリもチェック！',
    this.maxApps = 6,
    @visibleForTesting this.appsOverride,
  });

  final String currentAppId;

  /// 指定すると同じ category のアプリ（＝類似アプリ）だけに絞り込む。
  final String? currentCategory;

  final String title;
  final int maxApps;

  /// テスト専用: Remote Config を経由せず表示データを直接渡す。本番コードでは使わない。
  @visibleForTesting
  final List<PromotedApp>? appsOverride;

  @override
  Widget build(BuildContext context) {
    final apps = appsOverride ??
        CrossPromoService.getPromotedApps(
          currentAppId: currentAppId,
          currentCategory: currentCategory,
        );
    if (apps.isEmpty) return const SizedBox.shrink();

    final shown = apps.take(maxApps).toList();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.apps_rounded, size: 18, color: cs.onPrimaryContainer),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 214,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: shown.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) => _PromotedAppCard(app: shown[i]),
          ),
        ),
      ],
    );
  }
}

class _PromotedAppCard extends StatelessWidget {
  const _PromotedAppCard({required this.app});

  final PromotedApp app;

  Future<void> _open() async {
    final uri = Uri.tryParse(app.storeUrl);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return SizedBox(
      width: 148,
      child: Material(
        color: cs.surface,
        elevation: 1,
        shadowColor: cs.shadow.withValues(alpha: 0.3),
        surfaceTintColor: cs.surfaceTint,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _open,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: app.iconUrl.isNotEmpty
                            ? Image.network(
                                app.iconUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _IconFallback(app: app, theme: theme),
                              )
                            : _IconFallback(app: app, theme: theme),
                      ),
                    ),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.surface, width: 1.5),
                        ),
                        child: Icon(Icons.arrow_outward_rounded, size: 11, color: cs.onPrimary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  app.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  app.tagline,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// アイコンURLが無い/読み込み失敗した場合のフォールバック。
/// アプリ名の頭文字 + アプリIDから決定的に選ぶグラデーションで、
/// 「空っぽ」ではなくそれらしいアプリアイコン風に見せる。
class _IconFallback extends StatelessWidget {
  const _IconFallback({required this.app, required this.theme});

  final PromotedApp app;
  final ThemeData theme;

  static const _gradients = [
    [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    [Color(0xFFEC4899), Color(0xFFF43F5E)],
    [Color(0xFFF59E0B), Color(0xFFEF4444)],
    [Color(0xFF10B981), Color(0xFF22C55E)],
    [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    [Color(0xFF8B5CF6), Color(0xFFD946EF)],
  ];

  @override
  Widget build(BuildContext context) {
    final seed = app.id.isNotEmpty ? app.id : app.name;
    final colors = _gradients[seed.hashCode.abs() % _gradients.length];
    final initial = app.name.isNotEmpty ? app.name.characters.first : '?';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
