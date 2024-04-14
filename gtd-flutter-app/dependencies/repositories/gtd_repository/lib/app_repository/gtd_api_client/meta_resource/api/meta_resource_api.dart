import 'package:dio/dio.dart';
import 'package:dvt_helper/dvt_helper.dart';
import 'package:dvt_network/dvt_network.dart';
import 'package:gtd_repository/app_repository/common_model/gtd_api_error.dart';
import 'package:gtd_repository/app_repository/common_model/gtd_environment.dart';
import 'package:gtd_repository/app_repository/gtd_api_client/meta_resource/meta_resource.dart';

/// API Client for call API
class MetaResourceApi {
  GtdNetworkService networkService = GtdNetworkService.shared;
  GTDEnvType envType = GTDEnvType.B2CAPI;

  MetaResourceApi._();
  static final shared = MetaResourceApi._();

  Future<List<SearchAirport>> searchAirports(String keyword) async {
    try {
      final networkRequest =
          GTDNetworkRequest(type: GtdMethod.get, enpoint: GtdMetasrvEndpoint.searchAirportByKeyword(envType));
      networkRequest.queryParams = {"query": keyword};
      // networkRequest.data
      networkService.request = networkRequest;
      final Response response = await networkService.execute();
      List<SearchAirport> gtdSearchAirport = JsonParser.jsonArrayToModel(SearchAirport.fromJson, response.data);
      return gtdSearchAirport;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error searchAirports: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }

  Future<GtdPopularAirportRS> getCitiPopular() async {
    try {
      final networkRequest =
          GTDNetworkRequest(type: GtdMethod.get, enpoint: GtdMetasrvEndpoint.getPopularCities(envType));
      networkService.request = networkRequest;
      final Response response = await networkService.execute();
      GtdPopularAirportRS gtdPopularAirport = JsonParser.jsonToModel(GtdPopularAirportRS.fromJson, response.data);
      return gtdPopularAirport;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error getCitiPopular: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }

  Future<List<GtdCountryCodeRs>> getcountryCodes() async {
    try {
      final networkRequest = GTDNetworkRequest(type: GtdMethod.get, enpoint: GtdMetasrvEndpoint.getCountries(envType));
      networkRequest.queryParams = {"page": 0, "size": 1000, "sort": "sortname,asc"};
      // networkRequest.data
      networkService.request = networkRequest;
      final Response response = await networkService.execute();
      List<GtdCountryCodeRs> countries = JsonParser.jsonArrayToModel(GtdCountryCodeRs.fromJson, response.data);
      return countries;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error getcountryCodes: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }
}
