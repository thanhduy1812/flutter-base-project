import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/personal_info/model/nationality_model.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/meta_resource/models/response/gtd_country_code_rs.dart';
import 'package:rxdart/rxdart.dart';

class NationalityListViewModel extends BaseViewModel {
  List<GtdCountryCodeRs> countries = [];
  StreamController<String> querySearchController = StreamController();
  StreamController<List<NationalityModel>> nationalityController = StreamController();
  NationalityListViewModel({
    required this.countries,
  }) {
    nationalityController.add(countryViewModels);
    querySearchController.stream.debounceTime(const Duration(milliseconds: 300)).listen((event) {
      List<NationalityModel> matchItems = countryViewModels
          .where((element) => (element.model.name ?? "").toLowerCase().contains(event.toLowerCase()))
          .toList();
      nationalityController.sink.add(matchItems);
    });
  }

  List<NationalityModel> get countryViewModels {
    if (countries.isEmpty) {
      return [];
    }
    var groups = countries.groupListsBy((element) => (element.name ?? "*").characters.first.toUpperCase());
    List<NationalityModel> countryViewModels = groups.entries
        .map((e) => e.value
            .mapIndexed((index, element) => NationalityModel(
                model: element,
                groupName: (element.name ?? "*").characters.first.toUpperCase(),
                hasHeader: index == 0,
                hasFooter: index == e.value.length - 1))
            .toList())
        .flattened
        .toList();
    return countryViewModels;
  }
}
