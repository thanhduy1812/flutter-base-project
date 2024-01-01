
import 'package:dio/dio.dart';
import 'package:gtd_utils/data/network/gtd_json_parser.dart';
import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/combo_resource/gtd_combo_endpoint.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/combo_resource/models/request/gtd_combo_draft_booking_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_error_constant.dart';

import '../../air_tickets_resource/air_tickets_resource.dart';
import '../models/reponse/gtd_combo_draft_booking_rs.dart';

class ComboResourceApi {
  GtdNetworkService networkService = GtdNetworkService.shared;
  GTDEnvType envType = GTDEnvType.B2CAPI;

  ComboResourceApi._();
  static final shared = ComboResourceApi._();


  Future<String> draftBookingCombo(GtdComboDraftBookingRq comboDraftBookingRq) async {
    try {
      final networkRequest = GTDNetworkRequest(
          type: GtdMethod.post, enpoint: GtdComboEndpoint.draftBookingHotel(envType), data: comboDraftBookingRq);

      networkService.request = networkRequest;
      final Response response = await networkService.execute();
      GtdComboDraftBookingRs hotelDraftBookingRs =
          JsonParser.jsonToModel(GtdComboDraftBookingRs.fromJson, response.data);
      if ((hotelDraftBookingRs.errors ?? []).isNotEmpty ||
          hotelDraftBookingRs.booking?.bookingNumber == null) {
        throw GtdApiError.fromErrorConstant(GtdErrorConstant.unknown);
      }
      return hotelDraftBookingRs.booking!.bookingNumber!;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error draftBookingCombo: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }

  Future<AddBookingTravellerRs> addBookingTravellerCombo(AddBookingTravellerRq addBookingTravellerRq) async {
    try {
      final networkRequest = GTDNetworkRequest(
          type: GtdMethod.post,
          enpoint: GtdComboEndpoint.addBookingTraveller(envType),
          data: addBookingTravellerRq.toJson());
      networkService.request = networkRequest;
      final Response response = await networkService.execute();
      final AddbookingResultRs addBookingTravellerRs =
          JsonParser.jsonToModel(AddbookingResultRs.fromJson, response.data);
      if ((addBookingTravellerRs.errors ?? []).isNotEmpty || addBookingTravellerRs.result == null) {
        throw GtdApiError.fromErrorRs(addBookingTravellerRs.errors ?? []);
      }
      return addBookingTravellerRs.result!;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error addBookingTravellerCombo: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }
}