import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/config/di/di.container.dart';
import 'package:skillwave/cores/services/socket_service.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';
import 'package:skillwave/features/dashboardScreen/presentation/providers/comment_provider.dart';

part 'realtime_comment_event.dart';
part 'realtime_comment_state.dart';

@injectable
class RealtimeCommentBloc
    extends Bloc<RealtimeCommentEvent, RealtimeCommentState> {
  final SocketService _socketService = getIt<SocketService>();
  final Logger _logger = Logger();
  StreamSubscription<Map<String, dynamic>>? _commentSubscription;
  StreamSubscription<Map<String, dynamic>>? _replySubscription;

  // Track joined post rooms
  final Set<String> joinedRooms = <String>{};

  // Global comment provider
  final CommentProvider _commentProvider = CommentProvider();

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
      // Only initialize if not already connected
      if (!_socketService.isConnected) {
        _socketService.initializeSocket(event.baseUrl, event.token);
      }

      // Listen to real-time streams
      _commentSubscription?.cancel(); // Cancel existing subscriptions
      _commentSubscription = _socketService.newCommentStream.listen(
        (data) => add(NewCommentReceived(data)),
      );

      _replySubscription?.cancel(); // Cancel existing subscriptions
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
        joinedRooms.add(event.postId);
        _logger.i(
          'Joined post room: ${event.postId}. Total rooms: ${joinedRooms.length}',
        );
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
      // Only leave if explicitly requested (not on widget dispose)
      if (_socketService.isConnected && event.forceLeave) {
        _socketService.leavePostRoom(event.postId);
        joinedRooms.remove(event.postId);
        emit(RealtimeCommentLeftRoom(event.postId));
        _logger.i('Left post room: ${event.postId}');
      } else {
        _logger.w(
          'Socket not connected or force leave not requested, skipping leave post room',
        );
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
    final commentData = event.data;
    _logger.i('💬 New comment received: $commentData');

    // Extract post ID from comment data
    final postId =
        commentData['postId'] ?? commentData['post_id'] ?? commentData['post'];

    if (postId != null) {
      // Update global comment state
      _updateGlobalCommentState(postId, commentData);

      // Emit the new comment for all listeners to handle
      emit(RealtimeCommentNewComment(event.data));
    }
  }

  void _onNewReplyReceived(
    NewReplyReceived event,
    Emitter<RealtimeCommentState> emit,
  ) {
    final replyData = event.data;
    _logger.i('💬 New reply received: $replyData');

    // Extract post ID from reply data
    final postId =
        replyData['postId'] ?? replyData['post_id'] ?? replyData['post'];

    if (postId != null) {
      // Update global comment state
      _updateGlobalReplyState(postId, replyData);

      // Emit the new reply for all listeners to handle
      emit(RealtimeCommentNewReply(event.data));
    }
  }

  void _updateGlobalCommentState(
    String postId,
    Map<String, dynamic> commentData,
  ) {
    final comment = commentData['comment'] ?? commentData;
    if (comment != null) {
      // Create CommentEntity from comment data
      final newComment = _createCommentEntity(comment);

      // Update global state - this will add to ALL posts
      _commentProvider.addComment(postId, newComment);

      _logger.i('✅ Updated global comment state for ALL posts');
    }
  }

  void _updateGlobalReplyState(String postId, Map<String, dynamic> replyData) {
    final reply = replyData['reply'] ?? replyData;
    final commentId = replyData['commentId'] ?? replyData['comment_id'];

    if (reply != null && commentId != null) {
      // Create ReplyEntity from reply data
      final newReply = _createReplyEntity(reply);

      // Update global state using comment provider
      _commentProvider.addReply(postId, commentId, newReply);

      _logger.i(
        '✅ Updated global reply state for ALL posts, comment $commentId',
      );
    }
  }

  CommentEntity _createCommentEntity(Map<String, dynamic> comment) {
    return CommentEntity(
      id: comment['_id'] ?? comment['id'] ?? '',
      content: comment['content'] ?? '',
      user: UserEntity(
        id: comment['user_id']?['_id'] ?? comment['user']?['_id'] ?? '',
        name:
            comment['user_id']?['name'] ??
            comment['user']?['name'] ??
            'Unknown User',
        email: comment['user_id']?['email'] ?? comment['user']?['email'] ?? '',
        profilePicture:
            comment['user_id']?['profile_picture'] ??
            comment['user']?['profile_picture'] ??
            '',
        bio: comment['user_id']?['bio'] ?? comment['user']?['bio'] ?? '',
        role:
            comment['user_id']?['role'] ??
            comment['user']?['role'] ??
            'student',
        searchHistory: [],
        enrolledCourses: [],
        payments: [],
        blogPosts: [],
        quizResults: [],
        reviews: [],
        certificates: [],
        createdAt:
            DateTime.tryParse(
              comment['user_id']?['created_at'] ??
                  comment['user']?['created_at'] ??
                  '',
            ) ??
            DateTime.now(),
      ),
      createdAt:
          DateTime.tryParse(comment['created_at'] ?? '') ?? DateTime.now(),
      replies: [],
    );
  }

  ReplyEntity _createReplyEntity(Map<String, dynamic> reply) {
    return ReplyEntity(
      id: reply['_id'] ?? reply['id'] ?? '',
      content: reply['content'] ?? '',
      user: UserEntity(
        id: reply['user_id']?['_id'] ?? reply['user']?['_id'] ?? '',
        name:
            reply['user_id']?['name'] ??
            reply['user']?['name'] ??
            'Unknown User',
        email: reply['user_id']?['email'] ?? reply['user']?['email'] ?? '',
        profilePicture:
            reply['user_id']?['profile_picture'] ??
            reply['user']?['profile_picture'] ??
            '',
        bio: reply['user_id']?['bio'] ?? reply['user']?['bio'] ?? '',
        role: reply['user_id']?['role'] ?? reply['user']?['role'] ?? 'student',
        searchHistory: [],
        enrolledCourses: [],
        payments: [],
        blogPosts: [],
        quizResults: [],
        reviews: [],
        certificates: [],
        createdAt:
            DateTime.tryParse(
              reply['user_id']?['created_at'] ??
                  reply['user']?['created_at'] ??
                  '',
            ) ??
            DateTime.now(),
      ),
      createdAt: DateTime.tryParse(reply['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  void _onDisposeSocket(
    DisposeSocket event,
    Emitter<RealtimeCommentState> emit,
  ) {
    _commentSubscription?.cancel();
    _replySubscription?.cancel();
    // Only dispose if explicitly requested, not on widget disposal
    if (event.forceDispose) {
      _socketService.dispose();
    }
    emit(RealtimeCommentDisposed());
  }

  // Get comments for a specific post from global state
  List<CommentEntity> getCommentsForPost(String postId) {
    return _commentProvider.getComments(postId);
  }

  // Get all active post IDs
  Set<String> get activePostIds => joinedRooms;

  @override
  Future<void> close() {
    _commentSubscription?.cancel();
    _replySubscription?.cancel();
    // Only dispose socket when bloc is actually closed (app termination)
    // Don't dispose on widget disposal to maintain connection
    return super.close();
  }
}
