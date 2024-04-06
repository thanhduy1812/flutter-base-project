import 'package:gtd_booking/modules/hotel/search_result/view/hotel_result_content_item/view_model/combo_result_card_item_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_result_content_item/view_model/hotel_result_card_item_viewmodel.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_item_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_search_result_dto.dart';
import 'package:rxdart/rxdart.dart';

import 'hotel_result_map_viewmodel.dart';

class ComboResultMapViewModel extends HotelResultMapViewModel {
  double flightPricePerPerson = 0;

  ComboResultMapViewModel(super.totalNight, super.totalRoom);

  factory ComboResultMapViewModel.fromListHotelItemDTO(
      List<GtdHotelItemDTO> hotelItems, double flightPricePerPerson,
      {required int totalNights, required int totalRoom}) {
    ComboResultMapViewModel viewModel = ComboResultMapViewModel(
      totalNights,
      totalRoom,
    );
    viewModel.hotelCardItemViewModels = hotelItems
        .map((e) => ComboResultCardItemViewModel.fromHotelItemDTO(
              hotelItemDTO: e,
              totalNights: totalNights,
              flightPricePerPerson: flightPricePerPerson,
              totalRoom: totalRoom,
            ))
        .map((e) => e..cardItemType = HotelResultCardItemType.horizontal)
        .toList();
    viewModel.focusMapController.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((event) {
      viewModel.mapController.moveToPoint(
        event,
        zoom: viewModel.zoomLevel,
      );
    });

    viewModel.flightPricePerPerson = flightPricePerPerson;
    return viewModel;
  }

  @override
  void updateMoreItems(GtdHotelSearchResultDTO hotelSearchResultDTO) {
    totalItem = hotelSearchResultDTO.pageData.totalItem;
    totalPage = hotelSearchResultDTO.pageData.totalPage;
    currentPage = hotelSearchResultDTO.pageData.page;
    hasNextPage = hotelSearchResultDTO.pageData.hasNextPage;
    var nextItems = hotelSearchResultDTO.pageData.data
        .map((e) => ComboResultCardItemViewModel.fromHotelItemDTO(
              hotelItemDTO: e,
              flightPricePerPerson: flightPricePerPerson,
              totalNights: totalNight,
              totalRoom: totalRoom,
            ))
        .toList();
    hotelCardItemViewModels.addAll(nextItems);
  }
}
