import 'package:dvt_helper/dvt_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:gtd_repository/gtd_repository.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';

class HotelSearchLocationViewModel extends BaseViewModel {
  List<GtdHotelLocationDTO> popularHotelLocations = [];
  List<GtdHotelLocationDTO> searchedHotelLocations = [];
  List<GtdHotelLocationDTO> recentHotelLocations = [];
  HotelSearchLocationViewModel() {
    recentHotelLocations = CacheHelper.shared
        .loadListSavedObject(GtdHotelLocationDTO.fromMapCachedObject, key: CacheStorageType.hotelLocations.name);
    if (kDebugMode) {
      print("LOAD CACHED HOTEL");
      print(recentHotelLocations.map((e) => e.toMapCachedObject()).toList());
    }
  }
}
