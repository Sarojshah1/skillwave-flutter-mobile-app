import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';
import 'package:skillwave/features/profileScreen/domin/usecases/get_user_profile_usecase.dart';
import 'package:skillwave/features/profileScreen/domin/usecases/update_profile_picture_useCase.dart';
import 'package:skillwave/features/profileScreen/presentation/bloc/profile_bloc.dart';

import 'profile_bloc_test.mocks.dart';

@GenerateMocks([GetUserProfileUseCase, UpdateProfilePictureUseCase])
void main() {
  late ProfileBloc profileBloc;
  late MockGetUserProfileUseCase mockGetUserProfileUseCase;
  late MockUpdateProfilePictureUseCase mockUpdateProfilePictureUseCase;

  setUp(() {
    mockGetUserProfileUseCase = MockGetUserProfileUseCase();
    mockUpdateProfilePictureUseCase = MockUpdateProfilePictureUseCase();
    profileBloc = ProfileBloc(
      mockGetUserProfileUseCase,
      mockUpdateProfilePictureUseCase,
    );
  });

  tearDown(() {
    profileBloc.close();
  });

  group('ProfileBloc', () {
    final testUser = UserEntity(
      id: 'u1',
      name: 'Test User',
      email: 'test@example.com',
      role: 'student',
      bio: 'Test bio',
      profilePicture: '',
      enrolledCourses: const [],
      certificates: const [],
      createdAt: DateTime(2024, 1, 1),
    );

    test('initial state should be ProfileInitial', () {
      expect(profileBloc.state, isA<ProfileInitial>());
    });

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when LoadUserProfile is successful',
      build: () {
        when(
          mockGetUserProfileUseCase.call(),
        ).thenAnswer((_) async => SkillWaveResponse.success(testUser));
        return profileBloc;
      },
      act: (bloc) => bloc.add(LoadUserProfile()),
      expect: () => [isA<ProfileLoading>(), isA<ProfileLoaded>()],
      verify: (_) {
        verify(mockGetUserProfileUseCase.call()).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileError] when LoadUserProfile fails',
      build: () {
        when(mockGetUserProfileUseCase.call()).thenAnswer(
          (_) async => SkillWaveResponse.failure(ApiFailure(message: 'error')),
        );
        return profileBloc;
      },
      act: (bloc) => bloc.add(LoadUserProfile()),
      expect: () => [isA<ProfileLoading>(), isA<ProfileError>()],
      verify: (_) {
        verify(mockGetUserProfileUseCase.call()).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileUpdating, ProfileUpdateSuccess, ProfileLoading, ProfileLoaded] when UpdateProfilePicture is successful',
      build: () {
        when(
          mockUpdateProfilePictureUseCase.call(any),
        ).thenAnswer((_) async => SkillWaveResponse.success(null));
        when(
          mockGetUserProfileUseCase.call(),
        ).thenAnswer((_) async => SkillWaveResponse.success(testUser));
        return profileBloc;
      },
      act: (bloc) {
        final testFile = File('test_file.jpg');
        bloc.add(UpdateProfilePicture(testFile));
      },
      expect: () => [
        isA<ProfileUpdating>(),
        isA<ProfileUpdateSuccess>(),
        isA<ProfileLoading>(),
        isA<ProfileLoaded>(),
      ],
      verify: (_) {
        verify(mockUpdateProfilePictureUseCase.call(any)).called(1);
        verify(mockGetUserProfileUseCase.call()).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileUpdating, ProfileError] when UpdateProfilePicture fails',
      build: () {
        when(mockUpdateProfilePictureUseCase.call(any)).thenAnswer(
          (_) async => SkillWaveResponse.failure(ApiFailure(message: 'error')),
        );
        return profileBloc;
      },
      act: (bloc) {
        final testFile = File('test_file.jpg');
        bloc.add(UpdateProfilePicture(testFile));
      },
      expect: () => [isA<ProfileUpdating>(), isA<ProfileError>()],
      verify: (_) {
        verify(mockUpdateProfilePictureUseCase.call(any)).called(1);
      },
    );

    group('Equatable', () {
      test('ProfileLoaded with same user are equal', () {
        expect(ProfileLoaded(testUser), ProfileLoaded(testUser));
      });
      test('ProfileError with same failure are equal', () {
        const failure = ApiFailure(message: 'error');
        expect(ProfileError(failure), ProfileError(failure));
      });
    });
  });
}
