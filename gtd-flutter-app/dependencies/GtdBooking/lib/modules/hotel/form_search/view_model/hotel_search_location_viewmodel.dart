import 'package:flutter/foundation.dart';
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_location_dto.dart';

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
