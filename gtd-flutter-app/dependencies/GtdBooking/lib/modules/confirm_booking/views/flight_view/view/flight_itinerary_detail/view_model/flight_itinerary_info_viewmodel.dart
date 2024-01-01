// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/meta_resource/meta_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';

class FlightItineraryInfoViewModel extends BaseViewModel {
  final int indexItem;
  String openrationAirline = "Vietjet";
  String airlineName = "Bamboo Airways";
  String duration = "Thời gian bay 1h20p";
  String transitInfo = "Quá cảnh 1h40p";
  String cabinClassCode = "J1_Eco";
  String cabinClassType = "Phổ thông";
  String stopsInfo = "Bay thẳng";
  String airlineLogo = "url";
  String airlineInfo = "QH170 | Airbus A320";
  String departTime = "hh:00";
  String departLocation = "Hồ Chí Minh (SGN)";
  String departDate = "T2, 17/10/2022";
  String departAirport = "Sân bay Tân Sơn Nhất";
  String destinationTime = "hh:00";
  String destinationLocation = "Hồ Chí Minh (SGN)";
  String destinationDate = "T2, 17/10/2022";
  String destinationAirport = "Sân bay Tân Sơn Nhất";
// FlightItemDetail
  FlightItineraryInfoViewModel({
    required this.indexItem,
  });

  factory FlightItineraryInfoViewModel.fromFlightItem(
      {required int indexItem, required GtdFlightItemDetail flightItemDetail}) {
    FlightItineraryInfoViewModel viewModel = FlightItineraryInfoViewModel(indexItem: indexItem);

    FlightSegment flightSegment = flightItemDetail.flightItem.transitInfos[indexItem];
    viewModel.openrationAirline = flightSegment.operatingAirline?.code ?? "";
    viewModel.airlineName = flightSegment.operatingAirline?.name ?? "";
    viewModel.duration = "Thời gian bay ${flightSegment.journeyDurationDate()}";
    viewModel.transitInfo =
        flightSegment.stopQuantity != 0 ? "Quá cảnh ${flightSegment.stopQuantityDurationHour()}" : "Quá cảnh 0h";
    viewModel.cabinClassCode = "${flightSegment.cabinClassCode}";
    viewModel.cabinClassType = "${flightItemDetail.flightItem.cabinOptions?.firstOrNull?.cabinClassName}";
    viewModel.stopsInfo = flightItemDetail.flightItem.transitInfos.length == 1
        ? "Bay thẳng"
        : "${flightItemDetail.flightItem.transitInfos.length} điểm dừng";
    viewModel.airlineLogo = flightSegment.airlineLogo;
    viewModel.airlineInfo = flightSegment.flightDetailSubtitle;
    viewModel.departTime = flightSegment.departureTime;
    viewModel.departLocation = "${flightSegment.departureCity} (${flightSegment.departureAirportLocationCode})";
    viewModel.departDate = flightSegment.departureDate;
    viewModel.departAirport = flightSegment.departureAirportLocationName ?? "-";
    viewModel.destinationTime = flightSegment.arrivalTime;
    viewModel.destinationLocation = "${flightSegment.arrivalCity} (${flightSegment.arrivalAirportLocationCode})";
    viewModel.destinationDate = flightSegment.arrivalDate;
    viewModel.destinationAirport = flightSegment.arrivalAirportLocationName ?? "-";
    return viewModel;
  }
}
