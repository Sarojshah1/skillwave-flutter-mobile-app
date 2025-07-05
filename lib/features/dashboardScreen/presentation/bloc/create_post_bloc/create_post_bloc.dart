import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../data/models/post_dto.dart';
import '../../../domin/entity/post_entity.dart';
import '../../../domin/usecases/create_post_usecase.dart';
import 'create_post_events.dart';
import 'create_post_state.dart';

@injectable
class CreatePostBloc extends Bloc<CreatePostEvents, CreatePostState> {
  final CreatePostUseCase createPostUseCase;

  CreatePostBloc(this.createPostUseCase) : super(CreatePostInitial()) {
    on<CreatePost>(_onCreatePost);
  }

  Future<void> _onCreatePost(
    CreatePost event,
    Emitter<CreatePostState> emit,
  ) async {
    emit(CreatePostLoading());
    try {
      final result = await createPostUseCase(event.dto);
      result.fold(
        (failure) => emit(CreatePostError(message: failure.message)),
        (post) {
          if (post != null) {
            emit(CreatePostLoaded(post: post));
          }
        },
      );
    } catch (e) {
      emit(CreatePostError(message: e.toString()));
    }
  }
}
