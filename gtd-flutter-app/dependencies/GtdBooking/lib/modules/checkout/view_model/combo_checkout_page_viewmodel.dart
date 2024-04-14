import 'package:dvt_helper/dvt_helper.dart';
import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';
import 'package:gtd_repository/gtd_repository.dart';


import '../views/gotadi/gtd_checkout_content_viewmodel.dart';
import '../views/gotadi/gtd_combo_checkout_content_viewmodel.dart';
import 'flight_checkout_page_viewmodel.dart';

class ComboCheckoutPageViewModel extends CheckoutPageViewModel {
  final GtdHotelSearchAllRateRq searchAllRateRq;
  final SearchFlightFormModel searchFlightFormModel;
  late GtdCheckoutContentViewModel checkoutContentViewModel;
  ComboCheckoutPageViewModel(
      {required super.bookingDetailDTO, required this.searchAllRateRq, required this.searchFlightFormModel}) {
    title = "Thông tin hành khách";
    checkoutContentViewModel = GtdComboCheckoutContentViewModel(
        bookingDetailDTO: bookingDetailDTO!,
        hotelSearchAllRateRq: searchAllRateRq,
        searchFlightFormModel: searchFlightFormModel);
  }

  @override
  Result<bool, GtdApiError> validateTravelerForm() {
    if (travelerInputInfos.map((e) => e.isPresentHotel).where((element) => element == true).toList().isEmpty) {
      return Error(GtdApiError(message: "Vui lòng chọn đại diện phòng"));
    } else {
      return const Success(true);
    }
  }
}
