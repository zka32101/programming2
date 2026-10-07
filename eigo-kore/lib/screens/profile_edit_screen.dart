import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../providers/user_profile_provider.dart';
import '../providers/coin_provider.dart';
import '../models/avatar_model.dart';
import '../widgets/avatar_view.dart';
import '../design_system/design_system.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  final UserProfile profile;
  const ProfileEditScreen({
    super.key,
    required this.profile,
  });

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late TextEditingController _nameController;
  late int _selectedGrade;
  late bool _showNameInRanking;
  late String _avatar;
  late Set<String> _purchased;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _selectedGrade = widget.profile.grade;
    _showNameInRanking = widget.profile.showNameInRanking;
    // 旧バージョンの絵文字アバターは、対応する動物アバターに読み替える
    _avatar = legacyAvatarEmojiToId[widget.profile.avatar] ?? widget.profile.avatar;
    _purchased = {...widget.profile.purchasedAvatars};
  }

  bool _owned(AvatarIcon a) => a.isDefault || _purchased.contains(a.id);

  Future<void> _onAvatarTap(AvatarIcon a) async {
    if (_owned(a)) {
      setState(() => _avatar = a.id);
      return;
    }
    final coins = ref.read(coinProvider).totalCoins;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${a.name}を手に入れる？'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarView(a.id, size: 96),
            const SizedBox(height: 12),
            Text('${a.price}コインを使うよ（いま $coinsコイン）'),
            if (coins < a.price)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('あと${a.price - coins}コイン たりないよ！',
                    style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('やめる')),
          ElevatedButton(
            onPressed: coins < a.price ? null : () => Navigator.pop(ctx, true),
            child: const Text('買う'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final spent = await ref.read(coinProvider.notifier).spendCoins(a.price);
    if (!spent || !mounted) return;
    setState(() {
      _purchased.add(a.id);
      _avatar = a.id;
    });
    // コインを使ったので、購入は保存を待たずにすぐ記録する
    await ref.read(userProfilesProvider.notifier).updateProfile(
      widget.profile.copyWith(purchasedAvatars: _purchased, avatar: _avatar),
    );
  }

  Widget _buildAvatarPicker() {
    final coins = ref.watch(coinProvider).totalCoins;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('アバター', style: AppTypography.labelLarge),
            const Spacer(),
            Text('🪙 $coins', style: AppTypography.labelLarge),
          ],
        ),
        AppSpacing.verticalSpacerXs,
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            for (final a in allAvatarIcons)
              GestureDetector(
                onTap: () => _onAvatarTap(a),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                        border: Border.all(
                          color: _avatar == a.id ? AppColors.primary : AppColors.bgLight,
                          width: _avatar == a.id ? 3 : 1,
                        ),
                      ),
                      child: FittedBox(
                        child: AvatarView(a.id, size: 64, circle: false),
                      ),
                    ),
                    if (!_owned(a))
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                          color: Colors.black.withAlpha(110),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.lock, color: Colors.white, size: 18),
                              Text('🪙 ${a.price}',
                                  style: const TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('名前を入力してください')),
      );
      return;
    }

    final updated = widget.profile.copyWith(
      name: _nameController.text,
      grade: _selectedGrade,
      showNameInRanking: _showNameInRanking,
      avatar: _avatar,
      purchasedAvatars: _purchased,
    );

    await ref.read(userProfilesProvider.notifier).updateProfile(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('プロフィールを更新しました')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール編集'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.allPaddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Display
            Center(
              child: Column(
                children: [
                  AvatarView(_avatar, size: 120),
                  AppSpacing.verticalSpacerMd,
                  Text(
                    '${widget.profile.grade}年生',
                    style: AppTypography.labelLarge.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            AppSpacing.verticalSpacerLg,

            _buildAvatarPicker(),
            AppSpacing.verticalSpacerLg,

            // Name Section
            Text(
              '名前',
              style: AppTypography.labelLarge,
            ),
            AppSpacing.verticalSpacerXs,
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: '名前を入力',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
            AppSpacing.verticalSpacerLg,

            // Grade Section
            Text(
              '学年',
              style: AppTypography.labelLarge,
            ),
            AppSpacing.verticalSpacerXs,
            Row(
              children: List.generate(6, (i) {
                final grade = i + 1;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _selectedGrade = grade);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedGrade == grade
                            ? AppColors.primary
                            : AppColors.bgLight,
                        foregroundColor: _selectedGrade == grade
                            ? AppColors.textWhite
                            : AppColors.textPrimary,
                      ),
                      child: Text('$grade年'),
                    ),
                  ),
                );
              }),
            ),
            AppSpacing.verticalSpacerLg,

            // Privacy Settings Section
            Container(
              padding: AppSpacing.allPaddingMd,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(10),
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                border: Border.all(color: AppColors.primary.withAlpha(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🏅 ランキング設定',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.verticalSpacerSm,
                  Text(
                    'ランキングで名前を表示するかどうかを設定できます',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                  ),
                  AppSpacing.verticalSpacerMd,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.textWhite,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
                      border: Border.all(color: AppColors.bgLight),
                    ),
                    child: SwitchListTile(
                      secondary: Icon(
                        _showNameInRanking ? Icons.visibility : Icons.visibility_off,
                        color: _showNameInRanking ? AppColors.accentGreen : AppColors.textMuted,
                      ),
                      title: Text(
                        _showNameInRanking ? '名前を表示する' : '名前を表示しない',
                        style: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _showNameInRanking ? AppColors.accentGreen : AppColors.textMuted,
                        ),
                      ),
                      subtitle: Text(
                        _showNameInRanking
                            ? 'ランキングであなたの名前が表示されます'
                            : 'ランキングで「ユーザー #XXXX」と匿名表示されます',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                      ),
                      value: _showNameInRanking,
                      onChanged: (value) {
                        setState(() {
                          _showNameInRanking = value;
                        });
                      },
                      activeThumbColor: AppColors.accentGreen,
                      activeTrackColor: AppColors.accentGreen.withAlpha(80),
                      contentPadding: EdgeInsets.all(AppSpacing.sm),
                    ),
                  ),
                  AppSpacing.verticalSpacerMd,
                  Container(
                    padding: AppSpacing.allPaddingSm,
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange.withAlpha(15),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: AppSpacing.xs, top: 2),
                          child: const Icon(
                            Icons.info_outline,
                            color: AppColors.accentOrange,
                            size: 16,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '名前を表示しない場合でも、ランキングであなたの順位や成績は常に表示されます。プライバシーを保ちながらランキング参加ができます。',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.verticalSpacerXl,

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('保存する'),
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textWhite,
                ),
              ),
            ),
            AppSpacing.verticalSpacerMd,

            // Delete Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('このプロフィールを削除'),
                onPressed: () => _showDeleteConfirmation(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ),
            AppSpacing.verticalSpacerXxl,
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('プロフィールを削除'),
        content: Text(
          '「${widget.profile.name}」プロフィールを削除してもよろしいですか？'
          '\nこの操作は取り消せません。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(userProfilesProvider.notifier)
                  .deleteProfile(widget.profile.id);
              if (mounted) {
                Navigator.pop(ctx);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('プロフィールを削除しました')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('削除する', style: TextStyle(color: AppColors.textWhite)),
          ),
        ],
      ),
    );
  }
}
