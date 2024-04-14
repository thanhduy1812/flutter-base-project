import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dvt_helper/dvt_helper.dart';
import 'package:gtd_repository/gtd_repository.dart';

part 'hotel_draft_booking_state.dart';

class HotelDraftBookingCubit extends Cubit<HotelDraftBookingState> {
  HotelDraftBookingCubit() : super(HotelDraftBookingInitial());

  Future<Result<BookingDetailDTO, GtdApiError>> draftBookingHotel(GtdHotelCheckoutRq checkoutRq) async {
    var result = await GtdHotelRepository.shared.draftBookingHotel(checkoutRq);
    return result;
  }
}
