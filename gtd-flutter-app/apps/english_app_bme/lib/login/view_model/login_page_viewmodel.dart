import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/bme_client.dart';
import 'package:gtd_utils/data/bme_repositories/bme_repositories/bme_repository.dart';
import 'package:gtd_utils/data/network/models/wrapped_result/result.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

class LoginPageViewModel extends BasePageViewModel {
  String username = "";
  String password = "";
  bool isShowPassword = false;

  Future<Result<List<BmeUser>, GtdApiError>> login() async {
    return BmeRepository.shared.login(username: username, password: password);
  }
}
