import 'package:gtd_utils/data/bme_repositories/bme_client/api/bme_client_resource_api.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_origin_course_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_user_rs.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';

import '../../network/network.dart';
import '../../repositories/gtd_repository_error/gtd_api_error.dart';

class BmeRepository {
  final BmeClientResourceApi bmeClientResourceApi = BmeClientResourceApi.shared;

  BmeRepository._();
  static final shared = BmeRepository._();

//User
  Future<Result<List<BmeUser>, GtdApiError>> getListUser() async {
    try {
      final response = await bmeClientResourceApi.getListUser();
      return Success(response);
    } on GtdApiError catch (e) {
      Logger.e("getListUser: $e");
      return Error(e);
    }
  }

  Future<Result<List<BmeUser>, GtdApiError>> searchUserByKeyword(String keyword) async {
    try {
      final response = await bmeClientResourceApi.searchBmeUserByKey("phone_number", keyword);
      return Success(response);
    } on GtdApiError catch (e) {
      Logger.e("searchUserByKeyword: $e");
      return Error(e);
    }
  }

  Future<Result<List<BmeUser>, GtdApiError>> findUserByKey(String phoneNumber) async {
    try {
      final response = await bmeClientResourceApi.findBmeUserByKey({"username": phoneNumber});
      return Success(response);
    } on GtdApiError catch (e) {
      Logger.e("searchUserByKeyword: $e");
      return Error(e);
    }
  }

  Future<Result<BmeUser, GtdApiError>> createBmeUser({required BmeUser bmeUser}) async {
    try {
      final response = await bmeClientResourceApi.createBmeUser(bmeUser: bmeUser);
      return Success(response);
    } on GtdApiError catch (e) {
      Logger.e("createBmeUser: $e");
      return Error(e);
    }
  }

  Future<Result<List<BmeUser>, GtdApiError>> login({required String username, required String password}) async {
    try {
      var request = {"username": username, "password": password};
      final response = await bmeClientResourceApi.findBmeUserByKey(request);
      if (response.isNotEmpty) {
        // await CacheHelper.shared.saveSharedObject(response.first.toJson(), key: CacheStorageType.accountBox.name);
        return Success(response);
      }
      return Error(GtdApiError(code: "404", message: "User not found"));
    } on GtdApiError catch (e) {
      Logger.e("login: $e");
      return Error(e);
    }
  }

  //Course
    Future<Result<List<BmeOriginCourse>, GtdApiError>> getListBmeCourse() async {
    try {
      final response = await bmeClientResourceApi.getListCourse();
      return Success(response);
    } on GtdApiError catch (e) {
      Logger.e("getListBmeCourse: $e");
      return Error(e);
    }
  }
  Future<Result<List<BmeOriginCourse>, GtdApiError>> searchBmeCourseByKey(String keyword) async {
    try {
      final response = await bmeClientResourceApi.searchBmeCourseByKey("ma_lop", keyword);
      return Success(response);
    } on GtdApiError catch (e) {
      Logger.e("searchUserByKeyword: $e");
      return Error(e);
    }
  }

  Future<Result<List<BmeOriginCourse>, GtdApiError>> findBmeCourseByKey(String courseCode) async {
    try {
      final response = await bmeClientResourceApi.findBmeCourseByKey({"ma_lop": courseCode});
      return Success(response);
    } on GtdApiError catch (e) {
      Logger.e("findBmeCourseByKey: $e");
      return Error(e);
    }
  }
}
