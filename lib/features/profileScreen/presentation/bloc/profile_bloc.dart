import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';
import 'package:skillwave/features/profileScreen/domin/usecases/get_user_profile_usecase.dart';

part 'profile_events.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase _getUserProfileUseCase;

  ProfileBloc(this._getUserProfileUseCase) : super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
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
}