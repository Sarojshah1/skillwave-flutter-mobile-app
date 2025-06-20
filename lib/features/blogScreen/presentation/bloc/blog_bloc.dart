import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:skillwave/features/blogScreen/domain/entity/blog_entity.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/blogScreen/domain/usecases/get_blogs_usecase.dart';

part 'blog_event.dart';
part 'blog_state.dart';

@injectable
class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final GetBlogsUseCase _getBlogsUseCase;

  BlogBloc(this._getBlogsUseCase) : super(BlogInitial()) {
    on<LoadBlogs>(_onLoadBlogs);
  }
  List<BlogEntity> _allBlogs = [];
  bool _hasReachedMax = false;
  Future<void> _onLoadBlogs(
      LoadBlogs event,
      Emitter<BlogState> emit,
      ) async {
    if (_hasReachedMax && event.page != 1) {
      return;
    }
    try {
      // Emit loading only if it's the first page or initial load
      if (event.page == 1) {
        emit(BlogLoading());
      }

      final result = await _getBlogsUseCase.call(page: event.page, limit: event.limit);

      result.fold(
            (error) => emit(BlogError(error)),
            (blogs) {
          if (event.page == 1) {
            _allBlogs = blogs ?? [];
          } else {
            _allBlogs.addAll(blogs ?? []);
          }

          _hasReachedMax = (blogs == null || blogs.length < event.limit);

          emit(BlogLoaded(
            blogs: _allBlogs,
            hasReachedMax: _hasReachedMax,
          ));
        },
      );
    } catch (e) {
      print(e.toString());
      // emit(BlogError(Failure( message: e.toString())));
    }
  }
}
