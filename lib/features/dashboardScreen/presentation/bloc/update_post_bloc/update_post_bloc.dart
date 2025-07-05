import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../data/models/post_dto.dart';
import '../../../domin/entity/post_entity.dart';
import '../../../domin/usecases/update_post_usecase.dart';
import 'update_post_events.dart';
import 'update_post_state.dart';

@injectable
class UpdatePostBloc extends Bloc<UpdatePostEvents, UpdatePostState> {
  final UpdatePostUseCase updatePostUseCase;

  UpdatePostBloc(this.updatePostUseCase) : super(UpdatePostInitial()) {
    on<UpdatePost>(_onUpdatePost);
  }

  Future<void> _onUpdatePost(
    UpdatePost event,
    Emitter<UpdatePostState> emit,
  ) async {
    emit(UpdatePostLoading());
    try {
      final result = await updatePostUseCase(event.id, event.dto);
      result.fold(
        (failure) => emit(UpdatePostError(message: failure.message)),
        (post) {
          if (post != null) {
            emit(UpdatePostLoaded(post: post));
          }
        },
      );
    } catch (e) {
      emit(UpdatePostError(message: e.toString()));
    }
  }
}
