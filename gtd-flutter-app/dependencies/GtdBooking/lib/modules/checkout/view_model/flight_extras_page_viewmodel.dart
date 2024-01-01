import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/pricing_bottom_page_viewmodel.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/inventory_resource/models/response/gtd_insurance_plans_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tuple.dart';

import '../model/hotel_additional_item_vm.dart';
import '../views/gotadi/gtd_ssr_items/view_model/gtd_ssr_items_list_viewmodel.dart';

class FlightExtrasPageViewModel extends PricingBottomPageViewModel {
  List<ServiceType> get serviceTypes => [ServiceType.baggare, ServiceType.meal, ServiceType.insurance];
  List<SsrOfferDTO> initialSsrItems = [];
  List<InsurancePlan> initialInsurancePlans = [];
  List<HotelAdditionalItemVM> selectedHotelItems = [];

  FlightExtrasPageViewModel({super.bookingDetailDTO, required this.initialSsrItems}) {
    bookingNumber = bookingDetailDTO!.bookingNumber!;
  }

  Tuple<Widget, Tuple<String, String>> iconByServiceType(ServiceType serviceType) {
    switch (serviceType) {
      case ServiceType.baggare:
        return Tuple(
            item1: GtdAppIcon.iconNamedSupplier(iconName: "icon-baggage.svg"),
            item2: Tuple(item1: "Hành lý ký gửi", item2: "Chưa chọn hành lý"));
      case ServiceType.meal:
        return Tuple(
            item1: GtdAppIcon.iconNamedSupplier(iconName: "icon-food.svg"),
            item2: Tuple(item1: "Suất ăn", item2: "Chưa chọn suất ăn"));
      case ServiceType.insurance:
        return Tuple(
            item1: GtdAppIcon.iconNamedSupplier(iconName: "icon-insurance.svg"),
            item2: Tuple(item1: "Mua bảo hiểm", item2: "Chưa chọn bảo hiểm"));
      case ServiceType.hotelAdditional:
        return Tuple(
            item1: GtdAppIcon.iconNamedSupplier(iconName: "icon-hotel-additional.svg"),
            item2: Tuple(item1: "Thêm yêu cầu đặc biệt", item2: "Chưa thêm yêu cầu đặc biệt"));
      default:
        return Tuple(
            item1: GtdAppIcon.iconNamedSupplier(iconName: "icon-baggage.svg"),
            item2: Tuple(item1: "Unknown", item2: "Chưa chọn dịch vụ"));
    }
  }

  String extrasDescription(ServiceType serviceType) {
    if (serviceType == ServiceType.hotelAdditional) {
      return selectedHotelItems.isEmpty ? "" : "Yêu cầu cho phòng của bạn(nếu có)";
    } else {
      List<SsrOfferDTO> ssrItems = selectedSsrItems.where((element) => element.serviceType == serviceType).toList();
      if (ssrItems.isEmpty) {
        return "";
      }
      double amountSSr = ssrItems.map((e) => e.ssrAmount).fold(0, (previousValue, element) => previousValue + element);
      return "Đã đăng ký ${amountSSr.toCurrency()}";
    }
  }

  void updateSelectedSSRItemToTravelers(List<SelectedSSRTuple> selectedSSRTuples, ServiceType serviceType) {
    var entries = selectedSSRTuples.map((e) => MapEntry(e.travelerKey, e.selectedSsrItems)).toList();
    var seletedTravelerMap = Map.fromEntries(entries);
    travelerInputInfos.map((e) {
      e.updateSelectedSSRItems(seletedTravelerMap[e.travelerKey] ?? [], serviceType);
    }).toList();
  }

  bool mustInputContactDob() {
    var insuranceServies = selectedSsrItems
        .where((element) => element.serviceType == ServiceType.insurance && element.ssrSubType == "DELAY")
        .toList();
    if (insuranceServies.isNotEmpty && contactInputInfo?.dob == null) {
      return true;
    }
    return false;
  }
}
