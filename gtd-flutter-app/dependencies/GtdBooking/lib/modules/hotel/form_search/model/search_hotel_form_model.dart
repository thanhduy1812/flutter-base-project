import 'package:collection/collection.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/request/gtd_hotel_search_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_location_dto.dart';

import '../view/hotel_room_picker/view_model/hotel_room_picker_viewmodel.dart';

class SearchHotelFormModel {
  GtdHotelLocationDTO locationDTO;
  DateTime? fromDate;
  DateTime? toDate;
  List<HotelRoomPickerViewModel> rooms;
  int totalAdult;
  int totalChild;
  int totalInfant;
  SearchHotelFormModel({
    required this.locationDTO,
    this.fromDate,
    this.toDate,
    required this.totalAdult,
    required this.totalChild,
    this.totalInfant = 0,
    required this.rooms,
  });

  GtdHotelSearchRq createHotelSearchRequest() {
    var paxInfos = rooms.map((e) {
      var adult = e.adult;
      if ((e.child + e.infant) == 0) {
        return "$adult";
      } else {
        var childAges = [...e.roomChilds, ...e.roomInfants]
            .map((e) => e.age)
            .whereType<int>()
            .map((e) => e.toString())
            .toList()
            .join(",");
        return "$adult-$childAges";
      }
    }).toList();
    GtdHotelSearchRq searchRq = GtdHotelSearchRq(
      searchType: locationDTO.searchType,
      searchCode: locationDTO.searchCode,
      checkIn: fromDate!,
      checkOut: toDate!,
      paxInfos: paxInfos,
      supplier: locationDTO.supplier,
    )
      ..adult = rooms.map((e) => e.adult).fold(0, (previousValue, element) => previousValue + element)
      ..room = rooms.length
      ..child = rooms.map((e) => e.child).fold(0, (previousValue, element) => previousValue + element)
      ..childAges = rooms.map((e) => e.roomChilds).flattened.map((e) => e.age).whereType<int>().toList()
      ..infant = rooms.map((e) => e.infant).fold(0, (previousValue, element) => previousValue + element)
      ..infantAges = rooms.map((e) => e.roomChilds).flattened.map((e) => e.age).whereType<int>().toList();
    return searchRq;
  }

  Map<String, dynamic> toCachedObjectMap() {
    return <String, dynamic>{
      'locationDTO': locationDTO.toMapCachedObject(),
      'fromDate': fromDate?.millisecondsSinceEpoch,
      'toDate': toDate?.millisecondsSinceEpoch,
      'totalAdult': totalAdult,
      'totalChild': totalChild,
      'totalInfant': totalInfant,
    };
  }

  factory SearchHotelFormModel.fromCachedObjectMap(Map<String, dynamic> map) {
    return SearchHotelFormModel(
      locationDTO: GtdHotelLocationDTO.fromMapCachedObject(map['locationDTO'] as Map<String, dynamic>),
      fromDate: map['fromDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['fromDate'] as int) : null,
      toDate: map['toDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['toDate'] as int) : null,
      rooms: [],
      totalAdult: map['totalAdult'] ?? 1,
      totalChild: map['totalChild'] ?? 0,
      totalInfant: map['totalInfant'] ?? 0,
    );
  }
}
