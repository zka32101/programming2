import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart' show avatarProvider, AvatarWidget, AvatarModel;
import '../providers/profile_provider.dart';
import '../providers/profile_avatar_provider.dart';
import '../providers/selected_avatar_provider.dart';
import '../widgets/avatar_picker_grid.dart';
import '../providers/grade_provider.dart';
import '../theme/app_theme.dart';
import '../utils/grade_utils.dart';

class ProfileSelectionScreen extends ConsumerStatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  ConsumerState<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends ConsumerState<ProfileSelectionScreen> {
  late TextEditingController _nameController;
  int _selectedGrade = 1;

  String _newAvatarId = 'kuroneko';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(avatarProvider.notifier).load();
      ref.read(profileAvatarProvider.notifier).load();
      ref.read(selectedAvatarProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showAddProfileDialog() {
    _nameController.clear();
    _selectedGrade = 1;
    _newAvatarId = 'kuroneko';
    String? lockedHint;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('プロフィールを追加'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'お名前', hintText: 'たろう'),
              ),
              const SizedBox(height: 16),
              DropdownButton<int>(
                value: _selectedGrade,
                isExpanded: true,
                items: [0, 1, 2, 3, 4, 5, 6, 7].map((g) {
                  return DropdownMenuItem(value: g, child: Text(gradeLabel(g)));
                }).toList(),
                onChanged: (val) => setDialogState(() => _selectedGrade = val ?? 1),
              ),
              const SizedBox(height: 16),
              const Text('アバターを選ぶ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: AvatarPickerGrid(
                  unlockedIds: ref.read(avatarProvider).unlockedIds,
                  selectedId: _newAvatarId,
                  onSelect: (a) => setDialogState(() {
                    _newAvatarId = a.id;
                    lockedHint = null;
                  }),
                  onLockedTap: (a) => setDialogState(
                      () => lockedHint = '${a.name}はコレショップのアバターで買えるよ'),
                ),
              ),
              if (lockedHint != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(lockedHint!,
                      key: const Key('avatar_locked_hint'),
                      style: const TextStyle(fontSize: 12, color: kTextMuted)),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  final before = ref
                      .read(profileProvider)
                      .profiles
                      .map((p) => p.id)
                      .toSet();
                  await ref.read(profileProvider.notifier).addProfile(
                    _nameController.text,
                    _selectedGrade,
                  );
                  for (final p in ref.read(profileProvider).profiles) {
                    if (!before.contains(p.id)) {
                      await ref
                          .read(profileAvatarProvider.notifier)
                          .setAvatar(p.id, _newAvatarId);
                    }
                  }
                  if (mounted) Navigator.pop(context);
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
    final profiles = profileState.profiles;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF5F5), Color(0xFFFFE8E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text('🔴', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 12),
              const Text(
                '小学コレ！算数',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
              const SizedBox(height: 8),
              const Text(
                'だれが使う？',
                style: TextStyle(fontSize: 18, color: kTextMuted),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: profiles.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('プロフィールがありません', style: TextStyle(color: kTextMuted)),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _showAddProfileDialog,
                              icon: const Icon(Icons.add),
                              label: const Text('プロフィールを追加'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: profiles.length + 1,
                        itemBuilder: (_, i) {
                          if (i == profiles.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: OutlinedButton.icon(
                                onPressed: _showAddProfileDialog,
                                icon: const Icon(Icons.add),
                                label: const Text('別のプロフィールを追加'),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: kPrimaryColor),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                            );
                          }
                          final profile = profiles[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () async {
                                await ref.read(profileProvider.notifier).setCurrentProfile(profile.id);
                                final own = ref
                                    .read(profileAvatarProvider.notifier)
                                    .avatarFor(profile.id);
                                if (own != null) {
                                  await ref
                                      .read(selectedAvatarProvider.notifier)
                                      .select(own.id);
                                }
                                await ref
                                    .read(gradeProvider.notifier)
                                    .setGrade(clampToStageGrade(profile.grade));
                                if (mounted) {
                                  Navigator.of(context).pushReplacementNamed('/home');
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    ProfileAvatar(
                                      profileId: profile.id,
                                      name: profile.name,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            profile.name,
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            gradeLabel(profile.grade),
                                            style: const TextStyle(fontSize: 14, color: kTextMuted),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, color: kTextMuted, size: 16),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// プロフィール一覧の丸アバター。保存済みアバター画像（無ければ現在の選択アバター）を
/// 共通の AvatarWidget で表示する。AvatarWidget 自体が画像欠落時は絵文字にフォールバックする。
class ProfileAvatar extends ConsumerWidget {
  final String profileId;
  final String name;
  const ProfileAvatar({super.key, required this.profileId, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(profileAvatarProvider);
    final AvatarModel selected = ref.watch(selectedAvatarProvider);
    final AvatarModel avatar =
        ref.read(profileAvatarProvider.notifier).avatarFor(profileId) ?? selected;
    return AvatarWidget(avatar: avatar, size: 56);
  }
}
