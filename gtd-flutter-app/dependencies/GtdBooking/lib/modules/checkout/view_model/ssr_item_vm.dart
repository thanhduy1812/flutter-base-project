// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/item_select_vm.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';

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
