part of 'realtime_comment_bloc.dart';

abstract class RealtimeCommentState extends Equatable {
  const RealtimeCommentState();

  @override
  List<Object?> get props => [];
}

class RealtimeCommentInitial extends RealtimeCommentState {}

class RealtimeCommentConnected extends RealtimeCommentState {}

class RealtimeCommentJoinedRoom extends RealtimeCommentState {
  final String postId;

  const RealtimeCommentJoinedRoom(this.postId);

  @override
  List<Object> get props => [postId];
}

class RealtimeCommentLeftRoom extends RealtimeCommentState {
  final String postId;

  const RealtimeCommentLeftRoom(this.postId);

  @override
  List<Object> get props => [postId];
}

class RealtimeCommentNewComment extends RealtimeCommentState {
  final Map<String, dynamic> data;

  const RealtimeCommentNewComment(this.data);

  @override
  List<Object> get props => [data];
}

class RealtimeCommentNewReply extends RealtimeCommentState {
  final Map<String, dynamic> data;

  const RealtimeCommentNewReply(this.data);

  @override
  List<Object> get props => [data];
}

class RealtimeCommentError extends RealtimeCommentState {
  final String message;

  const RealtimeCommentError(this.message);

  @override
  List<Object> get props => [message];
}

class RealtimeCommentDisposed extends RealtimeCommentState {}
