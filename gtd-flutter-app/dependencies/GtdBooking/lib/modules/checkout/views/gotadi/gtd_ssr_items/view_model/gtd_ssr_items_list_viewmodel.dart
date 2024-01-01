// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/checkout/view_model/ssr_item_vm.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';

import 'package:gtd_utils/helpers/extension/number_extension.dart';

typedef TravelerSSRTuple = ({TravelerInputInfoDTO travelerDTO, List<SsrItemVM> ssrItems});
typedef SelectedSSRTuple = ({UniqueKey travelerKey, List<SsrOfferDTO> selectedSsrItems});

class GtdSSRItemListViewModel extends BaseViewModel {
  List<SsrOfferDTO> initialSSRItems = [];
  List<TravelerInputInfoDTO> travellerDTOs;
  FlightDirection flightDirection;
  ServiceType serviceType;
  List<TravelerSSRTuple> travelerTupleItems = [];
  String locationTitle = "";
  String operationAirlineTitle = "";
  // List<SelectedSSRTuple> selectedItems;
  GtdSSRItemListViewModel({
    required this.initialSSRItems,
    required this.travellerDTOs,
    required this.flightDirection,
    required this.serviceType,
  }) {
    travelerTupleItems = travellerDTOs.map((e) {
      var items = initListSSRItemVM(e.selectedServices);
      return (travelerDTO: e, ssrItems: items);
    }).toList();
  }

  List<SsrItemVM> initListSSRItemVM(List<SsrOfferDTO> selectedItems) {
    initialSSRItems.sort((a, b) => a.ssrAmount.compareTo(b.ssrAmount));
    return initialSSRItems.map((e) {
      var item = SsrItemVM(data: e);
      item.isSelected = selectedItems.contains(e);
      return item;
    }).toList();
  }

  List<SelectedSSRTuple> get travelerSeletedItems {
    return travelerTupleItems
        .map((e) => (
              travelerKey: e.travelerDTO.travelerKey,
              selectedSsrItems: e.ssrItems.where((element) => element.isSelected).map((e) => e.data).toList()
            ))
        .toList();
  }

  String get totalSsrAmount {
    var seletedItems =
        travelerTupleItems.map((e) => e.ssrItems).flattened.map((e) => e).where((element) => element.isSelected);
    var totalAmount =
        seletedItems.map((e) => e.data.ssrAmount).fold(0.0, (previousValue, element) => previousValue + element);
    return "${seletedItems.length} suất - ${totalAmount.toCurrency()}";
  }
}
