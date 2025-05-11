import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/auth/domian/entity/login_entity.dart';
import 'package:skillwave/features/auth/domian/entity/sign_up_entity.dart';
import 'package:skillwave/features/auth/domian/usecases/create_user_usecase.dart';
import 'package:skillwave/features/auth/domian/usecases/login_usecase.dart';

part 'auth_events.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CreateUserUseCase _createUserUseCase;
  final LogInUseCase _logInUseCase;

  AuthBloc({
    required CreateUserUseCase createUserUseCase,
    required LogInUseCase logInUseCase,
  })  : _createUserUseCase = createUserUseCase,
        _logInUseCase = logInUseCase,
        super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<LogInRequested>(_onLogInRequested);
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await _createUserUseCase.call(event.user, event.profilePicture);
    emit(result.fold(
          (failure) => AuthFailure(message: failure.message),
          (success) => SignupSuccess(isRegistered: success!),
    ));
  }

  Future<void> _onLogInRequested(
      LogInRequested event,
      Emitter<AuthState> emit,
      ) async {
    print("login bloc");
    emit(AuthLoading());
    final result = await _logInUseCase.call(event.entity);
    emit(result.fold(
          (failure) => AuthFailure(message: failure.message),
          (success) => LoginSuccess(isAuthenticated: success!),
    ));
  }

}
