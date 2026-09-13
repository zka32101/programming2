# CaregiverSyncService - Complete Reference

## Quick Start

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_core/services/caregiver_sync_service.dart';

// Initialize the service
final syncService = CaregiverSyncService(
  firestore: FirebaseFirestore.instance,
  caregiverId: currentUserId,
);

// Listen to parent scores in real-time
syncService.listenToMultipleParentScores(caregiverId).listen((scores) {
  print('Parent scores: $scores');
});

// Compare two parents
final comparison = await syncService.compareParentProgress(
  parentId1: 'parent1',
  parentId2: 'parent2',
);

// Aggregate metrics
final metrics = await syncService.aggregateMetrics(caregiverId);

// Manage permissions
await syncService.setPermissionLevel(
  parentId: 'parent1',
  caregiverId: 'caregiver1',
  level: ViewPermission.healthOnly,
);

// Clean up
syncService.dispose();
```

## Core Methods

### 1. listenToMultipleParentScores(String caregiverId)

**Purpose:** Listen to real-time health score updates from all assigned parents.

**Returns:** `Stream<Map<String, double>>`

**Parameters:**
- `caregiverId` (String): The caregiver ID

**Example:**
```dart
syncService.listenToMultipleParentScores('caregiver123')
  .listen((scores) {
    print('Updated scores: $scores');
    // Output: {parent1: 85.5, parent2: 92.0, parent3: 78.3}
  });
```

**Features:**
- Real-time updates via Firestore listeners
- Automatic filtering by caregiver's parents
- Automatic chunking for >10 parents
- Emits map of parentId to health score

**Behavior:**
- Emits empty map `{}` if caregiver has no parents
- Updates whenever any parent's health score changes
- Combines multiple Firestore queries automatically

---

### 2. compareParentProgress({required String parentId1, required String parentId2})

**Purpose:** Compare health and activity metrics between two parents.

**Returns:** `Future<ParentProgressComparison>`

**Parameters:**
- `parentId1` (String): First parent's ID
- `parentId2` (String): Second parent's ID

**Example:**
```dart
final comparison = await syncService.compareParentProgress(
  parentId1: 'parent123',
  parentId2: 'parent456',
);

print('${comparison.parentName1}: ${comparison.healthScore1}');
print('${comparison.parentName2}: ${comparison.healthScore2}');
print('Leader: ${comparison.healthScoreLeader}');
```

**Throws:** `CaregiverSyncException` with codes:
- `PARENT_NOT_FOUND`: Parent doesn't exist
- `ACCESS_DENIED`: Caregiver lacks access
- `COMPARISON_FAILED`: Operation failed

**Returns Data:**
```dart
ParentProgressComparison(
  parentId1: 'parent1',
  parentName1: 'John',
  parentId2: 'parent2',
  parentName2: 'Jane',
  healthScore1: 85.0,
  healthScore2: 92.0,
  activityLevel1: 70.0,
  activityLevel2: 88.0,
  achievements1: 5,
  achievements2: 8,
  daysSinceUpdate1: 2,
  daysSinceUpdate2: 5,
  healthScoreDifference: -7.0,      // parent1 - parent2
  activityLevelDifference: -18.0,   // parent1 - parent2
  healthScoreLeader: 'parent2',     // 'tie', parentId1, or parentId2
  activityLeader: 'parent2',        // 'tie', parentId1, or parentId2
  comparedAt: DateTime.now(),
)
```

---

### 3. aggregateMetrics(String caregiverId)

**Purpose:** Aggregate and summarize metrics across all assigned parents.

**Returns:** `Future<AggregatedMetrics>`

**Parameters:**
- `caregiverId` (String): The caregiver ID

**Example:**
```dart
final metrics = await syncService.aggregateMetrics('caregiver123');

print('Total parents: ${metrics.totalParents}');
print('Active: ${metrics.activeParents}');
print('Avg health: ${metrics.averageHealthScore}');
print('Alerts: ${metrics.criticalAlertsCount}');
print('Achievements: ${metrics.totalAchievements}');

// Per-parent data
metrics.parentHealthScores.forEach((parentId, score) {
  print('$parentId: $score');
});
```

**Throws:** `CaregiverSyncException` with codes:
- `CAREGIVER_NOT_FOUND`: Caregiver doesn't exist
- `AGGREGATION_FAILED`: Operation failed

**Returns Data:**
```dart
AggregatedMetrics(
  totalParents: 3,
  activeParents: 3,
  averageHealthScore: 85.5,
  lastUpdate: DateTime(...),
  parentHealthScores: {
    'parent1': 80.0,
    'parent2': 90.0,
    'parent3': 86.5,
  },
  parentActivityLevels: {
    'parent1': 70.0,
    'parent2': 88.0,
    'parent3': 75.0,
  },
  criticalAlertsCount: 2,
  totalAchievements: 15,
  computedAt: DateTime.now(),
)
```

---

### 4. setPermissionLevel({required String parentId, required String caregiverId, required ViewPermission level, CustomPermissions? customPermissions})

**Purpose:** Set or update caregiver's access level to a parent.

**Returns:** `Future<void>`

**Parameters:**
- `parentId` (String): The parent's ID
- `caregiverId` (String): The caregiver's ID
- `level` (ViewPermission): Permission level to grant
- `customPermissions` (CustomPermissions?): Custom permissions (only if level is custom)

**Example - Full Access:**
```dart
await syncService.setPermissionLevel(
  parentId: 'parent123',
  caregiverId: 'caregiver456',
  level: ViewPermission.fullAccess,
);
```

**Example - Health Only:**
```dart
await syncService.setPermissionLevel(
  parentId: 'parent123',
  caregiverId: 'caregiver456',
  level: ViewPermission.healthOnly,
);
```

**Example - Custom Permissions:**
```dart
await syncService.setPermissionLevel(
  parentId: 'parent123',
  caregiverId: 'caregiver456',
  level: ViewPermission.custom,
  customPermissions: CustomPermissions(
    viewBloodPressure: true,
    viewHeartRate: true,
    viewBloodGlucose: true,
    viewWeight: true,
    viewSleep: true,
    viewActivity: true,
    viewMedications: true,
    viewAppointments: false,
    viewEmergencyContacts: false,
    receiveAlerts: true,
    canAddNotes: true,
    viewHistory: true,
  ),
);
```

**Permission Levels:**
- `fullAccess`: All data and features
- `healthOnly`: Health metrics only
- `activityOnly`: Activity logs only
- `emergencyOnly`: Emergency contacts and alerts
- `readOnly`: Read-only all data
- `custom`: Custom field-level permissions

**Throws:** `CaregiverSyncException` with codes:
- `CAREGIVER_NOT_FOUND`: Caregiver doesn't exist
- `PARENT_NOT_FOUND`: Parent doesn't exist
- `ACCESS_DENIED`: Caregiver not assigned to parent
- `INSUFFICIENT_PERMISSIONS`: User not authorized
- `PERMISSION_UPDATE_FAILED`: Operation failed

---

### 5. getPermissionLevel({required String parentId, required String caregiverId})

**Purpose:** Get current permission level for a caregiver-parent pair.

**Returns:** `Future<ViewPermission?>`

**Parameters:**
- `parentId` (String): The parent's ID
- `caregiverId` (String): The caregiver's ID

**Example:**
```dart
final permission = await syncService.getPermissionLevel(
  parentId: 'parent123',
  caregiverId: 'caregiver456',
);

if (permission == ViewPermission.healthOnly) {
  print('Caregiver can only view health data');
}
```

**Returns:**
- `ViewPermission` if permission found
- `null` if no permission record exists

---

### 6. listenToPermissionChanges({required String parentId, required String caregiverId})

**Purpose:** Listen to permission changes for a caregiver-parent relationship.

**Returns:** `Stream<ViewPermission?>`

**Parameters:**
- `parentId` (String): The parent's ID
- `caregiverId` (String): The caregiver's ID

**Example:**
```dart
syncService.listenToPermissionChanges(
  parentId: 'parent123',
  caregiverId: 'caregiver456',
).listen((permission) {
  print('Permission changed to: $permission');
  if (permission == ViewPermission.emergencyOnly) {
    // Restrict UI access
  }
});
```

**Updates whenever permission level changes via `setPermissionLevel()`**

---

### 7. dispose()

**Purpose:** Clean up all active Firestore listeners to prevent memory leaks.

**Returns:** `void`

**Example:**
```dart
@override
void dispose() {
  syncService.dispose();
  super.dispose();
}
```

**Important:** Always call in StatefulWidget's `dispose()` method!

---

## Data Models

### AggregatedMetrics

```dart
class AggregatedMetrics {
  final int totalParents;                           // Total parents assigned
  final int activeParents;                          // Active parents
  final double averageHealthScore;                  // Average of all health scores
  final DateTime lastUpdate;                        // Most recent update time
  final Map<String, double> parentHealthScores;     // Per-parent scores
  final Map<String, double> parentActivityLevels;   // Per-parent activity
  final int criticalAlertsCount;                    // Total alerts
  final int totalAchievements;                      // Total achievements
  final DateTime computedAt;                        // When computed
  final Map<String, dynamic> metadata;              // Extra data
}
```

### ParentProgressComparison

```dart
class ParentProgressComparison {
  final String parentId1, parentId2;
  final String parentName1, parentName2;
  final double healthScore1, healthScore2;          // 0-100
  final double activityLevel1, activityLevel2;      // 0-100
  final int achievements1, achievements2;
  final int daysSinceUpdate1, daysSinceUpdate2;
  final double healthScoreDifference;               // parent1 - parent2
  final double activityLevelDifference;             // parent1 - parent2
  final String healthScoreLeader;                   // 'tie' or parentId
  final String activityLeader;                      // 'tie' or parentId
  final DateTime comparedAt;
}
```

### CaregiverSyncException

```dart
class CaregiverSyncException implements Exception {
  final String message;
  final String? code;
}

// Usage:
try {
  await syncService.compareParentProgress(...);
} on CaregiverSyncException catch (e) {
  if (e.code == 'ACCESS_DENIED') {
    // Handle access denied
  }
}
```

---

## Permission Levels

### ViewPermission Enum

```dart
enum ViewPermission {
  fullAccess,       // All data and features
  healthOnly,       // Health metrics only
  activityOnly,     // Activity logs only
  emergencyOnly,    // Emergency contacts and alerts
  readOnly,         // Read-only all data
  custom,           // Custom field permissions
}
```

### CustomPermissions Class

```dart
class CustomPermissions {
  final bool viewBloodPressure;
  final bool viewHeartRate;
  final bool viewBloodGlucose;
  final bool viewWeight;
  final bool viewSleep;
  final bool viewTemperature;
  final bool viewActivity;
  final bool viewMedications;
  final bool viewAppointments;
  final bool viewEmergencyContacts;
  final bool viewLocation;
  final bool receiveAlerts;
  final bool canAddNotes;
  final bool viewHistory;
}
```

---

## Error Codes

| Code | Meaning | Solution |
|------|---------|----------|
| `PARENT_NOT_FOUND` | Parent doesn't exist | Verify parent ID |
| `CAREGIVER_NOT_FOUND` | Caregiver doesn't exist | Check caregiver profile |
| `ACCESS_DENIED` | Caregiver can't access parent | Grant permission first |
| `AGGREGATION_FAILED` | Metrics computation failed | Check parent data |
| `COMPARISON_FAILED` | Comparison failed | Check both parents exist |
| `PERMISSION_UPDATE_FAILED` | Can't update permission | Check authorization |
| `INSUFFICIENT_PERMISSIONS` | User not authorized | Must be parent or admin |
| `GET_PERMISSION_FAILED` | Can't retrieve permission | Check permissions collection |

---

## Firestore Schema

### Collection: `caregivers`
```
caregivers/{caregiverId}
  ├── caregiverId: string
  ├── parentIds: List<string>
  ├── permission: string (full_access, health_only, etc.)
  ├── name: string
  ├── email: string
  ├── isActive: boolean
  └── updatedAt: timestamp
```

### Collection: `parents`
```
parents/{parentId}
  ├── parentId: string
  ├── name: string
  ├── healthScore: number (0-100)
  ├── activityLevel: number (0-100)
  ├── achievements: List<string>
  ├── criticalAlerts: List<object>
  ├── lastUpdate: timestamp
  ├── isActive: boolean
  └── ownerId: string
```

### Collection: `permissions`
```
permissions/{caregiverId}_{parentId}
  ├── caregiverId: string
  ├── parentId: string
  ├── permission: string
  ├── customPermissions: object (if custom)
  ├── setAt: timestamp
  └── setBy: string
```

### Collection: `audit_logs`
```
audit_logs/{logId}
  ├── action: string
  ├── caregiverId: string
  ├── parentId: string
  ├── newPermission: string
  ├── changedBy: string
  ├── timestamp: timestamp
  └── customPermissions: object
```

---

## Performance Tips

1. **Cache aggregation results:** Don't call `aggregateMetrics()` more than every 5 minutes
2. **Use streams:** Prefer `listenToMultipleParentScores()` over polling
3. **Limit comparisons:** Don't compare more than 2-3 parent pairs simultaneously
4. **Dispose listeners:** Always call `dispose()` to prevent memory leaks
5. **Batch updates:** Use `setPermissionLevel()` in sequence, not parallel
6. **Monitor query costs:** 25 parents = 3 Firestore reads (auto-chunked)

---

## Testing

```dart
test('compareParentProgress returns valid comparison', () async {
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
});
```

---

## See Also

- `caregiver_profile.dart` - Caregiver profile data model
- `multi_profile_service.dart` - Parent profile management
- `CAREGIVER_SYNC_SERVICE_GUIDE.md` - Detailed usage guide
- `caregiver_sync_service_example.dart` - Full working examples
