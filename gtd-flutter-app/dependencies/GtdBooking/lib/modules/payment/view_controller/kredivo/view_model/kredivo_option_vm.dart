import 'package:gtd_utils/base/view_model/item_select_vm.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/payment_resource/payment_resource.dart';

class KredivoOptionVM extends ItemSelectVM<GtdLoanKredivoMonth> {
  KredivoOptionVM({required super.data});

  @override
  String get itemTitle => "Thời hạn";

  @override
  String get itemSubTitle => "${data.key} tháng";
}
