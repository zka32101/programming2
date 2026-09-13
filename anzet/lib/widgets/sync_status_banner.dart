import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cloud_sync_provider.dart';

/// 同期ステータスバナー
class SyncStatusBanner extends ConsumerWidget {
  final bool showDetailsOnTap;

  const SyncStatusBanner({
    Key? key,
    this.showDetailsOnTap = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(cloudSyncProvider);
    final status = syncState.status;

    // 同期完了時はバナーを表示しない
    if (status == SyncStatus.synced && !syncState.isOffline) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: showDetailsOnTap
          ? () => _showSyncDetailsDialog(context, ref, syncState)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: _getBackgroundColor(status, syncState.isOffline),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _getBannerIcon(status),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getBannerTitle(status),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  if (status == SyncStatus.pending)
                    Text(
                      '保留中: ${syncState.pendingSyncCount}件',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  if (status == SyncStatus.error)
                    Text(
                      syncState.errorMessage ?? '同期エラーが発生しました',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (status == SyncStatus.pending)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              ),
            if (showDetailsOnTap)
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(Icons.chevron_right, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(SyncStatus status, bool isOffline) {
    if (isOffline) return Colors.orange;
    switch (status) {
      case SyncStatus.synced:
        return Colors.green;
      case SyncStatus.pending:
        return Colors.blue;
      case SyncStatus.error:
        return Colors.red;
      case SyncStatus.offline:
        return Colors.orange;
    }
  }

  Widget _getBannerIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return const Icon(Icons.check_circle, color: Colors.white);
      case SyncStatus.pending:
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        );
      case SyncStatus.error:
        return const Icon(Icons.error, color: Colors.white);
      case SyncStatus.offline:
        return const Icon(Icons.cloud_off, color: Colors.white);
    }
  }

  String _getBannerTitle(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return '同期完了';
      case SyncStatus.pending:
        return '同期中...';
      case SyncStatus.error:
        return '同期エラー';
      case SyncStatus.offline:
        return 'オフラインモード';
    }
  }

  void _showSyncDetailsDialog(
    BuildContext context,
    WidgetRef ref,
    CloudSyncState syncState,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('同期詳細'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _DetailRow(
              label: 'ステータス',
              value: _getBannerTitle(syncState.status),
            ),
            const SizedBox(height: 12),
            _DetailRow(
              label: '最終同期',
              value: syncState.lastSyncTime != null
                  ? '${syncState.lastSyncTime!.hour}:${syncState.lastSyncTime!.minute.toString().padLeft(2, '0')}'
                  : '未実施',
            ),
            const SizedBox(height: 12),
            if (syncState.pendingSyncCount > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    label: '保留中',
                    value: '${syncState.pendingSyncCount}件',
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            if (syncState.errorMessage != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    label: 'エラー',
                    value: syncState.errorMessage!,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            _DetailRow(
              label: 'オフラインモード',
              value: syncState.isOffline ? 'ON' : 'OFF',
            ),
          ],
        ),
        actions: [
          if (syncState.pendingSyncCount > 0)
            TextButton(
              onPressed: () {
                ref.read(cloudSyncProvider.notifier).syncPendingOperations();
                Navigator.pop(context);
              },
              child: const Text('今すぐ同期'),
            ),
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
