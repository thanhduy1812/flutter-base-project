import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/model/bme_origin_course_rs.dart';
import 'package:gtd_utils/data/bme_repositories/bme_repositories/bme_repository.dart';
import 'package:meta/meta.dart';

part 'bme_course_state.dart';

class BmeCourseCubit extends Cubit<BmeCourseState> {
  StreamController<String> querySearchController = StreamController();
  BmeCourseCubit() : super(BmeCourseInitial(courses: const []));

  Future<void> loadCourse() async {
    await BmeRepository.shared.getListBmeCourse().then((value) {
      value.whenSuccess((success) {
        emit(BmeCourseInitial(courses: success));
      });
    });
  }

  @override
  Future<void> close() {
    querySearchController.close();
    return super.close();
  }
}
