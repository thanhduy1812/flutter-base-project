import 'package:gtd_booking/modules/confirm_booking/view_model/price_bottom_detail_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/price_bottom_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view_model/flight_summary_item_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_search_room_detail_page_viewmodel.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/air_tickets_resource/air_tickets_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/combo_resource/models/request/gtd_combo_draft_booking_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/hotel_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_item.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/models/gt_hotel_room_detail_dto.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';

class ComboSearchRoomDetailPageViewModel extends HotelSearchRoomDetailPageViewModel {
  final GtdFlightSearchResultDTO flightSearchResultDTO;
    final SearchFlightFormModel searchFlightFormModel;
  ComboSearchRoomDetailPageViewModel(this.flightSearchResultDTO, this.searchFlightFormModel);
  factory ComboSearchRoomDetailPageViewModel.fromRatePlanCombineFlights(
      {String hotelName = "DE AN HOTEL",
      required GtdFlightSearchResultDTO flightSearchResultDTO,
      required SearchFlightFormModel searchFlightFormModel,
      required RatePlan ratePlan,
      required String tripId,
      required GtdHotelRoomDetailDTO hotelRoomDetailDTO}) {
    ComboSearchRoomDetailPageViewModel viewModel = ComboSearchRoomDetailPageViewModel(flightSearchResultDTO, searchFlightFormModel)
      ..ratePlan = ratePlan
      ..tripId = tripId
      ..hotelRoomDetailDTO = hotelRoomDetailDTO;

    viewModel.subTitleNotifer.value = hotelName;

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

  @override
  PriceBottomViewModel get priceBottomViewModel {
    return PriceBottomViewModel(netPrice: netRoomPrice, priceTitle: "Tổng tiền / tổng khách");
  }

  @override
  String get netRoomPrice {
    double flightTaxFees = flighItemDetails
        .map((e) => e.flightItem)
        .map((e) => e.selectedCabinOption)
        .map((e) => e?.priceInfo?.taxFee ?? 0)
        .fold(0, (previousValue, element) => previousValue + element);
    double flightBaseFare = flighItemDetails
        .map((e) => e.flightItem)
        .map((e) => e.selectedCabinOption)
        .map((e) => e?.priceInfo?.basePrice ?? 0)
        .fold(0, (previousValue, element) => previousValue + element);
    double flightNetPrice = flightTaxFees + flightBaseFare;
    double hotelNetPrice = (ratePlan.basePrice?.toDouble() ?? 0) + (ratePlan.taxAndFees?.toDouble() ?? 0);
    return (flightNetPrice + hotelNetPrice).toCurrency();
  }

  @override
  String get totalRoomPrice {
    double flightTaxFees = flighItemDetails
        .map((e) => e.flightItem)
        .map((e) => e.selectedCabinOption)
        .map((e) => e?.priceInfo?.taxFee ?? 0)
        .fold(0, (previousValue, element) => previousValue + element);
    double flightBaseFare = flighItemDetails
        .map((e) => e.flightItem)
        .map((e) => e.selectedCabinOption)
        .map((e) => e?.priceInfo?.basePrice ?? 0)
        .fold(0, (previousValue, element) => previousValue + element);
    double flightTotalPrice = flightTaxFees + flightBaseFare;
    double hotelTotalPrice = (ratePlan.basePriceBeforePromo?.toDouble() ?? 0) + (ratePlan.taxAndFees?.toDouble() ?? 0);
    return (flightTotalPrice + hotelTotalPrice).toCurrency();
  }

  GtdComboDraftBookingRq get createDraftBookingComboRq {
    GtdHotelCheckoutRq hotelCheckoutRq = createCheckoutRq();
    GtdFlightDraftBookingRq flightDraftBookingRq = flightSearchResultDTO.createDraftBookingRq();
    return GtdComboDraftBookingRq(
        createDraftBookingHotelPayload: hotelCheckoutRq, ticketDraftBookingVm: flightDraftBookingRq);
  }
}
