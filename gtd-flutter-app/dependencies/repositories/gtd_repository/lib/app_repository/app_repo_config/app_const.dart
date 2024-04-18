import 'package:gtd_repository/app_repository/common_model/gtd_environment.dart';

/// App name and info constants.
class AppRepository {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  AppRepository._();

  static final shared = AppRepository._();
  GTDRepoScheme? repoScheme;
}
