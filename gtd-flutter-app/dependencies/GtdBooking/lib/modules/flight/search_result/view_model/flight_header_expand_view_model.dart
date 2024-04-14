import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view_model/flight_summary_item_viewmodel.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_repository/gtd_repository.dart';

class FlightheaderExpandViewModel extends BaseViewModel {
  bool isExpandFlightInfo = true;
  List<FlightSummaryItemViewModel> flighItems = [];
  GtdFlightSearchResultDTO? flightSearchResultDTO;
  FlightheaderExpandViewModel({this.isExpandFlightInfo = true});

  factory FlightheaderExpandViewModel.fromFlightSearchResultDTO(
      {required GtdFlightSearchResultDTO flightSearchResultDTO}) {
    FlightheaderExpandViewModel viewModel = FlightheaderExpandViewModel()
      ..flighItems = FlightSummaryItemViewModel.fromGtdFlightSearchResultDTO(flightSearchResultDTO);
    return viewModel;
  }

  factory FlightheaderExpandViewModel.fromFlightSummaryItemViewModel(
      {required List<FlightSummaryItemViewModel> flighItems}) {
    FlightheaderExpandViewModel viewModel = FlightheaderExpandViewModel()..flighItems = flighItems;
    return viewModel;
  }
}
