import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/auth/domian/entity/login_entity.dart';
import 'package:skillwave/features/auth/domian/entity/sign_up_entity.dart';
import 'package:skillwave/features/auth/domian/usecases/create_user_usecase.dart';
import 'package:skillwave/features/auth/domian/usecases/forget_password_usecase.dart';
import 'package:skillwave/features/auth/domian/usecases/login_usecase.dart';
import 'package:skillwave/features/auth/domian/usecases/send_oto_usecase.dart';
import 'package:skillwave/features/auth/domian/usecases/verify_otp_usecase.dart';

part 'auth_events.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CreateUserUseCase _createUserUseCase;
  final LogInUseCase _logInUseCase;
  final SendOtpUseCase _otpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ForgetPasswordUseCase _forgetPasswordUseCase;

  AuthBloc(
    this._createUserUseCase,
    this._logInUseCase,
    this._otpUseCase,
    this._verifyOtpUseCase,
    this._forgetPasswordUseCase,
  ) : super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<LogInRequested>(_onLogInRequested);
    on<SendOtpEvent>(_onSendOtpEvent);
    on<VerifyOtpEvent>(_onVerifyOtpEvent);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _createUserUseCase.call(
      event.user,
      event.profilePicture,
    );
    emit(
      result.fold(
        (failure) => AuthFailure(message: failure.message),
        (success) => SignupSuccess(isRegistered: success!),
      ),
    );
  }

  Future<void> _onLogInRequested(
    LogInRequested event,
    Emitter<AuthState> emit,
  ) async {
    print("login bloc");
    emit(AuthLoading());
    final result = await _logInUseCase.call(event.entity);
    emit(
      result.fold(
        (failure) => AuthFailure(message: failure.message),
        (success) => LoginSuccess(isAuthenticated: success!),
      ),
    );
  }

  Future<void> _onSendOtpEvent(
    SendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    print("send otp");
    emit(AuthLoading());
    final result = await _otpUseCase.call(event.email);
    emit(
      result.fold(
        (failure) => AuthFailure(message: failure.message),
        (success) => SendOtpState(messgae: success!),
      ),
    );
  }

  Future<void> _onVerifyOtpEvent(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _verifyOtpUseCase.call(event.otp, event.email);
    emit(
      result.fold(
        (failure) => AuthFailure(message: failure.message),
        (success) => VerifyOtpState(messgae: success!),
      ),
    );
  }

  Future<void> _onResetPasswordEvent(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _forgetPasswordUseCase.call(
      event.password,
      event.email,
    );
    emit(
      result.fold(
        (failure) => AuthFailure(message: failure.message),
        (success) => ForgetPasswordState(messgae: success!),
      ),
    );
  }
}
