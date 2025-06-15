part of 'profile_bloc.dart';
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends ProfileEvent {}
class UpdateProfilePicture extends ProfileEvent {
  final File imageFile;

  const UpdateProfilePicture(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}