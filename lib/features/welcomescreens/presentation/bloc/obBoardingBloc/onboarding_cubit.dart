import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OnboardingCubit extends Cubit<int> {
  final int lastPageIndex;

  OnboardingCubit({required this.lastPageIndex}) : super(0);

  void nextPage() {
    if (state < lastPageIndex) {
      emit(state + 1);
    }
  }

  void skipOnboarding() {
    emit(lastPageIndex);
  }

  bool isLastPage() {
    return state == lastPageIndex;
  }
}

