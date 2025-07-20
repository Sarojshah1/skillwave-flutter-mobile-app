part of 'group_chat_bloc.dart';

abstract class GroupChatEvent extends Equatable {
  const GroupChatEvent();
  @override
  List<Object?> get props => [];
}

class LoadGroupChatMessages extends GroupChatEvent {
  final String groupId;
  const LoadGroupChatMessages(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

class SendGroupMessageApi extends GroupChatEvent {
  final String groupId;
  final String messageContent;
  const SendGroupMessageApi({
    required this.groupId,
    required this.messageContent,
  });
  @override
  List<Object?> get props => [groupId, messageContent];
}

class SendGroupMessageRealtime extends GroupChatEvent {
  final String groupId;
  final String userId;
  final String messageContent;
  final String messageType;
  const SendGroupMessageRealtime({
    required this.groupId,
    required this.userId,
    required this.messageContent,
    this.messageType = 'text',
  });
  @override
  List<Object?> get props => [groupId, userId, messageContent, messageType];
}

class SubscribeToRealtimeMessages extends GroupChatEvent {
  const SubscribeToRealtimeMessages();
}
