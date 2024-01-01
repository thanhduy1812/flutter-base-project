import 'package:gtd_booking/modules/payment/view_model/payment_method_page_viewmodel.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/payment_method_type.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/resource/gotadi_data/model/bank_holder_model.dart';
import 'package:gtd_utils/data/resource/gotadi_data/model/officer_model.dart';
import 'package:gtd_utils/data/resource/resource.dart';

class PaymentPaylaterPageViewModel extends PaymentMethodPageViewModel {
  final PaymentMethodType paymentMethodType = PaymentMethodType.paylater;
  final List<OfficerModel> officerInfos = gotadiOfficer.map((e) => OfficerModel.fromJson(e)).toList();
  final List<BankHolderModel> bankHolders = bankGotadiAccount.map((e) => BankHolderModel.fromJson(e)).toList();
  PaymentPaylaterPageViewModel({required BookingDetailDTO bookingDetailDTO, super.paymentFee, super.discountAmount})
      : super(bookingNumber: bookingDetailDTO.bookingNumber!) {
    title = "Giữ chỗ, chờ thanh toán";
    this.bookingDetailDTO = bookingDetailDTO;
  }
}
