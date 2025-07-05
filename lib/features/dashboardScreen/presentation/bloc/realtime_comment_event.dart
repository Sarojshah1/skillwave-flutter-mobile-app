part of 'realtime_comment_bloc.dart';

abstract class RealtimeCommentEvent extends Equatable {
  const RealtimeCommentEvent();

  @override
  List<Object?> get props => [];
}

class InitializeSocket extends RealtimeCommentEvent {
  final String baseUrl;
  final String? token;

  const InitializeSocket({this.baseUrl = ApiEndpoints.baseUrl, this.token});

  @override
  List<Object?> get props => [baseUrl, token];
}

class JoinPostRoom extends RealtimeCommentEvent {
  final String postId;

  const JoinPostRoom({required this.postId});

  @override
  List<Object> get props => [postId];
}

class LeavePostRoom extends RealtimeCommentEvent {
  final String postId;
  final bool forceLeave;

  const LeavePostRoom({required this.postId, this.forceLeave = false});

  @override
  List<Object?> get props => [postId, forceLeave];
}

class NewCommentReceived extends RealtimeCommentEvent {
  final Map<String, dynamic> data;

  const NewCommentReceived(this.data);

  @override
  List<Object> get props => [data];
}

class NewReplyReceived extends RealtimeCommentEvent {
  final Map<String, dynamic> data;

  const NewReplyReceived(this.data);

  @override
  List<Object> get props => [data];
}

class DisposeSocket extends RealtimeCommentEvent {
  final bool forceDispose;

  const DisposeSocket({this.forceDispose = false});

  @override
  List<Object?> get props => [forceDispose];
}
