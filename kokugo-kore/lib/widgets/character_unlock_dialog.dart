// lib/widgets/character_unlock_dialog.dart
// 新しいキャラクターをゲットした時の演出ダイアログ。
// result_screen.dart から、ステージクリア後に新規解放されたキャラクターがいれば
// 1体ずつ順番に表示する。

import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart' hide kTextMuted;

import '../theme/app_theme.dart';

Future<void> showCharacterUnlockDialog(
  BuildContext context,
  BaseCharacter character,
) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎊', style: TextStyle(fontSize: 44)),
          const SizedBox(height: 8),
          const Text(
            '新しいキャラクター\nゲット！',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [kPrimaryColor, kPrimaryDeep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: ClipOval(
              child: Container(
                color: Colors.white,
                child: character.imageAsset != null
                    ? Image.asset(character.imageAsset!, fit: BoxFit.contain)
                    : Center(
                        child: Text(character.emoji,
                            style: const TextStyle(fontSize: 56)),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            character.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '担当：${character.subject}',
            style: const TextStyle(color: kTextMuted, fontSize: 13),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'やったね！',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );

}

/// レベルアップ成功時の演出ダイアログ。kokugo_shop_page.dart から呼び出す。
Future<void> showCharacterLevelUpDialog(
  BuildContext context, {
  required BaseCharacter character,
  required int newLevel,
}) {
  final isMax = newLevel >= 5;
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isMax ? '✨' : '⬆️', style: const TextStyle(fontSize: 44)),
          const SizedBox(height: 8),
          Text(
            isMax ? 'レベルMAX達成！' : 'レベルアップ！',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            character.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            isMax ? 'MAX ✨' : 'Lv.$newLevel になったよ！',
            style: TextStyle(
              fontSize: 15,
              color: isMax ? Colors.amber.shade700 : kPrimaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (kLevelUpFeatureDesc[newLevel] != null) ...[
            const SizedBox(height: 12),
            Text(
              kLevelUpFeatureDesc[newLevel]!,
              style: const TextStyle(fontSize: 13, color: kTextMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'うれしい！',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}
