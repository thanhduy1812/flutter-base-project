import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/models/gt_hotel_room_detail_dto.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';

class HotelSummaryItemViewModel extends BaseViewModel {
  String changeHotelHeader = "2 phòng, 4 khách";
  String titleHeader = "Homestay Hostel Minh Loc Aparment";
  String roomType = "2x Phòng Superior";
  String roomInfo = "2 Phòng - 3 người lớn - 1 trẻ em";

  String checkin = "T2, 22/07/2023";
  String checkout = "T2, 22/07/2023";
  int nights = 2;
  int totalRooms = 1;

  HotelProductDetail? hotelProductDetail;
  HotelSummaryItemViewModel();
  factory HotelSummaryItemViewModel.fromBookingDetailDTO({required BookingDetailDTO bookingDetailDTO}) {
    var hotelProduct = bookingDetailDTO.hotelProductDetail!.hotelProduct!;
    HotelSummaryItemViewModel viewModel = HotelSummaryItemViewModel()
      ..hotelProductDetail = bookingDetailDTO.hotelProductDetail
      ..titleHeader = hotelProduct.propertyName ?? ""
      ..changeHotelHeader = bookingDetailDTO.hotelProductDetail?.bookHotelSumaryInfo ?? ""
      ..roomType = hotelProduct.rooms?.firstOrNull?.name ?? ""
      ..checkin = hotelProduct.checkinDate?.localDate("EE, dd/MM/yyy") ?? ""
      ..checkout = hotelProduct.checkoutDate?.localDate("EE, dd/MM/yyy") ?? ""
      ..roomInfo = bookingDetailDTO.hotelProductDetail?.bookHotelPassengerInfo ?? ""
      ..totalRooms = bookingDetailDTO.hotelProductDetail?.totalRooms ?? 0
      ..nights = hotelProduct.checkoutDate?.difference(hotelProduct.checkinDate!).inDays ?? 0;
    // viewModel.hotelProduct = hotelProduct;
    return viewModel;
  }

  factory HotelSummaryItemViewModel.fromHotelProduct({required HotelProductDetail hotelProductDetail}) {
    var hotelProduct = hotelProductDetail.hotelProduct!;
    HotelSummaryItemViewModel viewModel = HotelSummaryItemViewModel()
      ..titleHeader = hotelProduct.propertyName ?? ""
      ..hotelProductDetail = hotelProductDetail
      ..changeHotelHeader = hotelProductDetail.bookHotelSumaryInfo
      ..roomType = hotelProduct.rooms?.firstOrNull?.name ?? ""
      ..roomInfo = hotelProductDetail.bookHotelPassengerInfo
      ..checkin = hotelProduct.checkinDate?.localDate("EE, dd/MM/yyy") ?? ""
      ..checkout = hotelProduct.checkoutDate?.localDate("EE, dd/MM/yyy") ?? ""
      ..totalRooms = hotelProductDetail.totalRooms
      ..nights = hotelProduct.checkoutDate?.difference(hotelProduct.checkinDate!).inDays ?? 0;
    // viewModel.hotelProduct = hotelProduct;
    return viewModel;
  }

  GtdHotelRoomDetailDTO? get hotelRoomDetailDTO => hotelProductDetail?.litsHotelRoomDetail.firstOrNull;
}
