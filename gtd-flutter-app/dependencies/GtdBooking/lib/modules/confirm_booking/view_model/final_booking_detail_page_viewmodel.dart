// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_booking/modules/confirm_booking/view_model/pricing_bottom_page_viewmodel.dart';

class FinalBookingDetailPageViewModel extends PricingBottomPageViewModel {
  bool isWaitingPayment = false;
  FinalBookingDetailPageViewModel({
    required super.bookingNumber,
  }) {
    title = "Xác nhận";
    subTitle = "1 Người lớn, 1 Trẻ em";
  }

  String? get taxCompanyName => bookingDetailDTO?.invoiceBookingInfo?.taxCompanyName;


}
