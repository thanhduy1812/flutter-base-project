// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';

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
