import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skillwave/features/study_groups/domain/entity/group_message_entity.dart';
import 'package:skillwave/features/study_groups/domain/usecases/send_group_message_api_usecase.dart';
import 'package:skillwave/features/study_groups/domain/usecases/get_group_chat_messages_api_usecase.dart';
import 'package:skillwave/features/study_groups/domain/usecases/send_group_message_realtime_usecase.dart';
import 'package:skillwave/features/study_groups/domain/usecases/group_chat_realtime_stream_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/services/socket_service.dart';
import 'package:skillwave/config/di/di.container.dart';
import 'dart:async';

part 'group_chat_event.dart';
part 'group_chat_state.dart';

// Add events for typing indicator
class OtherUserTyping extends GroupChatEvent {
  final String userId;
  const OtherUserTyping(this.userId);
}

class OtherUserStoppedTyping extends GroupChatEvent {
  final String userId;
  const OtherUserStoppedTyping(this.userId);
}

// Add state for typing indicator
class GroupChatTypingState extends GroupChatState {
  final String typingUserId;
  final List<GroupMessageEntity> messages;
  const GroupChatTypingState({
    required this.typingUserId,
    required this.messages,
  });
  @override
  List<Object?> get props => [typingUserId, messages];
}

@injectable
class GroupChatBloc extends Bloc<GroupChatEvent, GroupChatState> {
  final SendGroupMessageApiUseCase sendGroupMessageApiUseCase;
  final GetGroupChatMessagesApiUseCase getGroupChatMessagesApiUseCase;
  final SendGroupMessageRealtimeUseCase sendGroupMessageRealtimeUseCase;
  final GroupChatRealtimeStreamUseCase groupChatRealtimeStreamUseCase;
  final SocketService socketService = getIt<SocketService>();
  String? _currentTypingUserId;
  Timer? _typingTimer;

  GroupChatBloc({
    required this.sendGroupMessageApiUseCase,
    required this.getGroupChatMessagesApiUseCase,
    required this.sendGroupMessageRealtimeUseCase,
    required this.groupChatRealtimeStreamUseCase,
  }) : super(GroupChatInitial()) {
    on<LoadGroupChatMessages>((event, emit) async {
      emit(GroupChatLoading());
      try {
        final messages = await getGroupChatMessagesApiUseCase(event.groupId);
        print('Messages: $messages');
        emit(GroupChatLoaded(messages: messages));
      } catch (e) {
        emit(GroupChatError(message: e.toString()));
      }
    });

    on<SendGroupMessageApi>((event, emit) async {
      try {
        await sendGroupMessageApiUseCase(
          groupId: event.groupId,
          messageContent: event.messageContent,
        );
      } catch (e) {
        emit(GroupChatError(message: e.toString()));
      }
    });

    on<SendGroupMessageRealtime>((event, emit) async {
      try {
        await sendGroupMessageRealtimeUseCase(
          groupId: event.groupId,
          userId: event.userId,
          messageContent: event.messageContent,
          messageType: event.messageType,
        );
      } catch (e) {
        emit(GroupChatError(message: e.toString()));
      }
    });

    on<SubscribeToRealtimeMessages>((event, emit) async {
      await emit.forEach<GroupMessageEntity>(
        groupChatRealtimeStreamUseCase(),
        onData: (message) {
          print('Received real-time message: ${message.messageContent}');
          final currentState = state;
          if (currentState is GroupChatLoaded) {
            final updatedMessages = List<GroupMessageEntity>.from(
              currentState.messages,
            )..add(message);
            return GroupChatLoaded(messages: updatedMessages);
          } else if (currentState is GroupChatTypingState) {
            final updatedMessages = List<GroupMessageEntity>.from(
              currentState.messages,
            )..add(message);
            return GroupChatTypingState(
              typingUserId: currentState.typingUserId,
              messages: updatedMessages,
            );
          } else {
            return GroupChatLoaded(messages: [message]);
          }
        },
        onError: (_, __) => GroupChatError(message: 'Realtime error'),
      );
    });

    // Listen for typing events from socket
    socketService.userTypingUserIdStream.listen((userId) {
      add(OtherUserTyping(userId));
    });
    socketService.userStoppedTypingUserIdStream.listen((userId) {
      add(OtherUserStoppedTyping(userId));
    });

    on<OtherUserTyping>((event, emit) {
      _currentTypingUserId = event.userId;
      final currentState = state;
      if (currentState is GroupChatLoaded) {
        emit(
          GroupChatTypingState(
            typingUserId: event.userId,
            messages: currentState.messages,
          ),
        );
      } else if (currentState is GroupChatTypingState) {
        emit(
          GroupChatTypingState(
            typingUserId: event.userId,
            messages: currentState.messages,
          ),
        );
      }
      // Reset typing timer
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 3), () {
        add(OtherUserStoppedTyping(event.userId));
      });
    });
    on<OtherUserStoppedTyping>((event, emit) {
      _currentTypingUserId = null;
      final currentState = state;
      if (currentState is GroupChatTypingState) {
        emit(GroupChatLoaded(messages: currentState.messages));
      }
    });
  }
}
