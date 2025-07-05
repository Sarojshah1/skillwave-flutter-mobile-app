import 'package:equatable/equatable.dart';
import '../../../data/models/post_dto.dart';

abstract class CreateReplyEvents extends Equatable {
  const CreateReplyEvents();

  @override
  List<Object?> get props => [];
}

class CreateReply extends CreateReplyEvents {
  final String postId;
  final String commentId;
  final CreateReplyDto dto;

  const CreateReply(this.postId, this.commentId, this.dto);

  @override
  List<Object?> get props => [postId, commentId, dto];
}
