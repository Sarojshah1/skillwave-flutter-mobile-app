import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domin/usecases/delete_post_usecase.dart';
import 'delete_post_events.dart';
import 'delete_post_state.dart';

@injectable
class DeletePostBloc extends Bloc<DeletePostEvents, DeletePostState> {
  final DeletePostUseCase deletePostUseCase;

  DeletePostBloc(this.deletePostUseCase) : super(DeletePostInitial()) {
    on<DeletePost>(_onDeletePost);
  }

  Future<void> _onDeletePost(
    DeletePost event,
    Emitter<DeletePostState> emit,
  ) async {
    emit(DeletePostLoading());
    try {
      final result = await deletePostUseCase(event.id);
      result.fold(
        (failure) => emit(DeletePostError(message: failure.message)),
        (_) => emit(DeletePostLoaded()),
      );
    } catch (e) {
      emit(DeletePostError(message: e.toString()));
    }
  }
}
