import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/config/di/di.container.dart';
import 'package:skillwave/cores/services/socket_service.dart';

part 'realtime_comment_event.dart';
part 'realtime_comment_state.dart';

@injectable
class RealtimeCommentBloc
    extends Bloc<RealtimeCommentEvent, RealtimeCommentState> {
  final SocketService _socketService = getIt<SocketService>();
  final Logger _logger = Logger();
  StreamSubscription<Map<String, dynamic>>? _commentSubscription;
  StreamSubscription<Map<String, dynamic>>? _replySubscription;

  RealtimeCommentBloc() : super(RealtimeCommentInitial()) {
    on<InitializeSocket>(_onInitializeSocket);
    on<JoinPostRoom>(_onJoinPostRoom);
    on<LeavePostRoom>(_onLeavePostRoom);
    on<NewCommentReceived>(_onNewCommentReceived);
    on<NewReplyReceived>(_onNewReplyReceived);
    on<DisposeSocket>(_onDisposeSocket);
  }

  void _onInitializeSocket(
    InitializeSocket event,
    Emitter<RealtimeCommentState> emit,
  ) {
    try {
      _socketService.initializeSocket(event.baseUrl, event.token);

      // Listen to real-time streams
      _commentSubscription = _socketService.newCommentStream.listen(
        (data) => add(NewCommentReceived(data)),
      );

      _replySubscription = _socketService.newReplyStream.listen(
        (data) => add(NewReplyReceived(data)),
      );

      emit(RealtimeCommentConnected());
    } catch (e) {
      emit(RealtimeCommentError('Failed to initialize socket: $e'));
    }
  }

  void _onJoinPostRoom(JoinPostRoom event, Emitter<RealtimeCommentState> emit) {
    try {
      // Only try to join if socket is connected
      if (_socketService.isConnected) {
        _socketService.joinPostRoom(event.postId);
        emit(RealtimeCommentJoinedRoom(event.postId));
      } else {
        _logger.w('Socket not connected, skipping join post room');
        emit(RealtimeCommentError('Socket not connected'));
      }
    } catch (e) {
      _logger.e('Failed to join post room: $e');
      emit(RealtimeCommentError('Failed to join post room: $e'));
    }
  }

  void _onLeavePostRoom(
    LeavePostRoom event,
    Emitter<RealtimeCommentState> emit,
  ) {
    try {
      // Only try to leave if socket is connected
      if (_socketService.isConnected) {
        _socketService.leavePostRoom(event.postId);
        emit(RealtimeCommentLeftRoom(event.postId));
      } else {
        _logger.w('Socket not connected, skipping leave post room');
        emit(RealtimeCommentLeftRoom(event.postId));
      }
    } catch (e) {
      _logger.e('Failed to leave post room: $e');
      emit(RealtimeCommentError('Failed to leave post room: $e'));
    }
  }

  void _onNewCommentReceived(
    NewCommentReceived event,
    Emitter<RealtimeCommentState> emit,
  ) {
    emit(RealtimeCommentNewComment(event.data));
  }

  void _onNewReplyReceived(
    NewReplyReceived event,
    Emitter<RealtimeCommentState> emit,
  ) {
    emit(RealtimeCommentNewReply(event.data));
  }

  void _onDisposeSocket(
    DisposeSocket event,
    Emitter<RealtimeCommentState> emit,
  ) {
    _commentSubscription?.cancel();
    _replySubscription?.cancel();
    _socketService.dispose();
    emit(RealtimeCommentDisposed());
  }

  @override
  Future<void> close() {
    _commentSubscription?.cancel();
    _replySubscription?.cancel();
    _socketService.dispose();
    return super.close();
  }
}
