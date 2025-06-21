import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/cores/network/models/skillwave_response.dart';
import 'package:skillwave/features/blogScreen/domain/entity/blog_entity.dart';
import 'package:skillwave/features/blogScreen/domain/usecases/get_blogs_usecase.dart';
import 'package:skillwave/features/blogScreen/presentation/bloc/blog_bloc.dart';

import 'blog_bloc_test.mocks.dart';

@GenerateMocks([GetBlogsUseCase])
void main() {
  late BlogBloc blogBloc;
  late MockGetBlogsUseCase mockGetBlogsUseCase;

  setUp(() {
    mockGetBlogsUseCase = MockGetBlogsUseCase();
    blogBloc = BlogBloc(mockGetBlogsUseCase);
  });

  tearDown(() {
    blogBloc.close();
  });

  group('BlogBloc', () {
    final testUser = UserEntity(
      id: 'u1',
      name: 'Test User',
      email: 'test@example.com',
      role: 'author',
      profilePicture: '',
      bio: 'bio',
    );
    final testBlog = BlogEntity(
      id: 'b1',
      user: testUser,
      title: 'Test Blog',
      content: 'Content',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 2),
      tags: ['tag1'],
    );
    final blogsList = [testBlog];

    test('initial state should be BlogInitial', () {
      expect(blogBloc.state, isA<BlogInitial>());
    });

    blocTest<BlogBloc, BlogState>(
      'emits [BlogLoading, BlogLoaded] when LoadBlogs is successful',
      build: () {
        when(
          mockGetBlogsUseCase.call(page: 1, limit: 10),
        ).thenAnswer((_) async => SkillWaveResponse.success(blogsList));
        return blogBloc;
      },
      act: (bloc) => bloc.add(const LoadBlogs(page: 1, limit: 10)),
      expect: () => [isA<BlogLoading>(), isA<BlogLoaded>()],
      verify: (_) {
        verify(mockGetBlogsUseCase.call(page: 1, limit: 10)).called(1);
      },
    );

    blocTest<BlogBloc, BlogState>(
      'emits [BlogLoading, BlogError] when LoadBlogs fails',
      build: () {
        when(mockGetBlogsUseCase.call(page: 1, limit: 10)).thenAnswer(
          (_) async => SkillWaveResponse.failure(ApiFailure(message: 'error')),
        );
        return blogBloc;
      },
      act: (bloc) => bloc.add(const LoadBlogs(page: 1, limit: 10)),
      expect: () => [isA<BlogLoading>(), isA<BlogError>()],
      verify: (_) {
        verify(mockGetBlogsUseCase.call(page: 1, limit: 10)).called(1);
      },
    );

    group('Equatable', () {
      test('BlogLoaded with same blogs and hasReachedMax are equal', () {
        expect(
          BlogLoaded(blogs: blogsList, hasReachedMax: false),
          BlogLoaded(blogs: blogsList, hasReachedMax: false),
        );
      });
      test('BlogError with same failure are equal', () {
        const failure = ApiFailure(message: 'error');
        expect(BlogError(failure), BlogError(failure));
      });
    });
  });
}
