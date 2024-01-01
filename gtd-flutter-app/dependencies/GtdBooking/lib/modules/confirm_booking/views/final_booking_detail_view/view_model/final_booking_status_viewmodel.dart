import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_final_booking_status.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';

class FinalBookingStatusViewModel extends BaseViewModel {
  bool isWaitingPayment = false;
  final BookingDetailDTO bookingDetailDTO;

  FinalBookingStatusViewModel({required this.bookingDetailDTO});

  DisplayBookingStatus get finalBookingStatus {
    return DisplayBookingStatus.fromBookingFinalStatus(bookingDetailDTO.bookingFinalStatus);
  }

  ({String paymentDate, String paymentMethod}) get paymentInfo {
    return (
      paymentDate: bookingDetailDTO.paymentInfo?.paymentDate?.utcDate("HH:mm, EEE dd/MM/yyyy") ?? "--",
      paymentMethod: bookingDetailDTO.paymentInfo?.paymentType?.code ?? "--"
    );
  }

  ({String purchaseProduct, String totalPayment}) get productInfo {
    String roundTypeTitle = bookingDetailDTO.isOneWay ? "Vé một chiều" : "Vé khứ hồi";

    String purchaseProduct = "";
    if (bookingDetailDTO.supplierType == "AIR") {
      roundTypeTitle = bookingDetailDTO.isOneWay ? "Vé một chiều" : "Vé khứ hồi";
      String productTitle = bookingDetailDTO.flightDetailItems?.firstOrNull?.inineraryCodeTitle ?? "--";
      purchaseProduct = "$roundTypeTitle, $productTitle";
    }
    if (bookingDetailDTO.supplierType == "HOTEL") {
      roundTypeTitle = "Đặt phòng khách sạn";
      purchaseProduct = roundTypeTitle;
    }
    if (bookingDetailDTO.supplierType == "COMBO") {
      roundTypeTitle = "Đặt combo";
      purchaseProduct = roundTypeTitle;
    }

    String totalAmount = ((bookingDetailDTO.paymentInfo?.paymentTotalAmount != 0)
            ? bookingDetailDTO.paymentInfo!.paymentTotalAmount!
            : bookingDetailDTO.paymentInfo!.totalFare)
        .toCurrency();
    return (purchaseProduct: purchaseProduct, totalPayment: totalAmount);
  }
}
