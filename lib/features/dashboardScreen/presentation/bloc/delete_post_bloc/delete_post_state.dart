import 'package:equatable/equatable.dart';

abstract class DeletePostState extends Equatable {
  const DeletePostState();

  @override
  List<Object?> get props => [];
}

class DeletePostInitial extends DeletePostState {}

class DeletePostLoading extends DeletePostState {}

class DeletePostLoaded extends DeletePostState {}

class DeletePostError extends DeletePostState {
  final String message;

  const DeletePostError({required this.message});

  @override
  List<Object?> get props => [message];
}
