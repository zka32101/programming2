import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';

/// 所持アバターだけ選べるピッカー。
/// 無料4種 + ショップで購入済み + [selectedId]（現在使用中）が選択可能。
/// 未所持はロック+価格表示で、タップすると [onLockedTap] が呼ばれる。
class AvatarPickerGrid extends StatelessWidget {
  final Set<String> unlockedIds;
  final String selectedId;
  final ValueChanged<AvatarModel> onSelect;
  final ValueChanged<AvatarModel>? onLockedTap;
  final double avatarSize;

  const AvatarPickerGrid({
    super.key,
    required this.unlockedIds,
    required this.selectedId,
    required this.onSelect,
    this.onLockedTap,
    this.avatarSize = 56,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: allAvatars.length,
      itemBuilder: (context, i) {
        final avatar = allAvatars[i];
        final owned =
            unlockedIds.contains(avatar.id) || avatar.id == selectedId;
        if (!owned) {
          return LockedAvatarWidget(
            key: ValueKey('locked_${avatar.id}'),
            avatar: avatar,
            size: avatarSize,
            onUnlock: onLockedTap == null ? null : () => onLockedTap!(avatar),
          );
        }
        return AvatarWidget(
          key: ValueKey('avatar_${avatar.id}'),
          avatar: avatar,
          size: avatarSize,
          isSelected: avatar.id == selectedId,
          onTap: () => onSelect(avatar),
        );
      },
    );
  }
}
