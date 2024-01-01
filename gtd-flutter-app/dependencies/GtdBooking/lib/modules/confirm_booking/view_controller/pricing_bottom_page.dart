import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/confirm_booking_page.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/confirm_booking_page_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/price_bottom_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/pricing_bottom_page_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/price_bottom_detail_view.dart';
import 'package:gtd_booking/modules/confirm_booking/views/price_bottom_view.dart';
import 'package:gtd_booking/modules/payment/view_controller/payment_method_page.dart';
import 'package:gtd_booking/modules/payment/view_model/payment_method_page_viewmodel.dart';
import 'package:gtd_utils/base/bloc/cubit/rebuild_widget_cubit.dart';
import 'package:gtd_utils/base/page/base_tabbar_page.dart';
import 'package:gtd_utils/base/view_model/gtd_validate_field_vm.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_date_picker_scroll/flutter_datetime_picker.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_text_field.dart';
import 'package:gtd_utils/utils/popup/gtd_loading.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../../checkout/cubit/add_booking_traveler_cubit.dart';
import '../../checkout/cubit/payment_display_info_cubit.dart';
import '../../checkout/view_model/flight_checkout_page_viewmodel.dart';
import '../../checkout/view_model/flight_extras_page_viewmodel.dart';
import '../../checkout/view_model/flight_ssr_selection_page_viewmodel.dart';

class PricingBottomPage<T extends PricingBottomPageViewModel> extends BaseTabbarPage<T> {
  const PricingBottomPage({super.key, required super.viewModel});

  @override
  AppBar? buildAppbar(BuildContext pageContext) {
    if (viewModel is FlightCheckoutPageViewModel) {
      viewModel.title = 'checkout.travellerInfo'.tr();
    }

    return super.buildAppbar(pageContext);
  }

  Widget buildHeaderBookingNumber({EdgeInsets? padding, required BuildContext context}) {
    return Ink(
      color: Colors.white,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Mã tham chiếu",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const Expanded(child: SizedBox()),
            Text(
              viewModel.bookingNumber ?? "---",
              style: TextStyle(
                color: Colors.grey.shade900,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: viewModel.bookingNumber!));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Booking number copied")));
              },
              padding: EdgeInsets.zero,
              alignment: Alignment.centerRight,
              icon: GtdAppIcon.iconNamedSupplier(iconName: "icon-duplicate.svg", height: 35),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    // TODO: implement buildBody
    throw UnimplementedError();
  }

  @override
  Widget? buildBottomBar(BuildContext pageContext) {
    return Material(
        color: Colors.white,
        elevation: 10,
        shadowColor: Colors.black,
        child: BlocProvider(
          create: (paymentContext) => PaymentDisplayInfoCubit(viewModel),
          child: BlocBuilder<PaymentDisplayInfoCubit, PaymentDisplayInfoState>(
            builder: (paymentContext, state) {
              return SafeArea(
                bottom: true,
                child: Ink(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: SizedBox(
                      height: 130,
                      child: Column(
                        children: [
                          BlocBuilder<RebuildWidgetCubit, RebuildWidgetState>(
                            builder: (rebuildContext, rebuildState) {
                              return PriceBottomView(
                                viewModel: PriceBottomViewModel(
                                    netPrice: viewModel.netAmount.toCurrency(),
                                    totalPrice: "",
                                    priceTitle: viewModel.bottomPriceTitle),
                                onTab: (value) => GtdPresentViewHelper.presentSheet(
                                  title: "Thông tin thanh toán",
                                  context: paymentContext,
                                  builder: Builder(
                                    builder: (context) {
                                      return PriceBottomDetailView(viewModel: viewModel.priceBottomDetailViewModel);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: buildBottomNext(paymentContext),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }

  Widget buildBottomNext(BuildContext paymentContext) {
    if (viewModel is FlightExtrasPageViewModel) {
      FlightExtrasPageViewModel extrasPageViewModel = viewModel as FlightExtrasPageViewModel;
      return GtdButton(
        isEnable: true,
        onPressed: (value) async {
          if (extrasPageViewModel.mustInputContactDob()) {
            GtdPresentViewHelper.presentView<DateTime?>(
                title: "Bổ sung thông tin",
                context: paymentContext,
                useRootContext: false,
                onChanged: (result) {
                  if (result != null) {
                    extrasPageViewModel.contactInputInfo?.dob = result;
                  }
                },
                builder: Builder(
                  builder: (context) {
                    GtdSelectDateTextFieldVM selectDateTextFieldVM = GtdSelectDateTextFieldVM(
                      label: "checkout.dob".tr(),
                      allowEmpty: false,
                    );
                    GtdInputTextFieldVM contactTextFieldVM = GtdInputTextFieldVM(
                        label: "Họ & tên người đại diện",
                        inputUserBehavior: GtdInputUserBehavior.selection,
                        text: viewModel.contactInputInfo?.fullName);
                    contactTextFieldVM.text = viewModel.contactInputInfo?.fullName ?? "";

                    return BlocProvider(
                      create: (context) => RebuildWidgetCubit(),
                      child: BlocBuilder<RebuildWidgetCubit, RebuildWidgetState>(
                        builder: (context, state) {
                          return SizedBox(
                            child: Column(
                              children: [
                                const Text.rich(
                                  TextSpan(text: "Việc mua ", children: [
                                    TextSpan(
                                        text: "bảo hiểm Du lịch Flexi", style: TextStyle(fontWeight: FontWeight.w600)),
                                    TextSpan(
                                        text:
                                            " đòi hỏi người đại liện hệ đăng ký cần có đủ các thông tin để làm hợp đồng bảo hiểm. Quý khách vui lòng hoàn tất các thông tin dưới đây:")
                                  ]),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                GtdTextField(
                                  viewModel: contactTextFieldVM,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  boxBorder: BoxDecoration(
                                      border: Border.all(color: CustomColors.borderColor, width: 1.0),
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                GtdTextField(
                                  viewModel: selectDateTextFieldVM,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  height: 61,
                                  boxBorder: BoxDecoration(
                                      border: Border.all(color: CustomColors.borderColor, width: 1.0),
                                      borderRadius: BorderRadius.circular(6)),
                                  rightIcon: const Icon(Icons.arrow_drop_down),
                                  onSelect: () => GtdDatePickerScroll.showDatePicker(context,
                                      maxTime:
                                          DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
                                      onConfirm: (value) {
                                    selectDateTextFieldVM.selectedDate = value;
                                  }),
                                ),
                                const Expanded(child: SizedBox()),
                                SizedBox(
                                  height: 48,
                                  width: double.infinity,
                                  child: GtdButton(
                                      borderRadius: 24,
                                      onPressed: (value) {
                                        Navigator.of(context).pop(selectDateTextFieldVM.selectedDate);
                                      },
                                      gradient: GtdColors.appGradient(context),
                                      text: "Xác nhận"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ));
          } else {
            var confirmViewModel =
                ConfirmBookingPageViewModel(bookingNumber: viewModel.bookingDetailDTO!.bookingNumber!);
            confirmViewModel.bookingDetailDTO = viewModel.bookingDetailDTO;
            confirmViewModel.savedTravellers = viewModel.savedTravellers;
            confirmViewModel.countries = viewModel.countries;
            confirmViewModel.travelerInputInfos = viewModel.travelerInputInfos;
            confirmViewModel.contactInputInfo = viewModel.contactInputInfo;
            confirmViewModel.invoiceBookingInfo = viewModel.invoiceBookingInfo;
            paymentContext.push(ConfirmBookingPage.route, extra: confirmViewModel);
          }
        },
        text: 'global.next'.tr(),
        fontSize: 16,
        height: 48,
        borderRadius: 24,
        gradient: AppColors.appGradient,
      );
    } else if (viewModel is FlightSSRSelectionPageViewModel) {
      return GtdButton(
        isEnable: true,
        onPressed: (value) {
          var dtos = (viewModel as FlightSSRSelectionPageViewModel).confirmSelectServiceRequest();
          paymentContext.pop(dtos);
        },
        text: "Xác nhận",
        fontSize: 16,
        height: 48,
        borderRadius: 24,
        gradient: AppColors.appGradient,
      );
    } else if (viewModel is ConfirmBookingPageViewModel) {
      return SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: GtdButton(
                text: "Thay đổi",
                height: 48,
                color: Colors.white,
                colorText: AppColors.normalText,
                border: const Border.fromBorderSide(
                  BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
                borderRadius: 24,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 1,
              child: BlocProvider(
                create: (context) => AddBookingTravelerCubit(),
                child: BlocBuilder<AddBookingTravelerCubit, AddBookingTravelerState>(
                  builder: (addBookingContext, addBookingState) {
                    return GtdButton(
                      text: "Đi tiếp",
                      isEnable: (viewModel as ConfirmBookingPageViewModel).isAcceptTerm,
                      height: 48,
                      color: AppColors.buttonColor,
                      borderRadius: 24,
                      gradient: AppColors.appGradient,
                      onPressed: (value) {
                        var addBookingTravellerRq =
                            (viewModel as ConfirmBookingPageViewModel).createAddBookingTravellerRq;
                        print("goto payment method");
                        print(addBookingTravellerRq.toJson());
                        GtdLoading.show();
                        BlocProvider.of<AddBookingTravelerCubit>(addBookingContext)
                            .addBookingTraveller(addBookingTravellerRq, viewModel.bookingDetailDTO?.supplierType ?? "")
                            .then((value) {
                          GtdLoading.hide().whenComplete(() {
                            value.when((success) {
                              if (success.bookingCode?.bookingNumber != null) {
                                PaymentMethodPageViewModel paymentViewModel =
                                    PaymentMethodPageViewModel(bookingNumber: success.bookingCode!.bookingNumber);
                                paymentContext.push(PaymentMethodPage.route, extra: paymentViewModel);
                              }
                            }, (error) {
                              GtdPopupMessage(addBookingContext).showError(error: error.message);
                            });
                          });
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
