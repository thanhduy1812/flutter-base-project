import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_origin_course_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_user_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_repositories/bme_repository.dart';
import 'package:gtd_utils/data/cache_helper/cache_helper.dart';
import 'package:meta/meta.dart';

part 'bme_course_state.dart';

class BmeCourseCubit extends Cubit<BmeCourseState> {
  StreamController<String> querySearchController = StreamController();
  BmeCourseCubit() : super(BmeCourseInitial(courses: const []));

  Future<void> loadCourse() async {
    var bmeUser = CacheHelper.shared.loadSavedObject(BmeUser.fromJson, key: CacheStorageType.accountBox.name);
    await BmeRepository.shared.getListBmeCourse().then((value) {
      value.whenSuccess((success) {
        var filterCourse = success
            .where((element) =>
                element.dinhHuong == "x" ||
                element.phatAm == "x" ||
                element.nghe == "x" ||
                element.noi == "x" ||
                element.nguPhap == "x")
            .where((element) => element.ngayKhaiGiang != "huy")
            .toList();
        if (bmeUser?.role?.toUpperCase() == BmeUserRole.mentor.roleValue ||
            bmeUser?.role?.toUpperCase() == BmeUserRole.user.roleValue) {
          filterCourse = filterCourse.where((element) => element.maLop == bmeUser?.tag).toList();
        }
        emit(BmeCourseInitial(courses: filterCourse));
      });
    });
  }

  @override
  Future<void> close() {
    querySearchController.close();
    return super.close();
  }
}
