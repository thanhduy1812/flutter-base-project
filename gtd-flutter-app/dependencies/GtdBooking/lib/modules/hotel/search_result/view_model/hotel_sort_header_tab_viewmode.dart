import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_repository/gtd_repository.dart';

class HotelSortHeaderTabViewModel extends BaseViewModel {
  List<GtdHotelSortOption> sortOptions = GtdHotelSortOption.values.map((e) => e).toList();
}
