
import 'package:gtd_booking/modules/hotel/form_search/view_model/passengers_room_viewmodel.dart';

class ComboPassengersRoomViewModel extends PassengersRoomViewModel {
  ComboPassengersRoomViewModel();
  int get totalInfant => savedHotelInputViewModel.totalInfantCount;
}