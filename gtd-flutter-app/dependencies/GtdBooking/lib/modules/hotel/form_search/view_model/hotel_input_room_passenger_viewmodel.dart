// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';

import 'package:gtd_booking/modules/hotel/form_search/view/hotel_room_picker/view_model/hotel_room_picker_viewmodel.dart';

class HotelInputRoomPassengerViewModel extends BaseViewModel {
  List<HotelRoomPickerViewModel> rooms = [HotelRoomPickerViewModel(index: 0)];

  void insertNewRoom() {
    rooms.insert(rooms.length, HotelRoomPickerViewModel(index: rooms.length));
  }

  void removeRoomAtIndex(int index) {
    rooms.removeAt(index);
    rooms.where((element) => element.index >= index).map((e) => e.index = e.index - 1).toList();
  }

  int get totalAdultCount => rooms.map((e) => e.adult).fold(0, (previousValue, element) => previousValue + element);
  int get totalChildCount => rooms.map((e) => e.child).fold(0, (previousValue, element) => previousValue + element);
  int get totalInfantCount => rooms.map((e) => e.infant).fold(0, (previousValue, element) => previousValue + element);

  int get totalGuest => totalAdultCount + totalChildCount + totalInfantCount;

  HotelInputRoomPassengerViewModel copyWith() {
    return HotelInputRoomPassengerViewModel()..rooms = rooms.map((e) => e.copyWith()).toList();
  }

  bool get isEnableButton {
    var hasNullAgeChild =
        rooms.map((e) => e.roomChilds).flattened.where((element) => element.age == null).toList().isNotEmpty;
    return !hasNullAgeChild;
  }
}
