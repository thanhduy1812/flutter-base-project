import 'package:gtd_booking/modules/hotel/search_result/view/hotel_result_content_item/model/hotel_result_card_item_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_item_dto.dart';

import 'hotel_result_card_item_viewmodel.dart';

class ComboResultCardItemViewModel extends HotelResultCardItemViewModel {
  double flightPricePerPerson = 0;

  ComboResultCardItemViewModel({
    super.cardItemType = HotelResultCardItemType.vertical,
    required super.totalNight,
    required super.totalRoom,
  });

  factory ComboResultCardItemViewModel.fromHotelItemDTO({
    required GtdHotelItemDTO hotelItemDTO,
    required double flightPricePerPerson,
    HotelResultCardItemType cardItemType = HotelResultCardItemType.vertical,
    required int totalNights,
    required int totalRoom,
  }) {
    ComboResultCardItemViewModel hotelResultCardItemViewModel =
        ComboResultCardItemViewModel(
      totalNight: totalNights,
      totalRoom: totalRoom,
    )
          ..flightPricePerPerson = flightPricePerPerson
          ..cardItemType = cardItemType
          ..hotelItemModel =
              HotelResultCardItemModel.fromHotelItemDTO(hotelItemDTO);
    return hotelResultCardItemViewModel;
  }

  @override
  double get netPrice {
    return flightPricePerPerson + super.netPrice;
  }

  @override
  double get totalPrice {
    return flightPricePerPerson + super.totalPrice;
  }

  @override
  String get priceTitle {
    return "Combo trọn gói/1 khách/ $totalNight đêm";
  }
}
