import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_item.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/helpers/extension/string_extension.dart';

enum ItemFlightType { data, loading }

class ItemFlightComponentViewModel extends BaseViewModel {
  final GtdFlightItem groupItem;
  GtdFlightItem? groupItemSelected;
  final ItemFlightType viewType;
  final FlightType flightType;

  ItemFlightComponentViewModel({
    required this.groupItem,
    required this.groupItemSelected,
    this.viewType = ItemFlightType.data,
    this.flightType = FlightType.dom,
  });

  factory ItemFlightComponentViewModel.loading() {
    return ItemFlightComponentViewModel(
      groupItem: GtdFlightItem(),
      groupItemSelected: GtdFlightItem(),
      viewType: ItemFlightType.loading,
    );
  }

  String getFlightCodeText() {
    final info = groupItem.flightItemInfo;
    String title = '';
    if (flightType == FlightType.dom) {
      if (info?.airline == 'BL') {
        title = 'VN';
      } else {
        title = info?.airline ?? '';
      }
      title = '$title${info?.flightNo ?? ''}';
      final aircraft = info?.aircraft;
      if (!aircraft.isNullOrEmpty()) {
        title = '$title | $aircraft';
      }
    } else {
      final segments = info?.flightSegments ?? [];
      if (segments.isNotEmpty) {
        title = '${segments.first.operatingAirline?.code ?? ''}'
            '${segments.first.operatingAirline?.flightNumber ?? ''}';
      }
      if (info?.airline == 'BL' || info?.airline == 'VN') {
        title = '$title | ${segments.first.aircraft ?? ''}';
      }
      if (segments.length > 1) {
        for (int i = 1; i < segments.length; i++) {
          title = '$title | ${segments[i].operatingAirline?.code ?? ''}'
              '${segments[i].operatingAirline?.flightNumber ?? ''}';
        }
      }
    }
    return title;
  }
}
