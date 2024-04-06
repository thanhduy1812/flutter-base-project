// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/base_view_model.dart';

class PriceBottomViewModel extends BaseViewModel {
  String totalPrice = "";
  String netPrice = "3,327,000 VND";
  String priceTitle;
  String priceSubtitle;

  PriceBottomViewModel({
    this.totalPrice = "",
    this.netPrice = "3,327,000 VND",
    this.priceTitle = "Chi phí / tổng khách",
    this.priceSubtitle = "Đã gồm thuế phí",
  });
}
