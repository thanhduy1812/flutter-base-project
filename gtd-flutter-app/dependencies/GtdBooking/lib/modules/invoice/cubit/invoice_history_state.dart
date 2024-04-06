part of 'invoice_history_cubit.dart';

sealed class InvoiceHistoryState extends Equatable {
  const InvoiceHistoryState();

  @override
  List<Object> get props => [];
}

final class InvoiceHistoryInitial extends InvoiceHistoryState {
  final GtdInvoiceHistoryRs? invoiceHistoryRs;

  const InvoiceHistoryInitial({this.invoiceHistoryRs});
  @override
  List<Object> get props => [invoiceHistoryRs ?? []];
}

final class InvoiceHistoryLoading extends InvoiceHistoryState {}

final class InvoiceHistoryError extends InvoiceHistoryState {
  final GtdApiError apiError;

  const InvoiceHistoryError({required this.apiError});

  @override
  List<Object> get props => [apiError];
}

final class InvoiceHistoryLoadMore extends InvoiceHistoryState {}

final class InvoiceSumaryInitial extends InvoiceHistoryState {
  final GtdInvoiceSumaryRs? invoiceSumaryRs;

  const InvoiceSumaryInitial({required this.invoiceSumaryRs});
}
