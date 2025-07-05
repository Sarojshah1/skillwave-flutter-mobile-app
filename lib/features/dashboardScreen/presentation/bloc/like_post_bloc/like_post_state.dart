import 'package:equatable/equatable.dart';

abstract class LikePostState extends Equatable {
  const LikePostState();

  @override
  List<Object?> get props => [];
}

class LikePostInitial extends LikePostState {}

class LikePostLoading extends LikePostState {}

class LikePostLoaded extends LikePostState {}

class LikePostError extends LikePostState {
  final String message;

  const LikePostError({required this.message});

  @override
  List<Object?> get props => [message];
}
