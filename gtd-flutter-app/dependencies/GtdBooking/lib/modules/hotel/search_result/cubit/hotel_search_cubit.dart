import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_repository/gtd_repository.dart';

part 'hotel_search_state.dart';

class HotelSearchCubit extends Cubit<HotelSearchState> {
  StreamController<List<GtdHotelFilterOptionDTO>> hotelFilterOptionController = StreamController()..add([]);
  HotelSearchCubit() : super(HotelSearchInitial());

  void searchHotelBestRate(Map<String, dynamic> request) async {
    emit(HotelSearchLoading());
    var result = await GtdHotelRepository.shared.searchHotelBestRate(request);
    result.when((success) => emit(HotelSearchLoaded(success)), (error) => emit(HotelSearchError(apiError: error)));
  }

  void searchHotelBestRateWithSort(Map<String, dynamic> request) async {
    emit(HotelSearchLoading());
    var result = await GtdHotelRepository.shared.searchHotelBestRate(request);
    result.when((success) => emit(HotelSortLoaded(success)), (error) => emit(HotelSearchError(apiError: error)));
  }

  void getHotelFilterOptions() async {
    var result = await GtdHotelRepository.shared.getHotelFilterOptions();
    result.when((success) {
      hotelFilterOptionController.sink.add(success);
    }, (error) => hotelFilterOptionController.sink.add([]));
  }

  void applyFilter(Map<String, dynamic> request) {
    if (kDebugMode) {
      print(request);
    }
    searchHotelBestRate(request);
  }

  void refreshSearchResult(Map<String, dynamic> request) {
    if (kDebugMode) {
      print(request);
    }
    searchHotelBestRate(request);
  }

  Future<void> searchLoadMoreHotelBestRate(Map<String, dynamic> request) async {
    var result = await GtdHotelRepository.shared.searchHotelBestRate(request);
    result.when(
        (success) => emit(HotelSearchLoadmoreLoaded(success)), (error) => emit(HotelSearchError(apiError: error)));
  }

  @override
  Future<void> close() {
    hotelFilterOptionController.close();
    return super.close();
  }
}
