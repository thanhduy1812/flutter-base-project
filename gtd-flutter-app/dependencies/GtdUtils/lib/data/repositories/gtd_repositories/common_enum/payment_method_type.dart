import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';

enum PaymentMethodType {
  atm("payment-atm", "Thẻ ATM nội địa", "International banking", "", "", "ATM_DEBIT"),
  credit("payment-credit", "Thẻ tín dụng quốc tế", "Visa, Mastercard, JCB", "", "", "CREDIT"),
  vnpayCredit("payment-credit", "Thẻ tín dụng quốc tế", "Credit Card: Visa, Master card, JCB", "", "", "VNPAY_CREDIT"),
  qr("payment-qr", "Thanh toán bằng QR code qua cổng ứng dụng VN Pay", "", "", "", "VNPAYQR"),
  zaloPay("payment-zalo", "Thanh toán bằng ví Zalo Pay", "", "-50,000 VND",
      "Dành cho khách hàng lần đầu thanh toán qua ví Zalo Pay", "ZALO"),
  viettelPay("payment-viettel", "Thanh toán bằng ví Vietel Pay", "", "", "", "VIETTELPAY"),
  momo("payment-momo", "Thanh toán bằng ví Momo", "", "", "", "MOMO"),
  payoo("payment-payoo", "Thanh toán qua Payoo ở các cửa hàng tiện lợi", "", "", "", "PAYOO"),
  kredivo("payment-kredivo", "Thanh toán trả góp Kredivo", "", "Trả góp lãi suất 0%",
      "Duyệt nhanh chóng với CMND/CCCD chỉ từ 0% & trả góp linh hoạt lên đến 3 tháng", "KREDIVO"),
  paylater("payment-later", "Giữ chỗ, chờ thanh toán sau", "", "",
      "Thanh toán trực tiếp tại văn phòng hoặc chuyển khoản", "CASH");

  final String iconName;
  final String title;
  final String desTitle;
  final String discount;
  final String subTitle;
  final String code;
  const PaymentMethodType(this.iconName, this.title, this.desTitle, this.discount, this.subTitle, this.code);

  Widget get iconImage {
    var image = GtdImage.svgFromSupplier(assetName: 'assets/payment/$iconName.svg');
    return image;
  }

  bool get hasPaymentFee {
    switch (this) {
      case PaymentMethodType.credit:
        return true;
      case PaymentMethodType.vnpayCredit:
        return true;
      case PaymentMethodType.atm:
        return true;
      case PaymentMethodType.qr:
        return true;
      case PaymentMethodType.viettelPay:
        return true;
      case PaymentMethodType.momo:
        return true;
      case PaymentMethodType.zaloPay:
        return true;
      case PaymentMethodType.payoo:
        return true;
      case PaymentMethodType.paylater:
        return false;
      // case PaymentMethodType.balance:
      //     return true;
      // case PaymentMethodType.airPay:
      //     return true;
      case PaymentMethodType.kredivo:
        return true;
      default:
        return false;
    }
  }

  bool get allowPromotion {
    switch (this) {
      case PaymentMethodType.credit:
        return true;
      case PaymentMethodType.vnpayCredit:
        return true;
      case PaymentMethodType.atm:
        return true;
      case PaymentMethodType.qr:
        return true;
      case PaymentMethodType.viettelPay:
        return true;
      case PaymentMethodType.momo:
        return true;
      case PaymentMethodType.zaloPay:
        return true;
      case PaymentMethodType.payoo:
        return false;
      case PaymentMethodType.paylater:
        return false;
      // case PaymentMethodType.balance:
      //     return true;
      // case PaymentMethodType.airPay:
      //     return true;
      case PaymentMethodType.kredivo:
        return true;
      default:
        return false;
    }
  }

  static PaymentMethodType? paymentItemTypeWithCode(String code) {
    return PaymentMethodType.values.firstWhereOrNull((element) => element.code == code);
  }

  static List<PaymentMethodType> findByCodes(List<String> codes) {
    return codes.map((e) => PaymentMethodType.paymentItemTypeWithCode(e)).whereType<PaymentMethodType>().toList();
  }
}
