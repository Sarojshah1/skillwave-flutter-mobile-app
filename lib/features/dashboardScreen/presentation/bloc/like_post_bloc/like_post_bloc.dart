import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domin/usecases/like_post_usecase.dart';
import 'like_post_events.dart';
import 'like_post_state.dart';

@injectable
class LikePostBloc extends Bloc<LikePostEvents, LikePostState> {
  final LikePostUseCase likePostUseCase;

  LikePostBloc(this.likePostUseCase) : super(LikePostInitial()) {
    on<LikePost>(_onLikePost);
  }

  Future<void> _onLikePost(LikePost event, Emitter<LikePostState> emit) async {
    emit(LikePostLoading());
    try {
      final result = await likePostUseCase(event.postId);
      result.fold(
        (failure) => emit(LikePostError(message: failure.message)),
        (_) => emit(LikePostLoaded()),
      );
    } catch (e) {
      emit(LikePostError(message: e.toString()));
    }
  }
}
