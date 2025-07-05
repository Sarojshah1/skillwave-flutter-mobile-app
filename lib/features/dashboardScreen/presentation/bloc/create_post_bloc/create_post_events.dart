import 'package:equatable/equatable.dart';
import '../../../data/models/post_dto.dart';

abstract class CreatePostEvents extends Equatable {
  const CreatePostEvents();

  @override
  List<Object?> get props => [];
}

class CreatePost extends CreatePostEvents {
  final CreatePostDto dto;

  const CreatePost(this.dto);

  @override
  List<Object?> get props => [dto];
}
