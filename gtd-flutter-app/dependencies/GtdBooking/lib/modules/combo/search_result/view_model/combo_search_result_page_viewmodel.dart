import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view_model/flight_summary_item_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';
import 'package:gtd_booking/modules/hotel/form_search/model/search_hotel_form_model.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/combo_result_content_vertical_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/combo_result_map_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_search_result_page_viewmodel.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_item.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_search_result_dto.dart';
import 'package:rxdart/rxdart.dart';

class ComboSearchResultPageViewModel extends HotelSearchResultPageViewModel {
  bool firstTimeCollapseFlight = false;
  final SearchFlightFormModel searchFlightFormModel;

  ValueNotifier<bool> isExpandFlightInfoNotifier = ValueNotifier(true);

  BehaviorSubject<({bool isLoaded, GtdFlightSearchResultDTO? data})> flightSearchSubject =
      BehaviorSubject.seeded((isLoaded: false, data: null));
  Sink<({bool isLoaded, GtdFlightSearchResultDTO? data})> get flightSearchSink => flightSearchSubject.sink;

  List<FlightSummaryItemViewModel> flightSelectedItems = [];
  ComboSearchResultPageViewModel(super.searchHotelFormModel, this.searchFlightFormModel) {
    title = "Combo SGN - DAD";
  }

  factory ComboSearchResultPageViewModel.fromGtdComboSearchResultDTO(
      {required SearchHotelFormModel searchHotelFormModel, required SearchFlightFormModel searchFlightFormModel}) {
    ComboSearchResultPageViewModel viewModel = ComboSearchResultPageViewModel(searchHotelFormModel, searchFlightFormModel);
    viewModel.title = searchHotelFormModel.locationDTO.name;
    int nights = searchHotelFormModel.toDate!.difference(searchHotelFormModel.fromDate!).inDays;
    viewModel.subTitle =
        "${searchHotelFormModel.rooms.length} Phòng ${searchHotelFormModel.totalAdult + searchHotelFormModel.totalChild} Khách $nights Đêm";
    viewModel.subTitleNotifer.value = viewModel.subTitle ?? "";

    viewModel.hotelSearchRq = searchHotelFormModel.createHotelSearchRequest();

    viewModel.verticalController.addListener(() {
      if (viewModel.verticalController.offset > 440 && !viewModel.firstTimeCollapseFlight) {
        viewModel.isExpandFlightInfoNotifier.value = false;
        viewModel.firstTimeCollapseFlight = true;
      }
    });
    return viewModel;
  }

  void updateFlightSelectedItems(List<FlightSummaryItemViewModel> flightSelectedItems) {
    this.flightSelectedItems = flightSelectedItems;
    updateHotelResultDTO(hotelSearchResultDTO);
  }

  @override
  void updateHotelResultDTO(GtdHotelSearchResultDTO hotelSearchResultDTO) {
    this.hotelSearchResultDTO = hotelSearchResultDTO;
    double flightPricePerPerson = flightSelectedItems
        .map((e) => e.flightItemDetail)
        .map((e) => e?.flightItem.selectedCabinOption?.priceInfo?.baseAdultPrice ?? 0)
        .fold(0, (previousValue, element) => previousValue + element);
    verticalContentViewModel = ComboResultContentVerticalViewModel.fromHotelSearchDTO(
        hotelSearchResultDTO, flightPricePerPerson,
        totalNights: totalNights);
    mapViewModel = ComboResultMapViewModel.fromListHotelItemDTO(
        hotelSearchResultDTO.pageData.data, flightPricePerPerson,
        totalNights: totalNights);
  }

  @override
  void dispose() {
    isExpandFlightInfoNotifier.dispose();
    flightSearchSubject.close();
    super.dispose();
  }
}
