import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/invoice/cubit/invoice_history_cubit.dart';
import 'package:gtd_booking/modules/invoice/model/group_month_invoice.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_info_row.dart';
import 'package:gtd_utils/base/view/gtd_web_view/gtd_web_view_stack.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/loadmore_list_extention.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_shimmer.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_sticky_header.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../view_model/invoice_history_page_viewmodel.dart';

class InvoiceHistoryPage extends BaseStatelessPage<InvoiceHistoryPageViewModel> {
  static const String route = "/invoiceHistoryPage";
  const InvoiceHistoryPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocProvider(
      create: (context) => InvoiceHistoryCubit()..loadAccountInfo(),
      child: Column(
        children: [
          BlocBuilder<InvoiceHistoryCubit, InvoiceHistoryState>(
            buildWhen: (previous, current) =>
                (current is InvoiceSumaryInitial || current is InvoiceHistoryInitial),
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GtdInfoRow(leftText: "Tổng số hoá đơn", rightText: "${viewModel.totalInvoices}"),
              );
            },
          ),
          Expanded(child: BlocBuilder<InvoiceHistoryCubit, InvoiceHistoryState>(
            builder: (context, state) {
              if (state is InvoiceHistoryError) {
                return const SizedBox(
                  child: Center(
                    child: Text("Không tìm thấy lịch sử hoá đơn"),
                  ),
                );
              }
              if (state is InvoiceSumaryInitial) {
                viewModel.updateInvoiceSumary(state.invoiceSumaryRs!);
              }
              if (state is InvoiceHistoryLoading) {
                return ListView.builder(itemCount: 4, itemBuilder: (context, index) => _invoiceItemLoading());
              }
              if (state is InvoiceHistoryInitial && state.invoiceHistoryRs != null) {
                viewModel.updateGroupMonthInvoice(state.invoiceHistoryRs!);
              }
              return RefreshIndicator(
                onRefresh: () async {
                  viewModel.reset();
                  BlocProvider.of<InvoiceHistoryCubit>(context).loadInvoiceHistories();
                },
                child: GtdLoadMoreExtention(
                    hasMore: () => viewModel.groupMonthInvoices.hasNextPage,
                    loadMore: () async {
                      if (state is! InvoiceHistoryLoadMore) {
                        await BlocProvider.of<InvoiceHistoryCubit>(context)
                            .loadMoreInvoiceHistories(page: viewModel.groupMonthInvoices.page + 1);
                      }
                    },
                    onLoadMore: () {
                      viewModel.addLoadingItems();
                    },
                    onLoadMoreFinished: () {
                      viewModel.finishLoading();
                    },
                    itemBuilder: (context, index) {
                      var groupMonthItem = viewModel.groupMonthInvoices.data[index];
                      if (groupMonthItem.isLoadingItem) {
                        return _invoiceItemLoading();
                      }
                      return GtdStickyHeader(
                          header: ColoredBox(
                              color: AppColors.lightMainColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: SizedBox(
                                    height: 70,
                                    child: GtdInfoRow(
                                      leftText: groupMonthItem.groupName,
                                      leftTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                      rightWidget: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(width: 90),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                GtdInfoRow(
                                                    leftText: "Số HĐ",
                                                    leftTextStyle: const TextStyle(fontWeight: FontWeight.w700),
                                                    rightText: groupMonthItem.totalInvoice,
                                                    rightColor: AppColors.mainColor),
                                                GtdInfoRow(
                                                  leftText: "Số tiền",
                                                  leftTextStyle: const TextStyle(fontWeight: FontWeight.w700),
                                                  rightText: groupMonthItem.totalAmount,
                                                  rightColor: AppColors.currencyText,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              )),
                          body: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var invoiceDetail = groupMonthItem.invoiceDetails[index];
                              return InkWell(
                                onTap: () {
                                  if (invoiceDetail.approvedStatus == "SUCCESS" &&
                                      invoiceDetail.einvoice?.messLog != null) {
                                    GtdPresentViewHelper.presentView(
                                        title: "Hoá đơn điện tử",
                                        context: context,
                                        builder: Builder(
                                          builder: (context) {
                                            return GtdWebViewStack(url: invoiceDetail.einvoice!.messLog!);
                                          },
                                        ));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: GtdInfoRow.twoColumn(
                                    leftWidget: Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(invoiceDetail.sumPaymentAmount?.toCurrency() ?? "",
                                              style: const TextStyle(fontWeight: FontWeight.w600)),
                                          Text("Ngày tạo ${invoiceDetail.createdDateDisplay}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400, color: AppColors.subText, fontSize: 12)),
                                          Text("Mã tham chiếu: ${invoiceDetail.bookingNumbers?.join(",")}",
                                              style: const TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    rightWidget: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(invoiceDetail.einvoice?.mtc ?? "",
                                            style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.subText)),
                                        Text(invoiceDetail.approvedStatus ?? "",
                                            style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.mainColor)),
                                        const Text(""),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: groupMonthItem.invoiceDetails.length,
                          ));
                    },
                    itemCount: () => viewModel.groupMonthInvoices.data.length),
              );
            },
          ))
        ],
      ),
    );
  }

  Widget _invoiceItemLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GtdShimmer(child: SizedBox(height: 80, width: double.infinity, child: GtdShimmer.cardLoading())),
    );
  }
}
