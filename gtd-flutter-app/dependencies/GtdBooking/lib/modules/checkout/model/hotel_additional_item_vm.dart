
import 'package:gtd_utils/base/view_model/item_select_vm.dart';

enum HotelAdditionalItem {
  noSmoking("Phòng không hút thuốc"),
  quietRoom("Phòng yên tĩnh"),
  highFloor("Phòng ở tầng cao"),
  bedType("Loại giường"),
  checkinout("Giờ nhận / trả phòng");

  final String title;
  const HotelAdditionalItem(this.title);
}
class HotelAdditionalItemVM extends ItemSelectVM<HotelAdditionalItem> {
  HotelAdditionalItemVM({required super.data});
}