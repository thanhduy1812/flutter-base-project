import 'package:gtd_utils/base/view_model/item_select_vm.dart';
import 'package:gtd_repository/gtd_repository.dart';

class KredivoOptionVM extends ItemSelectVM<GtdLoanKredivoMonth> {
  KredivoOptionVM({required super.data});

  @override
  String get itemTitle => "Thời hạn";

  @override
  String get itemSubTitle => "${data.key} tháng";
}
