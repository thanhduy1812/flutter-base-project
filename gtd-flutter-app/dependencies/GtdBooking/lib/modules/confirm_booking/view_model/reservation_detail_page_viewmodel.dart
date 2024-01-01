import 'package:collection/collection.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/air_tickets_resource/air_tickets_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/booking_resource/booking_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_product_type.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';

class ReservationDetailPageViewMode extends BasePageViewModel {
  GtdFlightItemDetail? flightItemDetail;
  HotelProductDetail? hotelProductDetail;
  List<BookedFareRule> bookedFareRules = [];
  String titleHeader = "Chuyến đi SGN - LAX";
  String dateTime = "T2, dd/mm/yyy";
  GtdProductType productType = GtdProductType.air;

  String? get flightFareRuleContent {
    return bookedFareRules
        .where((element) => element.groupId == flightItemDetail?.flightItem.groupId)
        .firstOrNull
        ?.fareRules
        ?.firstOrNull
        ?.fareRuleItems
        ?.firstOrNull
        ?.detail
        ?.trim();
  }

  ReservationDetailPageViewMode();

  factory ReservationDetailPageViewMode.fromFlightItemDetail({required GtdFlightItemDetail flightItemDetail}) {
    String directionTitle = flightItemDetail.flightDirection == FlightDirection.d ? "Chuyến đi" : "Chuyến về";
    String inineraryCodeTitle =
        "${flightItemDetail.flightItem.flightItemInfo?.originLocation?.locationCode} - ${flightItemDetail.flightItem.flightItemInfo?.destinationLocation?.locationCode}";
    ReservationDetailPageViewMode viewModel = ReservationDetailPageViewMode()
      ..productType = GtdProductType.air
      ..flightItemDetail = flightItemDetail
      ..title = directionTitle
      ..titleHeader = "$directionTitle - $inineraryCodeTitle "
      ..dateTime = flightItemDetail.flightItem.flightItemInfo?.originDateTime?.utcDate("EEE, dd/MM/yyyy") ?? "-";
    return viewModel;
  }

  factory ReservationDetailPageViewMode.fromHotelProductDetail({required HotelProductDetail hotelProductDetail}) {
    ReservationDetailPageViewMode viewModel = ReservationDetailPageViewMode()
      ..productType = GtdProductType.hotel
      ..hotelProductDetail = hotelProductDetail
      ..title = "Chi tiết đặt chỗ"
      ..titleHeader = ""
      ..dateTime = "";
    viewModel.subTitle = hotelProductDetail.bookHotelSumaryInfo;
    viewModel.subTitleNotifer.value = viewModel.subTitle ?? "";
    return viewModel;
  }

  List<({String title, TravelerInfoElement traveler})> get listPassengerInfo {
    List<TravelerInfoElement> travellers = [];
    if (productType == GtdProductType.air) {
      travellers = (flightItemDetail?.travelersInfo ?? []);
      List<({String title, TravelerInfoElement traveler})> adultTravelers = travellers
          .where((e) => e.adultType == FlightAdultType.adult.value)
          .mapIndexed((index, element) => (title: "Người lớn ${index + 1}", traveler: element))
          .toList();
      List<({String title, TravelerInfoElement traveler})> childTravelers = travellers
          .where((e) => e.adultType == FlightAdultType.child.value)
          .mapIndexed((index, element) => (title: "Trẻ em ${index + 1}", traveler: element))
          .toList();
      List<({String title, TravelerInfoElement traveler})> infantTravelers = travellers
          .where((e) => e.adultType == FlightAdultType.infant.value)
          .mapIndexed((index, element) => (title: "Trẻ em ${index + 1}", traveler: element))
          .toList();

      return [...adultTravelers, ...childTravelers, ...infantTravelers];
    }
    if (productType == GtdProductType.hotel) {
      travellers = (hotelProductDetail?.travelersInfo ?? []);
      return travellers
          .mapIndexed((index, element) => (title: "Đại diện phòng ${index + 1}", traveler: element))
          .toList();
    }
    return [];
  }

  TransactionInfo? get productTransationInfo {
    switch (productType) {
      case GtdProductType.air:
        return flightItemDetail!.transactionInfo;
      case GtdProductType.hotel:
        return hotelProductDetail!.transactionInfo!;
      default:
        return null;
    }
  }
}
