import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/coursesScreen/domain/usecase/create_payment_usecase.dart';

part 'payment_event.dart';
part 'payment_state.dart';

@injectable
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreatePaymentUseCase _createPaymentUseCase;

  PaymentBloc(this._createPaymentUseCase) : super(PaymentInitial()) {
    on<CreatePayment>(_onCreatePayment);
  }

  Future<void> _onCreatePayment(
    CreatePayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      final response = await _createPaymentUseCase.call(
        courseId: event.courseId,
        amount: event.amount,
        paymentMethod: event.paymentMethod,
        status: event.status,
      );
      if (response.isSuccess) {
        emit(PaymentSuccess());
      } else {
        emit(
          PaymentError(
            ApiFailure(message: response.failure?.message ?? 'Payment failed'),
          ),
        );
      }
    } catch (e) {
      emit(PaymentError(ApiFailure(message: e.toString())));
    }
  }
}
