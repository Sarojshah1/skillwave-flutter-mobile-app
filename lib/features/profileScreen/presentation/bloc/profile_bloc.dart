import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';
import 'package:skillwave/features/profileScreen/domin/usecases/get_user_profile_usecase.dart';
import 'package:skillwave/features/profileScreen/domin/usecases/update_profile_picture_useCase.dart';

part 'profile_events.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateProfilePictureUseCase profilePicture;

  ProfileBloc(this._getUserProfileUseCase,this.profilePicture) : super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateProfilePicture>(_onUpdateProfilePicture);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());

    final result = await _getUserProfileUseCase();

    result.fold(
          (failure) => emit(ProfileError(failure)),
          (user) {

          emit(ProfileLoaded(user!));

      },
    );
  }
  Future<void> _onUpdateProfilePicture(
      UpdateProfilePicture event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileUpdating());
    print("ProfileBloc initialized");
    final result = await profilePicture(event.imageFile);

    result.fold(
          (failure) => emit(ProfileError(failure)),
          (_) async {
        emit(ProfileUpdateSuccess());
        add(LoadUserProfile());
      },
    );
  }
}