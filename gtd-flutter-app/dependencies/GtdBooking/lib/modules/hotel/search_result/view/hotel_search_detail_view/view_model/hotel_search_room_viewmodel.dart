// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_booking/modules/confirm_booking/view_model/price_bottom_detail_viewmodel.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/reponse/gtd_hotel_search_all_rates_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/request/gtd_hotel_checkout_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/models/gt_hotel_room_detail_dto.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';

class HotelSearchRoomViewModel extends BaseViewModel {
  bool hasPromo = true;
  late RatePlan ratePlan;
  String tripId = "";
  String roomId = "";
  double? comparePrice;
  HotelSearchRoomViewModel();

  factory HotelSearchRoomViewModel.fromRatePlan(RatePlan ratePlan,
      {required String tripId, required String roomId}) {
    HotelSearchRoomViewModel viewModel = HotelSearchRoomViewModel()
      ..ratePlan = ratePlan
      ..roomId = roomId
      ..tripId = tripId;
    return viewModel;
  }

  GtdHotelCheckoutRq createCheckoutRq() {
    return GtdHotelCheckoutRq(tripId: tripId, roomId: roomId, ratePlanId: ratePlan.ratePlanId!);
  }

  String get netRoomPricePerNight {
    if (comparePrice != null) {
      return "+${(ratePlan.netRoomPricePerNight - comparePrice!).toCurrency()}";
    } else {
      return ratePlan.netRoomPricePerNight.toCurrency();
    }
  }

  String get totalRoomPricePerNight {
    if (comparePrice != null) {
      // return "+${(ratePlan.totalRoomPricePerNight - comparePrice!).toCurrency()}";
      return "";
    } else {
      return ratePlan.totalRoomPricePerNight.toCurrency();
    }
  }



  PriceBottomDetailViewModel get priceBottomDetailViewModel {
    return PriceBottomDetailViewModel.fromRatePlan(ratePlan);
  }
}
