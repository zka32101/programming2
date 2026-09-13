import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/services/parental_gate_service.dart';

import '../providers/screen_time_provider.dart';
import '../widgets/screen_time_limiter_widget.dart';

/// 親向け設定画面
class ParentSettingsScreen extends ConsumerStatefulWidget {
  final String childId;

  const ParentSettingsScreen({
    super.key,
    required this.childId,
  });

  @override
  ConsumerState<ParentSettingsScreen> createState() =>
      _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends ConsumerState<ParentSettingsScreen> {
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _requestParentalGate();
  }

  Future<void> _requestParentalGate() async {
    final result = await ParentalGateService.requireParentalGate(context);
    setState(() {
      _isAuthenticated = result;
    });
    if (!result) {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('保護者向け設定'),
        elevation: 0,
      ),
      body: !_isAuthenticated
          ? _buildLockedView()
          : _buildSettingsView(),
    );
  }

  Widget _buildLockedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            '認証が必要です',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '保護者PINを入力してください',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _requestParentalGate,
            child: const Text('もう一度試す'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ScreenTime制限
          ScreenTimeLimiterWidget(
            childId: widget.childId,
            onLimitExceeded: () {
              _showLimitExceededNotification();
            },
          ),
          const SizedBox(height: 24),

          // その他の親向け設定
          _SettingsSection(
            title: 'コンテンツ制限',
            children: [
              _SettingsTile(
                title: '不適切なコンテンツをブロック',
                value: true,
                onChanged: (value) {
                  // TODO: コンテンツフィルター実装
                },
              ),
              _SettingsTile(
                title: 'アプリ内購入を許可',
                value: false,
                onChanged: (value) {
                  // TODO: 課金制限実装
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // レポート
          _SettingsSection(
            title: 'レポート＆通知',
            children: [
              _SettingsTile(
                title: '日次使用レポート',
                subtitle: 'スクリーンタイム超過時に通知',
                value: true,
                onChanged: (value) {
                  // TODO: 通知設定実装
                },
              ),
              _SettingsTile(
                title: 'アプリ使用統計',
                value: true,
                onChanged: (value) {
                  // TODO: 統計追跡実装
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 危険ゾーン
          _SettingsSection(
            title: '危険な操作',
            isDangerous: true,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('このデバイスのデータを削除'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showDeleteDataDialog(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLimitExceededNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('スクリーンタイム制限に達しました'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showDeleteDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('データを削除しますか？'),
        content: const Text(
          'このデバイスの使用統計とすべても削除されます。\n'
          'この操作は取り消せません。',
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteData();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  void _deleteData() {
    // TODO: データ削除実装
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('データを削除しました')),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isDangerous;

  const _SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDangerous ? Colors.red : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isDangerous ? Colors.red.shade200 : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      onChanged: onChanged,
    );
  }
}
