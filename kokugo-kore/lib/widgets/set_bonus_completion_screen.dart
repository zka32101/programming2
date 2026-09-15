import 'dart:async';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../models/badge_set_bonus_model.dart';
import '../theme/app_theme.dart';

class SetBonusCompletionScreen extends StatefulWidget {
  final BadgeSetBonus setBonus;
  final int coinsEarned;
  final VoidCallback? onCompleted;

  const SetBonusCompletionScreen({
    super.key,
    required this.setBonus,
    required this.coinsEarned,
    this.onCompleted,
  });

  @override
  State<SetBonusCompletionScreen> createState() =>
      _SetBonusCompletionScreenState();
}

class _SetBonusCompletionScreenState extends State<SetBonusCompletionScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _glowController;
  late AnimationController _confettiController;
  late AnimationController _coinController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _glowAnimation;

  // タイマー参照（dispose時にキャンセルするため）
  Timer? _dismissTimer;
  Timer? _coinDelayTimer;
  final List<Timer> _vibrationTimers = [];

  @override
  void initState() {
    super.initState();

    // スケールアニメーション（アイコン拡大）- やや速めで鮮烈な印象
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // 回転アニメーション - ゆっくりした回転で豪華さを演出
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    );

    // グロー効果 - 脈動のようなタイミング
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // コンフェッティ効果 - 落ち着きのあるタイミング
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2800),
      vsync: this,
    );

    // コイン表示アニメーション - テキスト表示のタイミング調整
    _coinController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 4 * math.pi).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    _glowAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // 振動フィードバック
    _triggerVibration();

    // アニメーション開始
    _scaleController.forward();
    _rotateController.repeat();
    _glowController.repeat(reverse: true);
    _confettiController.forward();

    // コイン表示アニメーション開始（600msでlelay）
    _coinDelayTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) _coinController.forward();
    });

    // 演出終了後に画面を閉じる（5秒後）
    _dismissTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        widget.onCompleted?.call();
        Navigator.of(context).pop();
      }
    });
  }

  /// 振動フィードバック
  void _triggerVibration() {
    try {
      HapticFeedback.vibrate();

      // 振動タイマーをリストで管理（dispose時にキャンセル可能）
      final timer1 = Timer(const Duration(milliseconds: 200), () {
        try {
          HapticFeedback.vibrate();
        } catch (_) {}
      });
      _vibrationTimers.add(timer1);

      final timer2 = Timer(const Duration(milliseconds: 400), () {
        try {
          HapticFeedback.vibrate();
        } catch (_) {}
      });
      _vibrationTimers.add(timer2);
    } catch (_) {
      // 振動非対応デバイスの場合はスキップ
    }
  }

  @override
  void dispose() {
    // タイマーをキャンセル（メモリリーク防止）
    _dismissTimer?.cancel();
    _coinDelayTimer?.cancel();
    for (final timer in _vibrationTimers) {
      timer.cancel();
    }
    _vibrationTimers.clear();

    // AnimationController を破棄
    _scaleController.dispose();
    _rotateController.dispose();
    _glowController.dispose();
    _confettiController.dispose();
    _coinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          // コンフェッティ背景
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _confettiController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ConfettiPainter(
                    progress: _confettiController.value,
                  ),
                );
              },
            ),
          ),

          // 中央のコンテンツ
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // セットボーナスアイコン（スケール+回転）
                AnimatedBuilder(
                  animation: Listenable.merge([_scaleAnimation, _rotateAnimation, _glowAnimation]),
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // グロー背景
                        Container(
                          width: 160 * _scaleAnimation.value,
                          height: 160 * _scaleAnimation.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withAlpha(
                                  (_glowAnimation.value * 150).toInt(),
                                ),
                                blurRadius: 40,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                        ),

                        // アイコン本体
                        Transform.rotate(
                          angle: _rotateAnimation.value,
                          child: Container(
                            width: 120 * _scaleAnimation.value,
                            height: 120 * _scaleAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber.shade600,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(100),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                widget.setBonus.emoji,
                                style: TextStyle(
                                  fontSize: 80 * _scaleAnimation.value,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),

                // セット名
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    children: [
                      Text(
                        '🏆 セットボーナス完成！',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.setBonus.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.amber.shade400,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // コイン獲得表示
                ScaleTransition(
                  scale: _coinController,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.amber.shade400.withAlpha(240),
                          Colors.orange.shade500.withAlpha(200),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withAlpha(100),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.card_giftcard,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '+${widget.coinsEarned}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'コイン！',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 説明文
                FadeTransition(
                  opacity: _coinController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      widget.setBonus.rewardDescription,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// コンフェッティパーティクルペイナー
class ConfettiPainter extends CustomPainter {
  final double progress;

  ConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(12345);
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // 60個のコンフェッティ
    for (int i = 0; i < 60; i++) {
      final angle = (2 * math.pi * i) / 60;
      final velocity = 2.0 + random.nextDouble() * 2.0;
      final distance = velocity * progress * 400;

      final x = centerX + distance * math.cos(angle);
      final y = centerY + distance * math.sin(angle) + (progress * progress * 200);

      // パーティクルのサイズと色
      final size = 4.0 + random.nextDouble() * 6.0;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);

      // ランダムな色（金、銀、虹色）
      final colors = [
        Colors.amber,
        Colors.orange,
        Colors.yellow,
        Colors.red,
        Colors.pink,
        Colors.purple,
      ];
      final color = colors[i % colors.length];

      final paint = Paint()
        ..color = color.withAlpha((opacity * 180).toInt())
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), size, paint);
    }

    // 中央の輝き効果
    final glowSize = 30 * (1 - progress);
    final glowPaint = Paint()
      ..color = Colors.amber.withAlpha(((1 - progress) * 120).toInt())
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), glowSize, glowPaint);
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// セットボーナス完成演出を表示するヘルパー関数
Future<void> showSetBonusCompletionScreen(
  BuildContext context,
  BadgeSetBonus setBonus,
  int coinsEarned, {
  VoidCallback? onCompleted,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) =>
          SetBonusCompletionScreen(
        setBonus: setBonus,
        coinsEarned: coinsEarned,
        onCompleted: onCompleted,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}
