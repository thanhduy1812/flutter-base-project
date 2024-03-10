import 'package:dio/dio.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/bme_api_endpoint.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_origin_course_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_user_rs.dart';
import 'package:gtd_utils/data/network/gtd_json_parser.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

import '../../../network/network.dart';

class BmeClientResourceApi {
  GtdNetworkService networkService = GtdNetworkService.shared;
  GTDEnvType envType = GTDEnvType.BmeEnglish;

  BmeClientResourceApi._();
  static final shared = BmeClientResourceApi._();

  Future<List<BmeUser>> getListUser() async {
    try {
      final networkRequest = GTDNetworkRequest(type: GtdMethod.get, enpoint: BmeApiEndpoint.getListBmeUser(envType));
      networkService.request = networkRequest;
      final Response response = await networkService.execute();
      var result = JsonParser.jsonArrayToModel(BmeUser.fromJson, response.data["data"]);
      return result;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error getListUser: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }

  Future<BmeUser> createBmeUser({required BmeUser bmeUser}) async {
    try {
      final networkRequest = GTDNetworkRequest(type: GtdMethod.get, enpoint: BmeApiEndpoint.createBmeUser(envType));
      networkRequest.queryParams = bmeUser.toJson();
      networkService.request = networkRequest;
      final Response response = await networkService.execute();
      var result = JsonParser.jsonToModel(BmeUser.fromJson, response.data);
      return result;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error createBmeUser: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }

  Future<List<BmeUser>> findBmeUserByKey(Map<String, dynamic> dict) async {
    try {
      final networkRequest = GTDNetworkRequest(type: GtdMethod.get, enpoint: BmeApiEndpoint.findBmeUserByKey(envType));
      networkRequest.queryParams = dict;
      networkService.request = networkRequest;
      final Response response = await networkService.execute();
      var result = JsonParser.jsonArrayToModel(BmeUser.fromJson, response.data);
      return result;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error findBmeUserByKey: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }

  Future<List<BmeUser>> searchBmeUserByKey(String column, String substring) async {
    try {
      final networkRequest = GTDNetworkRequest(type: GtdMethod.get, enpoint: BmeApiEndpoint.findBmeUserByKey(envType));
      networkRequest.queryParams = {"column": column, "substring": substring};
      networkService.request = networkRequest;
      final Response response = await networkService.execute();
      var result = JsonParser.jsonArrayToModel(BmeUser.fromJson, response.data);
      return result;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error searchBmeUserByKey: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }

  //Courses
  Future<List<BmeOriginCourse>> getListCourse() async {
    try {
      final networkRequest =
          GTDNetworkRequest(type: GtdMethod.get, enpoint: BmeApiEndpoint.getListBmeOriginCourse(envType));
      networkService.request = networkRequest;
      final Response response = await networkService.execute();
      var result = JsonParser.jsonArrayToModel(BmeOriginCourse.fromJson, response.data);
      return result;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error getListCourse: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }

  Future<List<BmeOriginCourse>> findBmeCourseByKey(Map<String, dynamic> dict) async {
    try {
      final networkRequest = GTDNetworkRequest(type: GtdMethod.get, enpoint: BmeApiEndpoint.findBmeCoursesByKey(envType));
      networkRequest.queryParams = dict;
      networkService.request = networkRequest;
      final Response response = await networkService.execute();
      var result = JsonParser.jsonArrayToModel(BmeOriginCourse.fromJson, response.data);
      return result;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error findBmeCourseByKey: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }

  Future<List<BmeOriginCourse>> searchBmeCourseByKey(String column, String substring) async {
    try {
      final networkRequest = GTDNetworkRequest(type: GtdMethod.get, enpoint: BmeApiEndpoint.findBmeUserByKey(envType));
      networkRequest.queryParams = {"column": column, "substring": substring};
      networkService.request = networkRequest;
      final Response response = await networkService.execute();
      var result = JsonParser.jsonArrayToModel(BmeOriginCourse.fromJson, response.data);
      return result;
    } on DioException catch (e) {
      Logger.e('Trace: ${e.stackTrace} \nErrorMess: ${e.toString()}');
      GtdDioException dioException = GtdDioException.fromDioError(e);
      throw GtdApiError(message: dioException.message);
    } catch (e) {
      Logger.e("Error searchBmeCourseByKey: $e");
      throw GtdApiError.handleObjectError(e);
    }
  }
}
