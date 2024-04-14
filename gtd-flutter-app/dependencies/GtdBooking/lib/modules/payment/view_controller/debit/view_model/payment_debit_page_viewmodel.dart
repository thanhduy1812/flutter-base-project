import 'package:gtd_booking/modules/payment/view_model/payment_method_page_viewmodel.dart';
import 'package:gtd_repository/gtd_repository.dart';
import 'package:gtd_utils/data/resource/gotadi_data/model/bank_model.dart';

import 'debit_bank_item_viewmodel.dart';

class PaymentDebitPageViewModel extends PaymentMethodPageViewModel {
  final PaymentMethodType paymentMethodType = PaymentMethodType.atm;
  final List<DebitBankItemVM> bankDebitOptions = bankModels.map((e) => DebitBankItemVM(data: e)).toList();
  PaymentDebitPageViewModel({required BookingDetailDTO bookingDetailDTO, super.paymentFee, super.discountAmount})
      : super(bookingNumber: bookingDetailDTO.bookingNumber!) {
    title = "Thẻ ATM nội địa";
    this.bookingDetailDTO = bookingDetailDTO;
  }

  BankModel? get selectedBank {
    return bankDebitOptions.where((element) => element.isSelected == true).firstOrNull?.data;
  }
}
