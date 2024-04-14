// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_repository/gtd_repository.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';

class FinalBookingReservationViewModel extends BaseViewModel {
  late List<GtdFlightItemDetail> flightItemDetails;
  late List<HotelProductDetail> hotelProductDetails;
  FinalBookingReservationViewModel({
    required BookingDetailDTO bookingDetailDTO,
  }) {
    flightItemDetails = bookingDetailDTO.flightDetailItems ?? [];
    hotelProductDetails = [bookingDetailDTO.hotelProductDetail].where((element) => element?.hotelProduct != null).whereType<HotelProductDetail>().toList();
  }
}
