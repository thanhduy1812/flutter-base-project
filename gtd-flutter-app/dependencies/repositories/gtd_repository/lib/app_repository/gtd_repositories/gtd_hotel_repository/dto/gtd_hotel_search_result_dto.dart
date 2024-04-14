

import 'package:gtd_repository/app_repository/gtd_api_client/hotel_resource/hotel_resource.dart';

import '../../../common_model/gtd_paging_dto.dart';
import 'gtd_hotel_item_dto.dart';

class GtdHotelSearchResultDTO {
  String searchId = "";
  GtdPagingDTO<GtdHotelItemDTO> pageData = GtdPagingDTO();
  GtdHotelSearchResultDTO();

  factory GtdHotelSearchResultDTO.fromGtdHotelSearchResult(GtdHotelSearchResult hotelSearchResult) {
    GtdHotelSearchResultDTO hotelSearchResultDTO = GtdHotelSearchResultDTO()
      ..searchId = hotelSearchResult.searchId ?? ""
      ..pageData = GtdPagingDTO.fromHotelPage(
          data: (hotelSearchResult.propertyAvailable ?? [])
              .map((e) => GtdHotelItemDTO.fromHotelPropertyAvailable(e))
              .toList(),
          hotelPage: hotelSearchResult.pageResult);
    return hotelSearchResultDTO;
  }

  void updatePagingSearchResult(GtdHotelSearchResult hotelSearchResult) {
    List<GtdHotelItemDTO> newItems =
        (hotelSearchResult.propertyAvailable ?? []).map((e) => GtdHotelItemDTO.fromHotelPropertyAvailable(e)).toList();
    pageData.data.addAll(newItems);
    if (hotelSearchResult.pageResult != null) {
      pageData.updateNewHotelPage(hotelSearchResult.pageResult!);
    }
  }

  void updatePagingSearchResultDTO(GtdHotelSearchResultDTO hotelSearchResultDTO) {
    List<GtdHotelItemDTO> newItems = hotelSearchResultDTO.pageData.data;
    pageData.data.addAll(newItems);
    pageData.page = hotelSearchResultDTO.pageData.page;
    pageData.totalPage = hotelSearchResultDTO.pageData.totalPage;
    pageData.totalItem = hotelSearchResultDTO.pageData.totalItem;
  }
}
