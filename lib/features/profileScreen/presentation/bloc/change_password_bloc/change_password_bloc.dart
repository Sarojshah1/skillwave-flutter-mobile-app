import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/profileScreen/domin/usecases/change_password_usecase.dart';

part 'change_password_events.dart';
part 'change_password_state.dart';

@injectable
class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordBloc(this._changePasswordUseCase)
    : super(ChangePasswordInitial()) {
    on<ChangePasswordRequested>(_onChangePasswordRequested);
  }

  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(ChangePasswordLoading());

    final result = await _changePasswordUseCase(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
      confirmPassword: event.confirmPassword,
    );

    result.fold(
      (failure) => emit(ChangePasswordError(failure)),
      (_) => emit(ChangePasswordSuccess()),
    );
  }
}
