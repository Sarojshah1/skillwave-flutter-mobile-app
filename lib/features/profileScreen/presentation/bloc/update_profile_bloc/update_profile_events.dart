part of 'update_profile_bloc.dart';

abstract class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileRequested extends UpdateProfileEvent {
  final String name;
  final String email;
  final String bio;

  const UpdateProfileRequested({
    required this.name,
    required this.email,
    required this.bio,
  });

  @override
  List<Object?> get props => [name, email, bio];
}
