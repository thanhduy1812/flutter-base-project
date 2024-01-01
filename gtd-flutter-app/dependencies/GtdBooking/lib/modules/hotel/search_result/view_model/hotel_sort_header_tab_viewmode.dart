import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_hotel_sort_option.dart';

class HotelSortHeaderTabViewModel extends BaseViewModel {
  List<GtdHotelSortOption> sortOptions = GtdHotelSortOption.values.map((e) => e).toList();
}
