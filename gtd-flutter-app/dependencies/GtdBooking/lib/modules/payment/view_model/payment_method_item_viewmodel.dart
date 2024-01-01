// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/payment_method_type.dart';

class PaymentMethodItemViewModel extends BaseViewModel {
  final PaymentMethodType paymentType;
  bool isSelected = false;
  PaymentMethodItemViewModel({
    required this.paymentType,
    this.isSelected = false,
  });
}
