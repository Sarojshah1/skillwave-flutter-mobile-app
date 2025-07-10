import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domin/usecases/create_reply_usecase.dart';
import 'create_reply_events.dart';
import 'create_reply_state.dart';

@injectable
class CreateReplyBloc extends Bloc<CreateReplyEvents, CreateReplyState> {
  final CreateReplyUseCase createReplyUseCase;

  CreateReplyBloc(this.createReplyUseCase) : super(CreateReplyInitial()) {
    on<CreateReply>(_onCreateReply);
  }

  Future<void> _onCreateReply(
    CreateReply event,
    Emitter<CreateReplyState> emit,
  ) async {
    emit(CreateReplyLoading());
    try {
      final result = await createReplyUseCase(
        event.postId,
        event.commentId,
        event.dto,
      );
      result.fold(
        (failure) => emit(CreateReplyError(message: failure.message)),
        (_) => emit(CreateReplyLoaded()),
      );
    } catch (e) {
      emit(CreateReplyError(message: e.toString()));
    }
  }
}
