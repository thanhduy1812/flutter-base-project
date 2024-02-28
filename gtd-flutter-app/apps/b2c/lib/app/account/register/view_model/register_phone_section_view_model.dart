import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:rxdart/rxdart.dart';

class RegisterPhoneSectionViewModel extends BaseViewModel {
  RegisterPhoneSectionViewModel();

  final phoneSectionValidStream = BehaviorSubject<bool>.seeded(false);
}
