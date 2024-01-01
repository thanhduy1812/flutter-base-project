import 'package:collection/collection.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/pricing_bottom_page_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/final_booking_detail_view/views/insurance_view/view_model/insurance_viewmodel.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/inventory_resource/models/response/gtd_insurance_plans_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_insurance_type.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';

import '../views/gotadi/gtd_ssr_items/view_model/gtd_ssr_items_list_viewmodel.dart';

class FlightSSRSelectionPageViewModel extends PricingBottomPageViewModel {
  List<SsrOfferDTO> initialSsrItems = [];
  List<InsurancePlan> initialInsurancePlans = [];
  bool isRoundTrip;
  ServiceType serviceType;
  List<GtdSSRItemListViewModel> ssrItemLisviewModels = [];
  List<InsuranceViewModel> insuranceViewModels = [];
  InsuranceClassItem? selectedFlexiItem;
  FlightSSRSelectionPageViewModel(
      {this.isRoundTrip = false,
      super.bookingDetailDTO,
      required this.serviceType,
      List<TravelerInputInfoDTO> inputInfoDTOs = const [],
      this.initialSsrItems = const [],
      this.initialInsurancePlans = const []}) {
    switch (serviceType) {
      case ServiceType.baggare:
        title = "Hành lý ký gửi";
      case ServiceType.meal:
        title = "Suất ăn mua thêm";
      case ServiceType.insurance:
        title = "Mua bảo hiểm";
      default:
    }
    travelerInputInfos = inputInfoDTOs;
    var flightItems = bookingDetailDTO?.flightDetailItems ?? [];
    ssrItemLisviewModels = tabFlightDirections.map((e) => createSSRItemListViewModel(flightDirection: e)).map((e) {
      var flightItemDetail = flightItems.firstWhereOrNull((element) => element.flightDirection == e.flightDirection);
      e.locationTitle = flightItemDetail?.flightItem.flightItemInfo?.flightLocationTitle ?? "";
      e.operationAirlineTitle = flightItemDetail?.flightItem.flightItemInfo?.flightDetailSubtitle ?? "";
      return e;
    }).toList();

    //Update Selected Insurance
    var oldSelectedInsurances = travelerInputInfos
        .map((e) => e.selectedServices)
        .flattened
        .where((element) => element.serviceType == ServiceType.insurance)
        .map((e) => e.ssrSubType)
        .toList();
    var flexiPlanId = travelerInputInfos
        .map((e) => e.selectedServices)
        .flattened
        .where((element) => (element.serviceType == ServiceType.insurance && element.ssrSubType == "FLEXI"))
        .map((e) => (e.plandId, e.ssrAmount))
        .firstOrNull;
    print(flexiPlanId);
    selectedFlexiItem = initialInsurancePlans
        .where((element) => (element.extras?.insuranceType == "FLEXI"))
        .map((e) => e.extras)
        .map((e) => e?.insuranceClassItem ?? [])
        .flattened
        .where((element) => element.code == "${flexiPlanId?.$1}")
        .firstOrNull;
    insuranceViewModels = initialInsurancePlans
        .map((e) {
          if (e.extras?.insuranceType == "FLEXI") {
            return InsuranceViewModel.fromInsurancePlan(insurancePlan: e, selectedValue: selectedFlexiItem);
          } else {
            return InsuranceViewModel.fromInsurancePlan(insurancePlan: e);
          }
          
        })
        .map((e) => e..isSelected = oldSelectedInsurances.contains(e.insuranceType?.subType))
        .map((e) {
          if (e.insuranceType == GtdInsuranceType.flexi) {
            selectedFlexiItem?.classAmount = flexiPlanId?.$2;
            e.selectedValue = selectedFlexiItem;
          }
          return e;
        })
        .toList();
  }

  List<String> get tabTitles {
    switch (serviceType) {
      case ServiceType.baggare:
        return isRoundTrip ? ["Hành lý chuyến đi", "Hành lý chuyến về"] : ["Hành lý chuyến đi"];
      case ServiceType.meal:
        return isRoundTrip ? ["Thức ăn chuyến đi", "Thức ăn chuyến về"] : ["Thức ăn chuyến đi"];
      case ServiceType.insurance:
        return ["Bảo hiểm 2 chiều"];
      default:
        return [];
    }
  }

  GtdSSRItemListViewModel createSSRItemListViewModel({required FlightDirection flightDirection}) {
    List<SsrOfferDTO> filteredInititalSSRItems =
        filterSSRItemsByDirectionAndServiceType(flightDirection: flightDirection);
    return GtdSSRItemListViewModel(
        initialSSRItems: filteredInititalSSRItems,
        travellerDTOs: travelerInputInfos,
        flightDirection: flightDirection,
        serviceType: serviceType);
  }

  List<FlightDirection> get tabFlightDirections =>
      isRoundTrip ? [FlightDirection.d, FlightDirection.r] : [FlightDirection.d];

  List<SsrOfferDTO> filterSSRItemsByDirectionAndServiceType({required FlightDirection flightDirection}) {
    List<SsrOfferDTO> ssrItems = initialSsrItems
        .where((element) => (element.serviceType == serviceType && element.bookingDirection == flightDirection))
        .toList();
    return ssrItems;
  }

  List<SelectedSSRTuple> confirmSelectServiceRequest() {
    if (serviceType != ServiceType.insurance) {
      var selectedTravelerItems = ssrItemLisviewModels
          .map((e) => e.travelerSeletedItems)
          .flattened
          .groupListsBy((element) => element.travelerKey)
          .entries
          .map((e) {
        var mergeValues = e.value.map((e) => e.selectedSsrItems).reduce((value, element) => [...value, ...element]);
        return (travelerKey: e.key, selectedSsrItems: mergeValues);
      }).toList();
      return selectedTravelerItems;
    } else {
      var selectedInsuranceItems = insuranceViewModels
          .where((element) => element.isSelected == true)
          .map((e) => SsrOfferDTOMapper.fromInsurancePlan(
              e.insurancePlan!, bookingDetailDTO?.isRoundTrip == true ? FlightDirection.trip : FlightDirection.d,
              amount: e.premiumAmount))
          .map((e) => e..plandId = int.parse(selectedFlexiItem?.code ?? "0"))
          .toList();
      // Set insurance into valid travelers
      var departureDate = bookingDetailDTO!.flightDetailItems!.first.flightItem.flightItemInfo!.originDateTime!;
      var age85FromNow = DateTime(departureDate.year - 85, departureDate.day, departureDate.hour);
      var age6FromNow = DateTime(departureDate.year - 6, departureDate.day, departureDate.hour);
      var validTravelers = travelerInputInfos
          .where((element) => element.dob!.isAfter(age85FromNow) && element.dob!.isBefore(age6FromNow))
          .toList();

      var selectedTravelerItems =
          validTravelers.map((e) => (travelerKey: e.travelerKey, selectedSsrItems: selectedInsuranceItems)).toList();
      return selectedTravelerItems;
    }
  }

  @override
  String get bottomPriceTitle {
    switch (serviceType) {
      case ServiceType.baggare:
        return "Tổng phí hành lý";
      case ServiceType.meal:
        return "Tổng phí suất ăn";
      case ServiceType.insurance:
        return "Tổng phí bảo hiểm";
      default:
        return "Chi phí / tổng khách";
    }
  }

  @override
  double get netAmount {
    if (serviceType != ServiceType.insurance) {
      double ssrTotalAmount = ssrItemLisviewModels
          .map((e) => e.travelerSeletedItems)
          .flattened
          .map((e) => e.selectedSsrItems)
          .flattened
          .map((e) => e.ssrAmount)
          .fold(0, (previousValue, element) => previousValue + element);
      return ssrTotalAmount;
    } else {
      double ssrAmount = insuranceViewModels
          .where((e) => e.isSelected == true)
          .map((e) => e.premiumAmount)
          .fold(0, (previousValue, element) => previousValue + element);
      return ssrAmount;
    }
  }
}
