import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/hotel/form_search/model/search_hotel_form_model.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/request/gtd_hotel_search_all_rate_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/request/gtd_hotel_search_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_hotel_filter_type.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_search_result_dto.dart';

import '../view/hotel_result_content_item/model/hotel_result_card_item_model.dart';
import 'hotel_filter_item_vm.dart';
import 'hotel_result_content_vertical_viewmodel.dart';
import 'hotel_result_map_viewmodel.dart';

enum HotelSearchResultViewType { list, map }

class HotelSearchResultPageViewModel extends BasePageViewModel {
  // bool isComboView = false;
  HotelSearchResultViewType _viewType = HotelSearchResultViewType.list;

  HotelSearchResultViewType get viewType => _viewType;

  ScrollController verticalController = ScrollController();

  set viewType(HotelSearchResultViewType value) {
    notifyListeners();
    _viewType = value;
  }

  final SearchHotelFormModel searchHotelFormModel;

  late HotelResultContentVerticalViewModel verticalContentViewModel;
  late HotelResultMapViewModel mapViewModel;

  List<List<HotelFilterItemVM>> filterVMs = [];

  GtdHotelSearchRq hotelSearchRq = GtdHotelSearchRq(
      searchType: "AUTO",
      searchCode: "Hồ Chí Minh",
      checkIn: DateTime.now().add(const Duration(days: 5)),
      checkOut: DateTime.now().add(const Duration(days: 12)),
      paxInfos: ["2-6,4", "1-5"],
      supplier: "EXPEDIA");

  late GtdHotelSearchResultDTO hotelSearchResultDTO;
  HotelSearchResultPageViewModel(this.searchHotelFormModel) {
    title = "Đà Nẵng";
    subTitle = "2 Phòng, 4 Khách, 2 Đêm";
    subTitleNotifer.value = subTitle ?? "";
  }

  factory HotelSearchResultPageViewModel.fromGtdHotelSearchResultDTO(
      {required GtdHotelSearchResultDTO hotelSearchResultDTO, required SearchHotelFormModel searchHotelFormModel}) {
    HotelSearchResultPageViewModel viewModel = HotelSearchResultPageViewModel(searchHotelFormModel);
    viewModel.title = searchHotelFormModel.locationDTO.name;
    viewModel.subTitle =
        "${searchHotelFormModel.rooms.length} Phòng ${searchHotelFormModel.totalAdult + searchHotelFormModel.totalChild} Khách ${viewModel.totalNights} Đêm";
    viewModel.subTitleNotifer.value = viewModel.subTitle ?? "";
    viewModel.hotelSearchResultDTO = hotelSearchResultDTO;
    viewModel.verticalContentViewModel = HotelResultContentVerticalViewModel.fromHotelSearchDTO(hotelSearchResultDTO,
        totalNights: viewModel.totalNights);
    viewModel.mapViewModel = HotelResultMapViewModel.fromListHotelItemDTO(hotelSearchResultDTO.pageData.data,
        totalNights: viewModel.totalNights);
    viewModel.hotelSearchRq = searchHotelFormModel.createHotelSearchRequest();
    return viewModel;
  }

  void updateHotelResultDTO(GtdHotelSearchResultDTO hotelSearchResultDTO) {
    this.hotelSearchResultDTO = hotelSearchResultDTO;
    verticalContentViewModel =
        HotelResultContentVerticalViewModel.fromHotelSearchDTO(hotelSearchResultDTO, totalNights: totalNights);
    mapViewModel =
        HotelResultMapViewModel.fromListHotelItemDTO(hotelSearchResultDTO.pageData.data, totalNights: totalNights);
  }

  Map<String, dynamic> createFilterRequest() {
    var result = filterVMs.flattened
        .where((element) => element.isSelected)
        .map((e) => (e.data.filterType, e.data.value))
        .groupListsBy((element) => element.$1)
        .entries
        .map((e) => MapEntry(e.key, e.value.map((e) => e.$2).toList()))
        .map((e) {
          var key = e.key;
          var value = e.value;
          if (key.requestType == FilterRequestType.array) {
            return [MapEntry(key.requestKey, value)];
          }
          if (key.requestType == FilterRequestType.range) {
            var listNum = value.whereType<num>().toList();
            var fromKey = key.requestKey.split(",").first;
            var toKey = key.requestKey.split(",").last;
            return [MapEntry(fromKey, listNum.min), MapEntry(toKey, listNum.max)];
          }
          return [MapEntry(key.requestKey, value)];
        })
        .flattened
        .toList();
    var finalMap = Map.fromEntries(result);
    print(finalMap);
    return finalMap;
  }

  Map<String, dynamic> createSearchRequest({bool isRefesh = false}) {
    if (isRefesh) {
      hotelSearchRq.pageNumber = 0;
      verticalContentViewModel.hotelCardItemViewModels = [];
      mapViewModel.hotelCardItemViewModels = [];
    }
    return hotelSearchRq.combineWithFilter(createFilterRequest());
  }

  GtdHotelSearchAllRateRq createSearchAllRateRq(HotelResultCardItemModel itemModel) {
    String searchId = hotelSearchResultDTO.searchId;
    String propertyId = itemModel.propertyId;
    String supplier = itemModel.supplier;
    GtdHotelSearchAllRateRq searchAllRateRq = GtdHotelSearchAllRateRq(
        searchId: searchId,
        propertyId: propertyId,
        supplier: supplier,
        checkIn: hotelSearchRq.checkIn,
        checkOut: hotelSearchRq.checkOut,
        paxInfos: hotelSearchRq.paxInfos)
      ..adult = hotelSearchRq.adult
      ..room = hotelSearchRq.room
      ..child = hotelSearchRq.child
      ..childAges = hotelSearchRq.childAges;
    return searchAllRateRq;
  }

  Map<String, dynamic> createLoadmoreRequest() {
    hotelSearchRq.pageNumber = hotelSearchRq.pageNumber + 1;
    return hotelSearchRq.combineWithFilter(createFilterRequest());
  }

  int get totalNights {
    int nights = searchHotelFormModel.toDate!.difference(searchHotelFormModel.fromDate!).inDays;
    return nights;
  }

  @override
  void dispose() {
    verticalController.dispose();
    super.dispose();
  }
}
