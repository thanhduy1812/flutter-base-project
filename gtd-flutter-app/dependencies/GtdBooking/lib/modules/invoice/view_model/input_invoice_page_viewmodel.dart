// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/base/view_model/gtd_validate_field_vm.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/customer_resource/models/response/gtd_saved_company_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/customer_resource/models/response/gtd_saved_traveller_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/meta_resource/meta_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';

class InputInvoicePageViewModel extends BasePageViewModel {
  List<GtdSavedTravellerRs> savedTravellers;
  List<GtdCountryCodeRs> countries;
  List<GtdInputTextFieldVM> conpanyInfos = [];
  List<GtdInputTextFieldVM> receivedInfos = [];

  GtdInputTextFieldVM lookupOption =
      GtdInputTextFieldVM(label: "Chọn từ loại tài khoản", inputUserBehavior: GtdInputUserBehavior.selection);
  GtdInputTextFieldVM lookupValue = GtdInputTextFieldVM(label: "Nhập số thẻ thành viên");
  var companyNameVM = GtdInputTextFieldVM(label: "Tên Doanh nghiệp", selectType: GtdInputSelectType.name);
  var companyTaxVM = GtdInputTextFieldVM(label: "Mã số thuế", selectType: GtdInputSelectType.name);
  var companyAddressVM = GtdInputTextFieldVM(label: "Địa chỉ doanh nghiệp", selectType: GtdInputSelectType.name);
  var citiesVM = GtdInputTextFieldVM(
      label: "Tỉnh / Thành phố",
      selectType: GtdInputSelectType.city,
      inputUserBehavior: GtdInputUserBehavior.selection);
  var countryVM = GtdInputTextFieldVM(
      label: "Quốc gia cấp", selectType: GtdInputSelectType.country, inputUserBehavior: GtdInputUserBehavior.selection);

  var receivedNameVM = GtdInputTextFieldVM(label: "Họ & tên người nhận", selectType: GtdInputSelectType.name);
  var receivedPhoneVM = GtdInputTextFieldVM(label: "Điện thoại", selectType: GtdInputSelectType.name);
  var receivedEmailVM = GtdInputTextFieldVM(label: "Email liên hệ", selectType: GtdInputSelectType.name);
  var noteVM = GtdInputTextFieldVM(label: "Ghi chú(nếu có)", selectType: GtdInputSelectType.name);
  GtdInvoiceBookingInfo? invoiceBookingInfo;
  InputInvoicePageViewModel({
    this.savedTravellers = const [],
    this.countries = const [],
    this.invoiceBookingInfo,
  }) {
    title = "Thông tin xuất hoá đơn";
    conpanyInfos = [companyNameVM, companyTaxVM, companyAddressVM, citiesVM, countryVM];
    receivedInfos = [receivedNameVM, receivedPhoneVM, receivedEmailVM, noteVM];
    if (invoiceBookingInfo != null) {
      updateFromInvoiceBookingInfo(invoiceBookingInfo!);
    }
  }
  void removeAll() {
    conpanyInfos.map((e) => e.text = "").toList();
    receivedInfos.map((e) => e.text = "").toList();
  }

  void updateFromSavedCompany(GtdSavedCompanyRs savedCompanyRs) {
    companyNameVM.text = savedCompanyRs.businessName ?? "";
    companyTaxVM.text = savedCompanyRs.taxCode ?? "";
    companyAddressVM.text = savedCompanyRs.address ?? "";
  }

  void updateFromInvoiceBookingInfo(GtdInvoiceBookingInfo invoiceBookingInfo) {
    companyNameVM.text = invoiceBookingInfo.taxCompanyName ?? "";
    companyTaxVM.text = invoiceBookingInfo.taxNumber ?? "";
    companyAddressVM.text = invoiceBookingInfo.taxAddress ?? "";
    receivedNameVM.text = "${invoiceBookingInfo.customerLastName ?? ""} ${invoiceBookingInfo.customerFirstName ?? ""}";
    receivedEmailVM.text = invoiceBookingInfo.customerEmail ?? "";
    receivedPhoneVM.text = invoiceBookingInfo.customerPhoneNumber ?? "";
    noteVM.text = invoiceBookingInfo.note ?? "";
  }

  GtdInvoiceBookingInfo get confirmInvoiceBookingInfo {
    String fullName = receivedEmailVM.text;
    // int firstSpace = fullName.indexOf(" ");

    // String firstName = fullName.substring(0, firstSpace);
    // String lastName = fullName.substring(firstSpace).trim();
    var parts = fullName.split(" ").toList();
    String lastName = parts.firstOrNull ?? "";
    parts.removeAt(0);
    String firstName = parts.join(" ");
    GtdInvoiceBookingInfo invoiceBookingInfo = GtdInvoiceBookingInfo()
      ..taxCompanyName = companyNameVM.text
      ..taxNumber = companyTaxVM.text
      ..taxAddress = companyAddressVM.text
      ..taxReceiptRequest = true
      ..customerEmail = receivedEmailVM.text
      ..customerPhoneNumber = receivedPhoneVM.text
      ..note = noteVM.text
      ..customerFirstName = firstName
      ..customerLastName = lastName;
    return invoiceBookingInfo;
  }
}
