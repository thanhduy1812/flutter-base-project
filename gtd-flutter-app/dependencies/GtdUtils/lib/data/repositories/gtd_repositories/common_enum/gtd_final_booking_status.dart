import 'package:flutter/material.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';

enum BookingFinalStatus {
  bookPending("BOOK_PENDING"),
  bookOnProcess("BOOK_ON_PROCESS"),
  bookFailed("BOOK_FAILED"),
  bookCancelled("BOOK_CANCELLED"),
  bookExpired("BOOK_EXPIRED"),
  paymentPending("PAYMENT_PENDING"),
  paymentOnProcess("PAYMENT_ON_PROCESS"),
  paymentFailed("PAYMENT_FAILED"),
  issuedPending("ISSUED_PENDING"),
  issuedOnProcess("ISSUED_ON_PROCESS"),
  issuedFailed("ISSUED_FAILED"),
  issuedSucceeded("ISSUED_SUCCEEDED");

  final String value;
  const BookingFinalStatus(this.value);
  static BookingFinalStatus? findByStatus(String finalStatus) {
    return BookingFinalStatus.values.where((element) => element.value == finalStatus).firstOrNull;
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

  Widget get icon => GtdAppIcon.iconBookingStatus(status: this);

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
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.subText)),
              TextSpan(
                  text: "nếu không nhận được Email.",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText)),
            ],
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText),
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
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.subText)),
              TextSpan(
                  text: "nếu cần hỗ trợ.",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText)),
            ],
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText),
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
