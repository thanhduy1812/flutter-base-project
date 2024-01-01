import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';

class VibInvoiceModel {
  VibInvoiceModel({this.groupName, this.items});
  final String? groupName;
  final List<VibInvoiceItem>? items;
}

class VibInvoiceItem {
  VibInvoiceItem({required this.label, this.value});
  final String label;
  final String? value;
}

List<VibInvoiceModel> vibInvoiceMapper(BookingDetailDTO bookingDetail) {
  List<VibInvoiceModel> vibInvoices = [];
  List<VibInvoiceItem> itemInfo = [];

  itemInfo.add(VibInvoiceItem(label: 'createDate', value: bookingDetail.bookingDate?.utcDate("dd/MM/yyyy")));
  itemInfo.add(VibInvoiceItem(label: 'totalAmount', value: bookingDetail.bookingDate?.utcDate("dd/MM/yyyy")));
  vibInvoices.add(VibInvoiceModel(groupName: 'bookingInfo', items: itemInfo));

  List<VibInvoiceModel> listVibInvoice = [];

  return listVibInvoice;
}
