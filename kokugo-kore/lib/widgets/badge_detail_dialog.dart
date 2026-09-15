import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_core/models/badge_model.dart';
import '../models/badge_set_bonus_model.dart';

import '../theme/app_theme.dart';

/// バッジ詳細情報ダイアログ
class BadgeDetailDialog extends StatelessWidget {
  final BadgeModel badge;

  final DateTime? acquiredAt;
  final bool isAcquired;
  final List<BadgeSetBonus> relatedSetBonuses;

  const BadgeDetailDialog({
    super.key,
    required this.badge,
    this.acquiredAt,
    required this.isAcquired,
    this.relatedSetBonuses = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー（バッジアイコンと名前）
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kPrimaryColor.withAlpha(240),
                    kPrimaryColor.withAlpha(200),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // バッジアイコン
                  Text(
                    badge.emoji,
                    style: const TextStyle(fontSize: 56),
                  ),
                  const SizedBox(height: 16),

                  // バッジ名
                  Text(
                    badge.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // 獲得状態
                  const SizedBox(height: 8),
                  if (isAcquired)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade400,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '✓ 獲得済み',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '⊘ 未獲得',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // コンテンツ
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 説明
                  _buildSection(
                    context: context,
                    title: '説明',
                    content: badge.description,
                  ),
                  const SizedBox(height: 20),

                  // 獲得条件
                  _buildSection(
                    context: context,
                    title: '獲得条件',
                    content: _buildAcquisitionCondition(),
                  ),
                  const SizedBox(height: 20),

                  // 獲得日時
                  if (isAcquired && acquiredAt != null) ...[
                    _buildSection(
                      context: context,
                      title: '獲得日時',
                      content: _formatDateTime(acquiredAt!),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // 関連するセットボーナス
                  if (relatedSetBonuses.isNotEmpty) ...[
                    _buildRelatedSetBonuses(context),
                    const SizedBox(height: 20),
                  ],

                  // ボタン
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('閉じる'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async => await _shareBadge(context),
                          icon: const Icon(Icons.share),
                          label: const Text('共有'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode ? Colors.white70 : Colors.black87,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedSetBonuses(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'このバッジが含まれるセット',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ...relatedSetBonuses.map((set) {
          final isCompleted = set.isCompleted({badge.id});
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCompleted
                    ? (isDarkMode ? Colors.green.shade900 : Colors.green.shade50)
                    : (isDarkMode ? Colors.orange.shade900 : Colors.orange.shade50),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCompleted
                      ? (isDarkMode ? Colors.green.shade700 : Colors.green.shade300)
                      : (isDarkMode ? Colors.orange.shade700 : Colors.orange.shade300),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        set.emoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          set.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Colors.green.shade400
                              : Colors.orange.shade400,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isCompleted ? '完成' : '進捗中',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    set.rewardDescription,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  String _buildAcquisitionCondition() {
    // バッジごとの獲得条件を返す
    // 実装の簡略化のため、バッジの説明をそのまま使用
    return '${badge.description}を達成する';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _shareBadge(BuildContext context) async {
    // バッジ情報を共有
    final shareText = '''
🎉 バッジ「${badge.title}」を獲得しました！${badge.emoji}

📝 説明: ${badge.description}

🎮 「小学コレ！国語」でバッジを集めて、学習をもっと楽しくしよう！
''';

    try {
      // クリップボードにコピー
      final data = ClipboardData(text: shareText);
      await Clipboard.setData(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('バッジ情報をコピーしました'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('共有に失敗しました: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

/// バッジ詳細ダイアログを表示するヘルパー関数
void showBadgeDetailDialog(
  BuildContext context, {
  required BadgeModel badge,
  DateTime? acquiredAt,
  bool isAcquired = false,
  List<BadgeSetBonus> relatedSetBonuses = const [],
}) {
  showDialog(
    context: context,
    builder: (context) => BadgeDetailDialog(
      badge: badge,
      acquiredAt: acquiredAt,
      isAcquired: isAcquired,
      relatedSetBonuses: relatedSetBonuses,
    ),
  );
}
