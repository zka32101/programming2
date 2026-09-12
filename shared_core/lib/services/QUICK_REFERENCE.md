# CaregiverSyncService - Quick Reference Card

## Initialize
```dart
final syncService = CaregiverSyncService(
  firestore: FirebaseFirestore.instance,
  caregiverId: userId,
);
```

## 1. Monitor Multiple Parent Scores (Real-Time)
```dart
syncService.listenToMultipleParentScores(caregiverId)
  .listen((scores) {
    // {parent1: 85.5, parent2: 92.0}
  });
```
**→ Stream<Map<String, double>>**

## 2. Compare Two Parents
```dart
final comp = await syncService.compareParentProgress(
  parentId1: 'parent1',
  parentId2: 'parent2',
);
print(comp.healthScoreLeader);        // 'parent2' or 'tie'
print(comp.healthScoreDifference);    // -7.0 (parent1 - parent2)
print(comp.daysSinceUpdate1);         // 2 days
```
**→ Future<ParentProgressComparison>**

## 3. Aggregate All Parent Metrics
```dart
final metrics = await syncService.aggregateMetrics(caregiverId);
print(metrics.totalParents);           // 3
print(metrics.averageHealthScore);     // 85.5
print(metrics.parentHealthScores);     // {parent1: 80.0, ...}
print(metrics.criticalAlertsCount);    // 2
print(metrics.totalAchievements);      // 15
```
**→ Future<AggregatedMetrics>**

## 4. Set Permission Level
```dart
// Full Access
await syncService.setPermissionLevel(
  parentId: 'parent1',
  caregiverId: 'caregiver1',
  level: ViewPermission.fullAccess,
);

// Health Only
await syncService.setPermissionLevel(
  parentId: 'parent1',
  caregiverId: 'caregiver1',
  level: ViewPermission.healthOnly,
);

// Custom Permissions
await syncService.setPermissionLevel(
  parentId: 'parent1',
  caregiverId: 'caregiver1',
  level: ViewPermission.custom,
  customPermissions: CustomPermissions(
    viewBloodPressure: true,
    viewHeartRate: true,
    viewActivity: false,
    receiveAlerts: true,
  ),
);
```
**→ Future<void>**

## Permission Levels
| Level | Description |
|-------|-------------|
| `fullAccess` | All data and features |
| `healthOnly` | Health metrics only |
| `activityOnly` | Activity logs only |
| `emergencyOnly` | Emergency alerts only |
| `readOnly` | Read-only all data |
| `custom` | Field-level permissions |

## 5. Get/Watch Permissions
```dart
// Get current permission
final perm = await syncService.getPermissionLevel(
  parentId: 'parent1',
  caregiverId: 'caregiver1',
);

// Listen to permission changes
syncService.listenToPermissionChanges(
  parentId: 'parent1',
  caregiverId: 'caregiver1',
).listen((perm) {
  print('Permission changed to: $perm');
});
```
**→ Future<ViewPermission?> | Stream<ViewPermission?>**

## 6. Cleanup
```dart
@override
void dispose() {
  syncService.dispose();  // Important!
  super.dispose();
}
```

## Error Handling
```dart
try {
  await syncService.compareParentProgress(...);
} on CaregiverSyncException catch (e) {
  print('Error: ${e.code} - ${e.message}');
  // PARENT_NOT_FOUND, ACCESS_DENIED, COMPARISON_FAILED, etc.
}
```

## Common Error Codes
| Code | Solution |
|------|----------|
| `PARENT_NOT_FOUND` | Verify parent ID exists |
| `ACCESS_DENIED` | Grant permission first |
| `CAREGIVER_NOT_FOUND` | Check caregiver profile |
| `AGGREGATION_FAILED` | Check parent data integrity |
| `INSUFFICIENT_PERMISSIONS` | Must be parent or admin |

## Widget Integration Pattern
```dart
@override
void initState() {
  super.initState();
  syncService = CaregiverSyncService(
    firestore: FirebaseFirestore.instance,
    caregiverId: userId,
  );
}

@override
Widget build(BuildContext context) {
  return StreamBuilder<Map<String, double>>(
    stream: syncService.listenToMultipleParentScores(userId),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return CircularProgressIndicator();
      // Use snapshot.data!
    },
  );
}

@override
void dispose() {
  syncService.dispose();
  super.dispose();
}
```

## FutureBuilder Pattern
```dart
FutureBuilder<ParentProgressComparison>(
  future: syncService.compareParentProgress(
    parentId1: 'p1',
    parentId2: 'p2',
  ),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();
    final comp = snapshot.data!;
    // Use comp...
  },
)
```

## Data Refresh Pattern (Periodic)
```dart
@override
void initState() {
  super.initState();
  // Refresh metrics every 5 minutes
  _timer = Timer.periodic(Duration(minutes: 5), (_) async {
    final metrics = await syncService.aggregateMetrics(caregiverId);
    setState(() {
      _currentMetrics = metrics;
    });
  });
}

@override
void dispose() {
  _timer?.cancel();
  syncService.dispose();
  super.dispose();
}
```

## Testing
```dart
test('comparison calculates differences', () {
  final comp = ParentProgressComparison(
    parentId1: 'p1', parentName1: 'John',
    parentId2: 'p2', parentName2: 'Jane',
    healthScore1: 85.0, healthScore2: 90.0,
    activityLevel1: 70.0, activityLevel2: 75.0,
    achievements1: 5, achievements2: 8,
    daysSinceUpdate1: 2, daysSinceUpdate2: 3,
  );
  expect(comp.healthScoreDifference, equals(-5.0));
  expect(comp.healthScoreLeader, equals('p2'));
});
```

## Performance Tips
✓ Cache aggregation results (5-10 min)
✓ Use real-time streams, not polling
✓ Limit concurrent comparisons (2-3 max)
✓ Always call dispose()
✓ Handle 25+ parents automatically (chunked)

## Firestore Collections
```
caregivers/{id}          → parentIds, permission
parents/{id}             → healthScore, activityLevel, achievements
permissions/{id}_{id}    → permission, customPermissions
audit_logs/{id}          → action, changed_by, timestamp
```

## Related Classes
- `CaregiverProfile` - Caregiver model
- `ViewPermission` - Permission enum
- `CustomPermissions` - Field-level perms
- `AggregatedMetrics` - Aggregated data
- `ParentProgressComparison` - Comparison result

## Links
📄 Full Guide: `CAREGIVER_SYNC_SERVICE_GUIDE.md`
📖 API Ref: `README_CAREGIVER_SYNC.md`
💡 Examples: `caregiver_sync_service_example.dart`
📋 Tests: `caregiver_sync_service_test.dart`
