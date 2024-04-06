import 'package:gtd_booking/modules/checkout/views/gotadi/gtd_checkout_content_viewmodel.dart';
import 'package:gtd_booking/modules/checkout/views/gotadi/gtd_flight_checkout_content_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/pricing_bottom_page_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';
import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

class CheckoutPageViewModel extends PricingBottomPageViewModel {
  bool isTaxReceipt = false;

  CheckoutPageViewModel({required super.bookingDetailDTO});

  Result<bool, GtdApiError> validateTravelerForm() {
    throw UnimplementedError();
  }
}

class FlightCheckoutPageViewModel extends CheckoutPageViewModel {
  late GtdCheckoutContentViewModel checkoutContentViewModel;
  final SearchFlightFormModel searchFlightFormModel;

  FlightCheckoutPageViewModel({
    required super.bookingDetailDTO,
    required this.searchFlightFormModel,
  }) {
    checkoutContentViewModel = GtdFlightCheckoutContentViewModel(
      bookingDetailDTO: bookingDetailDTO!,
      searchFlightFormModel: searchFlightFormModel,
    );
    subTitle = searchFlightFormModel.passengerCountSubtitle();
  }
}
