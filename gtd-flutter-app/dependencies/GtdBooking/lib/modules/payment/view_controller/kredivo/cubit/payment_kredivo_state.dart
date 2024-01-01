// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'payment_kredivo_cubit.dart';

abstract class PaymentKredivoState extends Equatable {
  const PaymentKredivoState();

  @override
  List<Object> get props => [UniqueKey()];
}

class PaymentKredivoInitial extends PaymentKredivoState {}
