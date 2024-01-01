import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/personal_info/model/saved_company_model.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/customer_resource/models/response/gtd_saved_company_rs.dart';
import 'package:rxdart/rxdart.dart';

class SavedCompanyListViewModel extends BaseViewModel {
  List<GtdSavedCompanyRs> companies = [];
  StreamController<String> querySearchController = StreamController();
  StreamController<List<SavedCompanyModel>> companyModelController = StreamController();
  SavedCompanyListViewModel({
    required this.companies,
  }) {
    companyModelController.sink.add(companyViewModels);
    querySearchController.stream.debounceTime(const Duration(milliseconds: 300)).listen((event) {
      List<SavedCompanyModel> companyModels = companyViewModels.where((element) {
        return (element.model.businessName ?? "").toLowerCase().contains(event.toLowerCase()) ||
            (element.model.address ?? "").toLowerCase().contains(event.toLowerCase()) ||
            (element.model.taxCode ?? "").toLowerCase().contains(event.toLowerCase());
      }).toList();
      companyModelController.sink.add(companyModels);
    });
  }

  List<SavedCompanyModel> get companyViewModels {
    if (companies.isEmpty) {
      return [];
    }

    companies.sort(((a, b) => (a.businessName ?? "*").toLowerCase().compareTo((b.businessName ?? "*").toLowerCase())));
    var groups = companies.groupListsBy((element) => (element.businessName ?? "*").characters.first.toUpperCase());
    List<SavedCompanyModel> companyViewModels = groups.entries
        .map((e) => e.value
            .mapIndexed((index, element) => SavedCompanyModel(
                model: element,
                groupName: (element.businessName ?? "*").characters.first.toUpperCase(),
                hasHeader: index == 0,
                hasFooter: index == e.value.length - 1))
            .toList())
        .flattened
        .toList();
    return companyViewModels;
  }
}
