import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/auth/domian/entity/login_entity.dart';
import 'package:skillwave/features/auth/domian/entity/sign_up_entity.dart';
import 'package:skillwave/features/auth/domian/usecases/create_user_usecase.dart';
import 'package:skillwave/features/auth/domian/usecases/forget_password_usecase.dart';
import 'package:skillwave/features/auth/domian/usecases/login_usecase.dart';
import 'package:skillwave/features/auth/domian/usecases/send_oto_usecase.dart';
import 'package:skillwave/features/auth/domian/usecases/verify_otp_usecase.dart';
import 'package:skillwave/features/auth/presentation/bloc/auth_bloc.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([
  CreateUserUseCase,
  LogInUseCase,
  SendOtpUseCase,
  VerifyOtpUseCase,
  ForgetPasswordUseCase,
])
void main() {
  late AuthBloc authBloc;
  late MockCreateUserUseCase mockCreateUserUseCase;
  late MockLogInUseCase mockLogInUseCase;
  late MockSendOtpUseCase mockSendOtpUseCase;
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockForgetPasswordUseCase mockForgetPasswordUseCase;

  setUp(() {
    mockCreateUserUseCase = MockCreateUserUseCase();
    mockLogInUseCase = MockLogInUseCase();
    mockSendOtpUseCase = MockSendOtpUseCase();
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockForgetPasswordUseCase = MockForgetPasswordUseCase();

    authBloc = AuthBloc(
      mockCreateUserUseCase,
      mockLogInUseCase,
      mockSendOtpUseCase,
      mockVerifyOtpUseCase,
      mockForgetPasswordUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testName = 'Test User';
    const testRole = 'student';
    const testBio = 'Test bio';
    const testOtp = '123456';

    final testSignUpEntity = SignUpEntity(
      name: testName,
      email: testEmail,
      password: testPassword,
      role: testRole,
      bio: testBio,
    );

    final testLoginEntity = LogInEntity(
      email: testEmail,
      password: testPassword,
    );

    test('initial state should be AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    group('SignUpRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, SignupSuccess] when signup is successful',
        build: () {
          when(
            mockCreateUserUseCase.call(testSignUpEntity, null),
          ).thenAnswer((_) async => SkillWaveResponse.success(true));
          return authBloc;
        },
        act: (bloc) => bloc.add(SignUpRequested(user: testSignUpEntity)),
        expect: () => [isA<AuthLoading>(), isA<SignupSuccess>()],
        verify: (_) {
          verify(mockCreateUserUseCase.call(testSignUpEntity, null)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when signup fails',
        build: () {
          when(mockCreateUserUseCase.call(testSignUpEntity, null)).thenAnswer(
            (_) async =>
                SkillWaveResponse.failure(ApiFailure(message: 'Signup failed')),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(SignUpRequested(user: testSignUpEntity)),
        expect: () => [isA<AuthLoading>(), isA<AuthFailure>()],
        verify: (_) {
          verify(mockCreateUserUseCase.call(testSignUpEntity, null)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, SignupSuccess] when signup with profile picture is successful',
        build: () {
          when(
            mockCreateUserUseCase.call(testSignUpEntity, any),
          ).thenAnswer((_) async => SkillWaveResponse.success(true));
          return authBloc;
        },
        act: (bloc) {
          final testFile = File('test_file.jpg');
          bloc.add(
            SignUpRequested(user: testSignUpEntity, profilePicture: testFile),
          );
        },
        expect: () => [isA<AuthLoading>(), isA<SignupSuccess>()],
        verify: (_) {
          verify(mockCreateUserUseCase.call(testSignUpEntity, any)).called(1);
        },
      );
    });

    group('LogInRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, LoginSuccess] when login is successful',
        build: () {
          when(
            mockLogInUseCase.call(testLoginEntity),
          ).thenAnswer((_) async => SkillWaveResponse.success(true));
          return authBloc;
        },
        act: (bloc) => bloc.add(LogInRequested(entity: testLoginEntity)),
        expect: () => [isA<AuthLoading>(), isA<LoginSuccess>()],
        verify: (_) {
          verify(mockLogInUseCase.call(testLoginEntity)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when login fails',
        build: () {
          when(mockLogInUseCase.call(testLoginEntity)).thenAnswer(
            (_) async => SkillWaveResponse.failure(
              ApiFailure(message: 'Invalid credentials'),
            ),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(LogInRequested(entity: testLoginEntity)),
        expect: () => [isA<AuthLoading>(), isA<AuthFailure>()],
        verify: (_) {
          verify(mockLogInUseCase.call(testLoginEntity)).called(1);
        },
      );
    });

    group('SendOtpEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, SendOtpState] when OTP is sent successfully',
        build: () {
          when(mockSendOtpUseCase.call(testEmail)).thenAnswer(
            (_) async => SkillWaveResponse.success('OTP sent successfully'),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(SendOtpEvent(email: testEmail)),
        expect: () => [isA<AuthLoading>(), isA<SendOtpState>()],
        verify: (_) {
          verify(mockSendOtpUseCase.call(testEmail)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when OTP sending fails',
        build: () {
          when(mockSendOtpUseCase.call(testEmail)).thenAnswer(
            (_) async => SkillWaveResponse.failure(
              ApiFailure(message: 'Failed to send OTP'),
            ),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(SendOtpEvent(email: testEmail)),
        expect: () => [isA<AuthLoading>(), isA<AuthFailure>()],
        verify: (_) {
          verify(mockSendOtpUseCase.call(testEmail)).called(1);
        },
      );
    });

    group('VerifyOtpEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, VerifyOtpState] when OTP verification is successful',
        build: () {
          when(mockVerifyOtpUseCase.call(testOtp, testEmail)).thenAnswer(
            (_) async => SkillWaveResponse.success('OTP verified successfully'),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(VerifyOtpEvent(email: testEmail, otp: testOtp)),
        expect: () => [isA<AuthLoading>(), isA<VerifyOtpState>()],
        verify: (_) {
          verify(mockVerifyOtpUseCase.call(testOtp, testEmail)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when OTP verification fails',
        build: () {
          when(mockVerifyOtpUseCase.call(testOtp, testEmail)).thenAnswer(
            (_) async =>
                SkillWaveResponse.failure(ApiFailure(message: 'Invalid OTP')),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(VerifyOtpEvent(email: testEmail, otp: testOtp)),
        expect: () => [isA<AuthLoading>(), isA<AuthFailure>()],
        verify: (_) {
          verify(mockVerifyOtpUseCase.call(testOtp, testEmail)).called(1);
        },
      );
    });

    group('ResetPasswordEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, ForgetPasswordState] when password reset is successful',
        build: () {
          when(
            mockForgetPasswordUseCase.call(testPassword, testEmail),
          ).thenAnswer(
            (_) async =>
                SkillWaveResponse.success('Password reset successfully'),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          ResetPasswordEvent(email: testEmail, password: testPassword),
        ),
        expect: () => [isA<AuthLoading>(), isA<ForgetPasswordState>()],
        verify: (_) {
          verify(
            mockForgetPasswordUseCase.call(testPassword, testEmail),
          ).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when password reset fails',
        build: () {
          when(
            mockForgetPasswordUseCase.call(testPassword, testEmail),
          ).thenAnswer(
            (_) async => SkillWaveResponse.failure(
              ApiFailure(message: 'Password reset failed'),
            ),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          ResetPasswordEvent(email: testEmail, password: testPassword),
        ),
        expect: () => [isA<AuthLoading>(), isA<AuthFailure>()],
        verify: (_) {
          verify(
            mockForgetPasswordUseCase.call(testPassword, testEmail),
          ).called(1);
        },
      );
    });

    group('State properties', () {
      test('LoginSuccess should have correct isAuthenticated property', () {
        const loginSuccess = LoginSuccess(isAuthenticated: true);
        expect(loginSuccess.isAuthenticated, true);
      });

      test('SignupSuccess should have correct isRegistered property', () {
        const signupSuccess = SignupSuccess(isRegistered: true);
        expect(signupSuccess.isRegistered, true);
      });

      test('SendOtpState should have correct message property', () {
        const sendOtpState = SendOtpState(messgae: 'OTP sent');
        expect(sendOtpState.messgae, 'OTP sent');
      });

      test('VerifyOtpState should have correct message property', () {
        const verifyOtpState = VerifyOtpState(messgae: 'OTP verified');
        expect(verifyOtpState.messgae, 'OTP verified');
      });

      test('ForgetPasswordState should have correct message property', () {
        const forgetPasswordState = ForgetPasswordState(
          messgae: 'Password reset',
        );
        expect(forgetPasswordState.messgae, 'Password reset');
      });

      test('AuthFailure should have correct message property', () {
        const authFailure = AuthFailure(message: 'Error occurred');
        expect(authFailure.message, 'Error occurred');
      });
    });

    group('Event properties', () {
      test('SignUpRequested should have correct properties', () {
        final event = SignUpRequested(user: testSignUpEntity);
        expect(event.user, testSignUpEntity);
        expect(event.profilePicture, null);
      });

      test('LogInRequested should have correct properties', () {
        final event = LogInRequested(entity: testLoginEntity);
        expect(event.entity, testLoginEntity);
      });

      test('SendOtpEvent should have correct properties', () {
        final event = SendOtpEvent(email: testEmail);
        expect(event.email, testEmail);
      });

      test('VerifyOtpEvent should have correct properties', () {
        final event = VerifyOtpEvent(email: testEmail, otp: testOtp);
        expect(event.email, testEmail);
        expect(event.otp, testOtp);
      });

      test('ResetPasswordEvent should have correct properties', () {
        final event = ResetPasswordEvent(
          email: testEmail,
          password: testPassword,
        );
        expect(event.email, testEmail);
        expect(event.password, testPassword);
      });
    });

    group('Equatable implementation', () {
      test('AuthStates should be equal when properties are the same', () {
        const state1 = LoginSuccess(isAuthenticated: true);
        const state2 = LoginSuccess(isAuthenticated: true);
        expect(state1, equals(state2));
      });

      test('AuthStates should not be equal when properties are different', () {
        const state1 = LoginSuccess(isAuthenticated: true);
        const state2 = LoginSuccess(isAuthenticated: false);
        expect(state1, isNot(equals(state2)));
      });

      test('AuthEvents should be equal when properties are the same', () {
        final event1 = LogInRequested(entity: testLoginEntity);
        final event2 = LogInRequested(entity: testLoginEntity);
        expect(event1, equals(event2));
      });

      test('AuthEvents should not be equal when properties are different', () {
        final event1 = LogInRequested(entity: testLoginEntity);
        final event2 = LogInRequested(
          entity: LogInEntity(
            email: 'different@email.com',
            password: 'different',
          ),
        );
        expect(event1, isNot(equals(event2)));
      });
    });
  });
}
