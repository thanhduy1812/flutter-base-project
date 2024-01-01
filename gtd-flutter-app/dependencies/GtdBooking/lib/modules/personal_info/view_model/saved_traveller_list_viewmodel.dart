// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/personal_info/model/saved_traveller_model.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/customer_resource/models/response/gtd_saved_traveller_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_customer_repository/extension/gtd_saved_traveller_extension.dart';
import 'package:rxdart/rxdart.dart';

class SaveTravellerListViewModel extends BaseViewModel {
  List<GtdSavedTravellerRs> travellers = [];
  StreamController<String> querySearchController = StreamController();
  StreamController<List<SavedTravellerModel>> savedTravellers = StreamController();
  SaveTravellerListViewModel({
    required this.travellers,
  }) {
    savedTravellers.sink.add(travellerViewModels);
    querySearchController.stream.debounceTime(const Duration(milliseconds: 300)).listen((event) {
      List<SavedTravellerModel> travellers = travellerViewModels.where((element) {
        return element.model.fullname.toLowerCase().contains(event.toLowerCase()) ||
            element.model.subInfoEmailPhone.toLowerCase().contains(event.toLowerCase());
      }).toList();
      savedTravellers.sink.add(travellers);
    });
  }

  List<SavedTravellerModel> get travellerViewModels {
    if (travellers.isEmpty) {
      return [];
    }

    travellers.sort(((a, b) => (a.firstName?.split(" ").last ?? "*")
        .toLowerCase()
        .compareTo((b.firstName?.split(" ").last ?? "*").toLowerCase())));
    var groups = travellers
        .groupListsBy((element) => (element.firstName?.split(" ").last ?? "*").characters.first.toUpperCase());
    List<SavedTravellerModel> travellerViewModels = groups.entries
        .map((e) => e.value
            .mapIndexed((index, element) => SavedTravellerModel(
                model: element,
                groupName: (element.firstName?.split(" ").last ?? "*").characters.first.toUpperCase(),
                hasHeader: index == 0,
                hasFooter: index == e.value.length - 1))
            .toList())
        .flattened
        .toList();
    return travellerViewModels;
  }
}
