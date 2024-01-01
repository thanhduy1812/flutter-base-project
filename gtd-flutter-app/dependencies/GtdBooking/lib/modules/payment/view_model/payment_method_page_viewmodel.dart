// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:gtd_booking/modules/confirm_booking/view_model/pricing_bottom_page_viewmodel.dart';
import 'package:gtd_booking/modules/payment/view_model/payment_method_item_viewmodel.dart';

class PaymentMethodPageViewModel extends PricingBottomPageViewModel {
  String? voucherCode;
  double discountAmount = 0;
  List<PaymentMethodItemViewModel> availableMethods = [];
  double paymentFee = 0;
  PaymentMethodPageViewModel({
    required super.bookingNumber,
    this.voucherCode,
    this.availableMethods = const [],
    this.paymentFee = 0,
    this.discountAmount = 0,
  }) {
    print(bookingNumber);
  }

  PaymentMethodItemViewModel? get selectedPayment =>
      availableMethods.where((element) => element.isSelected).firstOrNull;

  bool get isEnablePayment {
    return selectedPayment != null;
  }

  @override
  // TODO: implement netAmount
  double get netAmount {
    return (bookingDetailDTO?.paymentInfo?.totalFare ?? 0) +
        (bookingDetailDTO?.paymentInfo?.totalSsrValue ?? 0) +
        paymentFee -
        discountAmount;
  }

  double get tempAmount {
    return (bookingDetailDTO?.paymentInfo?.totalFare ?? 0) +
        (bookingDetailDTO?.paymentInfo?.totalSsrValue ?? 0) -
        discountAmount;
  }

  PaymentMethodPageViewModel copyWith({
    required PaymentMethodPageViewModel viewModel,
  }) {
    return PaymentMethodPageViewModel(
      bookingNumber: viewModel.bookingNumber,
      voucherCode: viewModel.voucherCode,
      availableMethods: viewModel.availableMethods,
      paymentFee: viewModel.paymentFee,
    );
  }

  void updateFromStateViewModel({
    required PaymentMethodPageViewModel viewModel,
  }) {
    voucherCode = viewModel.voucherCode;
    paymentFee = viewModel.paymentFee;
    availableMethods = viewModel.availableMethods;
  }
}
