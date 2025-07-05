import 'package:equatable/equatable.dart';

abstract class LikePostEvents extends Equatable {
  const LikePostEvents();

  @override
  List<Object?> get props => [];
}

class LikePost extends LikePostEvents {
  final String postId;

  const LikePost(this.postId);

  @override
  List<Object?> get props => [postId];
}
