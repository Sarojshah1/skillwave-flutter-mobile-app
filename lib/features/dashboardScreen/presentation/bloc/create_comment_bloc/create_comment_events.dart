import 'package:equatable/equatable.dart';
import '../../../data/models/post_dto.dart';

abstract class CreateCommentEvents extends Equatable {
  const CreateCommentEvents();

  @override
  List<Object?> get props => [];
}

class CreateComment extends CreateCommentEvents {
  final String postId;
  final CreateCommentDto dto;

  const CreateComment(this.postId, this.dto);

  @override
  List<Object?> get props => [postId, dto];
}
