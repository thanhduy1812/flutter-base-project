import 'package:gtd_booking/modules/checkout/views/gotadi/gtd_checkout_content_viewmodel.dart';
import 'package:gtd_booking/modules/checkout/views/gotadi/gtd_hotel_checkout_content_viewmodel.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/request/gtd_hotel_search_all_rate_rq.dart';

import 'flight_checkout_page_viewmodel.dart';

class HotelCheckoutPageViewModel extends CheckoutPageViewModel {
  final GtdHotelSearchAllRateRq searchAllRateRq;
  late GtdCheckoutContentViewModel checkoutContentViewModel;

  HotelCheckoutPageViewModel(
      {required super.bookingDetailDTO, required this.searchAllRateRq}) {
    title = "Thông tin hành khách";
    subTitle = "${searchAllRateRq.adult} Người lớn"
        "${searchAllRateRq.child > 0 ? " "
            "${searchAllRateRq.child} , trẻ em" : ""}";
    subTitleNotifer.value = subTitle!;
    checkoutContentViewModel = GtdHotelCheckoutContentViewModel(
      bookingDetailDTO: bookingDetailDTO!,
      hotelSearchAllRateRq: searchAllRateRq,
    );
  }
}
