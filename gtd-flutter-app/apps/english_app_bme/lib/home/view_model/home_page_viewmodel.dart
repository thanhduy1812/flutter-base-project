import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/bme_client.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_origin_course_rs.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';
import 'package:rxdart/rxdart.dart';

enum HomePageTab {
  course(0, "Courses"),
  mentor(1, "Mentors"),
  student(2, "Students");

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

  HomePageViewModel() {
    title = seletedTab.title;
    var bmeUser = CacheHelper.shared.loadSavedObject(BmeUser.fromJson, key: CacheStorageType.accountBox.name);
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
                      .replaceAll(RegExp(r'\s+'), '')
                      .toLowerCase()
                      .contains(event.trim().replaceAll(RegExp(r'\s+'), '').toLowerCase()) ??
                  false)
              .toList();
        }
      }
      if (seletedTab == HomePageTab.mentor) {
        if (event.isEmpty) {
          filteredUsers = List.from(originUsers.where((element) => element.role != "USER").toList());
        } else {
          filteredUsers = List<BmeUser>.from(originUsers.where((element) => element.role != "USER").toList())
              .where((element) =>
                  ((element.fullName ?? "")
                      .trim()
                      .replaceAll(RegExp(r'\s+'), '')
                      .toLowerCase()
                      .contains(event.trim().replaceAll(RegExp(r'\s+'), '').toLowerCase())) ||
                  (element.phoneNumber ?? "")
                      .toLowerCase()
                      .contains(event.trim().replaceAll(RegExp(r'\s+'), '').toLowerCase()))
              .toList();
        }
      }

      if (seletedTab == HomePageTab.student) {
        if (event.isEmpty) {
          filteredUsers = List.from(originUsers.where((element) => element.role == "USER").toList());
        } else {
          filteredUsers = List<BmeUser>.from(originUsers.where((element) => element.role == "USER").toList())
              .where((element) =>
                  ((element.fullName ?? "")
                      .trim()
                      .replaceAll(RegExp(r'\s+'), '')
                      .toLowerCase()
                      .contains(event.trim().replaceAll(RegExp(r'\s+'), '').toLowerCase())) ||
                  (element.phoneNumber ?? "")
                      .toLowerCase()
                      .contains(event.trim().replaceAll(RegExp(r'\s+'), '').toLowerCase()))
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
      filteredUsers = List.from(originUsers.where((element) => element.role != "USER").toList());
    }
    if (tab == HomePageTab.student) {
      filteredUsers = List.from(originUsers.where((element) => element.role == "USER").toList());
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
      filteredUsers = List.from(originUsers.where((element) => element.role != "USER").toList());
    }
    if (seletedTab == HomePageTab.student) {
      filteredUsers = List.from(originUsers.where((element) => element.role == "USER").toList());
    }
  }
}
