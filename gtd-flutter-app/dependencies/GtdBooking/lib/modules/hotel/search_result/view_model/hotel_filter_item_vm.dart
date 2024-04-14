import 'package:gtd_utils/base/view_model/item_select_vm.dart';
import 'package:gtd_repository/gtd_repository.dart';

class HotelFilterItemVM extends ItemSelectVM<GtdHotelFilterOptionDTO> {
  HotelFilterItemVM({required super.data});

  @override
  String get itemTitle => data.name;

  HotelFilterItemVM clone() {
    HotelFilterItemVM newItem = HotelFilterItemVM(data: data);
    newItem.isSelected = isSelected;
    return newItem;
  }
}
