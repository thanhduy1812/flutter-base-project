import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'flight_ssr_selection_state.dart';

class FlightSsrSelectionCubit extends Cubit<FlightSsrSelectionState> {
  FlightSsrSelectionCubit() : super(FlightSsrSelectionInitial());
  void rebuildWidget() {
    emit(FlightSsrSelectionInitial());
  }
}
