import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/shared_prefs/app_shared_prefs.dart';
import 'package:skillwave/cores/shared_prefs/user_shared_prefs.dart';


part 'splash_events.dart';
part 'splash_state.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AppSharedPrefs appSharedPrefs;
  final UserSharedPrefs userSharedPrefs;

  SplashBloc(this.appSharedPrefs, this.userSharedPrefs) : super(SplashInitial()) {
    on<CheckAppStatusEvent>(_onCheckAppStatus);
  }

  Future<void> _onCheckAppStatus(
      CheckAppStatusEvent event, Emitter<SplashState> emit) async {
    emit(SplashLoading());

    final firstTimeResult = await appSharedPrefs.getFirstTime();
    final tokenResult = await userSharedPrefs.getUserToken();

    final token = tokenResult.fold((l) => null, (r) => r);
    final isFirstTime = firstTimeResult.fold((l) => null, (r) => r ?? true);

    if (token != null) {
      emit(SplashNavigateToHome());
    } else if (isFirstTime == true) {
      emit(SplashNavigateToOnboarding());
    } else {
      emit(SplashNavigateToLogin());
    }
  }
}
