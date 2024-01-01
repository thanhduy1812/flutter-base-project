// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_item_dto.dart';

import 'package:gtd_booking/modules/hotel/search_result/view/hotel_result_content_item/model/hotel_result_card_item_model.dart';

enum HotelResultCardItemType { vertical, horizontal, loading }

class HotelResultCardItemViewModel extends BaseViewModel {
  late HotelResultCardItemModel hotelItemModel;
  HotelResultCardItemType cardItemType = HotelResultCardItemType.vertical;
  final int totalNight;
  HotelResultCardItemViewModel({this.cardItemType = HotelResultCardItemType.vertical, required this.totalNight});

  factory HotelResultCardItemViewModel.fromHotelItemDTO(
      {required GtdHotelItemDTO hotelItemDTO, required int totalNight}) {
    HotelResultCardItemViewModel hotelResultCardItemViewModel = HotelResultCardItemViewModel(totalNight: totalNight);
    hotelResultCardItemViewModel.hotelItemModel = HotelResultCardItemModel.fromHotelItemDTO(hotelItemDTO);
    return hotelResultCardItemViewModel;
  }

  String get priceTitle {
    return "1 phòng/ $totalNight đêm";
  }

  double get totalPrice {
    double totalPrice = hotelItemModel.totalAmount;
    // return totalPrice / totalNight;
    return totalPrice;
  }

  double get netPrice {
    // return hotelItemModel.netAmount / totalNight;
    return hotelItemModel.netAmount;
  }

  // double get totalPricePerRoomPerNight {
  //   return hotelItemModel.totalAmount/ hotelItemModel.
  // }
}
