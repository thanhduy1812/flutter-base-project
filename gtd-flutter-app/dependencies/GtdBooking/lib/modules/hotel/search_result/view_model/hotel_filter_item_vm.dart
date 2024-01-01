import 'package:gtd_utils/base/view_model/item_select_vm.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_filter_option_dto.dart';

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
