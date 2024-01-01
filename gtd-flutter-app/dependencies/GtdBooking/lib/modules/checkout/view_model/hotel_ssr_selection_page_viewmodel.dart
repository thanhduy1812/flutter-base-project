import 'package:gtd_booking/modules/checkout/model/hotel_additional_item_vm.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';

class HotelSSRSelectionPageViewModel extends BasePageViewModel {
  String note = "";
  List<HotelAdditionalItemVM> selectedHotelAdditionalItems;
  List<HotelAdditionalItemVM> initHotelSSRItems = [];
  HotelSSRSelectionPageViewModel({
    this.note = "",
    this.selectedHotelAdditionalItems = const [],
  }) {
    title = "Yêu cầu đặc biệt";
    initHotelSSRItems = HotelAdditionalItem.values
        .map((e) => HotelAdditionalItemVM(data: e))
        .map((e) => e..isSelected = selectedHotelAdditionalItems.map((e) => e.data).contains(e.data))
        .toList();
  }

  void reset() {
    initHotelSSRItems.map((e) => e..isSelected = false).toList();
    notifyListeners();
  }

  void validateAdditional() {
    notifyListeners();
  }

  void confirmHotelAdditional() {
    selectedHotelAdditionalItems = initHotelSSRItems.where((element) => element.isSelected == true).toList();
  }

  bool get isEnableSaveButton {
    return note.isNotEmpty ||
        initHotelSSRItems.where((element) => element.isSelected == true).toList().isNotEmpty ||
        selectedHotelAdditionalItems.isNotEmpty &&
            initHotelSSRItems.where((element) => element.isSelected == true).toList().isEmpty;
  }

  String get generateBookingNote {
    var selectionNotes = initHotelSSRItems.where((element) => element.isSelected).map((e) => e.data.title).toList()
      ..add(note);
    return selectionNotes.join(",");
  }
}
