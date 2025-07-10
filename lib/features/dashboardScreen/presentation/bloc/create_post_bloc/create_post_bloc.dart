import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import '../../../domin/usecases/create_post_usecase.dart';
import 'create_post_events.dart';
import 'create_post_state.dart';

@injectable
class CreatePostBloc extends Bloc<CreatePostEvents, CreatePostState> {
  final CreatePostUseCase createPostUseCase;

  CreatePostBloc(this.createPostUseCase) : super(CreatePostInitial()) {
    on<CreatePost>(_onCreatePost);
    on<ResetCreatePost>(_onResetCreatePost);
  }

  Future<void> _onCreatePost(
    CreatePost event,
    Emitter<CreatePostState> emit,
  ) async {
    emit(CreatePostLoading());
    try {
      final result = await createPostUseCase(event.dto, images: event.images);
      result.fold(
        (failure) => emit(CreatePostError(message: failure.message)),
        (post) {
          if (post != null) {
            emit(CreatePostLoaded(message: post));
          } else {
            emit(
              CreatePostError(
                message: 'Failed to create post. Please try again.',
              ),
            );
          }
        },
      );
    } catch (e) {
      String errorMessage = 'An unexpected error occurred. Please try again.';
      if (e is Failure) {
        errorMessage = e.message;
      } else if (e.toString().contains('network') ||
          e.toString().contains('connection')) {
        errorMessage = 'No internet connection. Please check your network.';
      }
      emit(CreatePostError(message: errorMessage));
    }
  }

  void _onResetCreatePost(
    ResetCreatePost event,
    Emitter<CreatePostState> emit,
  ) {
    emit(CreatePostInitial());
  }
}
