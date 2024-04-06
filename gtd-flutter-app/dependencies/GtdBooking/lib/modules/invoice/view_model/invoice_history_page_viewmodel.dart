import 'package:collection/collection.dart';
import 'package:gtd_booking/modules/invoice/model/group_month_invoice.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/utility_resource/utility_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_model/gtd_paging_dto.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';
import 'package:intl/intl.dart';

class InvoiceHistoryPageViewModel extends BasePageViewModel {
  GtdPagingDTO<GroupMonthInvoice> groupMonthInvoices = GtdPagingDTO(data: []);
  List<GroupMonthInvoice> loadingItems = Iterable.generate(4).map((e) => GroupMonthInvoice.loadingItem()).toList();

  GtdInvoiceSumaryRs? invoiceSumaryRs;
  int totalInvoices = 0;

  InvoiceHistoryPageViewModel() {
    title = "Invoice history";
  }

  void updateGroupMonthInvoice(GtdInvoiceHistoryRs invoiceHistoryRs) {
    Map<String, List<GtdInvoiceDetail>> groups =
        (invoiceHistoryRs.content ?? []).groupListsBy((element) => element.groupName);
    //Update data to last group if have
    if (groups.keys.toList().contains(groupMonthInvoices.data.lastOrNull?.groupName)) {
      var values = groups[groupMonthInvoices.data.last.groupName] ?? [];
      groupMonthInvoices.data.last.invoiceDetails.addAll(values);
      groups.removeWhere((key, value) => key == groupMonthInvoices.data.last.groupName);
    }
    // Add new Groups
    List<GroupMonthInvoice> newGroupMonthInvoices = groups.entries.map((e) {
      var groupMonthInvoice = GroupMonthInvoice(groupName: e.key);
      groupMonthInvoice.invoiceDetails.addAll(e.value.toList());
      return groupMonthInvoice;
    }).toList();
    groupMonthInvoices.data.addAll(newGroupMonthInvoices);

    groupMonthInvoices.page = invoiceHistoryRs.pageable?.pageNumber ?? 0;
    groupMonthInvoices.totalPage = invoiceHistoryRs.totalPages ?? 0;
    if (invoiceSumaryRs != null) {
      updateInvoiceSumary(invoiceSumaryRs!);
    }
    
  }

  void updateInvoiceSumary(GtdInvoiceSumaryRs invoiceSumaryRs) {
    this.invoiceSumaryRs = invoiceSumaryRs;
    totalInvoices = invoiceSumaryRs.totalInvoice ?? 0;
    groupMonthInvoices.data.map((monthInvoice) {
      var result = (invoiceSumaryRs.invoiceSumary ?? [])
          .where((element) => element.groupName == monthInvoice.groupName)
          .map((e) {
        monthInvoice.totalAmount = (e.invoiceTotalSumMonth ?? 0).toCurrency();
        monthInvoice.totalInvoice = "${e.invoiceMonthCount ?? 0}";
        return monthInvoice;
      }).toList();
      return result;
    }).toList();
  }

  void addLoadingItems() {
    groupMonthInvoices.data.addAll(loadingItems);
  }

  void finishLoading() {
    groupMonthInvoices.data.removeWhere((element) => element.isLoadingItem);
  }

  void reset() {
    groupMonthInvoices = GtdPagingDTO(data: []);
  }
}

extension InvoiceSumaryHelper on InvoiceSumary {
  String get groupName {
    DateFormat dateParsingFormat = DateFormat("yyyy-MM-dd");
    try {
      var date = dateParsingFormat.parse(invoiceMonth ?? "");
      return monthYearFormat.format(date);
    } catch (e) {
      return "";
    }
  }
}
