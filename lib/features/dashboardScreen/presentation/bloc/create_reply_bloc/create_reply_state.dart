import 'package:equatable/equatable.dart';

abstract class CreateReplyState extends Equatable {
  const CreateReplyState();

  @override
  List<Object?> get props => [];
}

class CreateReplyInitial extends CreateReplyState {}

class CreateReplyLoading extends CreateReplyState {}

class CreateReplyLoaded extends CreateReplyState {}

class CreateReplyError extends CreateReplyState {
  final String message;

  const CreateReplyError({required this.message});

  @override
  List<Object?> get props => [message];
}
