part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class CreatePayment extends PaymentEvent {
  final String courseId;
  final int amount;
  final String paymentMethod;
  final String status;

  const CreatePayment({
    required this.courseId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
  });

  @override
  List<Object?> get props => [courseId, amount, paymentMethod, status];
}
