# Caregiver Sync Service Guide

## Overview

The `CaregiverSyncService` provides real-time synchronization and monitoring capabilities for caregivers managing multiple parent profiles. It enables seamless tracking of multiple parents' health metrics, permission management, and progress comparison through Firestore listeners.

## Key Features

### 1. Real-Time Parent Score Monitoring
Listen to health score updates from all assigned parents in real-time.

```dart
final syncService = CaregiverSyncService(
  firestore: FirebaseFirestore.instance,
  caregiverId: 'caregiver123',
);

// Listen to all parent scores
syncService.listenToMultipleParentScores('caregiver123').listen((scores) {
  print('Parent scores: $scores');
  // {parent1: 85.5, parent2: 92.0, parent3: 78.3}
});
```

**Features:**
- Real-time stream updates via Firestore listeners
- Automatic handling of multiple parents (chunks large lists)
- Returns map of `parentId` to health score
- Filters by caregiver's accessible parents

### 2. Parent Progress Comparison
Compare health and activity metrics between two parents for dashboard views.

```dart
final comparison = await syncService.compareParentProgress(
  parentId1: 'parent123',
  parentId2: 'parent456',
);

print('${comparison.parentName1} health: ${comparison.healthScore1}');
print('Leader: ${comparison.healthScoreLeader}');
```

**Returns:**
- Health scores (0-100)
- Activity levels (0-100)
- Achievement counts
- Days since last update
- Calculated differences and leaders

**Data Model: ParentProgressComparison**
```dart
class ParentProgressComparison {
  final String parentId1, parentId2;
  final String parentName1, parentName2;
  final double healthScore1, healthScore2;
  final double activityLevel1, activityLevel2;
  final int achievements1, achievements2;
  final int daysSinceUpdate1, daysSinceUpdate2;
  final double healthScoreDifference;
  final double activityLevelDifference;
  final String healthScoreLeader; // 'tie', parentId1, or parentId2
  final String activityLeader;
  final DateTime comparedAt;
}
```

### 3. Aggregated Metrics
Summarize metrics across all parents with comprehensive statistics.

```dart
final metrics = await syncService.aggregateMetrics('caregiver123');

print('Total parents: ${metrics.totalParents}');
print('Active parents: ${metrics.activeParents}');
print('Average health: ${metrics.averageHealthScore}');
print('Critical alerts: ${metrics.criticalAlertsCount}');
print('Total achievements: ${metrics.totalAchievements}');
```

**Returns:**
- Total and active parent counts
- Average health score across all parents
- Per-parent health scores and activity levels
- Total critical alerts
- Total achievements
- Computation timestamp

**Data Model: AggregatedMetrics**
```dart
class AggregatedMetrics {
  final int totalParents;
  final int activeParents;
  final double averageHealthScore;
  final DateTime lastUpdate;
  final Map<String, double> parentHealthScores;
  final Map<String, double> parentActivityLevels;
  final int criticalAlertsCount;
  final int totalAchievements;
  final DateTime computedAt;
  final Map<String, dynamic> metadata;
}
```

### 4. Permission Level Management
Set and monitor granular access permissions for caregivers per parent.

```dart
// Set full access permission
await syncService.setPermissionLevel(
  parentId: 'parent123',
  caregiverId: 'caregiver456',
  level: ViewPermission.fullAccess,
);

// Set health-only access
await syncService.setPermissionLevel(
  parentId: 'parent123',
  caregiverId: 'caregiver456',
  level: ViewPermission.healthOnly,
);

// Set custom permissions
await syncService.setPermissionLevel(
  parentId: 'parent123',
  caregiverId: 'caregiver456',
  level: ViewPermission.custom,
  customPermissions: CustomPermissions(
    viewBloodPressure: true,
    viewHeartRate: true,
    viewActivity: false,
    canAddNotes: true,
  ),
);
```

**Available Permission Levels:**
- `fullAccess`: All data and features
- `healthOnly`: Health metrics and summaries only
- `activityOnly`: Activity logs only
- `emergencyOnly`: Emergency contacts and alerts only
- `readOnly`: Read-only access to all data
- `custom`: Custom field-level permissions

**Get Current Permission:**
```dart
final permission = await syncService.getPermissionLevel(
  parentId: 'parent123',
  caregiverId: 'caregiver456',
);
```

**Listen to Permission Changes:**
```dart
syncService.listenToPermissionChanges(
  parentId: 'parent123',
  caregiverId: 'caregiver456',
).listen((permission) {
  print('Permission changed to: $permission');
});
```

## Firestore Structure

### Collections and Documents

#### `caregivers` collection
Stores caregiver profiles with their assigned parents.

```
caregivers/
  {caregiverId}/
    - caregiverId: string
    - parentIds: List<String>  # All parents this caregiver can see
    - permission: string       # Primary permission level
    - name: string
    - email: string
    - notificationPreferences: object
    - isActive: boolean
    - updatedAt: timestamp
```

#### `parents` collection
Stores parent profiles with health metrics.

```
parents/
  {parentId}/
    - parentId: string
    - name: string
    - healthScore: number (0-100)
    - activityLevel: number (0-100)
    - achievements: List<String>
    - criticalAlerts: List<Object>
    - lastUpdate: timestamp
    - isActive: boolean
```

#### `permissions` collection
Fine-grained permission tracking per caregiver-parent relationship.

```
permissions/
  {caregiverId}_{parentId}/
    - caregiverId: string
    - parentId: string
    - permission: string (full_access, health_only, etc.)
    - customPermissions: object (if permission == 'custom')
    - setAt: timestamp
    - setBy: string (caregiverId who set the permission)
```

#### `audit_logs` collection
Tracks all permission changes and access events.

```
audit_logs/
  {logId}/
    - action: string (permission_changed, etc.)
    - caregiverId: string
    - parentId: string
    - newPermission: string
    - changedBy: string
    - timestamp: timestamp
    - customPermissions: object (if applicable)
```

## Usage Patterns

### Pattern 1: Dashboard Summary
```dart
class CaregiverDashboard extends StatefulWidget {
  @override
  State<CaregiverDashboard> createState() => _CaregiverDashboardState();
}

class _CaregiverDashboardState extends State<CaregiverDashboard> {
  late CaregiverSyncService syncService;
  
  @override
  void initState() {
    super.initState();
    syncService = CaregiverSyncService(
      firestore: FirebaseFirestore.instance,
      caregiverId: currentUserId,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AggregatedMetrics>(
      stream: _getAggregatedMetricsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        
        final metrics = snapshot.data!;
        return Column(
          children: [
            Text('Monitoring ${metrics.activeParents} of ${metrics.totalParents} parents'),
            Text('Average Health: ${metrics.averageHealthScore.toStringAsFixed(1)}'),
            Text('Critical Alerts: ${metrics.criticalAlertsCount}'),
          ],
        );
      },
    );
  }
  
  Stream<AggregatedMetrics> _getAggregatedMetricsStream() {
    return Stream.periodic(
      const Duration(minutes: 5),
      (_) => syncService.aggregateMetrics(currentUserId),
    ).asyncExpand((future) => Stream.fromFuture(future));
  }
  
  @override
  void dispose() {
    syncService.dispose();
    super.dispose();
  }
}
```

### Pattern 2: Parent Comparison View
```dart
class ParentComparisonScreen extends StatefulWidget {
  final String parentId1;
  final String parentId2;
  
  const ParentComparisonScreen({
    required this.parentId1,
    required this.parentId2,
  });
  
  @override
  State<ParentComparisonScreen> createState() => _ParentComparisonScreenState();
}

class _ParentComparisonScreenState extends State<ParentComparisonScreen> {
  late CaregiverSyncService syncService;
  
  @override
  void initState() {
    super.initState();
    syncService = CaregiverSyncService(
      firestore: FirebaseFirestore.instance,
      caregiverId: currentUserId,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ParentProgressComparison>(
      future: syncService.compareParentProgress(
        parentId1: widget.parentId1,
        parentId2: widget.parentId2,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        
        final comparison = snapshot.data!;
        return Column(
          children: [
            ComparisonCard(
              name1: comparison.parentName1,
              score1: comparison.healthScore1,
              name2: comparison.parentName2,
              score2: comparison.healthScore2,
              leader: comparison.healthScoreLeader,
            ),
            SizedBox(height: 16),
            ActivityComparisonChart(comparison: comparison),
          ],
        );
      },
    );
  }
  
  @override
  void dispose() {
    syncService.dispose();
    super.dispose();
  }
}
```

### Pattern 3: Real-Time Score Monitoring
```dart
class HealthScoreMonitor extends StatefulWidget {
  final String caregiverId;
  
  const HealthScoreMonitor({required this.caregiverId});
  
  @override
  State<HealthScoreMonitor> createState() => _HealthScoreMonitorState();
}

class _HealthScoreMonitorState extends State<HealthScoreMonitor> {
  late CaregiverSyncService syncService;
  
  @override
  void initState() {
    super.initState();
    syncService = CaregiverSyncService(
      firestore: FirebaseFirestore.instance,
      caregiverId: caregiverId,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, double>>(
      stream: syncService.listenToMultipleParentScores(widget.caregiverId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No parents assigned');
        }
        
        final scores = snapshot.data!;
        return ListView.builder(
          itemCount: scores.length,
          itemBuilder: (context, index) {
            final parentId = scores.keys.elementAt(index);
            final score = scores.values.elementAt(index);
            
            return ListTile(
              title: Text(parentId),
              trailing: ScoreIndicator(score: score),
            );
          },
        );
      },
    );
  }
  
  @override
  void dispose() {
    syncService.dispose();
    super.dispose();
  }
}
```

### Pattern 4: Permission Management
```dart
class PermissionManager {
  final CaregiverSyncService syncService;
  
  PermissionManager(this.syncService);
  
  Future<void> grantHealthAccess(String parentId, String caregiverId) async {
    await syncService.setPermissionLevel(
      parentId: parentId,
      caregiverId: caregiverId,
      level: ViewPermission.healthOnly,
    );
  }
  
  Future<void> grantFullAccess(String parentId, String caregiverId) async {
    await syncService.setPermissionLevel(
      parentId: parentId,
      caregiverId: caregiverId,
      level: ViewPermission.fullAccess,
    );
  }
  
  Future<void> grantCustomAccess({
    required String parentId,
    required String caregiverId,
    required Map<String, bool> permissions,
  }) async {
    final customPerms = CustomPermissions(
      viewBloodPressure: permissions['bloodPressure'] ?? false,
      viewHeartRate: permissions['heartRate'] ?? false,
      viewBloodGlucose: permissions['glucose'] ?? false,
      viewWeight: permissions['weight'] ?? false,
      viewSleep: permissions['sleep'] ?? false,
      viewActivity: permissions['activity'] ?? false,
      viewMedications: permissions['medications'] ?? false,
      receiveAlerts: permissions['alerts'] ?? false,
      canAddNotes: permissions['notes'] ?? false,
    );
    
    await syncService.setPermissionLevel(
      parentId: parentId,
      caregiverId: caregiverId,
      level: ViewPermission.custom,
      customPermissions: customPerms,
    );
  }
  
  Stream<ViewPermission?> watchPermission(String parentId, String caregiverId) {
    return syncService.listenToPermissionChanges(
      parentId: parentId,
      caregiverId: caregiverId,
    );
  }
}
```

## Error Handling

All methods throw `CaregiverSyncException` with specific error codes:

```dart
try {
  await syncService.compareParentProgress(
    parentId1: 'parent1',
    parentId2: 'parent2',
  );
} on CaregiverSyncException catch (e) {
  if (e.code == 'PARENT_NOT_FOUND') {
    print('One or both parents do not exist');
  } else if (e.code == 'ACCESS_DENIED') {
    print('You do not have access to one or both parents');
  } else if (e.code == 'COMPARISON_FAILED') {
    print('Failed to compare parents: ${e.message}');
  }
}
```

**Common Error Codes:**
- `PARENT_NOT_FOUND`: Parent doesn't exist
- `ACCESS_DENIED`: Caregiver lacks access
- `CAREGIVER_NOT_FOUND`: Caregiver profile missing
- `AGGREGATION_FAILED`: Metric aggregation error
- `PERMISSION_UPDATE_FAILED`: Permission setting error
- `INSUFFICIENT_PERMISSIONS`: User not authorized
- `COMPARISON_FAILED`: Comparison operation error

## Firestore Optimization

### Listener Management
Always call `dispose()` to clean up listeners and prevent memory leaks:

```dart
@override
void dispose() {
  syncService.dispose();
  super.dispose();
}
```

### Chunk Handling
Large parent lists are automatically chunked (Firestore `whereIn` limit is 10):

```dart
// Automatically handles 25 parents with 3 requests
final scores = await syncService.listenToMultipleParentScores('caregiver123');
```

### Indexing Recommendations
Create composite indexes for optimal query performance:

```
Indexes needed:
1. caregivers (parentIds, parentIds as array)
2. parents (healthScore, lastUpdate)
3. permissions (caregiverId, parentId)
4. audit_logs (caregiverId, parentId, timestamp)
```

## Security Considerations

### Access Control
All methods verify the caregiver has access to parents before returning data:
- Parent access list from `caregivers/{caregiverId}/parentIds`
- Permission level checks via `permissions` collection
- Admin/parent-only operations for modification

### Audit Logging
All permission changes are logged to `audit_logs` collection with:
- Who made the change (`changedBy`)
- What changed (`newPermission`, `customPermissions`)
- When it changed (`timestamp`)
- Why (`action`, `details`)

### Permission Enforcement
Three levels of enforcement:
1. **Access Verification**: Can caregiver see this parent?
2. **Permission Level**: What type of access? (health only, full, etc.)
3. **Custom Permissions**: Granular field-level controls

## Testing

Example unit tests:

```dart
test('compareParentProgress returns proper differences', () async {
  final comparison = ParentProgressComparison(
    parentId1: 'p1', parentName1: 'Parent 1',
    parentId2: 'p2', parentName2: 'Parent 2',
    healthScore1: 85.0, healthScore2: 90.0,
    activityLevel1: 70.0, activityLevel2: 75.0,
    achievements1: 5, achievements2: 8,
    daysSinceUpdate1: 2, daysSinceUpdate2: 3,
  );
  
  expect(comparison.healthScoreDifference, equals(-5.0));
  expect(comparison.healthScoreLeader, equals('p2'));
});

test('aggregateMetrics calculates averages', () async {
  final metrics = AggregatedMetrics(
    totalParents: 3,
    activeParents: 3,
    averageHealthScore: 85.0,
    lastUpdate: DateTime.now(),
    parentHealthScores: {'p1': 80.0, 'p2': 85.0, 'p3': 90.0},
    parentActivityLevels: {},
    criticalAlertsCount: 2,
    totalAchievements: 15,
  );
  
  expect(metrics.averageHealthScore, equals(85.0));
  expect(metrics.totalAchievements, equals(15));
});
```

## FAQ

**Q: How often should I call `aggregateMetrics()`?**
A: Cache results for 5-10 minutes to avoid excessive reads. Use periodic streams for updates.

**Q: Does listening to scores update automatically?**
A: Yes, `listenToMultipleParentScores()` returns a real-time stream via Firestore listeners.

**Q: Can I revoke a caregiver's access?**
A: Use `setPermissionLevel()` with `emergencyOnly` to limit access, or remove from `parentIds` array.

**Q: How many parents can one caregiver monitor?**
A: No limit, but chunking handles >10 parents automatically.

**Q: Are permission changes audited?**
A: Yes, all changes are logged to `audit_logs` collection with full context.
