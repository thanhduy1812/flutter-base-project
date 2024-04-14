import 'package:gtd_utils/base/view_model/item_select_vm.dart';
import 'package:gtd_repository/gtd_repository.dart';

class GtdMyBookingSupplierItem extends ItemSelectVM<SupplierType> {
  GtdMyBookingSupplierItem({required super.data});

  @override
  String get itemTitle {
    switch (data) {
      case SupplierType.air:
        return "Vé máy bay";
      case SupplierType.hotel:
        return "Khách sạn";
      case SupplierType.combo:
        return "Combo tiết kiệm";

      default:
        return "Unknown";
    }
  }
}
