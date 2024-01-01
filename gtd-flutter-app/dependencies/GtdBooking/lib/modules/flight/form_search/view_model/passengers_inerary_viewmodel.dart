// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:math';

import 'package:gtd_utils/base/view_model/base_view_model.dart';

import 'package:gtd_booking/modules/flight/form_search/model/search_flight_form_model.dart';

class PassengersItineraryViewModel extends BaseViewModel {
  late SearchInfoPassengerVM adultVM;
  late SearchInfoPassengerVM childVM;
  late SearchInfoPassengerVM infantVM;
  PassengersItineraryViewModel() {
    adultVM = SearchInfoPassengerVM(value: 1, max: 9, min: 1);
    childVM = SearchInfoPassengerVM(value: 0);
    infantVM = SearchInfoPassengerVM(value: 0);
  }

  void updatePassenger({int? adult, int? child, int? infant}) {
    adultVM.value = adult ?? adultVM.value;
    childVM.value = child ?? childVM.value;
    infantVM.value = infant ?? infantVM.value;
    adultVM.max = 9 - childVM.value;
    childVM.max = adultVM.value == 1 ? 4 : (9 - adultVM.value);
    childVM.value = min(childVM.max, childVM.value);
    infantVM.max = adultVM.value;
    infantVM.value = min(infantVM.value, infantVM.max);
  }
}
