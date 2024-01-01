import 'package:collection/collection.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_filter_item_vm.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_hotel_filter_type.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_filter_option_dto.dart';

class HotelResultFilterViewModel extends BaseViewModel {
  List<List<HotelFilterItemVM>> groupListItems = [];
  bool hasOldFilter = false;
  HotelResultFilterViewModel(List<GtdHotelFilterOptionDTO> listHotelFilterOptionDTO,
      {List<List<HotelFilterItemVM>> savedGroupListItems = const []}) {
    if (savedGroupListItems.isEmpty) {
      var groupItems = listHotelFilterOptionDTO
          .map((e) => HotelFilterItemVM(data: e))
          .groupListsBy((element) => element.data.filterType);
      var sortedGroup = GtdHotelFilterType.listHotelFilterSorted()
          .map(
            (e) {
              return groupItems[e];
            },
          )
          .whereType<List<HotelFilterItemVM>>()
          .toList();
      groupListItems = sortedGroup;
    } else {
      hasOldFilter = true;
      groupListItems = savedGroupListItems.map((e) => e.map((e) => e.clone()).toList()).toList();
    }
  }

  List<GtdHotelFilterOptionDTO> get selectedFiterOption =>
      groupListItems.flattened.where((e) => e.isSelected).map((e) => e.data).toList();

  bool get isEnableApplyButton => selectedFiterOption.isNotEmpty || (hasOldFilter);
}
