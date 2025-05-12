import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0); // Start at page 0

  void nextPage() {
    emit(state + 1);
  }

  void skipOnboarding() {
    emit(3);
  }

  bool isLastPage() {
    return state == 3;
  }
}
