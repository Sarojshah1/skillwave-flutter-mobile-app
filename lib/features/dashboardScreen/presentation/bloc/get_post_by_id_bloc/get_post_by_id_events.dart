import 'package:equatable/equatable.dart';

abstract class GetPostByIdEvents extends Equatable {
  const GetPostByIdEvents();

  @override
  List<Object?> get props => [];
}

class GetPostById extends GetPostByIdEvents {
  final String id;

  const GetPostById(this.id);

  @override
  List<Object?> get props => [id];
}
