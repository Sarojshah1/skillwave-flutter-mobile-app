import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../data/models/post_dto.dart';
import '../../../domin/usecases/create_comment_usecase.dart';
import 'create_comment_events.dart';
import 'create_comment_state.dart';

@injectable
class CreateCommentBloc extends Bloc<CreateCommentEvents, CreateCommentState> {
  final CreateCommentUseCase createCommentUseCase;

  CreateCommentBloc(this.createCommentUseCase) : super(CreateCommentInitial()) {
    on<CreateComment>(_onCreateComment);
  }

  Future<void> _onCreateComment(
    CreateComment event,
    Emitter<CreateCommentState> emit,
  ) async {
    emit(CreateCommentLoading());
    try {
      final result = await createCommentUseCase(event.postId, event.dto);
      result.fold(
        (failure) => emit(CreateCommentError(message: failure.message)),
        (_) => emit(CreateCommentLoaded()),
      );
    } catch (e) {
      emit(CreateCommentError(message: e.toString()));
    }
  }
}
