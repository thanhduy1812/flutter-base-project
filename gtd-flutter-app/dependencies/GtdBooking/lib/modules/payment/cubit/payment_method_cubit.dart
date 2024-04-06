import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/payment/view_model/payment_method_item_viewmodel.dart';
import 'package:gtd_booking/modules/payment/view_model/payment_method_page_viewmodel.dart';
import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/payment_resource/payment_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/payment_method_type.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_payment_repository/gtd_payment_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';
import 'package:rxdart/rxdart.dart';

part 'payment_method_state.dart';

class PaymentMethodCubit extends Cubit<PaymentMethodState> {
  PaymentMethodPageViewModel viewModel;
  BehaviorSubject<List<PaymentMethodItemViewModel>> paymentMethodSubject = BehaviorSubject.seeded([]);
  Stream<List<PaymentMethodItemViewModel>> get paymentMethodsStream => paymentMethodSubject.stream;

  PaymentMethodCubit(this.viewModel) : super(PaymentMethodInitial());

  Future<Result<List<PaymentMethodType>, GtdApiError>> getPaymentMethods() async {
    var result = await GtdPaymentRepository.shared.getPaymentMethods();
    result.when((success) {
      List<PaymentMethodItemViewModel> paymentMethodItems =
          success.map((e) => PaymentMethodItemViewModel(paymentType: e)).toList();
      paymentMethodSubject.sink.add(paymentMethodItems);
    }, (error) => emit(PaymentMethodLoadError(error.message)));
    return result;
  }

  Future<Result<double, GtdApiError>> paymentFee({required PaymentMethodType paymentType}) async {
    var result = await GtdPaymentRepository.shared.getPaymentFee(
        bookingNumber: viewModel.bookingNumber!,
        paymentType: paymentType,
        totalFare: viewModel.tempAmount,
        tempDiscount: 0);
    Result<double, GtdApiError> finalResult = result.when((success) {
      viewModel.paymentFee = success.amount;
      return Success(viewModel.paymentFee);
    }, (error) => Error(error));
    return finalResult;
  }

  Future<Result<List<GtdLoanKredivoMonth>, GtdApiError>> getLoadKredivo() async {
    var result = await GtdPaymentRepository.shared.getLoanKredivo(kredivoLoanRq: GtdKredivoLoanRq(amount: 3662000));
    result.when((success) {
      Success(success);
    }, (error) => Error(error));
    return result;
  }

  Future<Result<String, GtdApiError>> paymentBooking({required PaymentMethodType paymentMethodType}) async {
    if (viewModel.bookingDetailDTO == null) {
      return Error(GtdApiError(message: "Booking DTO is null"));
    }

    GtdPaymentBookingRq paymentBookingRq = GtdPaymentBookingRq(
        bookingNumber: viewModel.bookingNumber!,
        bookingCode: viewModel.bookingDetailDTO!.bookingCode!,
        amount: viewModel.netAmount,
        paymentType: paymentMethodType.code);
    if (paymentMethodType == PaymentMethodType.atm) {
      ExtentInfo extentInfo = ExtentInfo(payByDebitReq: PayByDebitReq(paymentOptionEnum: "Vietcombank"));
      paymentBookingRq.extentInfo = extentInfo;
    }
    var result = await GtdPaymentRepository.shared.paymentBooking(paymentBookingRq: paymentBookingRq);
    Result<String, GtdApiError> finalResult = result.when((success) {
      if (success.hasPaymentAuth == true && success.paymentAuthUrl != null) {
        return Success(success.paymentAuthUrl!);
      } else {
        return Error(GtdApiError(message: "Get payment url failed"));
      }
    }, (error) => Error(error));
    return finalResult;
  }

  @override
  Future<void> close() {
    paymentMethodSubject.close();
    return super.close();
  }
}
