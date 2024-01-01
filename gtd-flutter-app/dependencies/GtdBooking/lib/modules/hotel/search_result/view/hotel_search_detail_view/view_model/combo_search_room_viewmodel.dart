import 'package:gtd_booking/modules/confirm_booking/view_model/price_bottom_detail_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view_model/flight_summary_item_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';
import 'package:gtd_booking/modules/hotel/form_search/model/search_hotel_form_model.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_search_detail_view/view_model/hotel_search_room_viewmodel.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/air_tickets_resource/air_tickets_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/combo_resource/combo_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/hotel_resource.dart';

import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';

class ComboSearchRoomViewModel extends HotelSearchRoomViewModel {
  final GtdFlightSearchResultDTO flightSearchResultDTO;
  final SearchFlightFormModel searchFlightFormModel;
  final SearchHotelFormModel searchHotelFormModel;
  ComboSearchRoomViewModel(this.flightSearchResultDTO, this.searchFlightFormModel, this.searchHotelFormModel);

  factory ComboSearchRoomViewModel.fromRatePlanCombineFlight(
      {required GtdFlightSearchResultDTO flightSearchResultDTO,
      required SearchFlightFormModel searchFlightFormModel,
      required SearchHotelFormModel searchHotelFormModel,
      required RatePlan ratePlan,
      required String tripId,
      required String roomId}) {
    ComboSearchRoomViewModel viewModel =
        ComboSearchRoomViewModel(flightSearchResultDTO, searchFlightFormModel, searchHotelFormModel)
          ..ratePlan = ratePlan
          ..roomId = roomId
          ..tripId = tripId;
    return viewModel;
  }

  List<GtdFlightItemDetail> get flighItemDetails {
    return FlightSummaryItemViewModel.fromGtdFlightSearchResultDTO(flightSearchResultDTO)
        .map((e) => e.flightItemDetail)
        .whereType<GtdFlightItemDetail>()
        .toList();
  }

  @override
  PriceBottomDetailViewModel get priceBottomDetailViewModel {
    return PriceBottomDetailViewModel.fromRatePlanCombineFlights(ratePlan, flighItemDetails);
  }

  GtdComboDraftBookingRq get createDraftBookingComboRq {
    GtdHotelCheckoutRq hotelCheckoutRq = createCheckoutRq();
    GtdFlightDraftBookingRq flightDraftBookingRq = flightSearchResultDTO.createDraftBookingRq();
    return GtdComboDraftBookingRq(
        createDraftBookingHotelPayload: hotelCheckoutRq, ticketDraftBookingVm: flightDraftBookingRq);
  }
}
