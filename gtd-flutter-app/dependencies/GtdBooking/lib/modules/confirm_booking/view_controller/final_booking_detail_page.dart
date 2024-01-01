import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/confirm_booking/cubit/booking_result_cubit.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/pricing_bottom_page.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/final_booking_detail_page_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/final_booking_detail_view/view_model/final_booking_reservation_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/final_booking_detail_view/view_model/final_booking_status_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/final_booking_detail_view/views/final_booking_status_view.dart';
import 'package:gtd_booking/modules/confirm_booking/views/reservation_detail_view/view_model/booking_invoice_info_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/reservation_detail_view/views/booking_invoice_info_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../../checkout/views/box_contact_info.dart';
import '../../checkout/views/gotadi/gtd_insurance/views/box_insurance_info.dart';
import '../../checkout/views/gotadi/gtd_invoice/views/box_invoice_info.dart';
import '../views/final_booking_detail_view/views/final_booking_reservation_view.dart';

class FinalBookingDetailPage extends PricingBottomPage<FinalBookingDetailPageViewModel> {
  static const String route = '/finalBookingDetailPage';
  const FinalBookingDetailPage({super.key, required super.viewModel});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (bookingDetailContext) => BookingResultCubit()..finalBookingDetail(viewModel.bookingNumber!),
      ),
    ], child: super.build(context));
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocListener<BookingResultCubit, BookingResultState>(
      listener: (context, state) {
        if (state is BookingDetailErrorState) {
          GtdPopupMessage(context).showError(error: state.apiError.message);
        }
      },
      child: BlocBuilder<BookingResultCubit, BookingResultState>(
        builder: (bookingResultContext, bookingResultState) {
          return StreamBuilder(
              stream: BlocProvider.of<BookingResultCubit>(pageContext).bookingDetailSubject.stream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  viewModel.bookingDetailDTO = snapshot.data;
                  return Column(
                    children: [
                      SizedBox(width: double.infinity, child: buildHeaderBookingNumber(context: pageContext)),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return CustomScrollView(
                              slivers: [
                                SliverPadding(
                                  padding: const EdgeInsets.all(16),
                                  sliver: SliverToBoxAdapter(
                                    child: FinalBookingStatusView(
                                        viewModel:
                                            FinalBookingStatusViewModel(bookingDetailDTO: viewModel.bookingDetailDTO!)),
                                  ),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.all(16),
                                  sliver: SliverToBoxAdapter(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 16),
                                          child: Text(
                                            "Tóm tắt hành trình",
                                            style: TextStyle(
                                                fontSize: 15, color: AppColors.boldText, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        FinalBookingReservationView(
                                          viewModel: FinalBookingReservationViewModel(
                                              bookingDetailDTO: viewModel.bookingDetailDTO!),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // FlightItemSummaryListInfo.buildHorizontalListFlightItems(
                                //     viewModel.bookingDetailDTO?.flightDetailItems ?? []),
                                SliverPadding(
                                  padding: const EdgeInsets.all(16),
                                  sliver: SliverToBoxAdapter(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 16),
                                          child: Text(
                                            "Thông tin liên hệ",
                                            style: TextStyle(
                                                fontSize: 15, color: AppColors.boldText, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        viewModel.bookingDetailDTO?.contactBookingInfo != null
                                            ? BoxContactInfo.contactInfoFormFromBookingDetail(
                                                contactInputInfo: viewModel.bookingDetailDTO!.contactBookingInfo!,
                                                context: context)
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                                viewModel.taxCompanyName == null
                                    ? const SliverToBoxAdapter()
                                    : SliverPadding(
                                        padding: const EdgeInsets.all(16),
                                        sliver: SliverToBoxAdapter(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 16),
                                                child: Text(
                                                  "Thông tin xuất hoá đơn",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColors.boldText,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              BoxInvoiceInfo.invoiceInfo(
                                                invoiceTitle: viewModel.taxCompanyName!,
                                                context: context,
                                                onSelect: () {
                                                  GtdPresentViewHelper.presentView(
                                                    title: "Thông tin xuất hoá đơn",
                                                    contentPadding: const EdgeInsets.all(0),
                                                    context: context,
                                                    builder: Builder(
                                                      builder: (context) {
                                                        return ColoredBox(
                                                          color: Colors.grey.shade100,
                                                          child: BookingInvoiceInfoView(
                                                              viewModel: BookingInvoiceInfoViewModel
                                                                  .fromBookingDetailInvoiceInfo(
                                                                      bookingInvoiceInfo: viewModel
                                                                          .bookingDetailDTO!.invoiceBookingInfo!)),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                viewModel.bookingDetailDTO!.hasInsurance
                                    ? SliverPadding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        sliver: SliverToBoxAdapter(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                                                child: Text(
                                                  "Bảo hiểm",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColors.boldText,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              BoxInsuranceInfo.buildListHorizontalInsuranceInfo(
                                                  context: context,
                                                  bookingDetailDTO: viewModel.bookingDetailDTO!,
                                                  showStatus: true),
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SliverToBoxAdapter(),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  );
                }
              });
        },
      ),
    );
  }

  @override
  Widget? buildBottomBar(BuildContext pageContext) {
    return null;
  }
}
