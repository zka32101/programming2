import 'package:flutter/material.dart';
import '../models/badge_model.dart';

/// 新規バッジ獲得時の達成演出ダイアログ(算数コレの NewBadgeDialog と同じ見た目)。
class NewBadgeDialog extends StatefulWidget {
  final List<BadgeModel> badges;
  final VoidCallback? onClose;

  const NewBadgeDialog({super.key, required this.badges, this.onClose});

  /// 新規獲得バッジがあるときだけ表示する。空なら何もしない。
  static Future<void> showIfAny(BuildContext context, List<BadgeModel> badges) async {
    if (badges.isEmpty) return;
    await showDialog<void>(
      context: context,
      builder: (_) => NewBadgeDialog(badges: badges),
    );
  }

  @override
  State<NewBadgeDialog> createState() => _NewBadgeDialogState();
}

class _NewBadgeDialogState extends State<NewBadgeDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _scale = Tween<double>(begin: 0.8, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final badges = widget.badges;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: ScaleTransition(
        scale: _scale,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: 260,
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0,
                        child: Image.asset('assets/celebrate/celebrate_starburst.webp', width: 250),
                      ),
                      Positioned(
                        top: 55,
                        child: Image.asset('assets/celebrate/celebrate_medal.webp', width: 130),
                      ),
                      Positioned(
                        bottom: 0,
                        child: SizedBox(
                          width: 260,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset('assets/celebrate/celebrate_ribbon_banner.webp', width: 260),
                              const Text(
                                'おめでとう！',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF461905),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (badges.length == 1)
                Text(
                  '${badges.first.emoji} ${badges.first.title} を獲得',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[800], fontSize: 16, fontWeight: FontWeight.bold),
                )
              else ...[
                Text(
                  '新しいバッジを ${badges.length} 個獲得しました',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
                const SizedBox(height: 8),
                for (final b in badges)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '${b.emoji} ${b.title}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[800], fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onClose?.call();
                },
                icon: const Icon(Icons.check),
                label: const Text('了解'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
