import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/models/avatar_model.dart';
import 'package:shared_core/widgets/avatar_widget.dart';
import 'package:shared_core/shared_core.dart' show requireParentalGate;
import '../providers/profile_provider.dart';

import '../providers/profile_avatar_provider.dart';
import '../providers/avatar_unlock_provider.dart';
import '../theme/app_theme.dart';

class ProfileSelectionScreen extends ConsumerStatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  ConsumerState<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends ConsumerState<ProfileSelectionScreen> {
  late TextEditingController _nameController;
  int _selectedGrade = 1;
  String _selectedAvatarId = 'kuroneko';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showAvatarChangeDialog(String profileId) {
    showDialog(
      context: context,
      builder: (ctx) => Consumer(
        builder: (ctx, ref, _) => AlertDialog(
          title: const Text('アイコンを変更'),
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allAvatars.map((avatar) {
              final avatarUnlock = ref.read(avatarUnlockProvider);
              final isUnlocked = avatarUnlock[avatar.id] ?? false;
            return GestureDetector(
              onTap: isUnlocked
                  ? () async {
                      await ref.read(profileAvatarProvider.notifier).setSelectedAvatar(profileId, avatar.id);
                      if (ctx.mounted) Navigator.pop(ctx);
                    }
                  : () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ショップで購入するとつかえます！'),
                          duration: Duration(seconds: 1),
                        ),
                      ),
              child: Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isUnlocked ? Colors.grey.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: AvatarImage(
                      avatar: avatar,
                      size: 48,
                      opacity: isUnlocked ? 1.0 : 0.4,
                    ),
                  ),
                  if (!isUnlocked)
                    const Positioned(
                      right: 0,
                      bottom: 0,
                      child: Icon(Icons.lock, size: 13, color: Colors.grey),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('とじる'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProfileDialog() {
    _nameController.clear();
    _selectedGrade = 1;
    _selectedAvatarId = 'kuroneko';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('新しいプロフィールを追加'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'お名前',
                    hintText: 'e.g., たろう',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButton<int>(
                  value: _selectedGrade,
                  items: List.generate(6, (i) => i + 1).map((grade) {
                    return DropdownMenuItem(value: grade, child: Text('$grade年生'));
                  }).toList(),
                  onChanged: (val) => setDialogState(() => _selectedGrade = val ?? 1),
                ),
                const SizedBox(height: 16),
                const Text('アイコンを選ぼう',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Builder(builder: (context) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: allAvatars.map((avatar) {
                      final avatarUnlock = ref.read(avatarUnlockProvider);
                      final isUnlocked = avatarUnlock[avatar.id] ?? false;
                      final selected = _selectedAvatarId == avatar.id;
                      return GestureDetector(
                        onTap: isUnlocked
                            ? () => setDialogState(() => _selectedAvatarId = avatar.id)
                            : () => ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ショップで購入するとつかえます！'),
                                    duration: Duration(seconds: 1),
                                  ),
                                ),
                        child: Stack(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isUnlocked
                                    ? (selected ? kPrimaryColor.withAlpha(40) : Colors.grey.shade100)
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selected ? kPrimaryColor : Colors.grey.shade300,
                                  width: selected ? 2 : 1,
                                ),
                              ),
                              child: AvatarImage(
                                avatar: avatar,
                                size: 44,
                                opacity: isUnlocked ? 1.0 : 0.4,
                              ),
                            ),
                            if (!isUnlocked)
                              const Positioned(
                                right: 0,
                                bottom: 0,
                                child: Icon(Icons.lock, size: 12, color: Colors.grey),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  await ref.read(profileProvider.notifier).addProfile(_nameController.text, _selectedGrade);
                  // avatar is saved after addProfile creates the profile
                  final profiles = ref.read(profileProvider).profiles;
                  if (profiles.isNotEmpty) {
                    final newId = profiles.last.id;
                    await ref.read(profileAvatarProvider.notifier).setSelectedAvatar(newId, _selectedAvatarId);
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                }
              },
              child: const Text('追加'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profileAvatarState = ref.watch(profileAvatarProvider);
    final profiles = profileState.profiles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィールを選択'),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
      ),
      body: profiles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('プロフィールがありません',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showAddProfileDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('最初のプロフィールを作成'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: profiles.length + 1,
              itemBuilder: (context, index) {
                if (index == profiles.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton.icon(
                      onPressed: _showAddProfileDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('プロフィールを追加'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  );
                }

                final profile = profiles[index];
                final selectedAvatarId = profileAvatarState.getSelectedAvatar(profile.id);
                final avatarModel = allAvatars.firstWhere(
                  (a) => a.id == selectedAvatarId,
                  orElse: () => allAvatars.first,
                );
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: kPrimaryColor.withAlpha(30),
                      child: AvatarImage(avatar: avatarModel, size: 40),
                    ),
                    title: Text(profile.name),
                    subtitle: Text('${profile.grade}年生'),
                    trailing: PopupMenuButton(
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'icon', child: Text('アイコン変更')),
                        const PopupMenuItem(value: 'delete', child: Text('削除')),
                      ],
                      onSelected: (val) async {
                        if (val == 'delete') {
                          if (profiles.length > 1) {
                            final passedGate = await requireParentalGate(
                              context,
                              title: 'ほごしゃかくにん',
                              description: 'プロフィールの削除には、ほごしゃの確認が必要です。',
                            );
                            if (!passedGate || !context.mounted) return;
                            await ref.read(profileProvider.notifier).deleteProfile(profile.id);
                          }
                        } else if (val == 'icon') {
                          _showAvatarChangeDialog(profile.id);
                        }
                      },
                    ),
                    onTap: () async {
                      await ref.read(profileProvider.notifier).setCurrentProfile(profile.id);
                      if (mounted) Navigator.of(context).pushReplacementNamed('/home');
                    },
                  ),
                );
              },
            ),
    );
  }
}
