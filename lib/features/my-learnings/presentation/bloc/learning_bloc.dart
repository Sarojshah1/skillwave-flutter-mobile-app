import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/features/my-learnings/domain/usecases/get_learning_usecase.dart';
import 'package:skillwave/features/my-learnings/domain/entity/enrollment_entity.dart';
import 'learning_event.dart';
import 'learning_state.dart';

@injectable
class LearningBloc extends Bloc<LearningEvent, LearningState> {
  final GetLearningUseCase _getLearningUseCase;

  LearningBloc(this._getLearningUseCase) : super(LearningInitial()) {
    on<FetchLearningEvent>(_onFetchLearning);
  }

  Future<void> _onFetchLearning(
    FetchLearningEvent event,
    Emitter<LearningState> emit,
  ) async {
    emit(LearningLoading());
    final response = await _getLearningUseCase();
    response.fold(
      (failure) => emit(LearningFailure(failure.message)),
      (data) => emit(LearningLoaded(data!)),
    );
  }
}
