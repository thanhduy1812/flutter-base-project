import 'package:gtd_booking/modules/confirm_booking/view_model/price_bottom_detail_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/price_bottom_viewmodel.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:dvt_helper/dvt_helper.dart';
import 'package:gtd_repository/gtd_repository.dart';

class HotelSearchRoomDetailPageViewModel extends BasePageViewModel {
  late RatePlan ratePlan;
  late GtdHotelRoomDetailDTO hotelRoomDetailDTO;
  GtdHotelSearchAllRateRq? searchAllRateRq;
  String tripId = "";
  double? comparePrice;
  HotelSearchRoomDetailPageViewModel() {
    title = "Thông tin phòng";
    subTitle = "DE AN HOTEL";
    subTitleNotifer.value = "DE AN HOTEL";
  }
  factory HotelSearchRoomDetailPageViewModel.fromRatePlan(
      {String hotelName = "DE AN HOTEL",
      required RatePlan ratePlan,
      required String tripId,
      required GtdHotelRoomDetailDTO hotelRoomDetailDTO}) {
    HotelSearchRoomDetailPageViewModel viewModel = HotelSearchRoomDetailPageViewModel()
      ..ratePlan = ratePlan
      ..tripId = tripId
      ..hotelRoomDetailDTO = hotelRoomDetailDTO;

    viewModel.subTitleNotifer.value = hotelName;
    return viewModel;
  }

  GtdHotelCheckoutRq createCheckoutRq() {
    return GtdHotelCheckoutRq(tripId: tripId, roomId: hotelRoomDetailDTO.id, ratePlanId: ratePlan.ratePlanId!);
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
      return "";
    } else {
      return ratePlan.totalRoomPricePerNight.toCurrency();
    }
  }

  String get netRoomPrice {
    return ((ratePlan.basePrice?.toDouble() ?? 0) + (ratePlan.taxAndFees?.toDouble() ?? 0)).toCurrency();
  }

  String get totalRoomPrice {
    return ((ratePlan.basePriceBeforePromo?.toDouble() ?? 0) + (ratePlan.taxAndFees?.toDouble() ?? 0)).toCurrency();
  }

  PriceBottomDetailViewModel get priceBottomDetailViewModel {
    return PriceBottomDetailViewModel.fromRatePlan(ratePlan);
  }

  PriceBottomViewModel get priceBottomViewModel {
    return PriceBottomViewModel(
        netPrice: netRoomPrice,
        totalPrice: (ratePlan.basePriceBeforePromo?.toInt() ?? 0) == 0 ? "" : totalRoomPrice,
        priceTitle: "Tổng tiền / tổng khách");
  }
}
