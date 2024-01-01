import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';

class FlightSearchingLoadingPageViewModel extends BasePageViewModel {
  final SearchFlightFormModel searchInfoFlightVM;
  FlightSearchingLoadingPageViewModel({required this.searchInfoFlightVM}) {
    extendBodyBehindAppBar = true;
  }
}
