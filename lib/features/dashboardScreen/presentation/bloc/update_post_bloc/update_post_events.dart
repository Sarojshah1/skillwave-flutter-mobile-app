import 'package:equatable/equatable.dart';
import '../../../data/models/post_dto.dart';

abstract class UpdatePostEvents extends Equatable {
  const UpdatePostEvents();

  @override
  List<Object?> get props => [];
}

class UpdatePost extends UpdatePostEvents {
  final String id;
  final UpdatePostDto dto;

  const UpdatePost(this.id, this.dto);

  @override
  List<Object?> get props => [id, dto];
}
