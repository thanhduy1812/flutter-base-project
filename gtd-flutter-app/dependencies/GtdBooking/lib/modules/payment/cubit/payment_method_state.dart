part of 'payment_method_cubit.dart';

abstract class PaymentMethodState extends Equatable {
  const PaymentMethodState();

  @override
  List<Object> get props => [];
}

class PaymentMethodInitial extends PaymentMethodState {}

class PaymentMethodLoadedMethods extends PaymentMethodState {}

class PaymentMethodLoadError extends PaymentMethodState {
  final String errorMessege;

  const PaymentMethodLoadError(this.errorMessege);
  @override
  List<Object> get props => [errorMessege];
}
