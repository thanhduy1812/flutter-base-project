import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_item.dart';

enum ItemFlightType { data, loading }

class ItemFlightComponentViewModel extends BaseViewModel {
  final GtdFlightItem groupItem;
  GtdFlightItem? groupItemSelected;
  final ItemFlightType viewType;

  ItemFlightComponentViewModel(
      {required this.groupItem, required this.groupItemSelected, this.viewType = ItemFlightType.data});

  factory ItemFlightComponentViewModel.loading() {
    return ItemFlightComponentViewModel(
        groupItem: GtdFlightItem(), groupItemSelected: GtdFlightItem(), viewType: ItemFlightType.loading);
  }
}
