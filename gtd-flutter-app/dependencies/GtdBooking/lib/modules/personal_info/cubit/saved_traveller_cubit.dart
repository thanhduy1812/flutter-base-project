import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dvt_helper/dvt_helper.dart';
import 'package:gtd_repository/gtd_repository.dart';
part 'saved_traveller_state.dart';

class SavedTravellerCubit extends Cubit<SavedTravellerState> {
  SavedTravellerCubit({List<GtdSavedTravellerRs>? savedTravellers}) : super(SavedTravellerInitial()) {
    bool isLogin = true;
    if (isLogin && savedTravellers == null) {
      getListSavedTraveller();
    } else {
      emit(SavedTravellerInitial(travellers: savedTravellers));
    }
  }

  Future<void> getListSavedTraveller() async {
    emit(SavedTravellerStateLoading());
    var result = await GtdCustomerRepository.shared.getSavedTravellers();
    result.when((success) {
      emit(SavedTravellerInitial(travellers: success));
    }, (error) {
      Logger.e(error.message);
      emit(SavedTravellerInitial(travellers: const []));
    });
  }

}
