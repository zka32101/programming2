import 'package:flutter/material.dart';
import '../models/avatar_model.dart';

class AvatarWidget extends StatelessWidget {
  final AvatarModel avatar;
  final double size;
  final VoidCallback? onTap;
  final bool isSelected;

  const AvatarWidget({
    super.key,
    required this.avatar,
    this.size = 80,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            avatar.emoji,
            style: TextStyle(fontSize: size * 0.5),
          ),
        ),
      ),
    );
  }
}

class LockedAvatarWidget extends StatelessWidget {
  final AvatarModel avatar;
  final double size;
  final VoidCallback? onUnlock;

  const LockedAvatarWidget({
    super.key,
    required this.avatar,
    this.size = 80,
    this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    final priceText = avatar.unlockType == AvatarUnlockType.coin
        ? '${avatar.coinCost ?? 0}🪙'
        : 'プレミアム';

    return GestureDetector(
      onTap: onUnlock,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0, 0, 0, 0.4, 0,
                ]),
                child: Text(
                  avatar.emoji,
                  style: TextStyle(fontSize: size * 0.5),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Text(
                priceText,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.lock,
              size: size * 0.3,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
