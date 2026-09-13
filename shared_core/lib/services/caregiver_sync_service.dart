import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_core/models/caregiver_profile.dart';

/// Exception for caregiver sync service operations
class CaregiverSyncException implements Exception {
  final String message;
  final String? code;

  CaregiverSyncException(this.message, {this.code});

  @override
  String toString() =>
      'CaregiverSyncException: $message${code != null ? ' ($code)' : ''}';
}

/// Data model for aggregated parent metrics
class AggregatedMetrics {
  /// Total number of parents being monitored
  final int totalParents;

  /// Number of active parents
  final int activeParents;

  /// Average health score across all parents (0-100)
  final double averageHealthScore;

  /// Timestamp of the last update across any parent
  final DateTime lastUpdate;

  /// Map of parentId to health score
  final Map<String, double> parentHealthScores;

  /// Map of parentId to activity level (0-100)
  final Map<String, double> parentActivityLevels;

  /// Critical alerts count across all parents
  final int criticalAlertsCount;

  /// Total achievements unlocked across all parents
  final int totalAchievements;

  /// Timestamp when these metrics were computed
  final DateTime computedAt;

  /// Additional metadata
  final Map<String, dynamic> metadata;

  AggregatedMetrics({
    required this.totalParents,
    required this.activeParents,
    required this.averageHealthScore,
    required this.lastUpdate,
    required this.parentHealthScores,
    required this.parentActivityLevels,
    required this.criticalAlertsCount,
    required this.totalAchievements,
    DateTime? computedAt,
    Map<String, dynamic>? metadata,
  })  : computedAt = computedAt ?? DateTime.now(),
        metadata = metadata ?? {};

  /// Convert to JSON for storage or transmission
  Map<String, dynamic> toJson() => {
        'totalParents': totalParents,
        'activeParents': activeParents,
        'averageHealthScore': averageHealthScore,
        'lastUpdate': Timestamp.fromDate(lastUpdate),
        'parentHealthScores': parentHealthScores,
        'parentActivityLevels': parentActivityLevels,
        'criticalAlertsCount': criticalAlertsCount,
        'totalAchievements': totalAchievements,
        'computedAt': Timestamp.fromDate(computedAt),
        'metadata': metadata,
      };

  /// Create from JSON
  factory AggregatedMetrics.fromJson(Map<String, dynamic> json) {
    return AggregatedMetrics(
      totalParents: json['totalParents'] ?? 0,
      activeParents: json['activeParents'] ?? 0,
      averageHealthScore: (json['averageHealthScore'] ?? 0.0).toDouble(),
      lastUpdate: (json['lastUpdate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      parentHealthScores:
          Map<String, double>.from(json['parentHealthScores'] ?? {}),
      parentActivityLevels:
          Map<String, double>.from(json['parentActivityLevels'] ?? {}),
      criticalAlertsCount: json['criticalAlertsCount'] ?? 0,
      totalAchievements: json['totalAchievements'] ?? 0,
      computedAt: (json['computedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      metadata: json['metadata'] ?? {},
    );
  }
}

/// Data model for parent progress comparison
class ParentProgressComparison {
  /// First parent ID
  final String parentId1;

  /// First parent name
  final String parentName1;

  /// Second parent ID
  final String parentId2;

  /// Second parent name
  final String parentName2;

  /// Health score for parent 1 (0-100)
  final double healthScore1;

  /// Health score for parent 2 (0-100)
  final double healthScore2;

  /// Activity level for parent 1 (0-100)
  final double activityLevel1;

  /// Activity level for parent 2 (0-100)
  final double activityLevel2;

  /// Number of achievements for parent 1
  final int achievements1;

  /// Number of achievements for parent 2
  final int achievements2;

  /// Days since last update for parent 1
  final int daysSinceUpdate1;

  /// Days since last update for parent 2
  final int daysSinceUpdate2;

  /// Health score difference (parent1 - parent2)
  final double healthScoreDifference;

  /// Activity level difference (parent1 - parent2)
  final double activityLevelDifference;

  /// Which parent has higher health score
  late final String healthScoreLeader = healthScoreDifference > 0
      ? parentId1
      : healthScoreDifference < 0
          ? parentId2
          : 'tie';

  /// Which parent has higher activity level
  late final String activityLeader = activityLevelDifference > 0
      ? parentId1
      : activityLevelDifference < 0
          ? parentId2
          : 'tie';

  /// Timestamp of comparison
  final DateTime comparedAt;

  ParentProgressComparison({
    required this.parentId1,
    required this.parentName1,
    required this.parentId2,
    required this.parentName2,
    required this.healthScore1,
    required this.healthScore2,
    required this.activityLevel1,
    required this.activityLevel2,
    required this.achievements1,
    required this.achievements2,
    required this.daysSinceUpdate1,
    required this.daysSinceUpdate2,
    DateTime? comparedAt,
  })  : healthScoreDifference = healthScore1 - healthScore2,
        activityLevelDifference = activityLevel1 - activityLevel2,
        comparedAt = comparedAt ?? DateTime.now();

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'parentId1': parentId1,
        'parentName1': parentName1,
        'parentId2': parentId2,
        'parentName2': parentName2,
        'healthScore1': healthScore1,
        'healthScore2': healthScore2,
        'activityLevel1': activityLevel1,
        'activityLevel2': activityLevel2,
        'achievements1': achievements1,
        'achievements2': achievements2,
        'daysSinceUpdate1': daysSinceUpdate1,
        'daysSinceUpdate2': daysSinceUpdate2,
        'healthScoreDifference': healthScoreDifference,
        'activityLevelDifference': activityLevelDifference,
        'healthScoreLeader': healthScoreLeader,
        'activityLeader': activityLeader,
        'comparedAt': Timestamp.fromDate(comparedAt),
      };
}

/// Service for managing caregiver synchronization and monitoring across multiple parents
///
/// This service provides:
/// - Real-time listening to multiple parent scores
/// - Parent progress comparison for dashboard views
/// - Aggregated metrics across all parents
/// - Permission level management per parent
/// - Firestore listener management
class CaregiverSyncService {
  final FirebaseFirestore _firestore;
  final String _caregiverId;

  // Firestore collection paths
  static const String _caregiversCollection = 'caregivers';
  static const String _parentsCollection = 'parents';
  static const String _metricsCollection = 'metrics';
  static const String _permissionsCollection = 'permissions';

  // Firestore listener references for cleanup
  final Map<String, StreamSubscription> _activeListeners = {};
  final Map<String, StreamSubscription> _aggregationListeners = {};

  /// Create instance of CaregiverSyncService
  CaregiverSyncService({
    required FirebaseFirestore firestore,
    required String caregiverId,
  })  : _firestore = firestore,
        _caregiverId = caregiverId;

  /// Listen to multiple parent scores in real-time
  ///
  /// Returns a stream that emits updates whenever any of the caregiver's
  /// assigned parents' health scores change. The stream emits a map of
  /// parentId to health score.
  ///
  /// The listener automatically handles permission checks and only streams
  /// data for parents the caregiver has access to.
  ///
  /// Example:
  /// ```dart
  /// syncService.listenToMultipleParentScores(caregiverId).listen((scores) {
  ///   print('Updated scores: $scores');
  /// });
  /// ```
  Stream<Map<String, double>> listenToMultipleParentScores(
    String caregiverId,
  ) {
    return _firestore
        .collection(_caregiversCollection)
        .doc(caregiverId)
        .snapshots()
        .asyncExpand((caregiverDoc) async* {
      if (!caregiverDoc.exists) {
        yield {};
        return;
      }

      final caregiverData = caregiverDoc.data() ?? {};
      final parentIds = List<String>.from(caregiverData['parentIds'] ?? []);

      if (parentIds.isEmpty) {
        yield {};
        return;
      }

      // Create a combined stream of all parent metrics
      // Split into chunks of 10 to avoid Firestore's whereIn limit
      final scoresMap = <String, double>{};

      for (var i = 0; i < parentIds.length; i += 10) {
        final chunk = parentIds.sublist(
          i,
          (i + 10).clamp(0, parentIds.length),
        );

        yield* _firestore
            .collection(_parentsCollection)
            .where(
              FieldPath.documentId,
              whereIn: chunk,
            )
            .snapshots()
            .map((parentDocs) {
          final scores = <String, double>{};
          for (final doc in parentDocs.docs) {
            final data = doc.data();
            final healthScore =
                (data['healthScore'] as num?)?.toDouble() ?? 0.0;
            scores[doc.id] = healthScore;
          }
          return {...scoresMap, ...scores};
        });
      }
    });
  }

  /// Compare progress between two parents for dashboard display
  ///
  /// Provides a comprehensive comparison of two parents' metrics including
  /// health scores, activity levels, achievement counts, and last update times.
  ///
  /// Throws [CaregiverSyncException] if:
  /// - Either parent doesn't exist
  /// - Caregiver doesn't have access to either parent
  /// - Data retrieval fails
  ///
  /// Example:
  /// ```dart
  /// final comparison = await syncService.compareParentProgress(
  ///   parentId1: 'parent123',
  ///   parentId2: 'parent456',
  /// );
  /// print('${comparison.parentName1} health: ${comparison.healthScore1}');
  /// ```
  Future<ParentProgressComparison> compareParentProgress({
    required String parentId1,
    required String parentId2,
  }) async {
    try {
      // Verify caregiver has access to both parents
      await _verifyParentAccess(parentId1);
      await _verifyParentAccess(parentId2);

      // Fetch both parent documents in parallel
      final parent1Doc = _firestore
          .collection(_parentsCollection)
          .doc(parentId1)
          .get();
      final parent2Doc = _firestore
          .collection(_parentsCollection)
          .doc(parentId2)
          .get();

      final results = await Future.wait([parent1Doc, parent2Doc]);
      final doc1 = results[0] as DocumentSnapshot<Map<String, dynamic>>;
      final doc2 = results[1] as DocumentSnapshot<Map<String, dynamic>>;

      if (!doc1.exists || !doc2.exists) {
        throw CaregiverSyncException(
          'One or both parents do not exist',
          code: 'PARENT_NOT_FOUND',
        );
      }

      final data1 = doc1.data() ?? {};
      final data2 = doc2.data() ?? {};

      // Extract metrics
      final healthScore1 = (data1['healthScore'] as num?)?.toDouble() ?? 0.0;
      final healthScore2 = (data2['healthScore'] as num?)?.toDouble() ?? 0.0;

      final activityLevel1 = (data1['activityLevel'] as num?)?.toDouble() ?? 0.0;
      final activityLevel2 = (data2['activityLevel'] as num?)?.toDouble() ?? 0.0;

      final achievements1 = (data1['achievements'] as List?)?.length ?? 0;
      final achievements2 = (data2['achievements'] as List?)?.length ?? 0;

      // Calculate days since last update
      final lastUpdate1 = (data1['lastUpdate'] as Timestamp?)?.toDate();
      final lastUpdate2 = (data2['lastUpdate'] as Timestamp?)?.toDate();

      final now = DateTime.now();
      final daysSinceUpdate1 = lastUpdate1 != null
          ? now.difference(lastUpdate1).inDays
          : 999;
      final daysSinceUpdate2 = lastUpdate2 != null
          ? now.difference(lastUpdate2).inDays
          : 999;

      return ParentProgressComparison(
        parentId1: parentId1,
        parentName1: data1['name'] ?? 'Parent 1',
        parentId2: parentId2,
        parentName2: data2['name'] ?? 'Parent 2',
        healthScore1: healthScore1,
        healthScore2: healthScore2,
        activityLevel1: activityLevel1,
        activityLevel2: activityLevel2,
        achievements1: achievements1,
        achievements2: achievements2,
        daysSinceUpdate1: daysSinceUpdate1,
        daysSinceUpdate2: daysSinceUpdate2,
      );
    } on CaregiverSyncException {
      rethrow;
    } catch (e) {
      throw CaregiverSyncException(
        'Failed to compare parent progress: $e',
        code: 'COMPARISON_FAILED',
      );
    }
  }

  /// Aggregate metrics from all parents assigned to a caregiver
  ///
  /// Computes comprehensive statistics across all parents including:
  /// - Total and active parent counts
  /// - Average health scores
  /// - Activity levels
  /// - Critical alerts
  /// - Total achievements
  ///
  /// Returns [AggregatedMetrics] containing all computed statistics.
  ///
  /// Throws [CaregiverSyncException] if data retrieval fails.
  ///
  /// Example:
  /// ```dart
  /// final metrics = await syncService.aggregateMetrics(caregiverId);
  /// print('Average health: ${metrics.averageHealthScore}');
  /// print('Total parents: ${metrics.totalParents}');
  /// ```
  Future<AggregatedMetrics> aggregateMetrics(String caregiverId) async {
    try {
      // Fetch caregiver profile
      final caregiverDoc = await _firestore
          .collection(_caregiversCollection)
          .doc(caregiverId)
          .get();

      if (!caregiverDoc.exists) {
        throw CaregiverSyncException(
          'Caregiver not found',
          code: 'CAREGIVER_NOT_FOUND',
        );
      }

      final caregiverData = caregiverDoc.data() ?? {};
      final parentIds = List<String>.from(caregiverData['parentIds'] ?? []);

      if (parentIds.isEmpty) {
        return AggregatedMetrics(
          totalParents: 0,
          activeParents: 0,
          averageHealthScore: 0.0,
          lastUpdate: DateTime.now(),
          parentHealthScores: {},
          parentActivityLevels: {},
          criticalAlertsCount: 0,
          totalAchievements: 0,
        );
      }

      final healthScores = <String, double>{};
      final activityLevels = <String, double>{};
      var totalAchievements = 0;
      var criticalAlerts = 0;
      var activeParents = 0;
      var lastUpdate = DateTime(2000); // Very old date

      // Fetch parent data in chunks (Firestore whereIn limit is 10)
      for (var i = 0; i < parentIds.length; i += 10) {
        final chunk = parentIds.sublist(
          i,
          (i + 10).clamp(0, parentIds.length),
        );

        final parentDocs = await _firestore
            .collection(_parentsCollection)
            .where(
              FieldPath.documentId,
              whereIn: chunk,
            )
            .get();

        for (final doc in parentDocs.docs) {
          final data = doc.data();
          final isActive = data['isActive'] ?? true;

          if (isActive) {
            activeParents++;
          }

          final healthScore = (data['healthScore'] as num?)?.toDouble() ?? 0.0;
          final activityLevel = (data['activityLevel'] as num?)?.toDouble() ?? 0.0;
          final achievements = (data['achievements'] as List?)?.length ?? 0;
          final criticalAlertsList =
              (data['criticalAlerts'] as List?)?.length ?? 0;
          final lastUpdateTime = (data['lastUpdate'] as Timestamp?)?.toDate();

          healthScores[doc.id] = healthScore;
          activityLevels[doc.id] = activityLevel;
          totalAchievements += achievements;
          criticalAlerts += criticalAlertsList;

          if (lastUpdateTime != null && lastUpdateTime.isAfter(lastUpdate)) {
            lastUpdate = lastUpdateTime;
          }
        }
      }

      // Calculate averages
      final averageHealthScore = healthScores.isEmpty
          ? 0.0
          : healthScores.values.reduce((a, b) => a + b) / healthScores.length;

      return AggregatedMetrics(
        totalParents: parentIds.length,
        activeParents: activeParents,
        averageHealthScore: averageHealthScore,
        lastUpdate: lastUpdate.year > 2000 ? lastUpdate : DateTime.now(),
        parentHealthScores: healthScores,
        parentActivityLevels: activityLevels,
        criticalAlertsCount: criticalAlerts,
        totalAchievements: totalAchievements,
      );
    } catch (e) {
      throw CaregiverSyncException(
        'Failed to aggregate metrics: $e',
        code: 'AGGREGATION_FAILED',
      );
    }
  }

  /// Set permission level for a caregiver to a specific parent
  ///
  /// Updates the caregiver's access level to a parent. The permission level
  /// determines what data the caregiver can view (full access, health only,
  /// activity only, emergency only, read-only, or custom).
  ///
  /// Permission levels:
  /// - `fullAccess`: All data and features
  /// - `healthOnly`: Health metrics and summaries
  /// - `activityOnly`: Activity logs only
  /// - `emergencyOnly`: Emergency contacts and alerts
  /// - `readOnly`: Read-only access to all data
  /// - `custom`: Custom permissions (requires customPermissions object)
  ///
  /// Throws [CaregiverSyncException] if:
  /// - Caregiver or parent doesn't exist
  /// - Authorization check fails
  /// - Update operation fails
  ///
  /// Example:
  /// ```dart
  /// await syncService.setPermissionLevel(
  ///   parentId: 'parent123',
  ///   caregiverId: 'caregiver456',
  ///   level: ViewPermission.healthOnly,
  /// );
  /// ```
  Future<void> setPermissionLevel({
    required String parentId,
    required String caregiverId,
    required ViewPermission level,
    CustomPermissions? customPermissions,
  }) async {
    try {
      // Verify caregiver exists
      final caregiverDoc = await _firestore
          .collection(_caregiversCollection)
          .doc(caregiverId)
          .get();

      if (!caregiverDoc.exists) {
        throw CaregiverSyncException(
          'Caregiver not found',
          code: 'CAREGIVER_NOT_FOUND',
        );
      }

      final caregiverData = caregiverDoc.data() ?? {};
      final parentIds = List<String>.from(caregiverData['parentIds'] ?? []);

      // Verify caregiver has access to this parent
      if (!parentIds.contains(parentId)) {
        throw CaregiverSyncException(
          'Caregiver does not have access to this parent',
          code: 'ACCESS_DENIED',
        );
      }

      // Verify parent exists
      final parentDoc =
          await _firestore.collection(_parentsCollection).doc(parentId).get();

      if (!parentDoc.exists) {
        throw CaregiverSyncException(
          'Parent not found',
          code: 'PARENT_NOT_FOUND',
        );
      }

      // Verify authorization (caregiver must be the parent or admin)
      await _verifyAuthorizationToModifyPermissions(parentId);

      // Prepare update data
      final updateData = <String, dynamic>{
        'permission': _permissionToString(level),
        'updatedAt': Timestamp.now(),
      };

      if (customPermissions != null && level == ViewPermission.custom) {
        updateData['customPermissions'] = _serializeCustomPermissions(customPermissions);
      }

      // Store permission record in permissions collection
      await _firestore
          .collection(_permissionsCollection)
          .doc('${caregiverId}_${parentId}')
          .set(
            {
              'caregiverId': caregiverId,
              'parentId': parentId,
              'permission': _permissionToString(level),
              'customPermissions': customPermissions != null
                  ? _serializeCustomPermissions(customPermissions)
                  : null,
              'setAt': Timestamp.now(),
              'setBy': _caregiverId,
            },
            SetOptions(merge: true),
          );

      // Update caregiver profile with new permission
      await _firestore
          .collection(_caregiversCollection)
          .doc(caregiverId)
          .update(updateData);

      // Log permission change
      await _logPermissionChange(
        caregiverId: caregiverId,
        parentId: parentId,
        newPermission: level,
        customPermissions: customPermissions,
      );
    } on CaregiverSyncException {
      rethrow;
    } catch (e) {
      throw CaregiverSyncException(
        'Failed to set permission level: $e',
        code: 'PERMISSION_UPDATE_FAILED',
      );
    }
  }

  /// Get current permission level for a caregiver to a specific parent
  Future<ViewPermission?> getPermissionLevel({
    required String parentId,
    required String caregiverId,
  }) async {
    try {
      final permDoc = await _firestore
          .collection(_permissionsCollection)
          .doc('${caregiverId}_${parentId}')
          .get();

      if (!permDoc.exists) {
        // Fall back to caregiver profile permission
        final caregiverDoc = await _firestore
            .collection(_caregiversCollection)
            .doc(caregiverId)
            .get();

        if (!caregiverDoc.exists) {
          return null;
        }

        final data = caregiverDoc.data() ?? {};
        final permissionStr = data['permission'] as String?;
        return _stringToPermission(permissionStr);
      }

      final data = permDoc.data() ?? {};
      final permissionStr = data['permission'] as String?;
      return _stringToPermission(permissionStr);
    } catch (e) {
      throw CaregiverSyncException(
        'Failed to get permission level: $e',
        code: 'GET_PERMISSION_FAILED',
      );
    }
  }

  /// Listen to permission changes for a caregiver-parent pair
  ///
  /// Returns a stream that emits the current and any future permission changes
  /// for the specified caregiver-parent relationship.
  Stream<ViewPermission?> listenToPermissionChanges({
    required String parentId,
    required String caregiverId,
  }) {
    return _firestore
        .collection(_permissionsCollection)
        .doc('${caregiverId}_${parentId}')
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        return null;
      }
      final data = doc.data() ?? {};
      final permissionStr = data['permission'] as String?;
      return _stringToPermission(permissionStr);
    });
  }

  /// Dispose of all active listeners
  void dispose() {
    for (final listener in _activeListeners.values) {
      listener.cancel();
    }
    for (final listener in _aggregationListeners.values) {
      listener.cancel();
    }
    _activeListeners.clear();
    _aggregationListeners.clear();
  }

  // ==================== PRIVATE HELPER METHODS ====================

  /// Verify caregiver has access to parent
  Future<void> _verifyParentAccess(String parentId) async {
    final caregiverDoc = await _firestore
        .collection(_caregiversCollection)
        .doc(_caregiverId)
        .get();

    if (!caregiverDoc.exists) {
      throw CaregiverSyncException(
        'Caregiver not found',
        code: 'CAREGIVER_NOT_FOUND',
      );
    }

    final data = caregiverDoc.data() ?? {};
    final parentIds = List<String>.from(data['parentIds'] ?? []);

    if (!parentIds.contains(parentId)) {
      throw CaregiverSyncException(
        'Access denied to parent $parentId',
        code: 'ACCESS_DENIED',
      );
    }
  }

  /// Verify authorization to modify permissions (must be parent or admin)
  Future<void> _verifyAuthorizationToModifyPermissions(
    String parentId,
  ) async {
    final parentDoc =
        await _firestore.collection(_parentsCollection).doc(parentId).get();

    if (!parentDoc.exists) {
      throw CaregiverSyncException(
        'Parent not found',
        code: 'PARENT_NOT_FOUND',
      );
    }

    final parentData = parentDoc.data() ?? {};
    final ownerId = parentData['ownerId'] as String?;

    // Check if current user is the parent
    if (ownerId != _caregiverId) {
      // Check if current user has admin role
      final userDoc = await _firestore
          .collection('users')
          .doc(_caregiverId)
          .get();

      if (!userDoc.exists) {
        throw CaregiverSyncException(
          'User not found',
          code: 'USER_NOT_FOUND',
        );
      }

      final userData = userDoc.data() ?? {};
      final role = userData['role'] as String?;

      if (role != 'admin' && role != 'parent') {
        throw CaregiverSyncException(
          'Insufficient permissions to modify access levels',
          code: 'INSUFFICIENT_PERMISSIONS',
        );
      }
    }
  }

  /// Convert ViewPermission enum to string
  String _permissionToString(ViewPermission permission) {
    return switch (permission) {
      ViewPermission.fullAccess => 'full_access',
      ViewPermission.healthOnly => 'health_only',
      ViewPermission.activityOnly => 'activity_only',
      ViewPermission.emergencyOnly => 'emergency_only',
      ViewPermission.readOnly => 'read_only',
      ViewPermission.custom => 'custom',
    };
  }

  /// Convert string to ViewPermission enum
  ViewPermission? _stringToPermission(String? str) {
    return switch (str) {
      'full_access' => ViewPermission.fullAccess,
      'health_only' => ViewPermission.healthOnly,
      'activity_only' => ViewPermission.activityOnly,
      'emergency_only' => ViewPermission.emergencyOnly,
      'read_only' => ViewPermission.readOnly,
      'custom' => ViewPermission.custom,
      _ => null,
    };
  }

  /// Serialize CustomPermissions to JSON
  Map<String, dynamic> _serializeCustomPermissions(
    CustomPermissions permissions,
  ) {
    return {
      'viewBloodPressure': permissions.viewBloodPressure,
      'viewHeartRate': permissions.viewHeartRate,
      'viewBloodGlucose': permissions.viewBloodGlucose,
      'viewWeight': permissions.viewWeight,
      'viewSleep': permissions.viewSleep,
      'viewTemperature': permissions.viewTemperature,
      'viewActivity': permissions.viewActivity,
      'viewMedications': permissions.viewMedications,
      'viewAppointments': permissions.viewAppointments,
      'viewEmergencyContacts': permissions.viewEmergencyContacts,
      'viewLocation': permissions.viewLocation,
      'receiveAlerts': permissions.receiveAlerts,
      'canAddNotes': permissions.canAddNotes,
      'viewHistory': permissions.viewHistory,
    };
  }

  /// Deserialize CustomPermissions from JSON
  CustomPermissions _deserializeCustomPermissions(Map<String, dynamic> json) {
    return CustomPermissions(
      viewBloodPressure: json['viewBloodPressure'] ?? false,
      viewHeartRate: json['viewHeartRate'] ?? false,
      viewBloodGlucose: json['viewBloodGlucose'] ?? false,
      viewWeight: json['viewWeight'] ?? false,
      viewSleep: json['viewSleep'] ?? false,
      viewTemperature: json['viewTemperature'] ?? false,
      viewActivity: json['viewActivity'] ?? false,
      viewMedications: json['viewMedications'] ?? false,
      viewAppointments: json['viewAppointments'] ?? false,
      viewEmergencyContacts: json['viewEmergencyContacts'] ?? false,
      viewLocation: json['viewLocation'] ?? false,
      receiveAlerts: json['receiveAlerts'] ?? false,
      canAddNotes: json['canAddNotes'] ?? false,
      viewHistory: json['viewHistory'] ?? false,
    );
  }

  /// Log permission change for audit trail
  Future<void> _logPermissionChange({
    required String caregiverId,
    required String parentId,
    required ViewPermission newPermission,
    CustomPermissions? customPermissions,
  }) async {
    try {
      await _firestore.collection('audit_logs').add({
        'action': 'permission_changed',
        'caregiverId': caregiverId,
        'parentId': parentId,
        'newPermission': _permissionToString(newPermission),
        'changedBy': _caregiverId,
        'timestamp': Timestamp.now(),
        'customPermissions': customPermissions != null
            ? _serializeCustomPermissions(customPermissions)
            : null,
      });
    } catch (e) {
      // Log failures are non-fatal
      print('Failed to log permission change: $e');
    }
  }
}
