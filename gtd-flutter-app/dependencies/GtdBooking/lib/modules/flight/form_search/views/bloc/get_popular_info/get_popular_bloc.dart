import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/meta_resource/meta_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository.dart';

part 'get_popular_event.dart';
part 'get_popular_state.dart';

class GetPopularBloc extends Bloc<GetPopularEvent, GetPopularState> {
  GetPopularBloc() : super(const GetPopularState()) {
    on<GetAllPopularFetched>(allPopularLocation);
  }

  Future<void> allPopularLocation(GetAllPopularFetched event, Emitter<GetPopularState> emit) async {
    try {
      emit(state.copyWith(status: GetPopularStatus.loading));
      final result = await GtdFlightRepository.shared.getPopularAirports();
      result.when((success) {
        emit(
          state.copyWith(
            status: GetPopularStatus.success,
            popularAirportRS: success,
          ),
        );
      }, (error) {
        emit(state.copyWith(status: GetPopularStatus.failure));
      });
    } catch (error) {
      emit(state.copyWith(status: GetPopularStatus.failure));
    }
  }
}
