import 'package:dio/dio.dart';
import 'package:dvt_helper/dvt_helper.dart';
import 'package:dvt_network/dvt_network.dart';
import 'package:gtd_repository/app_repository/common_model/gtd_api_error.dart';
import 'package:gtd_repository/app_repository/common_model/gtd_environment.dart';

import '../booking_api_endpoint.dart';
import '../models/request/search_booking_rq.dart';
import '../models/response/booking_detail_rs.dart';
import '../models/response/search_booking_rs.dart';

/// API Client for call API
class BookingResourceApi {
  GtdNetworkService networkService = GtdNetworkService.shared;
  GTDEnvType envType = GTDEnvType.B2CAPI;
  CancelToken cancelToken = CancelToken();

  BookingResourceApi._();
  static final shared = BookingResourceApi._();

  void cancelRequest() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel("cancelled");
    }
  }

  Future<SearchBookingRs> searchMyBooking(SearchBookingRq searchBookingRq) async {
    try {
      final networkRequest = GTDNetworkRequest(
        type: GtdMethod.get,
        enpoint: BookingApiEndpoint.searchMyBooking(envType),
        queryParams: searchBookingRq.toJson(),
      );
      networkService.request = networkRequest;
      final Response response = await networkService.execute(cancelToken: cancelToken);
      // SearchBookingRs searchBookingRs = SearchBookingRs.fromJson(response.data);
      SearchBookingRs searchBookingRs = JsonParser.jsonToModel(SearchBookingRs.fromJson, response.data);
      return searchBookingRs;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error searchMyBooking: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }

  Future<SearchBookingRs> searchListMyBooking(SearchBookingRq searchBookingRq) async {
    try {
      final networkRequest = GTDNetworkRequest(
        type: GtdMethod.get,
        enpoint: BookingApiEndpoint.searchListBooking(envType),
        queryParams: searchBookingRq.toJson(),
      );
      networkService.request = networkRequest;
      final Response response = await networkService.execute(cancelToken: cancelToken);
      // SearchBookingRs searchBookingRs = SearchBookingRs.fromJson(response.data);
      List<BookingInfoElement> bookingInfos = JsonParser.jsonArrayToModel(BookingInfoElement.fromJson, response.data);
      SearchBookingRs searchBookingRs = SearchBookingRs(content: bookingInfos);
      searchBookingRs.last = bookingInfos.isEmpty;
      return searchBookingRs;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error searchListMyBooking: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }

  Future<BookingDetailRs> getBookingDetailByBookingNumber(String bookingNumber) async {
    try {
      Map<String, dynamic> queryParams = <String, dynamic>{};
      queryParams['booking_number'] = bookingNumber;
      final networkRequest = GTDNetworkRequest(
        type: GtdMethod.get,
        enpoint: BookingApiEndpoint.getBookingDetai(envType),
        queryParams: queryParams,
      );
      networkService.request = networkRequest;
      final Response response = await networkService.execute(cancelToken: cancelToken);
      // BookingDetailRs bookingDetailRs = BookingDetailRs.fromJson(response.data);
      BookingDetailRs bookingDetailRs = JsonParser.jsonToModel(BookingDetailRs.fromJson, response.data);
      return bookingDetailRs;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error getBookingDetailByBookingNumber: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }

  Future<BookingDetailRs> getFinalBookingDetail(String bookingNumber) async {
    try {
      Map<String, dynamic> queryParams = <String, dynamic>{};
      queryParams['booking_number'] = bookingNumber;
      final networkRequest = GTDNetworkRequest(
        type: GtdMethod.get,
        enpoint: BookingApiEndpoint.finalBookingDetail(envType),
        queryParams: queryParams,
      );
      networkRequest.connectTimeout = 120;
      networkRequest.receiveTimeout = 120;
      networkService.request = networkRequest;
      final Response response = await networkService.execute(cancelToken: cancelToken);
      // BookingDetailRs bookingDetailRs = BookingDetailRs.fromJson(response.data);
      BookingDetailRs bookingDetailRs = JsonParser.jsonToModel(BookingDetailRs.fromJson, response.data);
      return bookingDetailRs;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error getFinalBookingDetail: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }
}
