// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/base_view_model.dart';

import 'package:gtd_booking/modules/hotel/form_search/view/hotel_room_picker/model/hotel_room_child_age.dart';

class HotelRoomPickerViewModel extends BaseViewModel {
  int index;
  int adult = 1;
  int child = 0;
  int infant = 0;

  List<HotelRoomChildAge> roomChilds = [];
  List<HotelRoomChildAge> roomInfants = [];

  HotelRoomPickerViewModel(
      {this.index = 0,
      this.adult = 1,
      this.child = 0,
      this.infant = 0,
      List<HotelRoomChildAge>? roomChilds,
      List<HotelRoomChildAge>? roomInfants}) {
    this.roomChilds = roomChilds ?? [];
    this.roomInfants = roomInfants ?? [];
  }

  HotelRoomPickerViewModel copyWith({
    int? index,
    int? adult,
    int? child,
    int? infant,
    List<HotelRoomChildAge>? roomChilds,
    List<HotelRoomChildAge>? roomInfants,
  }) {
    return HotelRoomPickerViewModel(
      index: index ?? this.index,
      adult: adult ?? this.adult,
      child: child ?? this.child,
      infant: infant ?? this.infant,
      roomChilds: roomChilds ?? this.roomChilds.map((e) => e.copyWith()).toList(),
      roomInfants: roomInfants ?? this.roomInfants.map((e) => e.copyWith()).toList(),
    );
  }
}
