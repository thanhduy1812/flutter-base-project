import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/payment_resource/payment_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_payment_repository/gtd_payment_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

import '../view_model/kredivo_option_vm.dart';

part 'payment_kredivo_state.dart';

class PaymentKredivoCubit extends Cubit<PaymentKredivoState> {
  List<KredivoOptionVM> kredivoOptionVMs = [];
  PaymentKredivoCubit() : super(PaymentKredivoInitial());

  Future<Result<List<GtdLoanKredivoMonth>, GtdApiError>> getLoadKredivo() async {
    var result = await GtdPaymentRepository.shared.getLoanKredivo(kredivoLoanRq: GtdKredivoLoanRq(amount: 3662000));
    result.when((success) {
      Success(success);
      kredivoOptionVMs = success.map((e) => KredivoOptionVM(data: e)).toList();
      kredivoOptionVMs[0].isSelected = true;
      emit(PaymentKredivoInitial());
    }, (error) => Error(error));
    return result;
  }

  void updateSelectLoan() {
    emit(PaymentKredivoInitial());
  }
}
