import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/utility_resource/utility_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_authentication_repository/gtd_authentication_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_utility_repository/gtd_utility_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

part 'invoice_history_state.dart';

class InvoiceHistoryCubit extends Cubit<InvoiceHistoryState> {
  String userRefCode = "C::A::1|18034";
  InvoiceHistoryCubit() : super(const InvoiceHistoryInitial());

  void loadAccountInfo() async {
    emit(InvoiceHistoryLoading());
    await GtdAuthenticationRepository.shared.getAccountInfo().then((value) {
      value.when((success) {
        userRefCode = success.userRefCode ?? "";
        loadInvoiceSumary();
        loadInvoiceHistories();
      }, (error) {
        emit(InvoiceHistoryError(apiError: error));
      });
    });
  }

  Future<void> loadInvoiceSumary() async {
    GtdUtilityRepository.shared.getInvoiceSumary(userRefcode: userRefCode).then((value) {
      value.whenSuccess((success) {
        emit(InvoiceSumaryInitial(invoiceSumaryRs: success));
      });
    });
  }

  Future<void> loadInvoiceHistories({int page = 0}) async {
    emit(InvoiceHistoryLoading());
    GtdUtilityRepository.shared.getInvoiceHistories(userRefcode: userRefCode, page: page).then((value) {
      value.when((success) => emit(InvoiceHistoryInitial(invoiceHistoryRs: success)),
          (error) => emit(InvoiceHistoryError(apiError: error)));
    });
  }

  Future<void> loadMoreInvoiceHistories({int page = 0}) async {
    emit(InvoiceHistoryLoadMore());
    GtdUtilityRepository.shared.getInvoiceHistories(userRefcode: userRefCode, page: page).then((value) {
      value.when((success) => emit(InvoiceHistoryInitial(invoiceHistoryRs: success)),
          (error) => emit(InvoiceHistoryError(apiError: error)));
    });
  }
}
