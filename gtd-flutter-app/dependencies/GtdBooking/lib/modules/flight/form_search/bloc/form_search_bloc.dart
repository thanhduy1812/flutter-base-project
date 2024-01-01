import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/flight/form_search/model/search_flight_info.dart';

import '../model/destination.dart';
import '../model/location.dart';
import '../model/passengers.dart';

part 'form_search_event.dart';
part 'form_search_state.dart';

class FormSearchBloc extends Bloc<FormSearchEvent, FormSearchState> {
  FormSearchBloc() : super(const FormSearchState()) {
    on<SelectDestinationLocation>(selectDestinationLocation);
    on<SelectDateForm>(selectDateForm);
    on<SetIsRoundTrip>(setIsRoundTrip);
    on<SetPassenger>(setPassenger);
  }
  Future<void> setPassenger(SetPassenger event, Emitter<FormSearchState> emit) async {
    try {
      SearchFlightInfo? formSearchModel = state.formSearchModel;
      formSearchModel = SearchFlightInfo(
          passengers: event.passengers,
          searchDate: formSearchModel?.searchDate,
          location: formSearchModel?.location,
          isRoundTrip: formSearchModel?.isRoundTrip);
      emit(
        state.copyWith(
          formSearchModel: formSearchModel,
        ),
      );
    } catch (error) {
      emit(state);
    }
  }

  Future<void> setIsRoundTrip(SetIsRoundTrip event, Emitter<FormSearchState> emit) async {
    try {
      SearchFlightInfo? formSearchModel = state.formSearchModel;
      formSearchModel = SearchFlightInfo(
          searchDate: formSearchModel?.searchDate,
          location: formSearchModel?.location,
          passengers: formSearchModel?.passengers,
          isRoundTrip: event.isRoundTrip);
      emit(
        state.copyWith(
          formSearchModel: formSearchModel,
        ),
      );
    } catch (error) {
      emit(state);
    }
  }

  Future<void> selectDateForm(SelectDateForm event, Emitter<FormSearchState> emit) async {
    try {
      SearchFlightInfo? formSearchModel = state.formSearchModel;
      formSearchModel = SearchFlightInfo(
          searchDate: event.searchDate,
          location: formSearchModel?.location,
          passengers: formSearchModel?.passengers,
          isRoundTrip: formSearchModel?.isRoundTrip);
      emit(
        state.copyWith(
          formSearchModel: formSearchModel,
        ),
      );
    } catch (error) {
      emit(state);
    }
  }

  Future<void> selectDestinationLocation(
      SelectDestinationLocation event, Emitter<FormSearchState> emit) async {
    try {
      SearchFlightInfo? formSearchModel = state.formSearchModel;
      Location? location;
      if (event.destination?.type == 'departure') {
        location = Location(
            origin: event.destination, destination: formSearchModel?.location?.destination);
      } else {
        location = Location(
          origin: formSearchModel?.location?.origin,
          destination: event.destination,
        );
      }
      formSearchModel = SearchFlightInfo(
          location: location,
          searchDate: formSearchModel?.searchDate,
          passengers: formSearchModel?.passengers,
          isRoundTrip: formSearchModel?.isRoundTrip);
      emit(
        state.copyWith(
          formSearchModel: formSearchModel,
        ),
      );
    } catch (error) {
      emit(state);
    }
  }
}
