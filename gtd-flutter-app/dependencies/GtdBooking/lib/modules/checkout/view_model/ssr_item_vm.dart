// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dvt_helper/dvt_helper.dart';
import 'package:gtd_repository/gtd_repository.dart';
import 'package:gtd_utils/base/view_model/item_select_vm.dart';

class SsrItemVM extends ItemSelectVM<SsrOfferDTO> {
  SsrItemVM({required super.data});

  @override
  String get itemTitle => "${data.ssrName} - ${data.ssrAmount.toCurrency()}";

  @override
  String get itemSubTitle => "";

  String get price {
    if (data.ssrAmount == 0) {
      return "Miễn phí";
    } else {
      return data.ssrAmount.toCurrency();
    }
  }

  String get displayName => data.ssrName;
}
