import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../data/models/post_dto.dart';
import '../../../domin/entity/post_entity.dart';
import '../../../domin/usecases/get_posts_usecase.dart';
import 'get_posts_events.dart';
import 'get_posts_state.dart';

@injectable
class GetPostsBloc extends Bloc<GetPostsEvents, GetPostsState> {
  final GetPostsUseCase getPostsUseCase;

  GetPostsBloc(this.getPostsUseCase) : super(GetPostsInitial()) {
    on<GetPosts>(_onGetPosts);
    on<RefreshPosts>(_onRefreshPosts);
    on<LoadMorePosts>(_onLoadMorePosts);
  }

  Future<void> _onGetPosts(GetPosts event, Emitter<GetPostsState> emit) async {
    emit(GetPostsLoading());
    try {
      final result = await getPostsUseCase(event.dto);
      result.fold(
        (failure) => emit(GetPostsError(message: failure.message)),
        (posts) => emit(GetPostsLoaded(posts: posts!)),
      );
    } catch (e) {
      emit(GetPostsError(message: e.toString()));
    }
  }

  Future<void> _onRefreshPosts(
    RefreshPosts event,
    Emitter<GetPostsState> emit,
  ) async {
    emit(GetPostsLoading());
    try {
      final result = await getPostsUseCase(event.dto);
      result.fold(
        (failure) => emit(GetPostsError(message: failure.message)),
        (posts) => emit(GetPostsLoaded(posts: posts!)),
      );
    } catch (e) {
      emit(GetPostsError(message: e.toString()));
    }
  }

  Future<void> _onLoadMorePosts(
    LoadMorePosts event,
    Emitter<GetPostsState> emit,
  ) async {
    final currentState = state;
    if (currentState is GetPostsLoaded) {
      emit(GetPostsLoadingMore(currentState.posts));
      try {
        final result = await getPostsUseCase(event.dto);
        result.fold(
          (failure) => emit(GetPostsError(message: failure.message)),
          (newPosts) {
            if (newPosts != null) {
              final updatedPosts = PostsResponseEntity(
                posts: [...currentState.posts.posts, ...newPosts.posts],
                totalPosts: newPosts.totalPosts,
                currentPage: newPosts.currentPage,
                totalPages: newPosts.totalPages,
                recommendations: newPosts.recommendations,
                userTags: newPosts.userTags,
              );
              emit(GetPostsLoaded(posts: updatedPosts));
            }
          },
        );
      } catch (e) {
        emit(GetPostsError(message: e.toString()));
      }
    }
  }
}
