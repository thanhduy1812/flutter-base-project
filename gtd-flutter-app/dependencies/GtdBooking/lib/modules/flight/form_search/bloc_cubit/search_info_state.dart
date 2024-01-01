// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';

sealed class SearchInfoState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchInfoInitState extends SearchInfoState {
  SearchInfoInitState();
}

class SearchInfoCachedLoadedState extends SearchInfoState {
  final SearchFlightFormModel searchInfoFlightVM;
  SearchInfoCachedLoadedState({required this.searchInfoFlightVM});
  @override
  List<Object> get props => [searchInfoFlightVM];

  SearchInfoCachedLoadedState copyWith({
    SearchFlightFormModel? searchInfoFlightVM,
  }) {
    return SearchInfoCachedLoadedState(
      searchInfoFlightVM: searchInfoFlightVM ?? this.searchInfoFlightVM,
    );
  }
}

class SearchInfoErrorState extends SearchInfoState {
  final GtdApiError apiError;
  SearchInfoErrorState({required this.apiError});
}

class SearchInfoLocationState extends SearchInfoState {}

class SearchInfoDateState extends SearchInfoState {}

class SearchInfoPassengersState extends SearchInfoState {}
