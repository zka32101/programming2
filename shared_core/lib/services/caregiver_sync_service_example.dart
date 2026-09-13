/// Example usage patterns for CaregiverSyncService
///
/// This file demonstrates practical usage patterns for implementing
/// caregiver synchronization features in your Flutter app.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_core/models/caregiver_profile.dart';
import 'caregiver_sync_service.dart';

// =============================================================================
// EXAMPLE 1: Basic Dashboard with Real-Time Score Monitoring
// =============================================================================

class CaregiverDashboardExample extends StatefulWidget {
  final String caregiverId;

  const CaregiverDashboardExample({required this.caregiverId});

  @override
  State<CaregiverDashboardExample> createState() =>
      _CaregiverDashboardExampleState();
}

class _CaregiverDashboardExampleState extends State<CaregiverDashboardExample> {
  late CaregiverSyncService syncService;

  @override
  void initState() {
    super.initState();
    syncService = CaregiverSyncService(
      firestore: FirebaseFirestore.instance,
      caregiverId: widget.caregiverId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caregiver Dashboard')),
      body: Column(
        children: [
          // Real-time health scores
          Expanded(
            child: StreamBuilder<Map<String, double>>(
              stream:
                  syncService.listenToMultipleParentScores(widget.caregiverId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No parents assigned'));
                }

                final scores = snapshot.data!;
                return ListView(
                  children: scores.entries.map((entry) {
                    return ParentScoreCard(
                      parentId: entry.key,
                      healthScore: entry.value,
                    );
                  }).toList(),
                );
              },
            ),
          ),

          // Aggregated metrics summary
          FutureBuilder<AggregatedMetrics>(
            future: syncService.aggregateMetrics(widget.caregiverId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              final metrics = snapshot.data!;
              return MetricsSummary(metrics: metrics);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    syncService.dispose();
    super.dispose();
  }
}

// =============================================================================
// EXAMPLE 2: Parent Comparison View
// =============================================================================

class ParentComparisonExample extends StatefulWidget {
  final String parentId1;
  final String parentId2;
  final String caregiverId;

  const ParentComparisonExample({
    required this.parentId1,
    required this.parentId2,
    required this.caregiverId,
  });

  @override
  State<ParentComparisonExample> createState() =>
      _ParentComparisonExampleState();
}

class _ParentComparisonExampleState extends State<ParentComparisonExample> {
  late CaregiverSyncService syncService;

  @override
  void initState() {
    super.initState();
    syncService = CaregiverSyncService(
      firestore: FirebaseFirestore.instance,
      caregiverId: widget.caregiverId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Comparison')),
      body: FutureBuilder<ParentProgressComparison>(
        future: syncService.compareParentProgress(
          parentId1: widget.parentId1,
          parentId2: widget.parentId2,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final comparison = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Health Score Comparison
                ComparisonHeader(
                  title: 'Health Score',
                  name1: comparison.parentName1,
                  score1: comparison.healthScore1,
                  name2: comparison.parentName2,
                  score2: comparison.healthScore2,
                  leader: comparison.healthScoreLeader,
                ),

                const SizedBox(height: 16),

                // Activity Level Comparison
                ComparisonHeader(
                  title: 'Activity Level',
                  name1: comparison.parentName1,
                  score1: comparison.activityLevel1,
                  name2: comparison.parentName2,
                  score2: comparison.activityLevel2,
                  leader: comparison.activityLeader,
                ),

                const SizedBox(height: 16),

                // Achievements Comparison
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Achievements Unlocked',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${comparison.parentName1}: '
                                '${comparison.achievements1}'),
                            Text('${comparison.parentName2}: '
                                '${comparison.achievements2}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Last Update Info
                Text(
                  'Last updated: ${comparison.daysSinceUpdate1} days ago',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    syncService.dispose();
    super.dispose();
  }
}

// =============================================================================
// EXAMPLE 3: Permission Management UI
// =============================================================================

class PermissionManagementExample extends StatefulWidget {
  final String parentId;
  final String caregiverId;

  const PermissionManagementExample({
    required this.parentId,
    required this.caregiverId,
  });

  @override
  State<PermissionManagementExample> createState() =>
      _PermissionManagementExampleState();
}

class _PermissionManagementExampleState
    extends State<PermissionManagementExample> {
  late CaregiverSyncService syncService;
  ViewPermission _selectedPermission = ViewPermission.fullAccess;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    syncService = CaregiverSyncService(
      firestore: FirebaseFirestore.instance,
      caregiverId: widget.caregiverId,
    );
    _loadCurrentPermission();
  }

  Future<void> _loadCurrentPermission() async {
    final permission = await syncService.getPermissionLevel(
      parentId: widget.parentId,
      caregiverId: widget.caregiverId,
    );

    if (permission != null) {
      setState(() {
        _selectedPermission = permission;
      });
    }
  }

  Future<void> _updatePermission(ViewPermission newPermission) async {
    setState(() {
      _isLoading = true;
    });

    try {
      CustomPermissions? customPerms;

      // Set up custom permissions if needed
      if (newPermission == ViewPermission.custom) {
        customPerms = CustomPermissions(
          viewBloodPressure: true,
          viewHeartRate: true,
          viewActivity: true,
          receiveAlerts: true,
        );
      }

      await syncService.setPermissionLevel(
        parentId: widget.parentId,
        caregiverId: widget.caregiverId,
        level: newPermission,
        customPermissions: customPerms,
      );

      setState(() {
        _selectedPermission = newPermission;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission updated successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permission Management')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PermissionOption(
                  title: 'Full Access',
                  description: 'View all data and features',
                  isSelected: _selectedPermission == ViewPermission.fullAccess,
                  onSelect: _isLoading
                      ? null
                      : () => _updatePermission(ViewPermission.fullAccess),
                ),
                const SizedBox(height: 12),
                PermissionOption(
                  title: 'Health Only',
                  description: 'View health metrics and summaries',
                  isSelected: _selectedPermission == ViewPermission.healthOnly,
                  onSelect: _isLoading
                      ? null
                      : () => _updatePermission(ViewPermission.healthOnly),
                ),
                const SizedBox(height: 12),
                PermissionOption(
                  title: 'Activity Only',
                  description: 'View activity logs only',
                  isSelected: _selectedPermission == ViewPermission.activityOnly,
                  onSelect: _isLoading
                      ? null
                      : () => _updatePermission(ViewPermission.activityOnly),
                ),
                const SizedBox(height: 12),
                PermissionOption(
                  title: 'Emergency Only',
                  description: 'View emergency contacts and alerts',
                  isSelected:
                      _selectedPermission == ViewPermission.emergencyOnly,
                  onSelect: _isLoading
                      ? null
                      : () => _updatePermission(ViewPermission.emergencyOnly),
                ),
                const SizedBox(height: 12),
                PermissionOption(
                  title: 'Read Only',
                  description: 'Read-only access to all data',
                  isSelected: _selectedPermission == ViewPermission.readOnly,
                  onSelect: _isLoading
                      ? null
                      : () => _updatePermission(ViewPermission.readOnly),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    syncService.dispose();
    super.dispose();
  }
}

// =============================================================================
// HELPER WIDGETS
// =============================================================================

class ParentScoreCard extends StatelessWidget {
  final String parentId;
  final double healthScore;

  const ParentScoreCard({
    required this.parentId,
    required this.healthScore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              parentId,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Health Score: '),
                Expanded(
                  child: LinearProgressIndicator(
                    value: healthScore / 100,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  healthScore.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MetricsSummary extends StatelessWidget {
  final AggregatedMetrics metrics;

  const MetricsSummary({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Parents: ${metrics.totalParents} / ${metrics.activeParents}'),
                Text('Avg Health: ${metrics.averageHealthScore.toStringAsFixed(1)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Alerts: ${metrics.criticalAlertsCount}'),
                Text('Achievements: ${metrics.totalAchievements}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ComparisonHeader extends StatelessWidget {
  final String title;
  final String name1;
  final double score1;
  final String name2;
  final double score2;
  final String leader;

  const ComparisonHeader({
    required this.title,
    required this.name1,
    required this.score1,
    required this.name2,
    required this.score2,
    required this.leader,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name1),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: score1 / 100,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        score1.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name2),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: score2 / 100,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        score2.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (leader != 'tie') ...[
              const SizedBox(height: 12),
              Text(
                'Leader: $leader',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PermissionOption extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback? onSelect;

  const PermissionOption({
    required this.title,
    required this.description,
    required this.isSelected,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: Radio<bool>(
          value: true,
          groupValue: isSelected,
          onChanged: onSelect != null ? (_) => onSelect!() : null,
        ),
        onTap: onSelect,
      ),
    );
  }
}
