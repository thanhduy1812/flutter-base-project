import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/flight/form_search/bloc_cubit/search_info_state.dart';
import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class SearchInfoCubit extends Cubit<SearchInfoState> {
  SearchInfoCubit() : super(SearchInfoInitState());

  BehaviorSubject<SearchFlightFormModel> searchInfoSubject = BehaviorSubject<SearchFlightFormModel>();

  final BehaviorSubject<bool> _roundTripSubject = BehaviorSubject<bool>.seeded(true);
  Stream<bool> get isRoundTrip => _roundTripSubject.stream.distinct();

  Future<void> initSearchInfoFromCache() async {
    SearchFlightFormModel? searchFlightFormModel = CacheHelper.shared
        .loadSavedObject(SearchFlightFormModel.fromCachedObject, key: CacheStorageType.flightBox.name);
    if (searchFlightFormModel != null) {
      searchInfoSubject.sink.add(searchFlightFormModel);
      emit(SearchInfoCachedLoadedState(searchInfoFlightVM: searchFlightFormModel));
    }
  }

  @override
  Future<void> close() {
    searchInfoSubject.close();
    _roundTripSubject.close();
    return super.close();
  }
}
