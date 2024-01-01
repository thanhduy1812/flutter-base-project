import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_item.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

enum FlightSelectItemStatus { loading, success, error }

abstract class FlightSelectItemState extends Equatable {
  late final GtdFlightItem flightItem;
  late final GtdApiError? apiError;
  late final FlightSelectItemStatus loadingStatus;
  @override
  List<Object> get props => [];

  FlightSelectItemState copyWith(
      {required GtdFlightItem flightItem,
      GtdApiError? apiError,
      FlightSelectItemStatus? flightSelectItemStatus}) {
    return FlightSelectInitItemState(flightItem: flightItem);
  }
}

class FlightSelectInitItemState extends FlightSelectItemState {
  FlightSelectInitItemState({required GtdFlightItem flightItem}) {
    this.flightItem = flightItem;
    loadingStatus = FlightSelectItemStatus.success;
  }
  FlightSelectInitItemState.defaultState() {
    flightItem = GtdFlightItem();
    loadingStatus = FlightSelectItemStatus.success;
  }
  FlightSelectInitItemState.stateWithItem(GtdFlightItem flightItem) {
    this.flightItem = flightItem;
  }

  @override
  List<Object> get props => [flightItem];
}

class FlightSelectItemLoadingState extends FlightSelectItemState {
  FlightSelectItemLoadingState(
      {required GtdFlightItem flightItem, required FlightSelectItemStatus loadingStatus}) {
    this.flightItem = flightItem;
    this.loadingStatus = loadingStatus;
  }
  @override
  List<Object> get props => [loadingStatus, UniqueKey()];
}
