import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../data/models/post_dto.dart';

abstract class CreatePostEvents extends Equatable {
  const CreatePostEvents();

  @override
  List<Object?> get props => [];
}

class CreatePost extends CreatePostEvents {
  final CreatePostDto dto;
  final List<File>? images;

  const CreatePost(this.dto, {this.images});

  @override
  List<Object?> get props => [dto, images];
}

class ResetCreatePost extends CreatePostEvents {
  const ResetCreatePost();
}
