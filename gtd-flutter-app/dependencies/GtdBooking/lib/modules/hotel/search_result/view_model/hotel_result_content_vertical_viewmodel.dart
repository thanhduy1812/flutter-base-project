// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/base_view_model.dart';

import 'package:gtd_booking/modules/hotel/search_result/view/hotel_result_content_item/view_model/hotel_result_card_item_viewmodel.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_search_result_dto.dart';

class HotelResultContentVerticalViewModel extends BaseViewModel {
  List<HotelResultCardItemViewModel> hotelCardItemViewModels = [];

  int totalItem = 0;
  int currentPage = 0;
  int totalPage = 0;
  bool hasNextPage = false;
  final int totalNights;
  final int totalRoom;

  HotelResultContentVerticalViewModel({
    required this.totalNights,
    required this.totalRoom,
  });

  factory HotelResultContentVerticalViewModel.fromHotelSearchDTO(
    GtdHotelSearchResultDTO hotelSearchResultDTO, {
    required int totalNights,
    required int totalRoom,
  }) {
    HotelResultContentVerticalViewModel viewModel =
        HotelResultContentVerticalViewModel(
      totalNights: totalNights,
      totalRoom: totalRoom,
    );
    viewModel.totalItem = hotelSearchResultDTO.pageData.totalItem;
    viewModel.totalPage = hotelSearchResultDTO.pageData.totalPage;
    viewModel.currentPage = hotelSearchResultDTO.pageData.page;
    viewModel.hasNextPage = hotelSearchResultDTO.pageData.hasNextPage;
    viewModel.hotelCardItemViewModels = hotelSearchResultDTO.pageData.data
        .map((e) => HotelResultCardItemViewModel.fromHotelItemDTO(
              hotelItemDTO: e,
              totalNight: totalNights,
              totalRoom: totalRoom,
            ))
        .toList();
    return viewModel;
  }

  void updateMoreItems(GtdHotelSearchResultDTO hotelSearchResultDTO) {
    totalItem = hotelSearchResultDTO.pageData.totalItem;
    totalPage = hotelSearchResultDTO.pageData.totalPage;
    currentPage = hotelSearchResultDTO.pageData.page;
    hasNextPage = hotelSearchResultDTO.pageData.hasNextPage;
    var nextItems = hotelSearchResultDTO.pageData.data
        .map((e) => HotelResultCardItemViewModel.fromHotelItemDTO(
              hotelItemDTO: e,
              totalNight: totalNights,
              totalRoom: totalRoom,
            ))
        .toList();
    hotelCardItemViewModels.addAll(nextItems);
  }

  void addLoadingItems() {
    List<HotelResultCardItemViewModel> hotelCardItemLoadingViewModels =
        Iterable<int>.generate(4)
            .map((e) => HotelResultCardItemViewModel(
                  cardItemType: HotelResultCardItemType.loading,
                  totalNight: totalNights,
                  totalRoom: totalRoom,
                ))
            .toList();
    hotelCardItemViewModels.addAll(hotelCardItemLoadingViewModels);
  }

  void finishLoadingItems() {
    hotelCardItemViewModels.removeWhere(
        (element) => element.cardItemType == HotelResultCardItemType.loading);
  }
}
