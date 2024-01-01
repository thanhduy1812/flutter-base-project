import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_location_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/gtd_hotel_repository.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';
import 'package:rxdart/rxdart.dart';

part 'hotel_search_location_state.dart';

class HotelSearchLocationCubit extends Cubit<HotelSearchLocationState> {
  StreamController<String> querySearchController = StreamController();
  HotelSearchLocationCubit() : super(HotelSearchLocationInitial()) {
    querySearchController.stream.debounceTime(const Duration(milliseconds: 300)).listen((event) {
      if (event.isEmpty) {
        emit(const HotelPopularLocationLoaded([]));
      } else {
        findHotelLocationsByKeyword(event);
      }
    });
  }

  void getListPopularHotel() async {
    emit(HotelSearchLocationLoading());
    var result = await GtdHotelRepository.shared.getHotelPopularLocation();
    result.when(
        (success) => emit(HotelPopularLocationLoaded(success.data)), (error) => emit(HotelSearchLocationError(error)));
  }

  void findHotelLocationsByKeyword(String keyword) async {
    var result = await GtdHotelRepository.shared.findHotelLocationByKeyword(keyword);
    result.when(
        (success) => emit(HotelSearchLocationLoaded(success.data)), (error) => emit(HotelSearchLocationError(error)));
  }

  @override
  Future<void> close() {
    querySearchController.close();
    return super.close();
  }
}
