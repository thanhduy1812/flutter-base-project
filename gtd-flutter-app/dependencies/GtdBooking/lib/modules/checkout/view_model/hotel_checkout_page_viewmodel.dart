import 'package:gtd_booking/modules/checkout/views/gotadi/gtd_checkout_content_viewmodel.dart';
import 'package:gtd_booking/modules/checkout/views/gotadi/gtd_hotel_checkout_content_viewmodel.dart';
import 'package:gtd_repository/gtd_repository.dart';

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
