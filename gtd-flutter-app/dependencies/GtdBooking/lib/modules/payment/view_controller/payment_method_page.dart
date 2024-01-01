import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/confirm_booking/cubit/booking_result_cubit.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/pricing_bottom_page.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view/flight_item_summary_list_info.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view/flight_summary_item.dart';
import 'package:gtd_booking/modules/confirm_booking/views/hotel_view/view_model/hotel_summary_item_viewmodel.dart';
import 'package:gtd_booking/modules/payment/cubit/payment_method_cubit.dart';
import 'package:gtd_booking/modules/payment/view_controller/debit/view_controller/payment_debit_page.dart';
import 'package:gtd_booking/modules/payment/view_controller/debit/view_model/payment_debit_page_viewmodel.dart';
import 'package:gtd_booking/modules/payment/view_controller/pay_later/view_controller/payment_paylater_page.dart';
import 'package:gtd_booking/modules/payment/view_controller/pay_later/view_model/payment_paylater_page_viewmodel.dart';
import 'package:gtd_booking/modules/payment/view_model/payment_method_list_viewmodel.dart';
import 'package:gtd_booking/modules/payment/view_model/payment_method_page_viewmodel.dart';

import 'package:gtd_booking/modules/payment/views/payment_method_item.dart';
import 'package:gtd_booking/modules/payment/views/payment_method_list_view.dart';
import 'package:gtd_booking/modules/payment/views/promotions/view_model/list_voucher_viewmodel.dart';
import 'package:gtd_booking/modules/payment/views/promotions/views/list_voucher_view.dart';
import 'package:gtd_utils/base/page/base_web_view_page.dart';
import 'package:gtd_utils/base/view_model/base_web_view_page_view_model.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/network/gtd_app_logger.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/payment_method_type.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_dash_border/gtd_dashed_border.dart';
import 'package:gtd_utils/utils/popup/gtd_app_loading.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../../confirm_booking/views/hotel_view/view/hotel_summary_item.dart';
import 'kredivo/view_model/kredivo_load_viewmodel.dart';
import 'kredivo/views/kredivo_loan_view.dart';

class PaymentMethodPage extends PricingBottomPage<PaymentMethodPageViewModel> {
  static const String route = '/paymentMethod';
  const PaymentMethodPage({super.key, required super.viewModel});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (bookingDetailContext) => BookingResultCubit()..currentState(viewModel.bookingNumber!),
            lazy: false,
          ),
          BlocProvider(
            create: (paymentMethodContext) => PaymentMethodCubit(viewModel)..getPaymentMethods(),
            lazy: false,
          ),
        ],
        child: BlocConsumer<PaymentMethodCubit, PaymentMethodState>(
          listener: (context, state) {
            if (state is PaymentMethodLoadError) {
              GtdPopupMessage(context).showError(error: state.errorMessege);
            }
          },
          builder: (context, state) {
            return super.build(context);
          },
        ));
  }

  @override
  AppBar? buildAppbar(BuildContext pageContext) {
    viewModel.title = "Payment";
    viewModel.subTitle = "1 nguoi lon, 2 tre em";
    // viewModel.subTitle = viewModel.bookingNumber;
    return super.buildAppbar(pageContext);
  }

  @override
  Widget? buildBottomBar(BuildContext pageContext) {
    return BlocBuilder<BookingResultCubit, BookingResultState>(builder: ((bookingResultContext, bookingResultState) {
      if (bookingResultState is BookingDetailLoadingState && bookingResultState.status == BookingDetailStatus.success) {
        viewModel.bookingDetailDTO =
            BlocProvider.of<BookingResultCubit>(bookingResultContext).bookingDetailSubject.value;
      }
      return super.buildBottomBar(bookingResultContext)!;
    }));
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    var stateViewModel = BlocProvider.of<PaymentMethodCubit>(pageContext).viewModel;
    viewModel.updateFromStateViewModel(viewModel: stateViewModel);
    return Column(
      children: [
        buildHeaderBookingNumber(context: pageContext),
        Expanded(
          child: CustomScrollView(
            slivers: [
              BlocBuilder<BookingResultCubit, BookingResultState>(
                builder: (bookingResultContext, bookingResultState) {
                  if (bookingResultState is BookingDetailLoadingState &&
                      bookingResultState.status == BookingDetailStatus.success) {
                    if (bookingResultState.status == BookingDetailStatus.isLoading) {
                      return FlightSummaryItem.buildLoadingShimmerFlightItems();
                    }
                    if (bookingResultState.status == BookingDetailStatus.success) {
                      viewModel.bookingDetailDTO =
                          BlocProvider.of<BookingResultCubit>(bookingResultContext).bookingDetailSubject.value;
                      if (viewModel.bookingDetailDTO?.supplierType == "AIR") {
                        return FlightItemSummaryListInfo.buildHorizontalListFlightItems(
                            viewModel.bookingDetailDTO?.flightDetailItems ?? []);
                      }
                      if (viewModel.bookingDetailDTO?.supplierType == "HOTEL") {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: HotelSummaryItem(
                                viewModel: HotelSummaryItemViewModel.fromBookingDetailDTO(
                                    bookingDetailDTO: viewModel.bookingDetailDTO!)),
                          ),
                        );
                      }
                    }

                    return const SliverToBoxAdapter();
                  }
                  // return FlightSummaryItem.buildLoadingShimmerFlightItems();
                  return const SliverToBoxAdapter();
                },
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Chọn hình thức thanh toán",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: BlocProvider.of<PaymentMethodCubit>(pageContext).paymentMethodsStream,
                  builder: (context, snapshot) {
                    viewModel.availableMethods = snapshot.data ?? [];
                    if (viewModel.availableMethods.isNotEmpty) {
                      // return buildPaymentSinglechild(viewModel.availableMethods, pageContext);
                      return SliverToBoxAdapter(
                          child: PaymentMethodListView(
                              viewModel: PaymentMethodListViewModel(paymentItems: viewModel.availableMethods)));
                    } else {
                      return SliverToBoxAdapter(child: PaymentMethodItem.buildLoadingLishtPaymentMethod());
                    }
                  }),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Ưu đãi dành cho bạn",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
              buidPromotion(pageContext),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget buildBottomNext(BuildContext paymentContext) {
    return GtdButton(
      isEnable: true,
      onPressed: (value) {
        if (viewModel.selectedPayment?.paymentType != null) {
          handlePaymentNext(paymentMethodType: viewModel.selectedPayment!.paymentType, paymentContext: paymentContext);
        }
      },
      text: "Thanh toán",
      fontSize: 16,
      height: 48,
      borderRadius: 24,
      gradient: AppColors.appGradient,
    );
  }

  void handlePaymentNext({required PaymentMethodType paymentMethodType, required BuildContext paymentContext}) {
    var kredivoLoadViewModel = KredivoLoadViewModel(bookingNumber: viewModel.bookingNumber!);
    if (paymentMethodType == PaymentMethodType.kredivo) {
      GtdPresentViewHelper.presentView(
          context: paymentContext,
          title: "Trả góp Kredivo",
          contentPadding: const EdgeInsets.all(0),
          hasInsetBottom: false,
          builder: Builder(
            builder: (popupContext) {
              return KredivoLoadView(viewModel: kredivoLoadViewModel);
            },
          ));
    } else if (paymentMethodType == PaymentMethodType.atm) {
      PaymentDebitPageViewModel debitViewModel = PaymentDebitPageViewModel(
          bookingDetailDTO: viewModel.bookingDetailDTO!,
          paymentFee: viewModel.paymentFee,
          discountAmount: viewModel.discountAmount);
      paymentContext.push(PaymentDebitPage.route, extra: debitViewModel);
    } else if (paymentMethodType == PaymentMethodType.paylater) {
      PaymentPaylaterPageViewModel paylaterViewModel = PaymentPaylaterPageViewModel(
          bookingDetailDTO: viewModel.bookingDetailDTO!,
          paymentFee: viewModel.paymentFee,
          discountAmount: viewModel.discountAmount);
      paymentContext.push(PaymentPaylaterPage.route, extra: paylaterViewModel);
    } else {
      GtdAppLoading.of(paymentContext).show();
      BlocProvider.of<PaymentMethodCubit>(paymentContext)
          .paymentBooking(paymentMethodType: paymentMethodType)
          .then((value) {
        GtdAppLoading.of(paymentContext).hide();
        value.when(
            (success) => paymentContext.push(BaseWebViewPage.route,
                extra: BaseWebViewPageViewModel(url: success)..title = paymentMethodType.title),
            (error) => GtdPopupMessage(paymentContext).showError(error: error.message));
      });
    }
  }

  Widget buidPromotion(BuildContext paymentContext) {
    bool isEmptyVoucher = viewModel.voucherCode == null;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: SizedBox(
          // height: 99,
          child: Card(
            elevation: 0,
            color: Colors.white,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    GtdPresentViewHelper.presentView(
                        context: paymentContext,
                        title: "Mã ưu đãi",
                        contentPadding: const EdgeInsets.all(0),
                        useRootContext: false,
                        hasInsetBottom: true,
                        builder: Builder(
                          builder: (popupVoucherContext) {
                            return ListVoucherView(viewModel: ListVoucherViewModel());
                          },
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SizedBox(
                      height: 48,
                      child: GtdDashedBorder(
                        color: Colors.green.shade500,
                        strokeWidth: 1,
                        radius: const Radius.circular(8),
                        padding: EdgeInsets.zero,
                        borderType: BorderType.rRect,
                        strokeCap: isEmptyVoucher ? StrokeCap.butt : StrokeCap.square,
                        child: Card(
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            // side: BorderSide(width: 1.0, color: Colors.green.shade500, strokeAlign: 10),

                            // side: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          color: isEmptyVoucher ? Colors.white : Colors.green.shade50,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                GtdImage.svgFromSupplier(
                                  assetName: 'assets/payment/payment-promotion.svg',
                                ),
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      "Free phí xuất vé, thanh toán sau abcd ef",
                                      style: TextStyle(fontSize: 13, color: Colors.green),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Ink(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.all(0),
                                    decoration: ShapeDecoration(
                                        shape: const CircleBorder(),
                                        color: isEmptyVoucher ? Colors.white : Colors.green.shade50),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.center,
                                      highlightColor: Colors.transparent,
                                      onPressed: () {
                                        // viewModel.availableMethods.map((e) => e.isSelected = false).toList();
                                        // BlocProvider.of<RebuildWidgetCubit>(paymentContext).rebuildWidget();
                                        BlocProvider.of<PaymentMethodCubit>(paymentContext).getLoadKredivo();
                                        Logger.i("remove promotion");
                                      },
                                      iconSize: 24,
                                      icon: Icon(
                                        isEmptyVoucher ? Icons.add : Icons.close,
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Khuyen mai",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      Text(
                        "- 35,000 VND",
                        style: TextStyle(color: Colors.deepOrange.shade500),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
