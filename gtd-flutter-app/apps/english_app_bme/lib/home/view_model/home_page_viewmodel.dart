import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/bme_client.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_origin_course_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_repositories/bme_repository.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';
import 'package:gtd_utils/data/network/models/wrapped_result/result.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';
import 'package:gtd_utils/helpers/extension/string_extension.dart';
import 'package:rxdart/rxdart.dart';

enum HomePageTab {
  course(0, "Courses"),
  mentor(1, "Teachers"),
  student(2, "Students"),
  account(3, "Account"),
  ;

  final int tabValue;
  final String title;
  const HomePageTab(this.tabValue, this.title);
}

class HomePageViewModel extends BasePageViewModel {
  HomePageTab seletedTab = HomePageTab.course;
  StreamController<String> querySearchController = StreamController();
  TextEditingController searchFieldController = TextEditingController();

  List<BmeUser> originUsers = [];
  List<BmeUser> filteredUsers = [];
  List<BmeOriginCourse> originCourses = [];
  List<BmeOriginCourse> filteredCourses = [];

  String role = "";
  BmeUser? loggedUser;

  HomePageViewModel() {
    title = seletedTab.title;
    var bmeUser = CacheHelper.shared.loadSavedObject(BmeUser.fromJson, key: CacheStorageType.accountBox.name);
    loggedUser = bmeUser;
    role = bmeUser?.role ?? "USER";
    querySearchController.stream.debounceTime(const Duration(milliseconds: 300)).listen((event) {
      if (seletedTab == HomePageTab.course) {
        if (event.isEmpty) {
          filteredCourses = List.from(originCourses);
        } else {
          filteredCourses = List<BmeOriginCourse>.from(originCourses)
              .where((element) =>
                  element.maLop
                      ?.trim()
                      // .replaceAll(RegExp(r'\s+'), '')
                      .removeDiacritics()
                      .toLowerCase()
                      .contains(event.trim().removeDiacritics().toLowerCase()) ??
                  false)
              .toList();
        }
      }
      if (seletedTab == HomePageTab.mentor) {
        if (event.isEmpty) {
          filteredUsers = List.from(
              originUsers.where((element) => element.role?.toUpperCase() != BmeUserRole.user.roleValue).toList());
        } else {
          filteredUsers = List<BmeUser>.from(
                  originUsers.where((element) => element.role?.toUpperCase() != BmeUserRole.user.roleValue).toList())
              .where((element) =>
                  ((element.fullName ?? "")
                      .trim()
                      // .replaceAll(RegExp(r'\s+'), '')
                      .removeDiacritics()
                      .toLowerCase()
                      .contains(event.trim().removeDiacritics().toLowerCase())) ||
                  (element.phoneNumber ?? "").toLowerCase().contains(event.trim().removeDiacritics().toLowerCase()))
              .toList();
        }
      }

      if (seletedTab == HomePageTab.student) {
        if (event.isEmpty) {
          filteredUsers = List.from(
              originUsers.where((element) => element.role?.toUpperCase() == BmeUserRole.user.roleValue).toList());
        } else {
          filteredUsers = List<BmeUser>.from(
                  originUsers.where((element) => element.role?.toUpperCase() == BmeUserRole.user.roleValue).toList())
              .where((element) =>
                  ((element.fullName ?? "")
                      .trim()
                      // .replaceAll(RegExp(r'\s+'), '')
                      // .replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '')
                      .removeDiacritics()
                      .toLowerCase()
                      .contains(event.trim().removeDiacritics().toLowerCase())) ||
                  (element.phoneNumber ?? "").toLowerCase().contains(event.trim().removeDiacritics().toLowerCase()))
              .toList();
        }
      }
      notifyListeners();
    });
  }

  void selectTab(int value) {
    HomePageTab tab =
        HomePageTab.values.firstWhere((element) => element.tabValue == value, orElse: () => HomePageTab.course);
    seletedTab = tab;
    title = seletedTab.title;
    if (seletedTab != HomePageTab.course) {
      filteredCourses = List.from(originCourses);
    }
    if (tab == HomePageTab.mentor) {
      filteredUsers =
          List.from(originUsers.where((element) => element.role?.toUpperCase() != BmeUserRole.user.roleValue).toList());
    }
    if (tab == HomePageTab.student) {
      filteredUsers =
          List.from(originUsers.where((element) => element.role?.toUpperCase() == BmeUserRole.user.roleValue).toList());
    }
    searchFieldController.clear();
    notifyListeners();
  }

  void updateFilteredUser() {
    if (searchFieldController.text.isNotEmpty) {
      filteredUsers = filteredUsers;
      return;
    }
    if (seletedTab == HomePageTab.mentor) {
      filteredUsers =
          List.from(originUsers.where((element) => element.role?.toUpperCase() != BmeUserRole.user.roleValue).toList());
    }
    if (seletedTab == HomePageTab.student) {
      filteredUsers =
          List.from(originUsers.where((element) => element.role?.toUpperCase() == BmeUserRole.user.roleValue).toList());
    }
  }

  Future<Result<bool, GtdApiError>> deleteCourse(int id) async {
    return await BmeRepository.shared.deleteBmeCourse(id);
  }

  Future<Result<BmeUser, GtdApiError>> updateUser() async {
    return await BmeRepository.shared.updateBmeUser(loggedUser!).then((value) {
      CacheHelper.shared.saveSharedObject(loggedUser!.toJson(), key: CacheStorageType.accountBox.name);
      return value;
    });
  }
}
