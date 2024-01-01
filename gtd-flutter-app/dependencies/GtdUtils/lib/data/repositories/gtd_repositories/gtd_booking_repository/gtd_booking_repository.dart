import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/booking_resource/booking_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

import 'dto/booking_detail_dto.dart';

class GtdBookingRepository {
  final BookingResourceApi bookingResourceApi = BookingResourceApi.shared;

  GtdBookingRepository._();
  static final shared = GtdBookingRepository._();
  // My booking repository
  Future<Result<SearchBookingRs, GtdApiError>> searchMyBooking(SearchBookingRq searchBookingRq) async {
    try {
      SearchBookingRs searchBookingRs = await bookingResourceApi.searchMyBooking(searchBookingRq).then((value) {
        return value;
      });
      return Success(searchBookingRs);
    } on GtdApiError catch (e) {
      Logger.e("searchMyBooking: $e");
      return Error(e);
    }
  }

    Future<Result<SearchBookingRs, GtdApiError>> searchListMyBooking(SearchBookingRq searchBookingRq) async {
    try {
      SearchBookingRs searchBookingRs = await bookingResourceApi.searchListMyBooking(searchBookingRq).then((value) {
        return value;
      });
      return Success(searchBookingRs);
    } on GtdApiError catch (e) {
      Logger.e("searchListMyBooking: $e");
      return Error(e);
    }
  }

  Future<Result<BookingDetailDTO, GtdApiError>> getBookingDetailByBookingNumber(String bookingNumber) async {
    try {
      BookingDetailDTO bookingDetailRs =
          await bookingResourceApi.getBookingDetailByBookingNumber(bookingNumber).then((value) {
        BookingDetailDTO bookingDetailDTO = BookingDetailDTO();
        bookingDetailDTO.mappingBookingDetail(value);
        return bookingDetailDTO;
      });
      return Success(bookingDetailRs);
    } on GtdApiError catch (e) {
      Logger.e("getBookingDetailByBookingNumber: $e");
      return Error(e);
    }
  }

  Future<Result<BookingDetailDTO, GtdApiError>> getFinalBookingDetailByBookingNumber(String bookingNumber) async {
    try {
      BookingDetailDTO bookingDetailRs = await bookingResourceApi.getFinalBookingDetail(bookingNumber).then((value) {
        BookingDetailDTO bookingDetailDTO = BookingDetailDTO();
        bookingDetailDTO.mappingBookingDetail(value);
        return bookingDetailDTO;
      });
      return Success(bookingDetailRs);
    } on GtdApiError catch (e) {
      Logger.e("getFinalBookingDetailByBookingNumber: $e");
      return Error(e);
    }
  }
}
