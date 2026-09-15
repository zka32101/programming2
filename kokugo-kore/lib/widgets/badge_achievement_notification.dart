import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_core/models/badge_model.dart';

import '../theme/app_theme.dart';
import '../models/badge_set_bonus_model.dart';

class BadgeAchievementNotification extends StatefulWidget {
  final List<BadgeModel>? badges;
  final BadgeSetBonus? setBonus;
  final int? setBonusCoins;
  final Duration displayDuration;
  final VoidCallback? onDismiss;

  const BadgeAchievementNotification({
    super.key,
    this.badges,
    this.setBonus,
    this.setBonusCoins,
    this.displayDuration = const Duration(seconds: 4),
    this.onDismiss,
  });

  // バッジ獲得通知用のコンストラクタ
  factory BadgeAchievementNotification.forBadges(
    List<BadgeModel> badges, {
    Duration displayDuration = const Duration(seconds: 4),
    VoidCallback? onDismiss,
  }) {
    return BadgeAchievementNotification(
      badges: badges,
      displayDuration: displayDuration,
      onDismiss: onDismiss,
    );
  }

  // セットボーナス獲得通知用のコンストラクタ
  factory BadgeAchievementNotification.forSetBonus(
    BadgeSetBonus setBonus,
    int coinsEarned, {
    Duration displayDuration = const Duration(seconds: 5),
    VoidCallback? onDismiss,
  }) {
    return BadgeAchievementNotification(
      setBonus: setBonus,
      setBonusCoins: coinsEarned,
      displayDuration: displayDuration,
      onDismiss: onDismiss,
    );
  }

  @override
  State<BadgeAchievementNotification> createState() =>
      _BadgeAchievementNotificationState();
}

class _BadgeAchievementNotificationState
    extends State<BadgeAchievementNotification>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _glowController;
  late AnimationController _particleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _glowAnimation;

  // タイマー参照（dispose時にキャンセルするため）
  Timer? _displayTimer;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();

    // スライドイン - 快速なスライド
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // スケール - エラスティック効果で目立たせる
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // 回転 - ゆったりした回転
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // グロー効果 - 脈動感
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    // パーティクル - 落ち着いた演出
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _slideController.forward();
    _scaleController.forward();
    _rotateController.repeat();
    _glowController.repeat(reverse: true);
    _particleController.forward();

    // 指定時間後に自動的に閉じる
    _displayTimer = Timer(widget.displayDuration, () {
      if (mounted) {
        _slideController.reverse();

        // スライドアウト完了後に画面を閉じる（600ms）
        _dismissTimer = Timer(const Duration(milliseconds: 600), () {
          if (mounted) {
            widget.onDismiss?.call();
            Navigator.of(context).pop();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // タイマーをキャンセル（メモリリーク防止）
    _displayTimer?.cancel();
    _dismissTimer?.cancel();

    // AnimationController を破棄
    _slideController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildAchievementCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard() {
    // セットボーナス獲得の場合
    if (widget.setBonus != null) {
      return _buildAchievementCardWithEffects(
        _buildSetBonusCard(widget.setBonus!, widget.setBonusCoins ?? 0),
        particleColor: Colors.amber,
      );
    }

    if (widget.badges?.isEmpty ?? true) return const SizedBox.shrink();

    // 複数バッジの場合
    if (widget.badges!.length > 1) {
      return _buildAchievementCardWithEffects(_buildMultipleBadgesCard());
    }

    // 単一バッジの場合
    final badge = widget.badges!.first;
    return _buildAchievementCardWithEffects(_buildSingleBadgeCard(badge));
  }

  Widget _buildSingleBadgeCard(BadgeModel badge) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor.withAlpha(240),
            kPrimaryColor.withAlpha(200),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withAlpha(100),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // タイトル
            const Text(
              '🎉 バッジを獲得しました！',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // バッジアイコンと名前
            Column(
              children: [
                _buildBadgeIcon(badge.emoji),
                const SizedBox(height: 12),
                Text(
                  badge.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  badge.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 閉じるボタン
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onDismiss?.call();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'すごい！',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleBadgesCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.shade600.withAlpha(240),
            Colors.orange.shade600.withAlpha(200),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withAlpha(100),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // タイトル
            const Text(
              '🎉🎉 複数のバッジを獲得！',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // バッジリスト
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: widget.badges
                      ?.map((badge) => _buildBadgeChip(badge))
                      .toList() ??
                  const [],
            ),
            const SizedBox(height: 16),

            // 閉じるボタン
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onDismiss?.call();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '完璧です！',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeChip(BadgeModel badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(badge.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                badge.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                badge.description,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeIcon(String emoji) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // グロー背景
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withAlpha(
                      (100 * _glowAnimation.value).toInt(),
                    ),
                    blurRadius: 20,
                    spreadRadius: 8,
                  ),
                ],
              ),
            );
          },
        ),

        // バッジ本体（回転効果付き）
        RotationTransition(
          turns: _rotateAnimation,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(220),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSetBonusCard(BadgeSetBonus setBonus, int coins) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.shade600.withAlpha(240),
            Colors.orange.shade500.withAlpha(200),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withAlpha(150),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // タイトル
            const Text(
              '🏆 セットボーナス完成！',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // セットアイコンと名前
            Column(
              children: [
                Text(
                  setBonus.emoji,
                  style: const TextStyle(fontSize: 56),
                ),
                const SizedBox(height: 16),
                Text(
                  setBonus.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  setBonus.rewardDescription,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // コイン獲得表示
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(220),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.card_giftcard, color: Colors.amber, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '+$coins コイン獲得！',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 閉じるボタン
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onDismiss?.call();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'すごい！',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCardWithEffects(Widget card, {Color? particleColor}) {
    return Stack(
      children: [
        // パーティクル背景
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(
                  progress: _particleController.value,
                  primaryColor: particleColor ?? kPrimaryColor,
                ),
              );
            },
          ),
        ),

        // メインカード
        card,
      ],
    );
  }
}

/// パーティクル効果を描画するカスタムペイナー
class ParticlePainter extends CustomPainter {
  final double progress;
  final Color primaryColor;

  ParticlePainter({
    required this.progress,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // 固定シードで同じパターンを生成
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // 20個のパーティクルを描画
    for (int i = 0; i < 20; i++) {
      final angle = (2 * math.pi * i) / 20;
      final distance = 80 + (progress * 60);
      final x = centerX + distance * math.cos(angle);
      final y = centerY + distance * math.sin(angle);

      // パーティクルのサイズと透明度
      final size = 4.0 - (progress * 3.0);
      final opacity = (1.0 - progress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = primaryColor.withAlpha((opacity * 150).toInt())
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), size.clamp(0.5, 4.0), paint);
    }

    // 中央のグロー効果
    final glowPaint = Paint()
      ..color = primaryColor.withAlpha(((1 - progress) * 100).toInt())
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX, centerY),
      20 * (1 - progress),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// バッジ獲得通知を表示するヘルパー関数
Future<void> showBadgeAchievementDialog(
  BuildContext context,
  List<BadgeModel> badges, {
  Duration displayDuration = const Duration(seconds: 4),
  VoidCallback? onDismiss,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withAlpha(100),
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: BadgeAchievementNotification.forBadges(
        badges,
        displayDuration: displayDuration,
        onDismiss: onDismiss,
      ),
    ),
  );
}

/// セットボーナス獲得通知を表示するヘルパー関数
Future<void> showSetBonusAchievementDialog(
  BuildContext context,
  BadgeSetBonus setBonus,
  int coinsEarned, {
  Duration displayDuration = const Duration(seconds: 5),
  VoidCallback? onDismiss,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withAlpha(100),
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: BadgeAchievementNotification.forSetBonus(
        setBonus,
        coinsEarned,
        displayDuration: displayDuration,
        onDismiss: onDismiss,
      ),
    ),
  );
}
