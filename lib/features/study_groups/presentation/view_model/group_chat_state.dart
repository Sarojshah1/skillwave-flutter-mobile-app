part of 'group_chat_bloc.dart';

abstract class GroupChatState extends Equatable {
  const GroupChatState();
  @override
  List<Object?> get props => [];
}

class GroupChatInitial extends GroupChatState {}

class GroupChatLoading extends GroupChatState {}

class GroupChatLoaded extends GroupChatState {
  final List<GroupMessageEntity> messages;
  const GroupChatLoaded({required this.messages});
  @override
  List<Object?> get props => [messages];
}

class GroupChatError extends GroupChatState {
  final String message;
  const GroupChatError({required this.message});
  @override
  List<Object?> get props => [message];
}
