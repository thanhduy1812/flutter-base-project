// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'payment_display_info_cubit.dart';

abstract class PaymentDisplayInfoState extends Equatable {
  const PaymentDisplayInfoState();

  @override
  List<Object> get props => [UniqueKey()];
}

class PaymentDisplayInfoInitial extends PaymentDisplayInfoState {}
