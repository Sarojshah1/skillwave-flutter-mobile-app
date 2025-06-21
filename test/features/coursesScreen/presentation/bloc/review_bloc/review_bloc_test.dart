import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/review_entity.dart';
import 'package:skillwave/features/coursesScreen/domain/usecase/get_reviews_by_course_id_usecase.dart';
import 'package:skillwave/features/coursesScreen/domain/usecase/create_review_usecase.dart';
import 'package:skillwave/features/coursesScreen/presentation/bloc/review_bloc/review_bloc.dart';

import 'review_bloc_test.mocks.dart';

@GenerateMocks([GetReviewsByCourseIdUseCase, CreateReviewUseCase])
void main() {
  late ReviewBloc reviewBloc;
  late MockGetReviewsByCourseIdUseCase mockGetReviewsByCourseIdUseCase;
  late MockCreateReviewUseCase mockCreateReviewUseCase;

  setUp(() {
    mockGetReviewsByCourseIdUseCase = MockGetReviewsByCourseIdUseCase();
    mockCreateReviewUseCase = MockCreateReviewUseCase();
    reviewBloc = ReviewBloc(
      mockCreateReviewUseCase,
      mockGetReviewsByCourseIdUseCase,
    );
  });

  tearDown(() {
    reviewBloc.close();
  });

  group('ReviewBloc', () {
    final testUser = UserEntity(
      id: 'u1',
      name: 'Test User',
      email: 'test@example.com',
      role: 'student',
      profilePicture: '',
      bio: '',
      enrolledCourses: const [],
      payments: const [],
      blogPosts: const [],
      quizResults: const [],
      reviews: const [],
      certificates: const [],
      searchHistory: const [],
      createdAt: DateTime(2024, 1, 1),
    );
    final testReview = ReviewEntity(
      id: 'r1',
      user: testUser,
      courseId: 'course1',
      rating: 5,
      comment: 'Great course!',
      createdAt: DateTime(2024, 1, 1),
    );
    final reviewsList = [testReview];

    test('initial state should be ReviewInitial', () {
      expect(reviewBloc.state, isA<ReviewInitial>());
    });

    blocTest<ReviewBloc, ReviewState>(
      'emits [ReviewLoading, ReviewsLoaded] when LoadReviewsByCourseId is successful',
      build: () {
        when(
          mockGetReviewsByCourseIdUseCase.call('course1'),
        ).thenAnswer((_) async => SkillWaveResponse.success(reviewsList));
        return reviewBloc;
      },
      act: (bloc) => bloc.add(const LoadReviewsByCourseId('course1')),
      expect: () => [isA<ReviewLoading>(), isA<ReviewsLoaded>()],
      verify: (_) {
        verify(mockGetReviewsByCourseIdUseCase.call('course1')).called(1);
      },
    );

    blocTest<ReviewBloc, ReviewState>(
      'emits [ReviewLoading, ReviewError] when LoadReviewsByCourseId fails',
      build: () {
        when(mockGetReviewsByCourseIdUseCase.call('course1')).thenAnswer(
          (_) async => SkillWaveResponse.failure(ApiFailure(message: 'error')),
        );
        return reviewBloc;
      },
      act: (bloc) => bloc.add(const LoadReviewsByCourseId('course1')),
      expect: () => [isA<ReviewLoading>(), isA<ReviewError>()],
      verify: (_) {
        verify(mockGetReviewsByCourseIdUseCase.call('course1')).called(1);
      },
    );

    blocTest<ReviewBloc, ReviewState>(
      'emits [ReviewLoading, ReviewCreated] when CreateReview is successful',
      build: () {
        when(
          mockCreateReviewUseCase.call(
            courseId: 'course1',
            rating: 5,
            comment: 'Great course!',
          ),
        ).thenAnswer((_) async => SkillWaveResponse.success(true));
        return reviewBloc;
      },
      act: (bloc) => bloc.add(
        const CreateReview(
          courseId: 'course1',
          rating: 5,
          comment: 'Great course!',
        ),
      ),
      expect: () => [isA<ReviewLoading>(), isA<ReviewCreated>()],
      verify: (_) {
        verify(
          mockCreateReviewUseCase.call(
            courseId: 'course1',
            rating: 5,
            comment: 'Great course!',
          ),
        ).called(1);
      },
    );

    blocTest<ReviewBloc, ReviewState>(
      'emits [ReviewLoading, ReviewError] when CreateReview fails',
      build: () {
        when(
          mockCreateReviewUseCase.call(
            courseId: 'course1',
            rating: 5,
            comment: 'Great course!',
          ),
        ).thenAnswer(
          (_) async => SkillWaveResponse.failure(ApiFailure(message: 'error')),
        );
        return reviewBloc;
      },
      act: (bloc) => bloc.add(
        const CreateReview(
          courseId: 'course1',
          rating: 5,
          comment: 'Great course!',
        ),
      ),
      expect: () => [isA<ReviewLoading>(), isA<ReviewError>()],
      verify: (_) {
        verify(
          mockCreateReviewUseCase.call(
            courseId: 'course1',
            rating: 5,
            comment: 'Great course!',
          ),
        ).called(1);
      },
    );

    group('Equatable', () {
      test('ReviewsLoaded with same reviews are equal', () {
        expect(ReviewsLoaded(reviewsList), ReviewsLoaded(reviewsList));
      });
      test('ReviewError with same failure are equal', () {
        const failure = ApiFailure(message: 'error');
        expect(ReviewError(failure), ReviewError(failure));
      });
    });
  });
}
