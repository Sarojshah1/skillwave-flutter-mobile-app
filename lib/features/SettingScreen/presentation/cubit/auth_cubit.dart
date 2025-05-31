import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/features/SettingScreen/domain/use_cases/logout_usecase.dart';
import 'logout_state.dart';

@injectable
class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase useCase;

  LogoutCubit(this.useCase) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    final result = await useCase.call();
    print(result.value);
    result.fold(
          (failure) => emit(LogoutFailure(failure.message)),
          (_) => emit(LogoutSuccess()),
    );
  }
}
