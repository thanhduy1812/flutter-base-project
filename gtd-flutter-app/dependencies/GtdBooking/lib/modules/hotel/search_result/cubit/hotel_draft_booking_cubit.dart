import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/request/gtd_hotel_checkout_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/gtd_hotel_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

part 'hotel_draft_booking_state.dart';

class HotelDraftBookingCubit extends Cubit<HotelDraftBookingState> {
  HotelDraftBookingCubit() : super(HotelDraftBookingInitial());

  Future<Result<BookingDetailDTO, GtdApiError>> draftBookingHotel(GtdHotelCheckoutRq checkoutRq) async {
    var result = await GtdHotelRepository.shared.draftBookingHotel(checkoutRq);
    return result;
  }
}
