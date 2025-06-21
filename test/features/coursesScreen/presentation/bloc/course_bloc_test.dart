import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/features/coursesScreen/domain/usecase/get_courses_usecase.dart';
import 'package:skillwave/features/coursesScreen/domain/usecase/get_course_by_id_usecase.dart';
import 'package:skillwave/features/coursesScreen/domain/usecase/create_payment_usecase.dart';
import 'package:skillwave/features/coursesScreen/presentation/bloc/course_bloc.dart';

import 'course_bloc_test.mocks.dart';

@GenerateMocks([GetCoursesUseCase, GetCourseByIdUseCase, CreatePaymentUseCase])
void main() {
  late CourseBloc courseBloc;
  late MockGetCoursesUseCase mockGetCoursesUseCase;
  late MockGetCourseByIdUseCase mockGetCourseByIdUseCase;
  late MockCreatePaymentUseCase mockCreatePaymentUseCase;

  setUp(() {
    mockGetCoursesUseCase = MockGetCoursesUseCase();
    mockGetCourseByIdUseCase = MockGetCourseByIdUseCase();
    mockCreatePaymentUseCase = MockCreatePaymentUseCase();
    courseBloc = CourseBloc(
      mockGetCoursesUseCase,
      mockGetCourseByIdUseCase,
      mockCreatePaymentUseCase,
    );
  });

  tearDown(() {
    courseBloc.close();
  });

  group('CourseBloc', () {
    final testCreatedBy = CreatedByEntity(
      id: 'u1',
      name: 'Instructor',
      email: 'instructor@example.com',
      password: '',
      role: 'instructor',
      profilePicture: '',
      bio: '',
      enrolledCourses: const [],
      payments: const [],
      blogPosts: const [],
      quizResults: const [],
      reviews: const [],
      certificates: const [],
      createdAt: DateTime(2024, 1, 1),
      searchHistory: const [],
    );
    final testCategory = CategoryEntity(
      id: 'c1',
      name: 'Programming',
      description: 'desc',
      icon: '',
    );
    final testLesson = LessonEntity(
      id: 'l1',
      courseId: 'course1',
      title: 'Lesson 1',
      content: 'Content',
      videoUrl: '',
      order: 1,
      v: 1,
    );
    final testCourse = CourseEntity(
      id: 'course1',
      title: 'Course 1',
      description: 'desc',
      createdBy: testCreatedBy,
      category: testCategory,
      price: 100,
      duration: '2h',
      level: 'Beginner',
      thumbnail: '',
      lessons: [testLesson],
      quizzes: const [],
      reviews: const [],
      certificates: const [],
      createdAt: DateTime(2024, 1, 1),
    );
    final coursesList = [testCourse];

    test('initial state should be CourseInitial', () {
      expect(courseBloc.state, isA<CourseInitial>());
    });

    blocTest<CourseBloc, CourseState>(
      'emits [CourseLoading, CourseLoaded] when LoadCourses is successful',
      build: () {
        when(
          mockGetCoursesUseCase.call(page: 1, limit: 10),
        ).thenAnswer((_) async => SkillWaveResponse.success(coursesList));
        return courseBloc;
      },
      act: (bloc) => bloc.add(const LoadCourses(page: 1, limit: 10)),
      expect: () => [isA<CourseLoading>(), isA<CourseLoaded>()],
      verify: (_) {
        verify(mockGetCoursesUseCase.call(page: 1, limit: 10)).called(1);
      },
    );

    blocTest<CourseBloc, CourseState>(
      'emits [CourseLoading, CourseError] when LoadCourses fails',
      build: () {
        when(mockGetCoursesUseCase.call(page: 1, limit: 10)).thenAnswer(
          (_) async => SkillWaveResponse.failure(ApiFailure(message: 'error')),
        );
        return courseBloc;
      },
      act: (bloc) => bloc.add(const LoadCourses(page: 1, limit: 10)),
      expect: () => [isA<CourseLoading>(), isA<CourseError>()],
      verify: (_) {
        verify(mockGetCoursesUseCase.call(page: 1, limit: 10)).called(1);
      },
    );

    blocTest<CourseBloc, CourseState>(
      'emits [CourseLoading, CourseByIdLoaded] when LoadCourseById is successful',
      build: () {
        when(
          mockGetCourseByIdUseCase.call('course1'),
        ).thenAnswer((_) async => SkillWaveResponse.success(testCourse));
        return courseBloc;
      },
      act: (bloc) => bloc.add(const LoadCourseById('course1')),
      expect: () => [isA<CourseLoading>(), isA<CourseByIdLoaded>()],
      verify: (_) {
        verify(mockGetCourseByIdUseCase.call('course1')).called(1);
      },
    );

    blocTest<CourseBloc, CourseState>(
      'emits [CourseLoading, CourseError] when LoadCourseById fails',
      build: () {
        when(mockGetCourseByIdUseCase.call('course1')).thenAnswer(
          (_) async => SkillWaveResponse.failure(ApiFailure(message: 'error')),
        );
        return courseBloc;
      },
      act: (bloc) => bloc.add(const LoadCourseById('course1')),
      expect: () => [isA<CourseLoading>(), isA<CourseError>()],
      verify: (_) {
        verify(mockGetCourseByIdUseCase.call('course1')).called(1);
      },
    );

    blocTest<CourseBloc, CourseState>(
      'emits [CourseLoading, PaymentSuccess] when CreatePayment is successful',
      build: () {
        when(
          mockCreatePaymentUseCase.call(
            courseId: 'course1',
            amount: 100,
            paymentMethod: 'card',
            status: 'success',
          ),
        ).thenAnswer((_) async => SkillWaveResponse.success(true));
        return courseBloc;
      },
      act: (bloc) => bloc.add(
        const CreatePayment(
          courseId: 'course1',
          amount: 100,
          paymentMethod: 'card',
          status: 'success',
        ),
      ),
      expect: () => [isA<CourseLoading>(), isA<PaymentSuccess>()],
      verify: (_) {
        verify(
          mockCreatePaymentUseCase.call(
            courseId: 'course1',
            amount: 100,
            paymentMethod: 'card',
            status: 'success',
          ),
        ).called(1);
      },
    );

    blocTest<CourseBloc, CourseState>(
      'emits [CourseLoading, CourseError] when CreatePayment fails',
      build: () {
        when(
          mockCreatePaymentUseCase.call(
            courseId: 'course1',
            amount: 100,
            paymentMethod: 'card',
            status: 'success',
          ),
        ).thenAnswer(
          (_) async => SkillWaveResponse.failure(ApiFailure(message: 'error')),
        );
        return courseBloc;
      },
      act: (bloc) => bloc.add(
        const CreatePayment(
          courseId: 'course1',
          amount: 100,
          paymentMethod: 'card',
          status: 'success',
        ),
      ),
      expect: () => [isA<CourseLoading>(), isA<CourseError>()],
      verify: (_) {
        verify(
          mockCreatePaymentUseCase.call(
            courseId: 'course1',
            amount: 100,
            paymentMethod: 'card',
            status: 'success',
          ),
        ).called(1);
      },
    );

    group('Equatable', () {
      test('CourseLoaded with same courses and hasReachedMax are equal', () {
        expect(
          CourseLoaded(courses: coursesList, hasReachedMax: false),
          CourseLoaded(courses: coursesList, hasReachedMax: false),
        );
      });
      test('CourseError with same failure are equal', () {
        const failure = ApiFailure(message: 'error');
        expect(CourseError(failure), CourseError(failure));
      });
    });
  });
}
