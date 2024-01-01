import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/payment_resource/payment_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_markup_type.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/payment_method_type.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

class GtdPaymentRepository {
  final PaymentResourceApi paymentResourceApi = PaymentResourceApi.shared;

  GtdPaymentRepository._();
  static final shared = GtdPaymentRepository._();

  Future<Result<List<PaymentMethodType>, GtdApiError>> getPaymentMethods() async {
    try {
      final response = await paymentResourceApi.getPaymentAvailable();
      return Success(PaymentMethodType.findByCodes(response));
    } on GtdApiError catch (e) {
      Logger.e("getPaymentMethods: $e");
      return Error(e);
    }
  }

  Future<Result<List<String>, GtdApiError>> getDebitBanks() async {
    try {
      final response = await paymentResourceApi.getPaymentDebitOptions();
      return Success(response);
    } on GtdApiError catch (e) {
      Logger.e("getDebitBanks: $e");
      return Error(e);
    }
  }

  Future<Result<({GtdMarkupType markupType, double amount}), GtdApiError>> getPaymentFee(
      {required String bookingNumber,
      required PaymentMethodType paymentType,
      required double totalFare,
      double tempDiscount = 0}) async {
    try {
      final response = await paymentResourceApi.getPaymentFee(
          bookingNumber: bookingNumber,
          paymentType: paymentType.code,
          totalFare: totalFare,
          tempDiscount: tempDiscount);
      var result = response.peymentFees
          ?.where((e) => e.paymentType?.toLowerCase() == paymentType.code.toLowerCase())
          .firstOrNull;

      return Success((markupType: GtdMarkupType.findByCode(result?.valueType ?? ""), amount: result?.amount ?? 0));
    } on GtdApiError catch (e) {
      Logger.e("getPaymentFee: $e");
      return Error(e);
    }
  }

  Future<Result<GtdPayBookingRs, GtdApiError>> paymentBooking({required GtdPaymentBookingRq paymentBookingRq}) async {
    try {
      GtdPayBookingRs response = await paymentResourceApi.paymentBooking(paymentBookingRq: paymentBookingRq);
      return Success(response);
    } on GtdApiError catch (e) {
      Logger.e("paymentBooking: $e");
      return Error(e);
    }
  }

  Future<Result<List<GtdLoanKredivoMonth>, GtdApiError>> getLoanKredivo(
      {required GtdKredivoLoanRq kredivoLoanRq}) async {
    try {
      GtdKredivoLoanDetail response = await paymentResourceApi.getLoanKredivo(kredivoLoanRq);
      return Success(response.innerArray);
    } on GtdApiError catch (e) {
      Logger.e("kredivoDetail: $e");
      return Error(e);
    }
  }
}
