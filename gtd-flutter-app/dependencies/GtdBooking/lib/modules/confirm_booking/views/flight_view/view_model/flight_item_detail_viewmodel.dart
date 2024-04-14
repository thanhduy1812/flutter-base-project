// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_repository/gtd_repository.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:dvt_helper/dvt_helper.dart';


class FlightItemDetailViewModel extends BaseViewModel {
  String titleHeader = "Chuyến đi SGN - LAX";
  String dateTime = "T2, dd/mm/yyy";
  final GtdFlightItemDetail flightItemDetail;
  List<BookedFareRule> bookedFareRules = [];
  FlightItemDetailViewModel({required this.flightItemDetail}) {
    String directionTitle = flightItemDetail.flightDirection == FlightDirection.d ? "Chuyến đi" : "Chuyến về";
    String inineraryCodeTitle =
        "${flightItemDetail.flightItem.flightItemInfo?.originLocation?.locationCode} - ${flightItemDetail.flightItem.flightItemInfo?.destinationLocation?.locationCode}";
    titleHeader = "$directionTitle - $inineraryCodeTitle ";
    dateTime = flightItemDetail.flightItem.flightItemInfo?.originDateTime?.utcDate("EEE, dd/MM/yyyy") ?? "-";
  }
  String? get flightFareRuleContent {
    return bookedFareRules
        .where((element) => element.groupId == flightItemDetail.flightItem.groupId)
        .firstOrNull
        ?.fareRules
        ?.firstOrNull
        ?.fareRuleItems
        ?.firstOrNull
        ?.detail
        ?.trim();
  }
}
