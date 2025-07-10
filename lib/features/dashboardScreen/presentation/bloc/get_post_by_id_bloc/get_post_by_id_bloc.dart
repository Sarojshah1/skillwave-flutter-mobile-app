import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domin/usecases/get_post_by_id_usecase.dart';
import 'get_post_by_id_events.dart';
import 'get_post_by_id_state.dart';

@injectable
class GetPostByIdBloc extends Bloc<GetPostByIdEvents, GetPostByIdState> {
  final GetPostByIdUseCase getPostByIdUseCase;

  GetPostByIdBloc(this.getPostByIdUseCase) : super(GetPostByIdInitial()) {
    on<GetPostById>(_onGetPostById);
  }

  Future<void> _onGetPostById(
    GetPostById event,
    Emitter<GetPostByIdState> emit,
  ) async {
    emit(GetPostByIdLoading());
    try {
      final result = await getPostByIdUseCase(event.id);
      result.fold(
        (failure) => emit(GetPostByIdError(message: failure.message)),
        (post) {
          if (post != null) {
            emit(GetPostByIdLoaded(post: post));
          }
        },
      );
    } catch (e) {
      emit(GetPostByIdError(message: e.toString()));
    }
  }
}
