import 'package:gtd_booking/modules/my_booking/model/gtd_my_booking_supplier_item.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';

class GtdMyBookingPageViewModel extends BasePageViewModel {
  List<GtdMyBookingSupplierItem> filterSupplierItems =
      SupplierType.values.map((e) => GtdMyBookingSupplierItem(data: e)).toList()..first.isSelected = true;
  GtdMyBookingPageViewModel() {
    title = "Quản lý đặt chỗ";
  }
}
