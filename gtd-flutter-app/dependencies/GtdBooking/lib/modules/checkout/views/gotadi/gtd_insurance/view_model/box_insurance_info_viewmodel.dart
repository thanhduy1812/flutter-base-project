// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/booking_resource/booking_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/inventory_resource/models/response/gtd_insurance_detail_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_insurance_type.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';

class BoxInsuranceInfoViewModel extends BaseViewModel {
  String title = "Bảo hiểm du lịch";
  String numberInsured = "3";
  String insuranceFee = "30,000 VND";
  String insuranceStatus = "REGISTER";
  bool showStatus = false;
  Color statusColor = Colors.amber;
  late GtdInsuranceType? insuranceType;
  // List<TravelerInfoElement> insuredTravelers = [];

  GtdInsuranceDetail? insuranceDetail;
  BoxInsuranceInfoViewModel(
      {this.insuranceType = GtdInsuranceType.delay, this.insuranceFee = "0 VND", this.numberInsured = "1"}) {
    if (insuranceType == GtdInsuranceType.delay) {
      title = "Bảo hiểm trễ chuyến";
    }
    if (insuranceType == GtdInsuranceType.flexi) {
      title = "Bảo hiểm du lịch";
    }
  }
  factory BoxInsuranceInfoViewModel.fromInsuranceDetail(
      {required GtdInsuranceDetail insuranceDetail, bool showStatus = false}) {
    var status = GtdInsuranceStatus.findByCode(insuranceDetail.status ?? "");
    BoxInsuranceInfoViewModel viewModel = BoxInsuranceInfoViewModel()
      ..insuranceDetail = insuranceDetail
      ..insuranceType = GtdInsuranceType.findByCode(insuranceDetail.insuranceType ?? "")
      ..numberInsured = "${(insuranceDetail.insuredInfos ?? []).length}"
      ..insuranceFee = (insuranceDetail.amount ?? 0.0).toCurrency()
      ..insuranceStatus = status?.value ?? "--"
      ..statusColor = status?.color ?? AppColors.boldText;

    if (viewModel.insuranceType == GtdInsuranceType.delay) {
      viewModel.title = "Bảo hiểm trễ chuyến";
    }
    if (viewModel.insuranceType == GtdInsuranceType.flexi) {
      viewModel.title = "Bảo hiểm du lịch";
    }
    return viewModel;
  }

  factory BoxInsuranceInfoViewModel.fromBookingInfoTraveler(
      {required GtdInsuranceDetail insuranceDetail, required List<TravelerInfoElement> travellers}) {
    BoxInsuranceInfoViewModel insuranceInfoViewModel =
        BoxInsuranceInfoViewModel.fromInsuranceDetail(insuranceDetail: insuranceDetail, showStatus: true);
    String typeInsurace = insuranceInfoViewModel.insuranceType?.name.toUpperCase() ?? "";
    var insuredInfosTemp = travellers
        .where((element) {
          var insuranceTraveler = element.serviceRequests
              ?.where((e) =>
                  e.serviceType == ServiceType.insurance.name &&
                  e.ssrId?.toUpperCase().contains(typeInsurace.toUpperCase()) == true)
              .firstOrNull;
          return insuranceTraveler != null;
        })
        .map((e) => InsuranceInfoMapper.fromTravelerInfoElement(e, insuranceInfoViewModel.insuranceType!))
        .toList();
    insuranceInfoViewModel.insuranceDetail?.insuredInfos = insuredInfosTemp;
    return insuranceInfoViewModel;
  }

  static List<BoxInsuranceInfoViewModel> fromListTravelerInputDTO(List<TravelerInputInfoDTO> inputInfoDTOs) {
    List<BoxInsuranceInfoViewModel> insuraceInfoVMs = [];
    List<SsrOfferDTO> delaySsrs = inputInfoDTOs
        .map((e) => e.selectedServices)
        .flattened
        .where((element) => element.serviceType == ServiceType.insurance && element.ssrSubType == "DELAY")
        .toList();

    if (delaySsrs.isNotEmpty) {
      double amount = delaySsrs.map((e) => e.ssrAmount).fold(0, (previousValue, element) => previousValue + element);
      var delaySSRDetail = BoxInsuranceInfoViewModel(
          insuranceType: GtdInsuranceType.delay,
          numberInsured: "${delaySsrs.length}",
          insuranceFee: amount.toCurrency());
      insuraceInfoVMs.add(delaySSRDetail);
    }
    List<SsrOfferDTO> flexiSsrs = inputInfoDTOs
        .map((e) => e.selectedServices)
        .flattened
        .where((element) => element.serviceType == ServiceType.insurance && element.ssrSubType == "FLEXI")
        .toList();
    if (flexiSsrs.isNotEmpty) {
      double amount = flexiSsrs.map((e) => e.ssrAmount).fold(0, (previousValue, element) => previousValue + element);
      var flexiSSRDetail = BoxInsuranceInfoViewModel(
          insuranceType: GtdInsuranceType.flexi,
          numberInsured: "${flexiSsrs.length}",
          insuranceFee: amount.toCurrency());
      insuraceInfoVMs.add(flexiSSRDetail);
    }
    return insuraceInfoVMs;
  }
}
