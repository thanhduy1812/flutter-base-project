import 'package:gtd_utils/data/network/network_service/gtd_end_points.dart';
import 'package:gtd_utils/data/network/network_service/gtd_environment.dart';

class BmeApiEndpoint extends GtdEndpoint {
  BmeApiEndpoint({required super.env, required super.path});
  static const String kUsers = "v1/users";
  static const String kUserCreate = "v1/users/create";
  static const String kUserFindByKey = "v1/users/find-by-key";
  static const String kUserSearchByColumn = "v1/users/search-by-column";

  static const String kBmeCourses = "v1/bme/courses";
  static const String kBmeCoursesCreate = "v1/bme/courses/create";
  static const String kBmeCoursesFindByKey = "v1/bme/courses/find-by-key";
  static const String kBmeCoursesSearchByColumn = "v1/bme/Courses/search-by-column";

//User
  static GtdEndpoint getListBmeUser(GTDEnvType envType) {
    const path = kUsers;
    return GtdEndpoint(env: GtdEnvironment(env: envType), path: path, hasScheme: false);
  }

  static GtdEndpoint createBmeUser(GTDEnvType envType) {
    const path = kUserCreate;
    return GtdEndpoint(env: GtdEnvironment(env: envType), path: path, hasScheme: false);
  }

  static GtdEndpoint findBmeUserByKey(GTDEnvType envType) {
    const path = kUserFindByKey;
    return GtdEndpoint(env: GtdEnvironment(env: envType), path: path, hasScheme: false);
  }

//BME
  static GtdEndpoint getListBmeOriginCourse(GTDEnvType envType) {
    const path = kBmeCourses;
    return GtdEndpoint(env: GtdEnvironment(env: envType), path: path, hasScheme: false);
  }

  static GtdEndpoint createBmeCourse(GTDEnvType envType) {
    const path = kBmeCoursesCreate;
    return GtdEndpoint(env: GtdEnvironment(env: envType), path: path, hasScheme: false);
  }

  static GtdEndpoint findBmeCoursesByKey(GTDEnvType envType) {
    const path = kBmeCoursesFindByKey;
    return GtdEndpoint(env: GtdEnvironment(env: envType), path: path, hasScheme: false);
  }
}
