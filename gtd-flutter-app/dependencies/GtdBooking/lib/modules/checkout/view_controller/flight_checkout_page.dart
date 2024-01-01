import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/checkout/cubit/checkout_cubit.dart';
import 'package:gtd_booking/modules/checkout/views/gotadi/gtd_checkout_content_view.dart';
import 'package:gtd_booking/modules/checkout/views/gotadi/gtd_flight_checkout_content_viewmodel.dart';
import 'package:gtd_booking/modules/checkout/views/vib/vib_flight_checkout_content.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/pricing_bottom_page.dart';
import 'package:gtd_booking/modules/personal_info/cubit/country_codes_cubit.dart';
import 'package:gtd_booking/modules/personal_info/cubit/saved_traveller_cubit.dart';
import 'package:gtd_utils/base/bloc/cubit/rebuild_widget_cubit.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/gtd_app_config.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/native_communicate/gtd_native_channel.dart';
import 'package:gtd_utils/utils/popup/gtd_app_loading.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';

import '../cubit/flight_checkout_cubit.dart';
import '../view_model/flight_checkout_page_viewmodel.dart';
import '../view_model/flight_extras_page_viewmodel.dart';
import 'flight_extras_page.dart';

class FlightCheckoutPage extends PricingBottomPage<FlightCheckoutPageViewModel> {
  static const String route = '/flightCheckout';
  const FlightCheckoutPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    switch (viewModel.supplier) {
      case GtdAppSupplier.vib:
        return const VibFlightCheckoutContent();
      case GtdAppSupplier.b2c:
        return BlocProvider.value(
          value: BlocProvider.of<RebuildWidgetCubit>(pageContext),
          child: GtdCheckoutContentView(
            viewModel: viewModel.checkoutContentViewModel,
          ),
        );
      // return const GtdCheckoutContent();
      default:
        return BlocProvider.value(
          value: BlocProvider.of<RebuildWidgetCubit>(pageContext),
          child: GtdCheckoutContentView(
            viewModel: viewModel.checkoutContentViewModel,
          ),
        );
    }
  }

  @override
  Widget buildBottomNext(BuildContext paymentContext) {
    return StreamBuilder(
        stream: viewModel.checkoutContentViewModel.isEnableCheckoutBtn,
        builder: (context, snapshot) {
          return GtdButton(
            isEnable: snapshot.data ?? false,
            onPressed: (snapshot.data == false)
                ? null
                : (value) {
                    viewModel.confirmListTravelerDTOS(
                      viewModel.checkoutContentViewModel.passengersFormSubject.value,
                      viewModel.checkoutContentViewModel.contactFormSubject.value,
                    );
                    onNext(paymentContext);
                  },
            text: 'global.next'.tr(),
            fontSize: 16,
            height: 48,
            borderRadius: 24,
            gradient: AppColors.appGradient,
          );
        });
  }

  void onNext(BuildContext paymentContext) {
    if (viewModel.supplier == GtdAppSupplier.vib) {
      BlocProvider.of<FlightCheckoutCubit>(paymentContext).validationPassengersInput().then((value) {
        if (value.item1 == true) {
          GtdAppLoading.of(paymentContext).show();
          BlocProvider.of<FlightCheckoutCubit>(paymentContext).addBookingTraveller().then((value) {
            GtdAppLoading.of(paymentContext).hide();
            value.when((success) {
              String bookingNumber = success;
              Map<String, dynamic> params = {};
              params.putIfAbsent("bookingNumber", () => bookingNumber);
              paymentContext.push('/flightBookingResult', extra: params);
              GtdNativeChannel.shared.gotoPaymentPartner(bookingNumber);
            }, (error) {
              GtdPopupMessage(paymentContext).showError(error: error.message);
            });
          });
        }
      });
    }

    if (viewModel.supplier == GtdAppSupplier.b2c &&
        viewModel.checkoutContentViewModel is GtdFlightCheckoutContentViewModel) {
      var inititalSsrs = (viewModel.checkoutContentViewModel as GtdFlightCheckoutContentViewModel)
          .ssrItemsSubject
          .value
          .map((e) => e.data)
          .toList();

      var flightExtraViewModel =
          FlightExtrasPageViewModel(bookingDetailDTO: viewModel.bookingDetailDTO, initialSsrItems: inititalSsrs);
      flightExtraViewModel.savedTravellers = viewModel.savedTravellers;
      flightExtraViewModel.countries = viewModel.countries;
      flightExtraViewModel.travelerInputInfos = viewModel.travelerInputInfos;
      flightExtraViewModel.contactInputInfo = viewModel.contactInputInfo;
      flightExtraViewModel.invoiceBookingInfo = viewModel.invoiceBookingInfo;
      paymentContext.push(FlightExtrasPage.route, extra: flightExtraViewModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (checkoutContext) => FlightCheckoutCubit()..initPassengers(viewModel),
      ),
      BlocProvider(
        create: (checkoutContext) => CheckoutCubit()..initPassengers(viewModel),
      ),
      BlocProvider(
        create: (savedTravellerContext) => SavedTravellerCubit(),
      ),
      BlocProvider(
        create: (countriesContext) => CountryCodesCubit()..getCountries(),
      ),
      // BlocProvider(
      //   // create: (paymentContext) => PaymentDisplayInfoCubit(BlocProvider.of<InfoFormValidationCubit>(paymentContext)),
      //   create: (paymentContext) => PaymentDisplayInfoCubit(viewModel),
      // ),
    ], child: super.build(context));
  }

  //   double offsetOfItem(GlobalKey key) {
  //   RenderBox? box = key.currentContext?.findRenderObject() as RenderBox;
  //   RenderBox? boxParent = _positionKey.currentContext?.findRenderObject() as RenderBox;
  //   final offset = box.localToGlobal(Offset.zero);
  //   final parrentOffset = boxParent.localToGlobal(Offset.zero);
  //   Logger.w(parrentOffset.dy.toString());
  //   return offset.dy - parrentOffset.dy - boxParent.size.height - box.size.height;
  // }
}
