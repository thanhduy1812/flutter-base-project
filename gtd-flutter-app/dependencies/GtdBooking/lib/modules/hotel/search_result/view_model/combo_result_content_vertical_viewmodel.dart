
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_result_content_vertical_viewmodel.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_search_result_dto.dart';

import '../view/hotel_result_content_item/view_model/combo_result_card_item_viewmodel.dart';

class ComboResultContentVerticalViewModel extends HotelResultContentVerticalViewModel {
    double flightPricePerPerson = 0;
  ComboResultContentVerticalViewModel({required super.totalNights});
  factory ComboResultContentVerticalViewModel.fromHotelSearchDTO(
      GtdHotelSearchResultDTO hotelSearchResultDTO, double flightPricePerPerson, {required int totalNights}) {
    ComboResultContentVerticalViewModel viewModel = ComboResultContentVerticalViewModel(totalNights: totalNights);
    viewModel.totalItem = hotelSearchResultDTO.pageData.totalItem;
    viewModel.totalPage = hotelSearchResultDTO.pageData.totalPage;
    viewModel.currentPage = hotelSearchResultDTO.pageData.page;
    viewModel.hasNextPage = hotelSearchResultDTO.pageData.hasNextPage;
    viewModel.hotelCardItemViewModels = hotelSearchResultDTO.pageData.data
        .map((e) => ComboResultCardItemViewModel.fromHotelItemDTO(hotelItemDTO: e, totalNights: totalNights, flightPricePerPerson: flightPricePerPerson))
        .toList();
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
        .map((e) => ComboResultCardItemViewModel.fromHotelItemDTO(hotelItemDTO: e, flightPricePerPerson: flightPricePerPerson, totalNights: totalNights))
        .toList();
    hotelCardItemViewModels.addAll(nextItems);
  }

}
