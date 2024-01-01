// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';

class BookingInvoiceInfoViewModel extends BaseViewModel {
  String companyName = "Cty TNHH TK ABCHFH";
  String companyTax = "580580697490";
  String companyAddress = "194 Nguyễn Thi Minh Khai, Phường Võ Thị Sáu, Quận 3";
  String companyAddressCity = "Hồ Chí Minh";
  String companyAddressCountry = "Việt Nam";
  String receiveName = "Lorersum";
  String receivePhoneNumber = "403970974097";
  String receiveEmail = "thuy.tathanh@gotadi.com";

  BookingInvoiceInfoViewModel();

  factory BookingInvoiceInfoViewModel.fromBookingDetailInvoiceInfo(
      {required GtdInvoiceBookingInfo bookingInvoiceInfo}) {
    BookingInvoiceInfoViewModel viewModel = BookingInvoiceInfoViewModel();
    viewModel.companyName = bookingInvoiceInfo.taxCompanyName ?? "";
    viewModel.companyTax = bookingInvoiceInfo.taxNumber ?? "";
    viewModel.companyAddress = bookingInvoiceInfo.taxAddress ?? "";
    viewModel.receiveName =
        "${bookingInvoiceInfo.customerLastName ?? ""} ${bookingInvoiceInfo.customerFirstName ?? ""}";
    viewModel.receiveEmail = bookingInvoiceInfo.customerEmail ?? "";
    viewModel.receivePhoneNumber = bookingInvoiceInfo.customerPhoneNumber ?? "";
    return viewModel;
  }
}
