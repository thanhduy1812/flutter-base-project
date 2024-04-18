import 'package:flutter/material.dart';
import 'package:gtd_repository/gtd_repository.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:dvt_helper/dvt_helper.dart';

import '../extension/gtd_app_icon_extension.dart';

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

enum DisplayBookingStatus {
  success(
    "Thanh toán thành công,\n xuất vé thành công",
    Color(0xFF1AA260),
  ),
  failed("Thanh toán thất bại,\n xuất vé thất bại", Color(0xFFDB0D0D)),
  booked("Đang chờ thanh toán,\n vé đang giữ chỗ", Color(0xFF0158A9)),
  pending("Thanh toán thành công,\n xuất vé đang chờ xử lý", Color(0xFFFBB21B)),
  ;

  final String title;
  final Color statusColor;
  const DisplayBookingStatus(this.title, this.statusColor);

  Widget get icon => GTDBookingIcon.iconBookingStatus(status: this);

  Widget get additionalInfo {
    switch (this) {
      case DisplayBookingStatus.pending:
        return Text.rich(
          TextSpan(
            text:
                "Vui lòng theo dõi thông tin cập nhật tình trạng đặt chỗ, được gửi đến Email liên hệ trong thời gian 2 giờ. Vui lòng liên hệ ",
            children: [
              TextSpan(
                  text: "Gotadi 1900-9002 ",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: GTDAppColors.subText)),
              TextSpan(
                  text: "nếu không nhận được Email.",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: GTDAppColors.subText)),
            ],
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: GTDAppColors.subText),
          ),
          textAlign: TextAlign.center,
        );
      case DisplayBookingStatus.booked:
        return Text.rich(
          TextSpan(
            text: "Vui lòng thanh toán trước thời gian giữ vé theo quy định hoặc liên hệ Gotadi ",
            children: [
              TextSpan(
                  text: "Gotadi 1900-9002 ",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: GTDAppColors.subText)),
              TextSpan(
                  text: "nếu cần hỗ trợ.",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: GTDAppColors.subText)),
            ],
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: GTDAppColors.subText),
          ),
          textAlign: TextAlign.center,
        );
      default:
        return const SizedBox();
    }
  }

  static DisplayBookingStatus fromBookingFinalStatus(BookingFinalStatus? bookingFinalStatus) {
    switch (bookingFinalStatus) {
      case BookingFinalStatus.issuedSucceeded:
        return DisplayBookingStatus.success;

      case BookingFinalStatus.bookPending:
      case BookingFinalStatus.bookOnProcess:
      case BookingFinalStatus.bookFailed:
      case BookingFinalStatus.bookCancelled:
      case BookingFinalStatus.bookExpired:
        return DisplayBookingStatus.failed;

      case BookingFinalStatus.paymentPending:
      case BookingFinalStatus.paymentOnProcess:
      case BookingFinalStatus.paymentFailed:
        return DisplayBookingStatus.booked;

      case BookingFinalStatus.issuedPending:
      case BookingFinalStatus.issuedOnProcess:
      case BookingFinalStatus.issuedFailed:
        return DisplayBookingStatus.pending;

      default:
        return DisplayBookingStatus.failed;
    }
  }
}
