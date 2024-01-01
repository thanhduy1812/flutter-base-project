part of 'flight_checkout_cubit.dart';

sealed class CheckoutState extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckoutStateInitial extends CheckoutState {}

class CheckoutStateScreenLoading extends CheckoutState {}

class CheckoutStateScreenLoaded extends CheckoutState {}
