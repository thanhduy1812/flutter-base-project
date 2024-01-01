import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_item.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';

class FlightSummaryItemViewModel extends BaseViewModel {
  String titleHeader = "Chuyến đi đã chọn";
  String departDate = "dd/mm/yyyy";
  String arrivalDate = "dd/mm/yyyy";
  String originCode = "SGN";
  String originTime = "hh:00";
  String destinationCode = "DAD";
  String destinationTime = "hh:00";
  String duration = "15h20p";
  String cabinclass = "Phổ thông(T)";
  String transitionTitle = "Bay thang";
  String airlineLogo = "";
  String airlineInfo = "VN204 | Airbus A321";

  GtdFlightItemDetail? flightItemDetail;
  FlightSummaryItemViewModel();
  factory FlightSummaryItemViewModel.fromItemDetail({required GtdFlightItemDetail flightItemDetail}) {
    FlightSummaryItemViewModel viewModel = FlightSummaryItemViewModel();
    viewModel.flightItemDetail = flightItemDetail;
    viewModel.titleHeader = flightItemDetail.flightDirection == FlightDirection.d
        ? 'flight.flightDirection.departure'
        : 'flight.flightDirection.return';
    viewModel.originCode = flightItemDetail.flightItem.flightItemInfo?.originLocation?.locationCode ?? "";
    viewModel.originTime = flightItemDetail.flightItem.flightItemInfo?.originTime ?? "";
    viewModel.destinationCode = flightItemDetail.flightItem.flightItemInfo?.destinationLocation?.locationCode ?? "";
    viewModel.destinationTime = flightItemDetail.flightItem.flightItemInfo?.destinationTime ?? "";
    viewModel.duration = flightItemDetail.flightItem.flightItemInfo?.journeyDurationDate() ?? "";
    viewModel.airlineLogo = flightItemDetail.flightItem.flightItemInfo?.airlineLogo ?? "";
    viewModel.airlineInfo = flightItemDetail.flightItem.flightItemInfo?.flightDetailSubtitle ?? "";
    viewModel.departDate = flightItemDetail.flightItem.flightItemInfo?.originDateTime?.utcDate("dd/MM/yyyy") ?? "";
    viewModel.arrivalDate = flightItemDetail.flightItem.flightItemInfo?.destinationDateTime?.utcDate("dd/MM/yyyy") ?? "";
    viewModel.transitionTitle = flightItemDetail.flightItem.transitInfos.length == 1
        ? "Bay thẳng"
        : "${flightItemDetail.flightItem.transitInfos.length} điểm dừng";
    return viewModel;
  }

  factory FlightSummaryItemViewModel.fromFlightItem(
      {required GtdFlightItem flightItem, required FlightDirection flightDirection}) {
    FlightSummaryItemViewModel viewModel = FlightSummaryItemViewModel();
    viewModel.titleHeader =
        flightDirection == FlightDirection.d ? 'flight.flightDirection.departure' : 'flight.flightDirection.return';
    viewModel.originCode = flightItem.flightItemInfo?.originLocation?.locationCode ?? "";
    viewModel.originTime = flightItem.flightItemInfo?.originTime ?? "";
    viewModel.destinationCode = flightItem.flightItemInfo?.destinationLocation?.locationCode ?? "";
    viewModel.destinationTime = flightItem.flightItemInfo?.destinationTime ?? "";
    viewModel.duration = flightItem.flightItemInfo?.journeyDurationDate() ?? "";
    viewModel.airlineLogo = flightItem.flightItemInfo?.airlineLogo ?? "";
    viewModel.airlineInfo = flightItem.flightItemInfo?.flightDetailSubtitle ?? "";
    viewModel.departDate = flightItem.flightItemInfo?.originDateTime?.utcDate("dd/MM/yyyy") ?? "";
    viewModel.arrivalDate = flightItem.flightItemInfo?.destinationDateTime?.utcDate("dd/MM/yyyy") ?? "";
    viewModel.transitionTitle =
        flightItem.transitInfos.length == 1 ? "Bay thẳng" : "${flightItem.transitInfos.length} điểm dừng";
    viewModel.flightItemDetail = GtdFlightItemDetail(flightDirection: flightDirection, flightItem: flightItem);
    return viewModel;
  }

  static List<FlightSummaryItemViewModel> fromGtdFlightSearchResultDTO(GtdFlightSearchResultDTO searchResultDTO) {
    List<FlightSummaryItemViewModel> items = [];
    var departFlightItem = searchResultDTO.departureItinerary?.selectedFlightItem;
    var returnFlightItem = searchResultDTO.returnItinerary?.selectedFlightItem;
    if (departFlightItem != null) {
      items.add(
          FlightSummaryItemViewModel.fromFlightItem(flightItem: departFlightItem, flightDirection: FlightDirection.d));
    }
    if (returnFlightItem != null) {
      items.add(
          FlightSummaryItemViewModel.fromFlightItem(flightItem: returnFlightItem, flightDirection: FlightDirection.r));
    }
    return items;
  }
}
