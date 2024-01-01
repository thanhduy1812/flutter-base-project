import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/constants/app_const.dart';
import 'package:gtd_utils/data/configuration/gtd_app_config.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/booking_resource/models/response/booking_detail_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_insurance_type.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_product_type.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_airline_cabin_class.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tuple.dart';

enum GtdDisplayItemType {
  other(1),
  header(2),
  flight(3),
  hotel(4),
  combo(5),
  adult(6),
  child(7),
  infant(8),
  baggage(9),
  meal(10),
  insuranceDelay(11),
  insuranceFlexi(12),
  insuranceCancel(13),
  taxFee(14),
  serviceFee(15),
  discount(16),
  tempPrice(17),
  totalPrice(18);

  final int position;
  const GtdDisplayItemType(this.position);

  Widget get icon {
    switch (this) {
      case GtdDisplayItemType.serviceFee:
      case GtdDisplayItemType.taxFee:
        return const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Icon(
            Icons.info,
            size: 20,
            color: Colors.grey,
          ),
        );
      default:
        return const SizedBox();
    }
  }
}

class GtdDisplayPriceItemVM extends BaseViewModel {
  String shortTitle;
  String fullTitle;
  String subTitle;
  FlightDirection? flightDirection;
  GtdDisplayItemType type = GtdDisplayItemType.taxFee;
  double price;
  TextStyle? valueStyle;
  GtdDisplayPriceItemVM({
    this.shortTitle = "",
    this.fullTitle = "",
    this.subTitle = "",
    this.flightDirection,
    this.type = GtdDisplayItemType.flight,
    this.valueStyle,
    this.price = 0,
  });

  factory GtdDisplayPriceItemVM.fromServiceType(
      {required ServiceType serviceType, required BookingDetailDTO bookingDetailDTO}) {
    GtdDisplayPriceItemVM vieModel = GtdDisplayPriceItemVM();
    List<ServiceRequest> ssrItems = (bookingDetailDTO.flightDetailItems ?? [])
        .map((e) => e.travelersInfo ?? [])
        .flattened
        .map((e) => e.serviceRequests ?? [])
        .flattened
        .where((element) => element.serviceType == serviceType.name)
        .toList();
    if (serviceType != ServiceType.insurance) {
      var totalPrice =
          ssrItems.map((e) => e.ssrAmount).fold(0.0, (previousValue, element) => previousValue + (element ?? 0.0));
      if (serviceType == ServiceType.baggare) {
        vieModel.shortTitle = "Phí hành lý";
        vieModel.type = GtdDisplayItemType.baggage;
      }
      if (serviceType == ServiceType.meal) {
        vieModel.shortTitle = "Phí suất ăn";
        vieModel.type = GtdDisplayItemType.meal;
      }
      vieModel.price = totalPrice;
    }
    return vieModel;
  }

  factory GtdDisplayPriceItemVM.flightFromSsrOfferDTOs(
      {required List<SsrOfferDTO> items, required ServiceType serviceType}) {
    GtdDisplayPriceItemVM vieModel = GtdDisplayPriceItemVM();
    List<SsrOfferDTO> ssrItems = items.where((element) => element.serviceType == serviceType).toList();

    if (serviceType != ServiceType.insurance) {
      double totalPrice = ssrItems.map((e) => e.ssrAmount).fold(0, (previousValue, element) => previousValue + element);
      if (serviceType == ServiceType.baggare) {
        vieModel.shortTitle = "Phí hành lý";
        vieModel.type = GtdDisplayItemType.baggage;
      }
      if (serviceType == ServiceType.meal) {
        vieModel.shortTitle = "Phí suất ăn";
        vieModel.type = GtdDisplayItemType.meal;
      }
      vieModel.price = totalPrice;
    }

    return vieModel;
  }

  factory GtdDisplayPriceItemVM.fromInsuranceType(
      {required GtdInsuranceType insuranceType, required BookingDetailDTO bookingDetailDTO}) {
    GtdDisplayPriceItemVM vieModel = GtdDisplayPriceItemVM();
    List<ServiceRequest> ssrItems = (bookingDetailDTO.flightDetailItems ?? [])
        .map((e) => e.travelersInfo ?? [])
        .flattened
        .map((e) => e.serviceRequests ?? [])
        .flattened
        .where((element) =>
            element.serviceType == ServiceType.insurance.name &&
            (element.ssrId?.contains(insuranceType.subType) ?? false))
        .toList();
    var totalPrice =
        ssrItems.map((e) => e.ssrAmount).fold(0.0, (previousValue, element) => previousValue + (element ?? 0.0));

    switch (insuranceType) {
      case GtdInsuranceType.delay:
        vieModel.shortTitle = "Bảo hiểm trễ chuyến";
        vieModel.type = GtdDisplayItemType.insuranceDelay;
        break;
      case GtdInsuranceType.flexi:
        vieModel.shortTitle = "Bảo hiểm du lịch";
        vieModel.type = GtdDisplayItemType.insuranceFlexi;
        break;
      default:
        vieModel.shortTitle = "Bảo hiểm";
        vieModel.type = GtdDisplayItemType.insuranceCancel;
    }

    vieModel.price = totalPrice;
    return vieModel;
  }

  factory GtdDisplayPriceItemVM.insuranceFromSsrOfferDTOs(
      {required List<SsrOfferDTO> items, required GtdInsuranceType insuranceType}) {
    GtdDisplayPriceItemVM vieModel = GtdDisplayPriceItemVM();
    List<SsrOfferDTO> ssrItems = items
        .where((element) => element.serviceType == ServiceType.insurance && element.ssrSubType == insuranceType.subType)
        .toList();
    var totalPrice = ssrItems.map((e) => e.ssrAmount).fold(0.0, (previousValue, element) => previousValue + element);

    switch (insuranceType) {
      case GtdInsuranceType.delay:
        vieModel.shortTitle = "Bảo hiểm trễ chuyến";
        vieModel.type = GtdDisplayItemType.insuranceDelay;
        break;
      case GtdInsuranceType.flexi:
        vieModel.shortTitle = "Bảo hiểm du lịch";
        vieModel.type = GtdDisplayItemType.insuranceFlexi;
        break;
      default:
        vieModel.shortTitle = "Bảo hiểm";
        vieModel.type = GtdDisplayItemType.insuranceCancel;
    }
    vieModel.price = totalPrice;

    return vieModel;
  }

  factory GtdDisplayPriceItemVM.fromAdultType(
      {required FlightAdultType adultType, required BookingDetailDTO bookingDetailDTO}) {
    GtdDisplayPriceItemVM vieModel = GtdDisplayPriceItemVM();
    double totalPrice = (bookingDetailDTO.flightDetailItems ?? []) //Use for finalBooking after Payment if data wrong!
        .map((e) => e.travelersInfo ?? [])
        .flattened
        .where((e) => e.adultType == adultType.value)
        .map((e) => e.baseFare)
        .fold(0, (previousValue, element) => previousValue + (element ?? 0));
    //Caculator netPerson for Hotel Combo
    GtdItineraryDisplayPriceInfo? displayPriceInfo =
        bookingDetailDTO.flightDetailItems?.firstOrNull?.flightItem.cabinOptions?.firstOrNull?.priceInfo;
    int totalPerson = (displayPriceInfo?.countAdult ?? 0) +
        (displayPriceInfo?.countChild ?? 0) +
        (displayPriceInfo?.countInfant ?? 0);
    double netHotelComboPerPerson = (bookingDetailDTO.hotelProductDetail?.transactionInfo?.baseFare ?? 0) / totalPerson;
    int countPerson = 0;
    switch (adultType) {
      case FlightAdultType.adult:
        // countPerson = bookingDetailDTO.flightDetailItems?.firstOrNull?.countAdult ?? 0;
        countPerson = bookingDetailDTO
                .flightDetailItems?.firstOrNull?.flightItem.cabinOptions?.firstOrNull?.priceInfo?.countAdult ??
            0;
        double netAdultPrice = (bookingDetailDTO.flightDetailItems ?? [])
            .map((e) => e.flightItem.cabinOptions ?? [])
            .flattened
            .map((e) => e.priceInfo?.totalBaseFareAdult ?? 0)
            .fold(0, (previousValue, element) => previousValue + element);
        if (bookingDetailDTO.supplierType == "AIR") {
          vieModel.shortTitle = "Người lớn x $countPerson";
          vieModel.price = netAdultPrice;
        }
        if (bookingDetailDTO.supplierType == "COMBO") {
          vieModel.shortTitle = "Trọn gói người lớn x $countPerson";
          vieModel.price = netAdultPrice + (netHotelComboPerPerson * countPerson);
        }

        vieModel.type = GtdDisplayItemType.adult;

        break;
      case FlightAdultType.child:
        // countPerson = bookingDetailDTO.flightDetailItems?.firstOrNull?.countChild ?? 0;
        countPerson = bookingDetailDTO
                .flightDetailItems?.firstOrNull?.flightItem.cabinOptions?.firstOrNull?.priceInfo?.countChild ??
            0;
        double netChildPrice = (bookingDetailDTO.flightDetailItems ?? [])
            .map((e) => e.flightItem.cabinOptions ?? [])
            .flattened
            .map((e) => e.priceInfo?.totalBaseFareChild ?? 0)
            .fold(0, (previousValue, element) => previousValue + element);
        if (bookingDetailDTO.supplierType == "AIR") {
          vieModel.shortTitle = "Trẻ em x $countPerson";
          vieModel.price = netChildPrice;
        }
        if (bookingDetailDTO.supplierType == "COMBO") {
          vieModel.shortTitle = "Trọn gói trẻ em x $countPerson";
          vieModel.price = netChildPrice + (netHotelComboPerPerson * countPerson);
        }
        vieModel.type = GtdDisplayItemType.child;

        break;
      case FlightAdultType.infant:
        countPerson = bookingDetailDTO
                .flightDetailItems?.firstOrNull?.flightItem.cabinOptions?.firstOrNull?.priceInfo?.countInfant ??
            0;
        double netInfantPrice = (bookingDetailDTO.flightDetailItems ?? [])
            .map((e) => e.flightItem.cabinOptions ?? [])
            .flattened
            .map((e) => e.priceInfo?.totalBaseFareInfant ?? 0)
            .fold(0, (previousValue, element) => previousValue + element);
        if (bookingDetailDTO.supplierType == "AIR") {
          vieModel.shortTitle = "Em bé x $countPerson";
          vieModel.price = netInfantPrice;
        }
        if (bookingDetailDTO.supplierType == "COMBO") {
          vieModel.shortTitle = "Trọn gói em bé x $countPerson";
          vieModel.price = netInfantPrice + (netHotelComboPerPerson * countPerson);
        }
        vieModel.type = GtdDisplayItemType.infant;

        break;
      default:
        countPerson = 0;
    }
    // vieModel.price = totalPrice;
    return vieModel;
  }

  factory GtdDisplayPriceItemVM.fromProductType({required BookingDetailDTO bookingDetailDTO}) {
    GtdDisplayPriceItemVM vieModel = GtdDisplayPriceItemVM();
    vieModel.type = GtdDisplayItemType.header;
    if (bookingDetailDTO.supplierType == GtdProductType.air.value) {
      String origin = bookingDetailDTO.flightDetailItems?.firstOrNull?.flightItem.flightItemInfo?.originLocation?.city
              ?.toUpperCase() ??
          "";
      String departAirline =
          bookingDetailDTO.flightDetailItems?.firstOrNull?.flightItem.flightItemInfo?.airlineName ?? "";
      String desitnation = bookingDetailDTO
              .flightDetailItems?.firstOrNull?.flightItem.flightItemInfo?.destinationLocation?.city
              ?.toUpperCase() ??
          "";
      if (bookingDetailDTO.isRoundTrip) {
        String returnAirline =
            bookingDetailDTO.flightDetailItems?.lastOrNull?.flightItem.flightItemInfo?.airlineName ?? "";
        vieModel.shortTitle = "KHỨ HỒI: $origin - $desitnation";
        vieModel.subTitle = "$departAirline - $returnAirline";
      } else {
        vieModel.shortTitle = "MỘT CHIỀU: $origin - $desitnation";
        vieModel.subTitle = departAirline;
      }
    }

    if (bookingDetailDTO.supplierType == GtdProductType.hotel.value) {
      var checkin = bookingDetailDTO.hotelProductDetail?.transactionInfo?.checkIn;
      var checkout = bookingDetailDTO.hotelProductDetail?.transactionInfo?.checkOut;

      vieModel.shortTitle =
          "${checkin?.localDate("dd/MM/yyyy") ?? "--"} - ${checkout?.localDate("dd/MM/yyyy") ?? "--"}";
      vieModel.subTitle = bookingDetailDTO.hotelProductDetail?.bookHotelPassengerInfo ?? "";
    }

    if (bookingDetailDTO.supplierType == GtdProductType.combo.value) {
      String origin = bookingDetailDTO.flightDetailItems?.firstOrNull?.flightItem.flightItemInfo?.originLocation?.city
              ?.toUpperCase() ??
          "";
      String desitnation = bookingDetailDTO
              .flightDetailItems?.firstOrNull?.flightItem.flightItemInfo?.destinationLocation?.city
              ?.toUpperCase() ??
          "";
      // vieModel.shortTitle =
      //     "${checkin?.localDate("dd/MM/yyyy") ?? "--"} - ${checkout?.localDate("dd/MM/yyyy") ?? "--"}";
      vieModel.shortTitle = "COMBO TIẾT KIỆM $origin - $desitnation";
      vieModel.subTitle = bookingDetailDTO.hotelProductDetail?.bookHotelPassengerInfo ?? "";
    }

    return vieModel;
  }

  factory GtdDisplayPriceItemVM.totalPrice(BookingDetailDTO bookingDetailDTO) {
    GtdDisplayPriceItemVM vieModel = GtdDisplayPriceItemVM();
    vieModel.type = GtdDisplayItemType.totalPrice;
    if (bookingDetailDTO.supplierType == GtdProductType.air.value) {
      vieModel.shortTitle = "Tổng giá vé";
    } else if (bookingDetailDTO.supplierType == GtdProductType.hotel.value) {
      vieModel.shortTitle = "Tổng thanh toán";
    } else {
      vieModel.shortTitle = "Tổng thanh toán";
    }
    vieModel.subTitle = "Đã bao gồm thuế & phí";
    vieModel.price = bookingDetailDTO.paymentInfo?.paymentTotalAmount == 0
        ? (bookingDetailDTO.paymentInfo?.totalFare ?? 0)
        : (bookingDetailDTO.paymentInfo?.paymentTotalAmount ?? 0);

    return vieModel;
  }

  static List<GtdDisplayPriceItemVM> fromBookingDetailDTO(BookingDetailDTO bookingDetailDTO) {
    List<GtdDisplayPriceItemVM> listDisplayPrices = [];
    var paymentInfo = bookingDetailDTO.paymentInfo!;

    var listPriceFlights = bookingDetailDTO.flightDetailItems
        ?.map((e) => Tuple(item1: e.flightDirection, item2: e.flightItem))
        .map((e) {
          var result = (e.item2.cabinOptions ?? [])
              .map((cabinclass) => cabinclass.priceInfo)
              .whereType<GtdItineraryDisplayPriceInfo>()
              .toList();
          var items = result.map((priceInfo) {
            List<GtdDisplayPriceItemVM> priceItems = [];
            //Flight Base Price
            priceItems.add(GtdDisplayPriceItemVM(
                flightDirection: e.item1,
                shortTitle:
                    "${e.item2.flightItemInfo?.originLocation?.locationCode} - ${e.item2.flightItemInfo?.destinationLocation?.locationCode}",
                subTitle: "",
                price: priceInfo.basePrice,
                type: GtdDisplayItemType.flight));
            return priceItems;
          });
          return items.flattened.toList();
        })
        .flattened
        .toList();
    var totalPriceVMPerAdultType = FlightAdultType.values
        .map((e) => GtdDisplayPriceItemVM.fromAdultType(adultType: e, bookingDetailDTO: bookingDetailDTO))
        .toList();
    var listServiceVMs = ServiceType.values
        .where((element) => element != ServiceType.insurance)
        .map((e) => GtdDisplayPriceItemVM.fromServiceType(serviceType: e, bookingDetailDTO: bookingDetailDTO))
        .where((element) => element.price != 0)
        .toList();
    var listInsuranceVms = GtdInsuranceType.values
        .map((e) => GtdDisplayPriceItemVM.fromInsuranceType(insuranceType: e, bookingDetailDTO: bookingDetailDTO))
        .where((element) => element.price != 0)
        .toList();
    if (AppConst.shared.appScheme.appSupplier == GtdAppSupplier.vib) {
      listDisplayPrices.addAll(listPriceFlights ?? []);
    } else if (bookingDetailDTO.supplierType == GtdProductType.air.value) {
      listDisplayPrices.addAll(totalPriceVMPerAdultType);
    } else if (bookingDetailDTO.supplierType == GtdProductType.hotel.value) {
      int totalRoom = bookingDetailDTO.hotelProductDetail?.totalRooms ?? 0;
      int totalNight = bookingDetailDTO.hotelProductDetail?.totalNight ?? 0;
      double basePrice = bookingDetailDTO.paymentInfo?.baseFare ?? 0;
      listDisplayPrices.add(GtdDisplayPriceItemVM(
          shortTitle: "$totalRoom phòng / $totalNight đêm", price: basePrice, type: GtdDisplayItemType.hotel));
    } else if (bookingDetailDTO.supplierType == GtdProductType.combo.value) {
      listDisplayPrices.addAll(totalPriceVMPerAdultType);
    }
    listDisplayPrices.addAll(listServiceVMs);
    listDisplayPrices.addAll(listInsuranceVms);
    listDisplayPrices.add(GtdDisplayPriceItemVM(
        shortTitle: "Thuế & phí", price: paymentInfo.serviceTax, type: GtdDisplayItemType.taxFee));
    listDisplayPrices.add(GtdDisplayPriceItemVM(
        shortTitle: "Phí dịch vụ", price: paymentInfo.totalServiceFee, type: GtdDisplayItemType.serviceFee));
    return listDisplayPrices;
  }
}
