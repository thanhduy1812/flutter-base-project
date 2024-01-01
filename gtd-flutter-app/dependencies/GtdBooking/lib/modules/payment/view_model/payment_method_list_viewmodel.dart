// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/base_view_model.dart';

import 'payment_method_item_viewmodel.dart';

class PaymentMethodListViewModel extends BaseViewModel {
  List<PaymentMethodItemViewModel> paymentItems;
  PaymentMethodListViewModel({
    this.paymentItems = const [],
  });
}
