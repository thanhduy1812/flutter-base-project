import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_result_content_item/view_model/hotel_result_card_item_viewmodel.dart';
import 'package:gtd_utils/base/view/gtd_flutter_map/gtd_map_controller.dart';
import 'package:gtd_utils/base/view/gtd_flutter_map/gtd_map_point.dart';
import 'package:gtd_utils/base/view/gtd_flutter_map/gtd_marker.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_item_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_search_result_dto.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';
import 'package:rxdart/rxdart.dart';

class HotelResultMapViewModel extends BaseViewModel {
  ScrollController horizontalController = ScrollController(keepScrollOffset: true);
  GtdMapController mapController = GtdMapController();
  List<HotelResultCardItemViewModel> hotelCardItemViewModels = [];

  StreamController<GtdMapPoint> focusMapController = StreamController();
  int totalItem = 0;
  int currentPage = 0;
  int totalPage = 0;
  bool hasNextPage = false;
  final int totalNight;
  HotelResultMapViewModel(this.totalNight);

  factory HotelResultMapViewModel.fromListHotelItemDTO(List<GtdHotelItemDTO> hotelItems, {required int totalNights}) {
    HotelResultMapViewModel viewModel = HotelResultMapViewModel(totalNights);
    viewModel.hotelCardItemViewModels = hotelItems
        .map((e) => HotelResultCardItemViewModel.fromHotelItemDTO(hotelItemDTO: e, totalNight: totalNights))
        .map((e) => e..cardItemType = HotelResultCardItemType.horizontal)
        .toList();
    viewModel.focusMapController.stream.debounceTime(const Duration(seconds: 1)).listen((event) {
      viewModel.mapController.moveToPoint(event);
    });
    return viewModel;
  }

  List<GtdMarker> get markers {
    var markers = hotelCardItemViewModels
        .where((element) => element.hotelItemModel.mapPoint != null)
        .map((e) => e.hotelItemModel)
        .map((e) => GtdMarker(
            value: e.netAmount.toCurrency(), latitude: e.mapPoint!.latitude, longitude: e.mapPoint!.longitude))
        .toList();
    //For test
    // markers.add(GtdMarker(value: "134,300 VND", latitude: 10.8045027, longitude: 106.7910036));
    return markers;
  }

  GtdMapPoint get initMapPoint {
    var marker = markers.firstOrNull;
    if (marker != null) {
      return GtdMapPoint(latitude: marker.latitude, longitude: marker.longitude);
    } else {
      return GtdMapPoint(latitude: 10.8045027, longitude: 106.7910036);
    }
  }

  void updateMoreItems(GtdHotelSearchResultDTO hotelSearchResultDTO) {
    totalItem = hotelSearchResultDTO.pageData.totalItem;
    totalPage = hotelSearchResultDTO.pageData.totalPage;
    currentPage = hotelSearchResultDTO.pageData.page;
    hasNextPage = hotelSearchResultDTO.pageData.hasNextPage;
    var nextItems = hotelSearchResultDTO.pageData.data
        .map((e) => HotelResultCardItemViewModel.fromHotelItemDTO(hotelItemDTO: e, totalNight: totalNight))
        .toList();
    hotelCardItemViewModels.addAll(nextItems);
  }
}
