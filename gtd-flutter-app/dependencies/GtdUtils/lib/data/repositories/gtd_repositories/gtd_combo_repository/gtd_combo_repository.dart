

import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/hotel_resource.dart';

import '../../gtd_api_client/air_tickets_resource/air_tickets_resource.dart';
import '../../gtd_api_client/booking_resource/booking_resource.dart';
import '../../gtd_api_client/combo_resource/combo_resource.dart';
import '../../gtd_repository_error/gtd_api_error.dart';
import '../gtd_booking_repository/dto/booking_detail_dto.dart';

class GtdComboRepository {
  final ComboResourceApi comboResourceApi = ComboResourceApi.shared;
  final HotelResourceApi hotelResourceApi = HotelResourceApi.shared;
  final BookingResourceApi bookingResourceApi = BookingResourceApi.shared;

  GtdComboRepository._();
  static final shared = GtdComboRepository._();

  Future<Result<BookingDetailDTO, GtdApiError>> draftBookingCombo(GtdComboDraftBookingRq comboDraftBookingRq) async {
    try {
      final response = await hotelResourceApi
          .checkoutHotel(comboDraftBookingRq.createDraftBookingHotelPayload)
          .then((value) => comboResourceApi.draftBookingCombo(comboDraftBookingRq))
          .then((value) => bookingResourceApi.getBookingDetailByBookingNumber(value));
      if (response.bookingNumber == null) {
        throw GtdApiError(message: "Booking number is empty");
      }
      var bookingDetailDTO = BookingDetailDTO()..mappingBookingDetail(response);
      return Success(bookingDetailDTO);
    } on GtdApiError catch (e) {
      Logger.e("draftBookingCombo: $e");
      return Error(e);
    }
  }

  Future<Result<AddBookingTravellerRs, GtdApiError>> addBookingTraveller(
      AddBookingTravellerRq addBookingTravellerRq) async {
    try {
      AddBookingTravellerRs addBookingTravellerRs =
          await comboResourceApi.addBookingTravellerCombo(addBookingTravellerRq);
      // Handle error from draftBookingRs
      if (addBookingTravellerRs.success == false || addBookingTravellerRs.errors?.isNotEmpty == true) {
        return Error(GtdApiError.fromErrorRs(addBookingTravellerRs.errors ?? []));
      }
      return Success(addBookingTravellerRs);
    } on GtdApiError catch (e) {
      Logger.e("addBookingTravellerCombo: $e");
      return Error(e);
    }
  }
}
