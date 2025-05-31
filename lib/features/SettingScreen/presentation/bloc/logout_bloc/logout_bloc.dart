
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/features/SettingScreen/domain/use_cases/logout_usecase.dart';

part 'logout_event.dart';
part 'logout_state.dart';

@injectable
class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutUseCase useCase;
  LogoutBloc(this.useCase) : super(LogoutInitial()) {
    on<LogoutEventTriggered>(_onLogoutTriggered);
  }

  Future<void> _onLogoutTriggered(
      LogoutEventTriggered event, Emitter<LogoutState> emit) async {
    emit(LogoutLoading());

    try {
      await Future.delayed(Duration(seconds: 2));
      await useCase.call();
      emit(LogoutSuccess());

    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }
}