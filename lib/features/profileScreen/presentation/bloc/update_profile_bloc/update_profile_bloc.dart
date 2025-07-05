import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/profileScreen/domin/usecases/update_profile_usecase.dart';

part 'update_profile_events.dart';
part 'update_profile_state.dart';

@injectable
class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final UpdateProfileUseCase _updateProfileUseCase;

  UpdateProfileBloc(this._updateProfileUseCase)
    : super(UpdateProfileInitial()) {
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<UpdateProfileState> emit,
  ) async {
    emit(UpdateProfileLoading());

    final result = await _updateProfileUseCase(
      name: event.name,
      email: event.email,
      bio: event.bio,
    );

    result.fold(
      (failure) => emit(UpdateProfileError(failure)),
      (_) => emit(UpdateProfileSuccess()),
    );
  }
}
