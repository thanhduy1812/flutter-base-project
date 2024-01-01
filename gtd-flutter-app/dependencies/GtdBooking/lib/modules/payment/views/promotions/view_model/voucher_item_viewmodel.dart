import 'package:gtd_utils/base/view_model/item_select_vm.dart';

class VoucherItemViewModel extends ItemSelectVM<String> {
  bool hasLimited = true;
  bool isNearExpired = true;
  VoucherItemViewModel({required super.data});
}
