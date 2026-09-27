import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 進行中の会話における1ターン分の発言
class ChatTurn {
  final String id;
  final String speaker; // 'PLAYER' or 'NPC'
  final String message;
  final bool? expectedCorrectness;
  final String? feedback;

  const ChatTurn({
    required this.id,
    required this.speaker,
    required this.message,
    this.expectedCorrectness,
    this.feedback,
  });

  ChatTurn copyWith({
    bool? expectedCorrectness,
    String? feedback,
  }) {
    return ChatTurn(
      id: id,
      speaker: speaker,
      message: message,
      expectedCorrectness: expectedCorrectness ?? this.expectedCorrectness,
      feedback: feedback ?? this.feedback,
    );
  }
}

/// 現在進行中の会話の状態
class CurrentConversationState {
  final String? sceneId;
  final String? npcId;
  final String? locationId;
  final List<ChatTurn> conversationHistory;

  const CurrentConversationState({
    this.sceneId,
    this.npcId,
    this.locationId,
    this.conversationHistory = const [],
  });

  CurrentConversationState copyWith({
    String? sceneId,
    String? npcId,
    String? locationId,
    List<ChatTurn>? conversationHistory,
  }) {
    return CurrentConversationState(
      sceneId: sceneId ?? this.sceneId,
      npcId: npcId ?? this.npcId,
      locationId: locationId ?? this.locationId,
      conversationHistory: conversationHistory ?? this.conversationHistory,
    );
  }
}

class CurrentConversationNotifier extends StateNotifier<CurrentConversationState> {
  CurrentConversationNotifier() : super(const CurrentConversationState());

  /// 新しい会話を開始する
  void startConversation({
    required String sceneId,
    required String npcId,
    required String locationId,
  }) {
    state = CurrentConversationState(
      sceneId: sceneId,
      npcId: npcId,
      locationId: locationId,
      conversationHistory: const [],
    );
  }

  /// 発言を追加する
  void addTurn(ChatTurn turn) {
    state = state.copyWith(
      conversationHistory: [...state.conversationHistory, turn],
    );
  }

  /// 会話をリセットする
  void reset() {
    state = const CurrentConversationState();
  }
}

final currentConversationProvider =
    StateNotifierProvider<CurrentConversationNotifier, CurrentConversationState>(
        (ref) {
  return CurrentConversationNotifier();
});
