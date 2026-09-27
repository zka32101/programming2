import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

enum NotificationType {
  challengeStarting,
  challengeEnding,
  challengeCompleted,
  petEvolved,
  videoRecommended,
  friendChallengeInvite,
  friendChallengeCompleted,
  achievementUnlocked,
  dailyQuestReminder,
  streakMilestone,
  levelUp,
  shopItemNew,
  custom,
}

enum NotificationPriority {
  low,
  normal,
  high,
  urgent,
}

@JsonSerializable()
class Notification {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final String? icon;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isRead;
  final String? actionRoute;
  final Map<String, dynamic>? actionData;
  final DateTime? expiresAt;
  final NotificationPriority priority;

  Notification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.icon,
    this.imageUrl,
    required this.createdAt,
    required this.isRead,
    this.actionRoute,
    this.actionData,
    this.expiresAt,
    required this.priority,
  });

  String get typeLabel {
    switch (type) {
      case NotificationType.challengeStarting:
        return 'チャレンジ開始';
      case NotificationType.challengeEnding:
        return 'チャレンジ終了';
      case NotificationType.challengeCompleted:
        return 'チャレンジ完了';
      case NotificationType.petEvolved:
        return 'ペット進化';
      case NotificationType.videoRecommended:
        return 'ビデオ推奨';
      case NotificationType.friendChallengeInvite:
        return 'フレンドチャレンジ招待';
      case NotificationType.friendChallengeCompleted:
        return 'フレンドチャレンジ完了';
      case NotificationType.achievementUnlocked:
        return 'アチーブメント解除';
      case NotificationType.dailyQuestReminder:
        return 'デイリークエスト';
      case NotificationType.streakMilestone:
        return 'ストリークマイルストーン';
      case NotificationType.levelUp:
        return 'レベルアップ';
      case NotificationType.shopItemNew:
        return 'ショップ新商品';
      case NotificationType.custom:
        return 'カスタム';
    }
  }

  String get typeEmoji {
    switch (type) {
      case NotificationType.challengeStarting:
        return '🚀';
      case NotificationType.challengeEnding:
        return '⏰';
      case NotificationType.challengeCompleted:
        return '🎉';
      case NotificationType.petEvolved:
        return '✨';
      case NotificationType.videoRecommended:
        return '🎬';
      case NotificationType.friendChallengeInvite:
        return '👋';
      case NotificationType.friendChallengeCompleted:
        return '🏆';
      case NotificationType.achievementUnlocked:
        return '🏅';
      case NotificationType.dailyQuestReminder:
        return '📋';
      case NotificationType.streakMilestone:
        return '🔥';
      case NotificationType.levelUp:
        return '⭐';
      case NotificationType.shopItemNew:
        return '🛍️';
      case NotificationType.custom:
        return '📢';
    }
  }

  String get priorityLabel {
    switch (priority) {
      case NotificationPriority.low:
        return '低';
      case NotificationPriority.normal:
        return '通常';
      case NotificationPriority.high:
        return '高';
      case NotificationPriority.urgent:
        return '緊急';
    }
  }

  Notification copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? message,
    String? icon,
    String? imageUrl,
    DateTime? createdAt,
    bool? isRead,
    String? actionRoute,
    Map<String, dynamic>? actionData,
    DateTime? expiresAt,
    NotificationPriority? priority,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
      actionData: actionData ?? this.actionData,
      expiresAt: expiresAt ?? this.expiresAt,
      priority: priority ?? this.priority,
    );
  }

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}

@JsonSerializable()
class NotificationPreference {
  final String userId;
  final bool enableChallengeReminders;
  final bool enablePetNotifications;
  final bool enableVideoRecommendations;
  final bool enableFriendChallenges;
  final bool enableAchievements;
  final bool enableDailyQuests;
  final bool enableStreakMilestones;
  final bool enableShopUpdates;
  final bool enablePushNotifications;
  final bool enableEmailNotifications;
  final bool enableSoundNotifications;
  final bool enableVibrationNotifications;
  final String? quietHoursStartTime;
  final String? quietHoursEndTime;
  final DateTime lastUpdatedAt;

  NotificationPreference({
    required this.userId,
    required this.enableChallengeReminders,
    required this.enablePetNotifications,
    required this.enableVideoRecommendations,
    required this.enableFriendChallenges,
    required this.enableAchievements,
    required this.enableDailyQuests,
    required this.enableStreakMilestones,
    required this.enableShopUpdates,
    required this.enablePushNotifications,
    required this.enableEmailNotifications,
    required this.enableSoundNotifications,
    required this.enableVibrationNotifications,
    this.quietHoursStartTime,
    this.quietHoursEndTime,
    required this.lastUpdatedAt,
  });

  bool isInQuietHours() {
    if (quietHoursStartTime == null || quietHoursEndTime == null) {
      return false;
    }
    final now = TimeOfDay.now();
    final parts = quietHoursStartTime!.split(':');
    final startHour = int.parse(parts[0]);
    final startMinute = int.parse(parts[1]);
    final start = TimeOfDay(hour: startHour, minute: startMinute);

    final endParts = quietHoursEndTime!.split(':');
    final endHour = int.parse(endParts[0]);
    final endMinute = int.parse(endParts[1]);
    final end = TimeOfDay(hour: endHour, minute: endMinute);

    if (start.hour < end.hour) {
      return now.hour >= start.hour && now.hour < end.hour;
    } else {
      return now.hour >= start.hour || now.hour < end.hour;
    }
  }

  NotificationPreference copyWith({
    String? userId,
    bool? enableChallengeReminders,
    bool? enablePetNotifications,
    bool? enableVideoRecommendations,
    bool? enableFriendChallenges,
    bool? enableAchievements,
    bool? enableDailyQuests,
    bool? enableStreakMilestones,
    bool? enableShopUpdates,
    bool? enablePushNotifications,
    bool? enableEmailNotifications,
    bool? enableSoundNotifications,
    bool? enableVibrationNotifications,
    String? quietHoursStartTime,
    String? quietHoursEndTime,
    DateTime? lastUpdatedAt,
  }) {
    return NotificationPreference(
      userId: userId ?? this.userId,
      enableChallengeReminders:
          enableChallengeReminders ?? this.enableChallengeReminders,
      enablePetNotifications:
          enablePetNotifications ?? this.enablePetNotifications,
      enableVideoRecommendations:
          enableVideoRecommendations ?? this.enableVideoRecommendations,
      enableFriendChallenges:
          enableFriendChallenges ?? this.enableFriendChallenges,
      enableAchievements: enableAchievements ?? this.enableAchievements,
      enableDailyQuests: enableDailyQuests ?? this.enableDailyQuests,
      enableStreakMilestones:
          enableStreakMilestones ?? this.enableStreakMilestones,
      enableShopUpdates: enableShopUpdates ?? this.enableShopUpdates,
      enablePushNotifications:
          enablePushNotifications ?? this.enablePushNotifications,
      enableEmailNotifications:
          enableEmailNotifications ?? this.enableEmailNotifications,
      enableSoundNotifications:
          enableSoundNotifications ?? this.enableSoundNotifications,
      enableVibrationNotifications:
          enableVibrationNotifications ?? this.enableVibrationNotifications,
      quietHoursStartTime: quietHoursStartTime ?? this.quietHoursStartTime,
      quietHoursEndTime: quietHoursEndTime ?? this.quietHoursEndTime,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  factory NotificationPreference.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferenceFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationPreferenceToJson(this);

  static NotificationPreference defaultPreference(String userId) {
    return NotificationPreference(
      userId: userId,
      enableChallengeReminders: true,
      enablePetNotifications: true,
      enableVideoRecommendations: true,
      enableFriendChallenges: true,
      enableAchievements: true,
      enableDailyQuests: true,
      enableStreakMilestones: true,
      enableShopUpdates: true,
      enablePushNotifications: true,
      enableEmailNotifications: false,
      enableSoundNotifications: true,
      enableVibrationNotifications: true,
      quietHoursStartTime: '22:00',
      quietHoursEndTime: '08:00',
      lastUpdatedAt: DateTime.now(),
    );
  }
}

@JsonSerializable()
class NotificationStats {
  final String userId;
  final int totalNotifications;
  final int unreadNotifications;
  final int readNotifications;
  final int deletedNotifications;
  final Map<String, int> notificationsByType;
  final DateTime? lastNotificationAt;

  NotificationStats({
    required this.userId,
    required this.totalNotifications,
    required this.unreadNotifications,
    required this.readNotifications,
    required this.deletedNotifications,
    required this.notificationsByType,
    this.lastNotificationAt,
  });

  factory NotificationStats.fromJson(Map<String, dynamic> json) =>
      _$NotificationStatsFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationStatsToJson(this);
}

/// 通知設定（ローカル保存用、SharedPreferences で永続化）
class NotificationSettings {
  final bool dailyRemindersEnabled;
  final int dailyReminderHour;
  final bool streakRemindersEnabled;
  final int streakReminderHour;
  final bool achievementNotifications;
  final bool friendNotifications;
  final bool promotionalNotifications;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final DateTime lastUpdated;

  NotificationSettings({
    this.dailyRemindersEnabled = true,
    this.dailyReminderHour = 18,
    this.streakRemindersEnabled = true,
    this.streakReminderHour = 20,
    this.achievementNotifications = true,
    this.friendNotifications = true,
    this.promotionalNotifications = false,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    required this.lastUpdated,
  });

  NotificationSettings copyWith({
    bool? dailyRemindersEnabled,
    int? dailyReminderHour,
    bool? streakRemindersEnabled,
    int? streakReminderHour,
    bool? achievementNotifications,
    bool? friendNotifications,
    bool? promotionalNotifications,
    bool? soundEnabled,
    bool? vibrationEnabled,
    DateTime? lastUpdated,
  }) {
    return NotificationSettings(
      dailyRemindersEnabled:
          dailyRemindersEnabled ?? this.dailyRemindersEnabled,
      dailyReminderHour: dailyReminderHour ?? this.dailyReminderHour,
      streakRemindersEnabled:
          streakRemindersEnabled ?? this.streakRemindersEnabled,
      streakReminderHour: streakReminderHour ?? this.streakReminderHour,
      achievementNotifications:
          achievementNotifications ?? this.achievementNotifications,
      friendNotifications: friendNotifications ?? this.friendNotifications,
      promotionalNotifications:
          promotionalNotifications ?? this.promotionalNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      dailyRemindersEnabled: json['dailyRemindersEnabled'] as bool? ?? true,
      dailyReminderHour: json['dailyReminderHour'] as int? ?? 18,
      streakRemindersEnabled: json['streakRemindersEnabled'] as bool? ?? true,
      streakReminderHour: json['streakReminderHour'] as int? ?? 20,
      achievementNotifications:
          json['achievementNotifications'] as bool? ?? true,
      friendNotifications: json['friendNotifications'] as bool? ?? true,
      promotionalNotifications:
          json['promotionalNotifications'] as bool? ?? false,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'dailyRemindersEnabled': dailyRemindersEnabled,
        'dailyReminderHour': dailyReminderHour,
        'streakRemindersEnabled': streakRemindersEnabled,
        'streakReminderHour': streakReminderHour,
        'achievementNotifications': achievementNotifications,
        'friendNotifications': friendNotifications,
        'promotionalNotifications': promotionalNotifications,
        'soundEnabled': soundEnabled,
        'vibrationEnabled': vibrationEnabled,
        'lastUpdated': lastUpdated.toIso8601String(),
      };
}

/// 通知履歴の1件（ローカル保存用、SharedPreferences で永続化）
class NotificationRecord {
  final String notificationId;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  NotificationRecord({
    required this.notificationId,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationRecord copyWith({
    String? notificationId,
    NotificationType? type,
    String? title,
    String? message,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationRecord(
      notificationId: notificationId ?? this.notificationId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  factory NotificationRecord.fromJson(Map<String, dynamic> json) {
    return NotificationRecord(
      notificationId: json['notificationId'] as String,
      type: NotificationType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => NotificationType.custom,
      ),
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'notificationId': notificationId,
        'type': type.name,
        'title': title,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
        'isRead': isRead,
      };
}
