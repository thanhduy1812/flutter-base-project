import 'dart:math';

import 'package:gtd_booking/modules/hotel/form_search/view_model/date_checkinout_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_model/passengers_room_viewmodel.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_location_dto.dart';
import 'package:rxdart/rxdart.dart';

import '../model/search_hotel_form_model.dart';
import 'hotel_search_location/hotel_location_vm.dart';

class SearchHotelPageViewModel extends BasePageViewModel {
  final BehaviorSubject<bool> _validLocationController = BehaviorSubject.seeded(false);
  Stream<bool> get isEnableButtonStream => Rx.combineLatest2(
      _validLocationController.stream, checkinoutViewModel.validFormController.stream, (a, b) => a & b);
  DateCheckinoutViewModel checkinoutViewModel = DateCheckinoutViewModel();
  HotelLocationTextFieldVM hotelLocation = HotelLocationTextFieldVM(
      location: GtdHotelLocationDTO.initEmptyData(), label: "Điểm đến / Tên khách sạn", allowEmpty: false);
  PassengersRoomViewModel passengersRoomViewModel = PassengersRoomViewModel();

  late GtdHotelLocationDTO _selectedHotelLocationDTO;

  GtdHotelLocationDTO get selectedHotelLocationDTO => _selectedHotelLocationDTO;

  set selectedHotelLocationDTO(GtdHotelLocationDTO value) {
    _selectedHotelLocationDTO = value;
    hotelLocation.location = _selectedHotelLocationDTO;
    validLocationHotel();
  }

  SearchHotelPageViewModel({bool isCombo = false}) {
    title = "Đặt phòng khách sạn";
    var cachedHotelSearch = CacheHelper.shared.loadSavedObject(SearchHotelFormModel.fromCachedObjectMap,
        key: isCombo ? CacheStorageType.comboHotelBox.name : CacheStorageType.hotelBox.name);
    if (cachedHotelSearch != null) {
      selectedHotelLocationDTO = cachedHotelSearch.locationDTO;
      checkinoutViewModel.fromDate.selectedDate = cachedHotelSearch.fromDate;
      checkinoutViewModel.toDate.selectedDate = cachedHotelSearch.toDate;
      checkinoutViewModel.validForm();
    } else {
      _selectedHotelLocationDTO = GtdHotelLocationDTO.initEmptyData();
    }
  }

  void validLocationHotel() {
    bool isValidLocation = hotelLocation.text.isNotEmpty;
    _validLocationController.sink.add(isValidLocation);
  }

  SearchHotelFormModel get searchHotelFormModel {
    return SearchHotelFormModel(
        locationDTO: hotelLocation.location,
        fromDate: checkinoutViewModel.fromDate.selectedDate,
        toDate: checkinoutViewModel.toDate.selectedDate,
        totalAdult: passengersRoomViewModel.totalAdult,
        totalChild: passengersRoomViewModel.totalChild,
        rooms: passengersRoomViewModel.totalRooms);
  }

  void savedCachedHotelLocations(GtdHotelLocationDTO hotelLocationDTO) {
    var savedListHotelLocations = CacheHelper.shared
        .loadListSavedObject(GtdHotelLocationDTO.fromMapCachedObject, key: CacheStorageType.hotelLocations.name);
    var newList = {hotelLocationDTO, ...savedListHotelLocations}.toList();
    var finalSavedList = newList.sublist(0, min(newList.length, 4));
    CacheHelper.shared.saveListSharedObject(finalSavedList.map((e) => e.toMapCachedObject()).toList(),
        key: CacheStorageType.hotelLocations.name);
  }

  void savedCachedHotelFormModel(SearchHotelFormModel searchHotelFormModel) {
    CacheHelper.shared.saveSharedObject(searchHotelFormModel.toCachedObjectMap(), key: CacheStorageType.hotelBox.name);
  }
}
