import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/request/gtd_hotel_search_all_rate_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_search_detail_dto.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';

import '../view/hotel_search_detail_view/view_model/hotel_search_detail_list_room_viewmodel.dart';

class HotelSearchDetailPageViewModel extends BasePageViewModel {
  late GtdHotelSearchDetailDTO hotelSearchDetailDTO;
  late GtdHotelSearchAllRateRq searchAllRateRq;
  HotelSearchDetailPageViewModel() {
    extendBodyBehindAppBar = true;
    // listRoomViewModels.last.isEmptyRoom = true;
    hotelSearchDetailDTO = GtdHotelSearchDetailDTO();
  }

  factory HotelSearchDetailPageViewModel.fromHotelSearchDetailDTO(GtdHotelSearchDetailDTO hotelSearchDetailDTO) {
    HotelSearchDetailPageViewModel viewModel = HotelSearchDetailPageViewModel();
    viewModel.hotelSearchDetailDTO = hotelSearchDetailDTO;
    // viewModel.listRoomViewModels = hotelSearchDetailDTO.hotelItemDTO?.rooms
    //         .map((e) => HotelSearchDetailListRoomViewModel.fromGtdHotelRoomDetailDTO(e))
    //         .toList() ??
    //     [];
    return viewModel;
  }

  List<HotelSearchDetailListRoomViewModel> get listRoomViewModels =>
      hotelSearchDetailDTO.hotelItemDTO?.rooms
          .map(
            (e) => HotelSearchDetailListRoomViewModel.fromGtdHotelRoomDetailDTO(e,
                hotelName: hotelSearchDetailDTO.hotelItemDTO?.hotelName ?? "", tripId: hotelSearchDetailDTO.tripId),
          )
          .toList() ??
      [];

  List<String> get hotelImages => hotelSearchDetailDTO.hotelItemDTO?.hotelUrlImgs ?? [];

  int get countNights => searchAllRateRq.checkOut.difference(searchAllRateRq.checkIn).inDays;

  String get checkin => searchAllRateRq.checkIn.localDate("EEE, dd/MM/yyyy");
  String get checkout => searchAllRateRq.checkOut.localDate("EEE, dd/MM/yyyy");

  String get searchInfoTitle {
    var restult = "${searchAllRateRq.room} Phòng - ${searchAllRateRq.adult} Người lớn ";
    if (searchAllRateRq.child > 0) {
      restult = "$restult- ${searchAllRateRq.child} Trẻ em(${searchAllRateRq.childAges.map((e) => "$e T").join(",")})";
    }
    return restult;
  }

  String get nearByInfo {
    return (hotelSearchDetailDTO.hotelItemDTO?.descriptions.where((e) => e.name == "attractions") ?? [])
        .map((e) => e.value)
        .join("\n");
  }

  // GtdHotelSearchAllRateRq createRequestAllrate() {
  //   return GtdHotelSearchAllRateRq(
  //       searchId:
  //           "eyJzZWFyY2hJZCI6IiIsImNoZWNrSW4iOiIyMDIzLTA4LTI4IiwiY2hlY2tPdXQiOiIyMDIzLTA5LTA0IiwicGF4SW5mb3MiOlt7ImFkdWx0UXVhbnRpdHkiOjEsImNoaWxkUXVhbnRpdHkiOjAsImluZmFudFF1YW50aXR5IjowLCJjaGlsZEFnZXMiOltdfV0sImxhbmd1YWdlIjoidmkiLCJjdXJyZW5jeSI6IlZORCIsInN1cHBsaWVyIjoiRVhQRURJQSIsInNhbGVzRW52IjoiSE9URWxfT05MWSIsInJhdGVPcHRpb25zIjpbIlRBIiwiT1RBIl0sImJ1c2luZXNzVHlwZSI6IkIyQyIsInJlcXVlc3RlckNsYXNzIjpudWxsLCJzdWJTYWxlQ2hhbm5lbCI6IkIyQ19XRUIiLCJzZWFyY2hDb2RlIjoiNjI1Nzk4MiIsInNlYXJjaFR5cGUiOiJQUk9WSU5DRV9TVEFURSIsInJhdGVQbGFuc0NvdW50IjoxLCJ0YXJnZXRTdXBwbGllciI6bnVsbCwibG9jYXRpb25Db29yZGluYXRlcyI6bnVsbCwicmFkaXVzIjpudWxsfQ==",
  //       propertyId: "2930",
  //       supplier: "AXISROOM",
  //       checkIn: DateTime(2023, 8, 28),
  //       checkOut: DateTime(2023, 9, 4),
  //       paxInfos: ["1"]);
  // }
}
