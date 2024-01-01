import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/meta_resource/models/json_models/search_airport.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository.dart';

part 'get_location_event.dart';
part 'get_location_state.dart';

class GetLocationBloc extends Bloc<GetLocationEvent, GetLocationState> {
  GetLocationBloc() : super(const GetLocationState()) {
    on<GetLocationFetched>(searchLocation);
  }

  Future<void> searchLocation(GetLocationFetched event, Emitter<GetLocationState> emit) async {
    try {
      emit(state.copyWith(status: GetLocationStatus.loading));
      final result = await GtdFlightRepository.shared.searchAirports(event.keyword);
      result.when((success) {
        emit(
          state.copyWith(
            status: GetLocationStatus.success,
            cities: success,
            keyword: event.keyword,
            hasReachedMax: false,
          ),
        );
      }, (error) {
        emit(state.copyWith(status: GetLocationStatus.failure));
      });
    } catch (error) {
      emit(state.copyWith(status: GetLocationStatus.failure));
    }
  }
}