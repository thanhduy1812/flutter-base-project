import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/checkout/cubit/checkout_cubit.dart';
import 'package:gtd_booking/modules/checkout/cubit/flight_checkout_cubit.dart';
import 'package:gtd_booking/modules/checkout/cubit/flight_service_request_cubit.dart';
import 'package:gtd_booking/modules/checkout/view_controller/input_info_passenger_page.dart';
import 'package:gtd_booking/modules/checkout/view_model/checkout_traveller_form_vm.dart';
import 'package:gtd_booking/modules/checkout/view_model/flight_checkout_page_viewmodel.dart';
import 'package:gtd_booking/modules/checkout/view_model/input_info_passenger_page_viewmodel.dart';
import 'package:gtd_booking/modules/checkout/views/box_contact_info.dart';
import 'package:gtd_booking/modules/checkout/views/box_passenger_form.dart';
import 'package:gtd_booking/modules/checkout/views/gotadi/gtd_flight_checkout_content_viewmodel.dart';
import 'package:gtd_booking/modules/checkout/views/gotadi/gtd_hotel_checkout_content_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/combo_view/view/combo_summary_item.dart';
import 'package:gtd_booking/modules/confirm_booking/views/combo_view/view_model/combo_summary_item_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view/flight_item_summary_list_info.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view_model/flight_summary_item_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/hotel_view/view_model/hotel_summary_item_viewmodel.dart';
import 'package:gtd_booking/modules/invoice/view_controller/input_invoice_page.dart';
import 'package:gtd_booking/modules/invoice/view_model/input_invoice_page_viewmodel.dart';
import 'package:gtd_booking/modules/personal_info/cubit/country_codes_cubit.dart';
import 'package:gtd_booking/modules/personal_info/cubit/saved_traveller_cubit.dart';
import 'package:gtd_utils/base/bloc/cubit/rebuild_widget_cubit.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/helpers/extension/build_context_extension.dart';
import 'package:gtd_utils/utils/data_loader/resource_loader.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_html_view.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_radio_title.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../../../confirm_booking/views/hotel_view/view/hotel_summary_item.dart';
import 'gtd_checkout_content_viewmodel.dart';
import 'gtd_combo_checkout_content_viewmodel.dart';

class GtdCheckoutContentView extends BaseView<GtdCheckoutContentViewModel> {
  const GtdCheckoutContentView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    var pageViewModel = context.viewModelOf<CheckoutPageViewModel>();
    if (pageViewModel == null) {
      return const SizedBox();
    } else {
      return Column(
        children: [
          const Divider(
            color: Colors.black,
          ),
          const SizedBox(height: 1),
          Expanded(
            child: BlocBuilder<RebuildWidgetCubit, RebuildWidgetState>(
              builder: (rebuildContext, rebuildState) {
                return BlocBuilder<CheckoutCubit, CheckoutState>(
                  builder: (checkoutContext, infoFormState) {
                    return StatefulBuilder(builder: (context, setState) {
                      return Ink(
                        color: Colors.grey.shade50,
                        child: CustomScrollView(
                          slivers: [
                            Builder(
                              builder: (context) {
                                if (viewModel is GtdFlightCheckoutContentViewModel) {
                                  return BlocProvider(
                                    create: (context) =>
                                        FlightServiceRequestCubit(bookingDetailDTO: viewModel.bookingDetailDTO)
                                          ..getServiceRequests(),
                                    child: BlocBuilder<FlightServiceRequestCubit, FlightServiceRequestState>(
                                      builder: (serviceContext, serviceState) {
                                        if (serviceState is FlightServiceRequestLoaded &&
                                            viewModel is GtdFlightCheckoutContentViewModel) {
                                          (viewModel as GtdFlightCheckoutContentViewModel)
                                              .updateFetchedSSRItems(serviceState.ssrOfferDTOs);
                                        }
                                        return FlightItemSummaryListInfo.buildHorizontalListFlightItems(
                                            viewModel.bookingDetailDTO.flightDetailItems ?? []);
                                      },
                                    ),
                                  );
                                }
                                if (viewModel is GtdHotelCheckoutContentViewModel) {
                                  return SliverToBoxAdapter(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: SizedBox(
                                        child: HotelSummaryItem(
                                            viewModel: HotelSummaryItemViewModel.fromBookingDetailDTO(
                                                bookingDetailDTO: viewModel.bookingDetailDTO))),
                                  ));
                                }

                                if (viewModel is GtdComboCheckoutContentViewModel) {
                                  return BlocProvider(
                                    create: (context) =>
                                        FlightServiceRequestCubit(bookingDetailDTO: viewModel.bookingDetailDTO)
                                          ..getServiceRequests(),
                                    child: BlocBuilder<FlightServiceRequestCubit, FlightServiceRequestState>(
                                      builder: (serviceContext, serviceState) {
                                        if (serviceState is FlightServiceRequestLoaded &&
                                            viewModel is GtdComboCheckoutContentViewModel) {
                                          (viewModel as GtdComboCheckoutContentViewModel)
                                              .updateFetchedSSRItems(serviceState.ssrOfferDTOs);
                                        }
                                        // return FlightItemSummaryListInfo.buildHorizontalListFlightItems(
                                        //     viewModel.bookingDetailDTO.flightDetailItems ?? []);
                                        List<FlightSummaryItemViewModel> flightItemViewModels = (viewModel
                                                    .bookingDetailDTO.flightDetailItems ??
                                                [])
                                            .map((e) => FlightSummaryItemViewModel.fromItemDetail(flightItemDetail: e))
                                            .toList();
                                        HotelSummaryItemViewModel hotelSummaryItemViewModel =
                                            HotelSummaryItemViewModel.fromBookingDetailDTO(
                                                bookingDetailDTO: viewModel.bookingDetailDTO);
                                        return SliverToBoxAdapter(
                                            child: ComboSummaryItem(
                                                viewModel: ComboSummaryItemViewModel(
                                                    flightItemViewModels: flightItemViewModels,
                                                    hotelItemViewModel: hotelSummaryItemViewModel)));
                                      },
                                    ),
                                  );
                                }

                                return const SliverToBoxAdapter();
                              },
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                        text: "Thông tin hành khách \n",
                                        style: TextStyle(
                                            fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText)),
                                    TextSpan(
                                        text:
                                            "Vui lòng nhập Tiếng Việt không dấu hoặc Tiếng Anh theo thông tin CMND/CCCD/Passport",
                                        style: TextStyle(
                                            fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText)),
                                  ]),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Ink(
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.05),
                                        spreadRadius: 0,
                                        blurRadius: 0,
                                        offset: Offset(0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: BlocBuilder<SavedTravellerCubit, SavedTravellerState>(
                                    builder: (savedTravellerContext, savedTravellerState) {
                                      bool isDisable = savedTravellerState is SavedTravellerStateLoading;
                                      if (savedTravellerState is SavedTravellerInitial) {
                                        pageViewModel.savedTravellers = (savedTravellerState).travellers;
                                      }

                                      return BlocBuilder<CountryCodesCubit, CountryCodesState>(
                                        builder: (countryContext, countryState) {
                                          pageViewModel.countries = countryState.countries;
                                          return StreamBuilder(
                                              stream: viewModel.passengersStream,
                                              builder: (context, snapshot) {
                                                if (snapshot.data == null) {
                                                  return const SizedBox();
                                                }
                                                List<CheckoutTravellerFormVM> travellers = snapshot.data ?? [];
                                                return ListView.separated(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: travellers.length,
                                                  itemBuilder: (context, index) {
                                                    var travelerVM = travellers[index];
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 0),
                                                      child: GestureDetector(
                                                        behavior: HitTestBehavior.opaque,
                                                        onTap: isDisable
                                                            ? null
                                                            : () {
                                                                var inputInfoViewModel =
                                                                    InputInfoPassengerPageViewModel(
                                                                        title: travelerVM.adultTitle,
                                                                        travelerInputInfoDTO: travelerVM
                                                                                .travelerInputInfoDTO ??
                                                                            TravelerInputInfoDTO(
                                                                                title: travellers[index].adultTitle,
                                                                                adultType: travelerVM.adultType,
                                                                                infoType: (viewModel
                                                                                        is GtdHotelCheckoutContentViewModel)
                                                                                    ? TravelerInputInfoType
                                                                                        .presenterHotel
                                                                                    : (viewModel
                                                                                            is GtdComboCheckoutContentViewModel)
                                                                                        ? TravelerInputInfoType
                                                                                            .travelerCombo
                                                                                        : TravelerInputInfoType
                                                                                            .traveler),
                                                                        // savedTravellers: pageViewModel.savedTravellers.where((element) => element.adultType == travelerVM.adultType.value).toList(),
                                                                        savedTravellers: pageViewModel.savedTravellers
                                                                            .where((element) =>
                                                                                element.adultType ==
                                                                                    travelerVM.adultType.value ||
                                                                                element.dob == null)
                                                                            .toList(),
                                                                        countries: pageViewModel.countries);
                                                                var result = context.push(
                                                                  InputInfoPassengerPage.route,
                                                                  extra: inputInfoViewModel,
                                                                );
                                                                result.then((value) {
                                                                  print(value);
                                                                  TravelerInputInfoDTO? infoDTO =
                                                                      value as TravelerInputInfoDTO?;
                                                                  if (infoDTO != null) {
                                                                    viewModel.updatePassengerFromTravelerInputInfo(
                                                                        key: travellers[index].position,
                                                                        infoDTO: infoDTO);
                                                                  }
                                                                });
                                                              },
                                                        child: Opacity(
                                                          opacity: isDisable ? 0.4 : 1,
                                                          child: BoxPassengerForm(
                                                            key: travellers[index].position,
                                                            travellerForm: travellers[index],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder: (context, index) => const Divider(),
                                                );
                                              });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: StreamBuilder(
                                    stream: viewModel.contactStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.data == null) {
                                        return const SizedBox();
                                      }
                                      var contactForm = snapshot.data!;
                                      return BoxContactInfo(
                                        key: contactForm.position,
                                        contactForm: contactForm,
                                      );
                                    }),
                              ),
                            ),
                            Builder(builder: (context) {
                              if (viewModel is GtdComboCheckoutContentViewModel) {
                                return SliverToBoxAdapter(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: const Icon(
                                          Icons.warning_rounded,
                                          size: 40,
                                        ),
                                        title: Text(
                                          "Thông tin quan trọng về combo của bạn!",
                                          style: TextStyle(
                                              fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText),
                                        ),
                                      ),
                                      Card(
                                        margin: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Text.rich(TextSpan(
                                              text: "Đây là giá không hoàn tiền \n",
                                              style: TextStyle(
                                                  fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.boldText),
                                              children: const [
                                                TextSpan(
                                                    text:
                                                        "Nếu có thay đổi hoặc hủy dịch vụ này, quý khách sẽ không nhận được bất kỳ khoản hoàn trả nào.Chúng tôi hiểu rằng, có thể có những thay đổi trong kế hoạch chuyến đi của quý vị. Gotadi sẽ linh hoạt hỗ trợ đối với những yêu cầu phát sinh và trong điều kiện cho phép đối với từng loại dịch vụ (theo điều kiện riêng của vé máy bay, nơi lưu trú)…",
                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
                                              ])),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                );
                              } else {
                                return _buildInvoiceCell(pageViewModel, context);
                              }
                            }),
                          ],
                        ),
                      );
                    });
                  },
                );
              },
            ),
          ),
        ],
      );
    }
  }

  SliverToBoxAdapter _buildInvoiceCell(CheckoutPageViewModel pageViewModel, BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: "Thông tin xuất hoá đơn",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText)),
              ]),
            ),
            Card(
              elevation: 1,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GtdRadioTitle(
                          label: "Xuất hoá đơn",
                          value: true,
                          groupValue: pageViewModel.isTaxReceipt,
                          onChanged: (value) {
                            print(value);
                            InputInvoicePageViewModel invoicePageViewModel = InputInvoicePageViewModel(
                                countries: pageViewModel.countries,
                                invoiceBookingInfo: pageViewModel.invoiceBookingInfo);
                            var result = context.push<GtdInvoiceBookingInfo>(InputInvoicePage.route,
                                extra: invoicePageViewModel);
                            result.then((invoiceInfo) {
                              if (invoiceInfo != null) {
                                pageViewModel.isTaxReceipt = value;
                                pageViewModel.invoiceBookingInfo = invoiceInfo;
                                BlocProvider.of<RebuildWidgetCubit>(context).rebuildWidget();
                              }
                            });
                          },
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        GtdRadioTitle(
                          label: "Không xuất",
                          value: false,
                          groupValue: pageViewModel.isTaxReceipt,
                          onChanged: (value) {
                            print(value);
                            pageViewModel.isTaxReceipt = value;
                            pageViewModel.invoiceBookingInfo = null;
                            BlocProvider.of<RebuildWidgetCubit>(context).rebuildWidget();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: "Từ ngày 03/05/2022 Gotadi chuyển sang xuất hóa đơn điện tử ",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.boldText)),
                        TextSpan(
                            text:
                                "với những đặt chỗ trong cùng ngày giao dịch. Những giao dịch quá hạn Gotadi xin phép từ chối yêu cầu hỗ trợ điều chỉnh thông tin hoặc xuất hóa đơn. ",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.normalText)),
                        TextSpan(
                          text: "Tìm hiểu thêm",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.mainColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              GtdResourceLoader.loadContentFromResource(
                                      pathResource: GtdResourceLoader.gotadiInvoicePath)
                                  .then((value) {
                                GtdPresentViewHelper.presentView(
                                    title: "Lưu ý xuất hoá đơn điện tử",
                                    context: context,
                                    builder: Builder(
                                      builder: (context) {
                                        return GtdHtmlView(
                                          htmlString: value,
                                        );
                                      },
                                    ));
                              });
                            },
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
