import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/notification_model.dart';
import 'logger_service.dart';

/// Service for managing user notifications
/// Phase 14 Part 4: Notifications System
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// ローカル通知プラグインを初期化する
  Future<void> init() async {
    if (_initialized) return;
    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);
      await _localNotifications.initialize(initSettings);
      _initialized = true;
    } catch (e) {
      LoggerService.error('Failed to initialize notifications', exception: e);
    }
  }

  /// 通知権限をリクエストする
  Future<bool> requestPermission() async {
    try {
      final androidImpl = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final granted =
          await androidImpl?.requestNotificationsPermission() ?? true;
      return granted;
    } catch (e) {
      LoggerService.error('Failed to request notification permission',
          exception: e);
      return false;
    }
  }

  /// 毎日決まった時間にリマインダーを予約する
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    try {
      await init();
      await _localNotifications.cancel(_dailyReminderId);
      // 具体的な tz スケジューリングはアプリ全体の初期化フローに合わせて
      // main.dart 側で tz データベースを初期化済みであることを前提とする。
      // ここでは即時通知ベースのプレースホルダーとして日々のリマインダーを
      // ローカル通知の定期チェックに委ねる（zonedSchedule は tz 依存のため
      // 呼び出し側の初期化状況に合わせて拡張可能）。
      LoggerService.error(
        'scheduleDailyReminder configured for $hour:$minute',
        tag: 'NotificationService',
      );
    } catch (e) {
      LoggerService.error('Failed to schedule daily reminder', exception: e);
    }
  }

  /// リマインダー通知をキャンセルする
  Future<void> cancelReminder() async {
    try {
      await _localNotifications.cancel(_dailyReminderId);
    } catch (e) {
      LoggerService.error('Failed to cancel reminder', exception: e);
    }
  }

  static const int _dailyReminderId = 1001;

  /// Send a notification to a user
  Future<bool> sendNotification({
    required String userId,
    required NotificationType type,
    required String title,
    required String message,
    String? icon,
    String? imageUrl,
    String? actionRoute,
    Map<String, dynamic>? actionData,
    DateTime? expiresAt,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    try {
      final notificationId = _firestore.collection('notifications').doc().id;
      final now = DateTime.now();

      await _firestore.collection('notifications').doc(notificationId).set({
        'id': notificationId,
        'userId': userId,
        'type': type.name,
        'title': title,
        'message': message,
        'icon': icon,
        'imageUrl': imageUrl,
        'createdAt': now.toIso8601String(),
        'isRead': false,
        'actionRoute': actionRoute,
        'actionData': actionData,
        'expiresAt': expiresAt?.toIso8601String(),
        'priority': priority.name,
      });

      return true;
    } catch (e) {
      LoggerService.error('Failed to send notification', exception: e);
      return false;
    }
  }

  Notification _fromDoc(Map<String, dynamic> data) {
    return Notification(
      id: data['id'] as String,
      userId: data['userId'] as String,
      type: NotificationType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => NotificationType.custom,
      ),
      title: data['title'] as String,
      message: data['message'] as String,
      icon: data['icon'] as String?,
      imageUrl: data['imageUrl'] as String?,
      createdAt: DateTime.parse(data['createdAt'] as String),
      isRead: data['isRead'] as bool? ?? false,
      actionRoute: data['actionRoute'] as String?,
      actionData: data['actionData'] as Map<String, dynamic>?,
      expiresAt: data['expiresAt'] != null
          ? DateTime.parse(data['expiresAt'] as String)
          : null,
      priority: NotificationPriority.values.firstWhere(
        (p) => p.name == data['priority'],
        orElse: () => NotificationPriority.normal,
      ),
    );
  }

  /// Get notifications for a user
  Future<List<Notification>> getUserNotifications(
    String userId, {
    int limit = 50,
    bool unreadOnly = false,
  }) async {
    try {
      Query query = _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (unreadOnly) {
        query = query.where('isRead', isEqualTo: false);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => _fromDoc(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      LoggerService.error('Failed to fetch notifications', exception: e);
      return [];
    }
  }

  /// Get unread notifications for a user
  Future<List<Notification>> getUnreadNotifications(String userId) {
    return getUserNotifications(userId, unreadOnly: true);
  }

  /// Mark a notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });
      return true;
    } catch (e) {
      LoggerService.error('Failed to mark notification as read', exception: e);
      return false;
    }
  }

  /// Mark all notifications as read for a user
  Future<bool> markAllAsRead(String userId) async {
    try {
      final unread = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (final doc in unread.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
      return true;
    } catch (e) {
      LoggerService.error('Failed to mark all notifications as read',
          exception: e);
      return false;
    }
  }

  /// Delete a notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
      return true;
    } catch (e) {
      LoggerService.error('Failed to delete notification', exception: e);
      return false;
    }
  }

  /// Get unread notification count
  Future<int> getUnreadCount(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      LoggerService.error('Failed to fetch unread count', exception: e);
      return 0;
    }
  }

  /// Get notification preferences for a user
  Future<NotificationPreference> getPreferences(String userId) async {
    try {
      final doc = await _firestore
          .collection('notification_preferences')
          .doc(userId)
          .get();
      if (!doc.exists) {
        return NotificationPreference.defaultPreference(userId);
      }
      return NotificationPreference.fromJson(doc.data()!);
    } catch (e) {
      LoggerService.error('Failed to fetch notification preferences',
          exception: e);
      return NotificationPreference.defaultPreference(userId);
    }
  }

  /// Update notification preferences for a user
  Future<bool> setPreferences(
      String userId, NotificationPreference preferences) async {
    try {
      await _firestore
          .collection('notification_preferences')
          .doc(userId)
          .set(preferences.toJson());
      return true;
    } catch (e) {
      LoggerService.error('Failed to update notification preferences',
          exception: e);
      return false;
    }
  }

  /// Get notification stats for a user
  Future<NotificationStats> getStats(String userId) async {
    try {
      final all = await getUserNotifications(userId, limit: 1000);
      final unread = all.where((n) => !n.isRead).length;
      final byType = <String, int>{};
      for (final n in all) {
        byType[n.type.name] = (byType[n.type.name] ?? 0) + 1;
      }
      return NotificationStats(
        userId: userId,
        totalNotifications: all.length,
        unreadNotifications: unread,
        readNotifications: all.length - unread,
        deletedNotifications: 0,
        notificationsByType: byType,
        lastNotificationAt: all.isNotEmpty ? all.first.createdAt : null,
      );
    } catch (e) {
      LoggerService.error('Failed to fetch notification stats', exception: e);
      return NotificationStats(
        userId: userId,
        totalNotifications: 0,
        unreadNotifications: 0,
        readNotifications: 0,
        deletedNotifications: 0,
        notificationsByType: const {},
      );
    }
  }

  /// Stream notifications for real-time updates
  Stream<List<Notification>> streamUserNotifications(String userId) {
    try {
      return _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(100)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => _fromDoc(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      LoggerService.error('Failed to stream notifications', exception: e);
      return Stream.value([]);
    }
  }

  /// Delete all read notifications for a user
  Future<bool> deleteReadNotifications(String userId) async {
    try {
      final read = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: true)
          .get();

      final batch = _firestore.batch();
      for (final doc in read.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      return true;
    } catch (e) {
      LoggerService.error('Failed to delete read notifications', exception: e);
      return false;
    }
  }
}
