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
                element.dinhHuong == "X" ||
                element.phatAm == "X" ||
                element.nghe == "X" ||
                element.noi == "X" ||
                element.nguPhap == "X")
            .toList();
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
