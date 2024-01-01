import 'dart:async';

import 'package:gtd_booking/modules/payment/views/promotions/view_model/voucher_item_viewmodel.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';

class ListVoucherViewModel extends BaseViewModel {
  bool hasLimited = true;
  bool isNearExpired = true;
  bool isSelected = true;
  List<VoucherItemViewModel> voucherVMs =
      [1, 2, 3, 4, 5, 6, 7, 8, 9].map((e) => VoucherItemViewModel(data: "voucher")).toList();
  StreamController<String> querySearchController = StreamController();
}
