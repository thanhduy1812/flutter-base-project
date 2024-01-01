import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/confirm_booking_page_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/combo_view/view/combo_summary_item.dart';
import 'package:gtd_booking/modules/confirm_booking/views/combo_view/view_model/combo_summary_item_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/flight_view/view_model/flight_summary_item_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/hotel_view/view_model/hotel_summary_item_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/views/reservation_detail_view/views/booking_invoice_info_view.dart';
import 'package:gtd_booking/modules/personal_info/cubit/country_codes_cubit.dart';
import 'package:gtd_booking/modules/personal_info/cubit/saved_traveller_cubit.dart';
import 'package:gtd_utils/base/bloc/cubit/rebuild_widget_cubit.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_radio.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../../checkout/views/box_contact_info.dart';
import '../../checkout/views/box_passenger_form.dart';
import '../../checkout/views/gotadi/gtd_insurance/views/box_insurance_info.dart';
import '../../checkout/views/gotadi/gtd_invoice/views/box_invoice_info.dart';
import '../views/flight_view/view/flight_item_summary_list_info.dart';
import '../views/hotel_view/view/hotel_summary_item.dart';
import '../views/reservation_detail_view/view_model/booking_invoice_info_viewmodel.dart';
import '../views/reservation_detail_view/view_model/booking_traveler_info_viewmodel.dart';
import '../views/reservation_detail_view/views/booking_traveler_info_view.dart';
import 'pricing_bottom_page.dart';

class ConfirmBookingPage extends PricingBottomPage<ConfirmBookingPageViewModel> {
  static const String route = '/confirmBooking';
  const ConfirmBookingPage({super.key, required super.viewModel});

  @override
  AppBar? buildAppbar(BuildContext pageContext) {
    viewModel.subTitle = viewModel.generateSubTitle;
    return super.buildAppbar(pageContext);
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    // var travellers = viewModel.travelerInputInfos;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          SizedBox(width: double.infinity, child: buildHeaderBookingNumber(context: pageContext)),
          Expanded(
            child: CustomScrollView(
              slivers: [
                Builder(builder: (context) {
                  if (viewModel.bookingDetailDTO?.supplierType == "AIR") {
                    return FlightItemSummaryListInfo.buildHorizontalListFlightItems(
                        viewModel.bookingDetailDTO?.flightDetailItems ?? []);
                  }
                  if (viewModel.bookingDetailDTO?.supplierType == "HOTEL") {
                    return SliverToBoxAdapter(
                        child: HotelSummaryItem(
                      viewModel:
                          HotelSummaryItemViewModel.fromBookingDetailDTO(bookingDetailDTO: viewModel.bookingDetailDTO!),
                    ));
                  }
                  if (viewModel.bookingDetailDTO?.supplierType == "COMBO") {
                    List<FlightSummaryItemViewModel> flightItemViewModels =
                        (viewModel.bookingDetailDTO?.flightDetailItems ?? [])
                            .map((e) => FlightSummaryItemViewModel.fromItemDetail(flightItemDetail: e))
                            .toList();
                    HotelSummaryItemViewModel hotelSummaryItemViewModel =
                        HotelSummaryItemViewModel.fromBookingDetailDTO(bookingDetailDTO: viewModel.bookingDetailDTO!);
                    return SliverToBoxAdapter(
                        child: ComboSummaryItem(
                            viewModel: ComboSummaryItemViewModel(
                                flightItemViewModels: flightItemViewModels,
                                hotelItemViewModel: hotelSummaryItemViewModel)));
                  }
                  return const SliverToBoxAdapter();
                }),
                buildListPassengers(pageContext),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (savedTravellerContext) => SavedTravellerCubit(savedTravellers: viewModel.savedTravellers),
      ),
      BlocProvider(
        create: (countriesContext) => CountryCodesCubit(countries: viewModel.countries),
      ),
    ], child: super.build(context));
  }

  Widget buildListPassengers(BuildContext context) {
    var travellers = viewModel.travelerInputInfos;
    var passengerHeaderTitle = "Thông tin hành khách";
    if (viewModel.bookingDetailDTO?.supplierType == "AIR") {
      passengerHeaderTitle = "Thông tin hành khách";
    }
    if (viewModel.bookingDetailDTO?.supplierType == "HOTEL") {
      passengerHeaderTitle = "Thông tin phòng & khách";
    }
    if (viewModel.bookingDetailDTO?.supplierType == "COMBO") {
      passengerHeaderTitle = "Thông tin phòng & khách";
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        ///THONG TIN HANH KHACH
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            passengerHeaderTitle,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
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
                viewModel.savedTravellers = (savedTravellerState as SavedTravellerInitial?)?.travellers ?? [];
                return BlocBuilder<CountryCodesCubit, CountryCodesState>(
                  builder: (countryContext, countryState) {
                    viewModel.countries = countryState.countries;
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: travellers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              GtdPresentViewHelper.presentView(
                                  title: "Thông tin khách",
                                  contentPadding: const EdgeInsets.all(0),
                                  context: context,
                                  builder: Builder(
                                    builder: (context) {
                                      return ColoredBox(
                                        color: Colors.grey.shade100,
                                        child: BookingTravelerInfoView(
                                            viewModel: BookingTravelerInfoViewModel.fromTravelerInputInfoDTO(
                                          title: travellers[index].title,
                                          traveler: travellers[index],
                                        )),
                                      );
                                    },
                                  ));
                            },
                            child: BoxPassengerForm.pasengerInfoForm(travellers[index], context),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    );
                  },
                );
              },
            ),
          ),
        ),

        ///THONG TIN LIEN HE
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Thông tin liên hệ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        BoxContactInfo.contactInfoForm(
            context: context,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            contactInputInfo: viewModel.contactInputInfo),

        /// THONG TIN XUAT HOA DON
        viewModel.invoiceBookingInfo == null
            ? const SizedBox()
            : InkWell(
                onTap: () {
                  GtdPresentViewHelper.presentView(
                    title: "Thông tin xuất hoá đơn",
                    contentPadding: const EdgeInsets.all(0),
                    context: context,
                    builder: Builder(
                      builder: (context) {
                        return ColoredBox(
                          color: Colors.grey.shade100,
                          child: BookingInvoiceInfoView(
                              viewModel: BookingInvoiceInfoViewModel.fromBookingDetailInvoiceInfo(
                                  bookingInvoiceInfo: viewModel.invoiceBookingInfo!)),
                        );
                      },
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Thông tin xuất hoá đơn",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
        viewModel.invoiceBookingInfo == null
            ? const SizedBox()
            : InkWell(
                onTap: () {
                  GtdPresentViewHelper.presentView(
                    title: "Thông tin xuất hoá đơn",
                    contentPadding: const EdgeInsets.all(0),
                    context: context,
                    builder: Builder(
                      builder: (context) {
                        return ColoredBox(
                          color: Colors.grey.shade100,
                          child: BookingInvoiceInfoView(
                              viewModel: BookingInvoiceInfoViewModel.fromBookingDetailInvoiceInfo(
                                  bookingInvoiceInfo: viewModel.invoiceBookingInfo!)),
                        );
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BoxInvoiceInfo.invoiceInfo(
                      invoiceTitle: viewModel.invoiceBookingInfo?.taxCompanyName ?? "", context: context),
                ),
              ),

        /// BAO HIEM
        buildInsuranceSection(context),

        /// Combo Note
        (viewModel.bookingDetailDTO?.supplierType == "COMBO")
            ? Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.warning_rounded,
                        size: 40,
                      ),
                      title: Text(
                        "Thông tin quan trọng về combo của bạn!",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text.rich(TextSpan(
                            text: "Đây là giá không hoàn tiền \n",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.boldText),
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
              )
            : const SizedBox(),

        ///Term and policy
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GtdRadio(
                    groupValue: viewModel.isAcceptTerm,
                    value: true,
                    padding: const EdgeInsets.all(8),
                    selectedIcon: GtdAppIcon.iconNamedSupplier(iconName: "/radio/radio-checkbox-active.svg"),
                    unselectedIcon: GtdAppIcon.iconNamedSupplier(iconName: "/radio/radio-checkbox.svg"),
                    onChanged: ((value) {
                      viewModel.isAcceptTerm = !viewModel.isAcceptTerm;
                      BlocProvider.of<RebuildWidgetCubit>(context).rebuildWidget();
                    })),
                Expanded(
                  child: Text.rich(TextSpan(children: [
                    const TextSpan(
                      text: 'Tôi đã đọc và chấp nhận ',
                      style: TextStyle(
                        color: Color(0xFF121826),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: 'Điều khoản sử dụng của Gotadi và Điều lệ vận chuyển',
                      style: const TextStyle(
                        color: Color(0xFF1AA260),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("dieu khoan su dung");
                        },
                    ),
                    const TextSpan(
                      text: ' đối với các chuyến bay của',
                      style: TextStyle(
                        color: Color(0xFF121826),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: ' Vietnam Airlines',
                      style: const TextStyle(
                        color: Color(0xFF1AA260),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("Vietnam Airlines");
                        },
                    ),
                  ])),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget buildInsuranceSection(BuildContext context) {
    bool hasInsurance = viewModel.travelerInputInfos
        .map((e) => e.selectedServices)
        .flattened
        .where((e) => e.serviceType == ServiceType.insurance)
        .toList()
        .isNotEmpty;
    if (!hasInsurance) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Bảo hiểm",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        BoxInsuranceInfo.buildListHorizontalInsuranceInfoConfirmPage(
            context: context, inputInfoDTOs: viewModel.travelerInputInfos)
        // BoxInsuranceInfo.buildListHorizontalInsuranceInfo(
        //   context: context,
        //   bookingDetailDTO: viewModel.bookingDetailDTO!,
        // ),
      ],
    );
  }
}
