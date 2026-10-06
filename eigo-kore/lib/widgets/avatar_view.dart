import 'package:flutter/material.dart';
import '../models/avatar_model.dart';

/// プロフィールのアバター表示。
///
/// 保存値が `avatar_N` なら動物イラスト、旧版の絵文字（👧👦🧒👶）は対応する
/// 動物イラストに読み替え、それ以外の絵文字（友だちが旧版の場合など）はそのまま
/// 文字で表示する。
class AvatarView extends StatelessWidget {
  final String value;
  final double size;
  final bool circle;

  const AvatarView(this.value, {super.key, this.size = 40, this.circle = true});

  static AvatarIcon? resolve(String value) {
    final id = legacyAvatarEmojiToId[value] ?? value;
    for (final a in allAvatarIcons) {
      if (a.id == id) return a;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final icon = resolve(value);
    if (icon == null) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(child: Text(value, style: TextStyle(fontSize: size * 0.8))),
      );
    }
    final image = Image.asset(
      icon.imageAsset,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Center(
        child: Text(icon.emoji, style: TextStyle(fontSize: size * 0.8)),
      ),
    );
    return SizedBox(
      width: size,
      height: size,
      child: circle
          ? ClipOval(child: image)
          : ClipRRect(borderRadius: BorderRadius.circular(size * 0.18), child: image),
    );
  }
}
