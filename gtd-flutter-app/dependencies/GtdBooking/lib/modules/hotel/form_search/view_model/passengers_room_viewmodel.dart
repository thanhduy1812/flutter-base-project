import 'package:gtd_booking/modules/hotel/form_search/view/hotel_room_picker/view_model/hotel_room_picker_viewmodel.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';

import 'hotel_input_room_passenger_viewmodel.dart';

class PassengersRoomViewModel extends BaseViewModel {
  HotelInputRoomPassengerViewModel savedHotelInputViewModel = HotelInputRoomPassengerViewModel();
  PassengersRoomViewModel();

  int get totalAdult => savedHotelInputViewModel.totalAdultCount;
  int get totalChild => savedHotelInputViewModel.totalChildCount;
  List<HotelRoomPickerViewModel> get totalRooms => savedHotelInputViewModel.rooms;
}
