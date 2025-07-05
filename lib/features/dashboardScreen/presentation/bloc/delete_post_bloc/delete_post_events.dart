import 'package:equatable/equatable.dart';

abstract class DeletePostEvents extends Equatable {
  const DeletePostEvents();

  @override
  List<Object?> get props => [];
}

class DeletePost extends DeletePostEvents {
  final String id;

  const DeletePost(this.id);

  @override
  List<Object?> get props => [id];
}
