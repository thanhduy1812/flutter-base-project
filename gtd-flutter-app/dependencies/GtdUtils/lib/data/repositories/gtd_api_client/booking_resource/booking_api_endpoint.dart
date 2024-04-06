import 'package:gtd_utils/data/network/network_service/gtd_end_points.dart';
import 'package:gtd_utils/data/network/network_service/gtd_environment.dart';

class BookingApiEndpoint extends GtdEndpoint {
  BookingApiEndpoint({required super.env, required super.path});
  static const String kSearchMyBooking = '/bookingsrv/api/bookings/search/my-booking';
  static const String kSearchListBooking = '/bookingsrv/api/bookings/search';
  static const String kBookingDetail = '/api/products/booking-detail';
  static const String kFinalBookingDetail = '/api/products/final-booking-detail';

  static GtdEndpoint searchMyBooking(GTDEnvType envType) {
    const path = kSearchMyBooking;
    return GtdEndpoint(env: GtdEnvironment(env: envType), path: path);
  }

  static GtdEndpoint searchListBooking(GTDEnvType envType) {
    const path = kSearchListBooking;
    return GtdEndpoint(env: GtdEnvironment(env: envType), path: path);
  }

  static GtdEndpoint getBookingDetai(GTDEnvType envType) {
    const path = kBookingDetail;
    return GtdEndpoint(env: GtdEnvironment(env: envType), path: path);
  }

  static GtdEndpoint finalBookingDetail(GTDEnvType envType) {
    const path = kFinalBookingDetail;
    return GtdEndpoint(env: GtdEnvironment(env: envType), path: path);
  }
}
