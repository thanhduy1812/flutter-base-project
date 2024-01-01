// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view_model/flight_summary_item_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';
import 'package:gtd_booking/modules/hotel/form_search/model/search_hotel_form_model.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_search_detail_view/view_model/hotel_search_detail_list_room_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_search_detail_page_viewmodel.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/models/gt_hotel_room_detail_dto.dart';

class ComboHotelSearchDetailPageViewModel extends HotelSearchDetailPageViewModel {
  bool isExpandFlightInfo = false;
  GtdFlightSearchResultDTO? flightSearchResultDTO;
  final SearchFlightFormModel searchFlightFormModel;
  final SearchHotelFormModel searchHotelFormModel;
  ComboHotelSearchDetailPageViewModel(this.searchFlightFormModel, this.searchHotelFormModel) : super();

  factory ComboHotelSearchDetailPageViewModel.fromSearchDetailDTO({GtdFlightSearchResultDTO? flightSearchResultDTO, required SearchFlightFormModel searchFlightFormModel, required SearchHotelFormModel searchHotelFormModel}) {
    ComboHotelSearchDetailPageViewModel viewModel = ComboHotelSearchDetailPageViewModel(searchFlightFormModel,searchHotelFormModel)
      ..flightSearchResultDTO = flightSearchResultDTO;
    return viewModel;
  }

  List<FlightSummaryItemViewModel> get flightItems {
    if (flightSearchResultDTO != null) {
      return FlightSummaryItemViewModel.fromGtdFlightSearchResultDTO(flightSearchResultDTO!);
    } else {
      return [];
    }
  }

  @override
  List<HotelSearchDetailListRoomViewModel> get listRoomViewModels => super.listRoomViewModels.map((e) {
        double? compareFirstPrice =
            super.listRoomViewModels.firstOrNull?.hotelRoomDetailDTO.ratePlans.firstOrNull?.netRoomPricePerNight;
        e.comparePrice = compareFirstPrice;
        return e;
      }).toList();
}
