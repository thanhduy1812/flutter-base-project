import 'package:dvt_helper/dvt_helper.dart';
import 'package:gtd_repository/gtd_repository.dart';
class GroupMonthInvoice {
  final String groupName;
  String totalInvoice = "0";
  String totalAmount = "0";
  bool isLoadingItem = false;
  final List<GtdInvoiceDetail> invoiceDetails = [];

  GroupMonthInvoice({required this.groupName});

  factory GroupMonthInvoice.loadingItem() {
    var item = GroupMonthInvoice(groupName: "groupName")..isLoadingItem = true;
    return item;
  }

  void addInvoiceDetails(List<GtdInvoiceDetail> invoiceDetails) {
    invoiceDetails.addAll(invoiceDetails);
  }
}

extension GtdInvoiceDetailExtension on GtdInvoiceDetail {
  String get groupName {
    if (createdDate == null) {
      return "";
    }
    return monthYearFormat.format(createdDate!);
  }

  String get createdDateDisplay {
    if (createdDate == null) {
      return "--";
    }
    return dateFormat.format(createdDate!);
  }
}
