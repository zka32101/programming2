import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/challenge_model.dart';
import '../services/challenge_service.dart';

// Service provider
final challengeServiceProvider = Provider((ref) {
  return ChallengeService();
});

// Active challenges provider
final activeChallengesProvider = FutureProvider<List<SocialChallenge>>((ref) async {
  final service = ref.watch(challengeServiceProvider);
  return service.getActiveChallenges();
});

// User created challenges provider
final userCreatedChallengesProvider =
    FutureProvider.family<List<SocialChallenge>, String>((ref, userId) async {
  final service = ref.watch(challengeServiceProvider);
  return service.getUserCreatedChallenges(userId);
});

// User joined challenges provider
final userJoinedChallengesProvider =
    FutureProvider.family<List<SocialChallenge>, String>((ref, userId) async {
  final service = ref.watch(challengeServiceProvider);
  return service.getUserJoinedChallenges(userId);
});

// Challenge by type provider
final challengesByTypeProvider =
    FutureProvider.family<List<SocialChallenge>, ChallengeType>(
  (ref, type) async {
    final service = ref.watch(challengeServiceProvider);
    return service.getChallengesByType(type);
  },
);

// Single challenge provider
final challengeProvider =
    FutureProvider.family<SocialChallenge, String>((ref, challengeId) async {
  final service = ref.watch(challengeServiceProvider);
  return service.getChallengeById(challengeId);
});

// Challenge invitations provider
final challengeInvitationsProvider =
    FutureProvider.family<List<ChallengeInvitation>, String>((ref, userId) async {
  final service = ref.watch(challengeServiceProvider);
  return service.getChallengeInvitations(userId);
});

// Challenge statistics provider
final challengeStatsProvider =
    FutureProvider.family<ChallengeStats, String>((ref, userId) async {
  final service = ref.watch(challengeServiceProvider);
  return service.getUserChallengeStats(userId);
});

// Search challenges provider
final searchChallengesProvider =
    FutureProvider.family<List<SocialChallenge>, String>(
  (ref, query) async {
    if (query.isEmpty) return [];
    final service = ref.watch(challengeServiceProvider);
    return service.searchChallenges(query);
  },
);

// Create challenge action
class CreateChallengeParams {
  final String title;
  final String description;
  final ChallengeType type;
  final ChallengeGoalMetric goalMetric;
  final int goalValue;
  final DateTime startDate;
  final DateTime endDate;
  final int maxParticipants;
  final bool isPublic;
  final int? firstPlacePrize;
  final int? secondPlacePrize;
  final int? thirdPlacePrize;
  final List<String>? tags;

  CreateChallengeParams({
    required this.title,
    required this.description,
    required this.type,
    required this.goalMetric,
    required this.goalValue,
    required this.startDate,
    required this.endDate,
    required this.maxParticipants,
    required this.isPublic,
    this.firstPlacePrize,
    this.secondPlacePrize,
    this.thirdPlacePrize,
    this.tags,
  });
}

final createChallengeActionProvider =
    FutureProvider.family<SocialChallenge, CreateChallengeParams>(
  (ref, params) async {
    final service = ref.watch(challengeServiceProvider);
    final challenge = SocialChallenge(
      id: '', // Will be set by service
      creatorId: '', // TODO: Get from auth
      creatorName: '', // TODO: Get from user profile
      creatorAvatar: '', // TODO: Get from user profile
      title: params.title,
      description: params.description,
      type: params.type,
      status: ChallengeStatus.active,
      goalMetric: params.goalMetric,
      goalValue: params.goalValue,
      startDate: params.startDate,
      endDate: params.endDate,
      createdAt: DateTime.now(),
      maxParticipants: params.maxParticipants,
      currentParticipants: 1, // Creator is participant
      isPublic: params.isPublic,
      invitedUserIds: [],
      participants: {},
      firstPlacePrize: params.firstPlacePrize,
      secondPlacePrize: params.secondPlacePrize,
      thirdPlacePrize: params.thirdPlacePrize,
      tags: params.tags,
    );

    final created = await service.createChallenge(challenge);
    ref.refresh(activeChallengesProvider);
    return created;
  },
);

// Join challenge action
class JoinChallengeParams {
  final String challengeId;
  final String userId;
  final String userName;
  final String userAvatar;

  JoinChallengeParams({
    required this.challengeId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
  });
}

final joinChallengeActionProvider =
    FutureProvider.family<ChallengeParticipation, JoinChallengeParams>(
  (ref, params) async {
    final service = ref.watch(challengeServiceProvider);
    final participation = await service.joinChallenge(
      params.challengeId,
      params.userId,
      params.userName,
      params.userAvatar,
    );
    
    ref.refresh(activeChallengesProvider);
    ref.refresh(challengeProvider(params.challengeId));
    ref.refresh(userJoinedChallengesProvider(params.userId));
    
    return participation;
  },
);

// Complete challenge action
class CompleteChallengeParams {
  final String challengeId;
  final String userId;
  final int finalScore;
  final int xpEarned;
  final int coinsEarned;

  CompleteChallengeParams({
    required this.challengeId,
    required this.userId,
    required this.finalScore,
    required this.xpEarned,
    required this.coinsEarned,
  });
}

final completeChallengeActionProvider =
    FutureProvider.family<ChallengeResult, CompleteChallengeParams>(
  (ref, params) async {
    final service = ref.watch(challengeServiceProvider);
    final result = await service.completeChallenge(
      params.challengeId,
      params.userId,
      params.finalScore,
      params.xpEarned,
      params.coinsEarned,
    );
    
    ref.refresh(challengeProvider(params.challengeId));
    ref.refresh(challengeStatsProvider(params.userId));
    
    return result;
  },
);

// Invite to challenge action
class InviteToChallengeParams {
  final String challengeId;
  final List<String> userIds;
  final String inviterName;

  InviteToChallengeParams({
    required this.challengeId,
    required this.userIds,
    required this.inviterName,
  });
}

final inviteToChallengeActionProvider =
    FutureProvider.family<void, InviteToChallengeParams>(
  (ref, params) async {
    final service = ref.watch(challengeServiceProvider);
    await service.inviteUsersToChallenge(
      params.challengeId,
      params.userIds,
      params.inviterName,
    );
    
    ref.refresh(challengeProvider(params.challengeId));
  },
);

// Accept invitation action
class AcceptInvitationParams {
  final String invitationId;
  final String challengeId;
  final String userId;

  AcceptInvitationParams({
    required this.invitationId,
    required this.challengeId,
    required this.userId,
  });
}

final acceptChallengeInvitationActionProvider =
    FutureProvider.family<void, AcceptInvitationParams>(
  (ref, params) async {
    final service = ref.watch(challengeServiceProvider);
    await service.acceptChallengeInvitation(
      params.invitationId,
      params.challengeId,
      params.userId,
    );
    
    ref.refresh(challengeInvitationsProvider(params.userId));
    ref.refresh(userJoinedChallengesProvider(params.userId));
  },
);

// Challenge search query state
final challengeSearchQueryProvider = StateProvider<String>((ref) {
  return '';
});

// Challenge filter state
final challengeTypeFilterProvider = StateProvider<ChallengeType?>((ref) {
  return null;
});

// Challenge sort state
enum ChallengeSortBy { newest, mostPopular, endingSoon }

final challengeSortProvider = StateProvider<ChallengeSortBy>((ref) {
  return ChallengeSortBy.newest;
});

// ==================== フレンドチャレンジ（1対1） ====================

/// ユーザーが参加しているフレンドチャレンジ（1対1）
final userFriendChallengesProvider =
    FutureProvider.family<List<SocialChallenge>, String>((ref, userId) async {
  final service = ref.watch(challengeServiceProvider);
  final created = await service.getUserCreatedChallenges(userId);
  final joined = await service.getUserJoinedChallenges(userId);
  return [
    ...created.where((c) => c.type == ChallengeType.individual),
    ...joined.where((c) => c.type == ChallengeType.individual),
  ];
});

class CreateFriendChallengeParams {
  final String userId;
  final String friendId;
  final String description;
  final int targetValue;

  CreateFriendChallengeParams({
    required this.userId,
    required this.friendId,
    required this.description,
    required this.targetValue,
  });
}

final createFriendChallengeActionProvider =
    FutureProvider.family<SocialChallenge, CreateFriendChallengeParams>(
  (ref, params) async {
    final now = DateTime.now();
    final challenge = SocialChallenge(
      id: 'friend_challenge_${now.millisecondsSinceEpoch}',
      creatorId: params.userId,
      creatorName: params.userId,
      creatorAvatar: '🧒',
      title: params.description,
      description: params.description,
      type: ChallengeType.individual,
      status: ChallengeStatus.active,
      goalMetric: ChallengeGoalMetric.totalScore,
      goalValue: params.targetValue,
      startDate: now,
      endDate: now.add(const Duration(days: 7)),
      createdAt: now,
      maxParticipants: 2,
      currentParticipants: 2,
      isPublic: false,
      invitedUserIds: [params.friendId],
      participants: {params.userId: 0, params.friendId: 0},
    );
    ref.read(_localChallengesProvider.notifier).add(challenge);
    return challenge;
  },
);

/// ローカルに保持しているフレンドチャレンジ一覧（作成直後の即時反映用）
final _localChallengesProvider =
    StateNotifierProvider<_LocalChallengesNotifier, List<SocialChallenge>>(
        (ref) {
  return _LocalChallengesNotifier();
});

class _LocalChallengesNotifier extends StateNotifier<List<SocialChallenge>> {
  _LocalChallengesNotifier() : super([]);

  void add(SocialChallenge challenge) {
    state = [...state, challenge];
  }

  void update(String challengeId, SocialChallenge Function(SocialChallenge) updater) {
    state = state
        .map((c) => c.id == challengeId ? updater(c) : c)
        .toList();
  }
}

class UpdateFriendChallengeProgressParams {
  final String challengeId;
  final String userId;
  final int progress;

  UpdateFriendChallengeProgressParams({
    required this.challengeId,
    required this.userId,
    required this.progress,
  });
}

final updateFriendChallengeProgressActionProvider =
    FutureProvider.family<void, UpdateFriendChallengeProgressParams>(
  (ref, params) async {
    ref.read(_localChallengesProvider.notifier).update(params.challengeId, (c) {
      final updated = Map<String, int>.from(c.participants);
      updated[params.userId] = params.progress;
      return c.copyWith(participants: updated);
    });
    ref.read(userChallengeProgressProvider('${params.userId}:${params.challengeId}'));
  },
);

// ==================== チャレンジ進捗・ランキング（共通） ====================

class UserChallengeProgress {
  final String userId;
  final String challengeId;
  final int progress;
  final bool isCompleted;
  final DateTime joinedAt;
  final List<String> earnedRewardIds;

  UserChallengeProgress({
    required this.userId,
    required this.challengeId,
    required this.progress,
    this.isCompleted = false,
    required this.joinedAt,
    this.earnedRewardIds = const [],
  });

  UserChallengeProgress copyWith({
    int? progress,
    bool? isCompleted,
    List<String>? earnedRewardIds,
  }) {
    return UserChallengeProgress(
      userId: userId,
      challengeId: challengeId,
      progress: progress ?? this.progress,
      isCompleted: isCompleted ?? this.isCompleted,
      joinedAt: joinedAt,
      earnedRewardIds: earnedRewardIds ?? this.earnedRewardIds,
    );
  }
}

final _userChallengeProgressStore =
    StateNotifierProvider<_UserChallengeProgressNotifier, Map<String, UserChallengeProgress>>(
        (ref) {
  return _UserChallengeProgressNotifier();
});

class _UserChallengeProgressNotifier
    extends StateNotifier<Map<String, UserChallengeProgress>> {
  _UserChallengeProgressNotifier() : super({});

  void setProgress(String key, int progress) {
    final parts = key.split(':');
    final existing = state[key];
    state = {
      ...state,
      key: (existing ?? UserChallengeProgress(
        userId: parts[0],
        challengeId: parts.length > 1 ? parts[1] : '',
        progress: 0,
        joinedAt: DateTime.now(),
      ))
          .copyWith(progress: progress),
    };
  }

  void claimRewards(String key) {
    final existing = state[key];
    if (existing == null) return;
    state = {
      ...state,
      key: existing.copyWith(isCompleted: true),
    };
  }
}

/// "userId:challengeId" 形式のキーでユーザーの進捗を取得
final userChallengeProgressProvider =
    FutureProvider.family<UserChallengeProgress?, String>((ref, key) async {
  final store = ref.watch(_userChallengeProgressStore);
  final parts = key.split(':');
  return store[key] ??
      UserChallengeProgress(
        userId: parts[0],
        challengeId: parts.length > 1 ? parts[1] : '',
        progress: 0,
        joinedAt: DateTime.now(),
      );
});

/// "userId:challengeId" 形式のキーでユーザーの順位を取得
final userChallengeRankProvider =
    FutureProvider.family<int?, String>((ref, key) async {
  final parts = key.split(':');
  if (parts.length < 2) return null;
  final challengeId = parts[1];
  final challenge = await ref.watch(challengeProvider(challengeId).future);
  return challenge?.getUserRank(parts[0]);
});

/// チャレンジのリーダーボード（参加者のスコア降順）
final challengeLeaderboardProvider =
    FutureProvider.family<List<MapEntry<String, int>>, String>(
        (ref, challengeId) async {
  final challenge = await ref.watch(challengeProvider(challengeId).future);
  return challenge?.getTopParticipants(limit: 50) ?? [];
});

/// 進捗更新アクション（フレンドチャレンジ以外の一般チャレンジ用）
class UpdateChallengeProgressParams {
  final String userId;
  final String challengeId;
  final int progress;

  UpdateChallengeProgressParams({
    required this.userId,
    required this.challengeId,
    required this.progress,
  });
}

final updateChallengeProgressActionProvider =
    FutureProvider.family<void, UpdateChallengeProgressParams>(
  (ref, params) async {
    ref
        .read(_userChallengeProgressStore.notifier)
        .setProgress('${params.userId}:${params.challengeId}', params.progress);
    ref.invalidate(
        userChallengeProgressProvider('${params.userId}:${params.challengeId}'));
  },
);

/// 報酬受け取りアクション（"userId:challengeId" 形式のキー）
final claimRewardsActionProvider =
    FutureProvider.family<void, String>((ref, key) async {
  ref.read(_userChallengeProgressStore.notifier).claimRewards(key);
  ref.invalidate(userChallengeProgressProvider(key));
});
