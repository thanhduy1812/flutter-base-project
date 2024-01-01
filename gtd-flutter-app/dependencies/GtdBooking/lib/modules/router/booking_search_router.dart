import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/checkout/view_controller/combo_checkout_page.dart';
import 'package:gtd_booking/modules/checkout/view_controller/flight_checkout_page.dart';
import 'package:gtd_booking/modules/checkout/view_controller/flight_extras_page.dart';
import 'package:gtd_booking/modules/checkout/view_controller/flight_ssr_selection_page.dart';
import 'package:gtd_booking/modules/checkout/view_controller/hotel_checkout_page.dart';
import 'package:gtd_booking/modules/checkout/view_controller/hotel_ssr_selection_page.dart';
import 'package:gtd_booking/modules/checkout/view_controller/input_info_passenger_page.dart';
import 'package:gtd_booking/modules/checkout/view_model/combo_checkout_page_viewmodel.dart';
import 'package:gtd_booking/modules/checkout/view_model/flight_checkout_page_viewmodel.dart';
import 'package:gtd_booking/modules/checkout/view_model/flight_extras_page_viewmodel.dart';
import 'package:gtd_booking/modules/checkout/view_model/flight_ssr_selection_page_viewmodel.dart';
import 'package:gtd_booking/modules/checkout/view_model/hotel_checkout_page_viewmodel.dart';
import 'package:gtd_booking/modules/checkout/view_model/hotel_ssr_selection_page_viewmodel.dart';
import 'package:gtd_booking/modules/checkout/view_model/input_info_passenger_page_viewmodel.dart';
import 'package:gtd_booking/modules/combo/form_search/view_controller/combo_searching_loading_page.dart';
import 'package:gtd_booking/modules/combo/form_search/view_controller/search_combo_page.dart';
import 'package:gtd_booking/modules/combo/form_search/view_model/combo_searching_loading_page_viewmodel.dart';
import 'package:gtd_booking/modules/combo/form_search/view_model/search_combo_page_viewmodel.dart';
import 'package:gtd_booking/modules/combo/search_result/view_controller/combo_search_result_page.dart';
import 'package:gtd_booking/modules/combo/search_result/view_model/combo_search_result_page_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/booking_result.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/confirm_booking_page.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/final_booking_detail_page.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/reservation_detail_page.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/confirm_booking_page_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/final_booking_detail_page_viewmodel.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/reservation_detail_page_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/view_controller/search_flight_page.dart';
import 'package:gtd_booking/modules/flight/form_search/view_model/flight_searching_loading_page_viewmodel.dart';
import 'package:gtd_booking/modules/flight/search_result/view_model/flight_search_result_page_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_controller/hotel_searching_loading_page.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_controller/search_hotel_page.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_model/search_hotel_page_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_controller/hotel_search_detail_page.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_controller/hotel_search_result_page.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_controller/hotel_search_room_detail_page.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_search_detail_page_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_search_result_page_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_search_room_detail_page_viewmodel.dart';
import 'package:gtd_booking/modules/intro_view/view_controller/home_vib.dart';
import 'package:gtd_booking/modules/intro_view/view_controller/introduce_vib.dart';

import 'package:gtd_booking/modules/flight/form_search/view_controller/flight_searching_loading_page.dart';
import 'package:gtd_booking/modules/invoice/view_controller/input_invoice_page.dart';
import 'package:gtd_booking/modules/invoice/view_model/input_invoice_page_viewmodel.dart';
import 'package:gtd_booking/modules/my_booking/view_controller/gtd_my_booking_page.dart';
import 'package:gtd_booking/modules/my_booking/view_controller/vib_my_booking_page.dart';
import 'package:gtd_booking/modules/my_booking/view_model/gtd_my_booking_page_viewmodel.dart';
import 'package:gtd_booking/modules/payment/view_controller/debit/view_controller/payment_debit_page.dart';
import 'package:gtd_booking/modules/payment/view_controller/debit/view_model/payment_debit_page_viewmodel.dart';
import 'package:gtd_booking/modules/payment/view_controller/pay_later/view_controller/payment_paylater_page.dart';
import 'package:gtd_booking/modules/payment/view_controller/pay_later/view_model/payment_paylater_page_viewmodel.dart';
import 'package:gtd_booking/modules/payment/view_controller/payment_method_page.dart';
import 'package:gtd_booking/modules/payment/view_controller/vib_invoice.dart';
import 'package:gtd_booking/modules/payment/view_model/payment_method_page_viewmodel.dart';
import 'package:gtd_utils/base/page/base_web_view_page.dart';
import 'package:gtd_utils/base/router/app_router.dart';
import 'package:gtd_utils/base/view_model/base_web_view_page_view_model.dart';
import 'package:gtd_utils/constants/app_const.dart';
import 'package:gtd_utils/data/configuration/gtd_app_config.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';

import '../flight/form_search/view_model/search_flight_page_viewmodel.dart';
import '../flight/search_result/view_controller/flight_search_result_page.dart';
import '../hotel/form_search/view_model/hotel_searching_loading_page_viewmodel.dart';

extension GtdBookingRouter on AppRouter {
  static List<RouteBase> bookingBaseRouters({GlobalKey<NavigatorState>? rootKey, GlobalKey<NavigatorState>? shellKey}) {
    List<RouteBase> bookingRouters = [
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/homeVIB',
        // path: '/',
        name: 'homeVIB', //Used for pushNamed and pass params
        builder: (context, state) {
          return HomeVibPage(key: state.pageKey);
          // return const HomeScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/testLocale',
        // path: '/',
        name: 'testLocale', //Used for pushNamed and pass params
        builder: (context, state) {
          return VIBIntroWidget(key: state.pageKey);
          // return const HomeScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/vib',
        // path: '/',
        name: 'vib', //Used for pushNamed and pass params
        builder: (context, state) {
          return VIBIntroWidget(key: state.pageKey);
          // return const HomeScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/myBooking',
        name: 'myBooking',
        builder: (context, state) {
          // final StatefulWidget pageRouter;
          switch (AppConst.shared.appScheme.appSupplier) {
            case GtdAppSupplier.vib:
              return VibMyBookingPage(key: state.pageKey);

            default:
              return GtdMyBookingPage(key: state.pageKey, viewModel: GtdMyBookingPageViewModel());
          }
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: SearchFlightPage.route,
        // path: '/',
        name: 'flightSearch', //Used for pushNamed and pass params
        builder: (context, state) {
          SearchFlightPageViewModel? viewModel = state.extra as SearchFlightPageViewModel?;
          return SearchFlightPage(
            viewModel: viewModel ?? SearchFlightPageViewModel(),
            key: state.pageKey,
          );
        },
        routes: const [],
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: FlightSearchingLoadingPage.route,
        name: 'loadingFlightSearch',
        builder: (context, state) {
          FlightSearchingLoadingPageViewModel viewModel = state.extra as FlightSearchingLoadingPageViewModel;
          return FlightSearchingLoadingPage(
            key: state.pageKey,
            viewModel: viewModel,
          );
        },
        routes: const [],
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: FlightSearchResultPage.route,
        name: 'flightSearchResult',
        builder: (context, state) {
          FlightSearchResultPageViewModel viewModel = state.extra as FlightSearchResultPageViewModel;
          return FlightSearchResultPage(key: state.pageKey, viewModel: viewModel);
        },
        routes: const [],
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/flightBookingResult',
        builder: (context, state) {
          String? bookingNumber = (state.extra as Map<String, dynamic>)
              .entries
              .firstWhere((element) => element.key == "bookingNumber")
              .value as String;
          return BookingResultPage(
            key: state.pageKey,
            bookingNumber: bookingNumber,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: FlightCheckoutPage.route,
        builder: (context, state) {
          FlightCheckoutPageViewModel? viewModel = state.extra as FlightCheckoutPageViewModel?;
          return FlightCheckoutPage(
            key: state.pageKey,
            viewModel: viewModel!,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/vibInvoice',
        builder: (context, state) {
          String? bookingNumber = (state.extra as Map<String, dynamic>)
              .entries
              .firstWhere((element) => element.key == "bookingNumber")
              .value as String;
          // String? fromBankNumber = (state.extra as Map<String, dynamic>)
          //     .entries
          //     .firstWhere((element) => element.key == "fromBankNumber")
          //     .value as String;
          return VibInvoicePage(
            key: state.pageKey,
            bookingNumber: bookingNumber,
            // fromBankNumber: fromBankNumber,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: ConfirmBookingPage.route,
        builder: (context, state) {
          ConfirmBookingPageViewModel? viewModel = state.extra as ConfirmBookingPageViewModel?;
          return ConfirmBookingPage(
            key: state.pageKey,
            viewModel: viewModel ?? ConfirmBookingPageViewModel(bookingNumber: "bookingNumber"),
          );
        },
      ),

      // PAYMENT -----------------------------
      GoRoute(
        parentNavigatorKey: rootKey,
        path: PaymentMethodPage.route,
        builder: (context, state) {
          var viewModel = state.extra as PaymentMethodPageViewModel?;
          return PaymentMethodPage(
            key: state.pageKey,
            viewModel: viewModel ?? PaymentMethodPageViewModel(bookingNumber: "ADCO2308142193313"),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: PaymentDebitPage.route,
        builder: (context, state) {
          var viewModel = state.extra as PaymentDebitPageViewModel?;
          return PaymentDebitPage(
            key: state.pageKey,
            viewModel: viewModel!,
          );
        },
      ),

      GoRoute(
        parentNavigatorKey: rootKey,
        path: PaymentPaylaterPage.route,
        builder: (context, state) {
          var viewModel = state.extra as PaymentPaylaterPageViewModel?;
          return PaymentPaylaterPage(
            key: state.pageKey,
            viewModel: viewModel!,
          );
        },
      ),

      GoRoute(
        parentNavigatorKey: rootKey,
        path: FinalBookingDetailPage.route,
        builder: (context, state) {
          var viewModel = state.extra as FinalBookingDetailPageViewModel?;
          return FinalBookingDetailPage(
            key: state.pageKey,
            viewModel: viewModel ?? FinalBookingDetailPageViewModel(bookingNumber: "ADCO2309062225983"),
          );
        },
      ),

      GoRoute(
        parentNavigatorKey: rootKey,
        path: ReservationDetailPage.route,
        builder: (context, state) {
          var viewModel = state.extra as ReservationDetailPageViewMode?;
          return ReservationDetailPage(
            key: state.pageKey,
            viewModel: viewModel!,
          );
        },
      ),

      // BOOKING SERVICE -----------------------------
      GoRoute(
        parentNavigatorKey: rootKey,
        path: InputInfoPassengerPage.route,
        builder: (context, state) {
          InputInfoPassengerPageViewModel? viewModel = state.extra as InputInfoPassengerPageViewModel?;
          return InputInfoPassengerPage(
            key: state.pageKey,
            viewModel: viewModel ?? InputInfoPassengerPageViewModel(title: "Người lớn x"),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: FlightSSRSelectionPage.route,
        builder: (context, state) {
          var viewModel = state.extra as FlightSSRSelectionPageViewModel?;
          return FlightSSRSelectionPage(
            key: state.pageKey,
            viewModel: viewModel ?? FlightSSRSelectionPageViewModel(serviceType: ServiceType.baggare),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: FlightExtrasPage.route,
        builder: (context, state) {
          FlightExtrasPageViewModel? viewModel = state.extra as FlightExtrasPageViewModel?;
          return FlightExtrasPage(
            key: state.pageKey,
            viewModel: viewModel ?? FlightExtrasPageViewModel(initialSsrItems: []),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: BaseWebViewPage.route,
        builder: (context, state) {
          BaseWebViewPageViewModel? viewModel = state.extra as BaseWebViewPageViewModel?;
          return BaseWebViewPage(
            key: state.pageKey,
            viewModel: viewModel ?? BaseWebViewPageViewModel(url: "https://www.24h.com.vn/"),
          );
        },
      ),
      // INVOICES
      GoRoute(
        parentNavigatorKey: rootKey,
        path: InputInvoicePage.route,
        builder: (context, state) {
          InputInvoicePageViewModel? viewModel = state.extra as InputInvoicePageViewModel?;
          return InputInvoicePage(
            key: state.pageKey,
            viewModel: viewModel ?? InputInvoicePageViewModel(),
          );
        },
      ),

      //HOTEL
      GoRoute(
        parentNavigatorKey: rootKey,
        path: HotelSearchingLoadingPage.route,
        builder: (context, state) {
          var viewModel = state.extra as HotelSearchingLoadingPageViewModel?;
          return HotelSearchingLoadingPage(
            key: state.pageKey,
            viewModel: viewModel!,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: SearchHotelPage.route,
        builder: (context, state) {
          //  SearchHotelPageViewModel? viewModel = state.extra as SearchHotelPageViewModel?;
          SearchHotelPageViewModel viewModel = SearchHotelPageViewModel();
          return SearchHotelPage(
            key: state.pageKey,
            viewModel: viewModel,
          );
        },
      ),

      GoRoute(
        parentNavigatorKey: rootKey,
        path: HotelSearchResultPage.route,
        builder: (context, state) {
          HotelSearchResultPageViewModel? viewModel = state.extra as HotelSearchResultPageViewModel?;
          return HotelSearchResultPage(
            key: state.pageKey,
            viewModel: viewModel!,
          );
        },
      ),

      GoRoute(
        parentNavigatorKey: rootKey,
        path: HotelSearchDetailPage.route,
        // pageBuilder: (context, state) {
        //   HotelSearchDetailPageViewModel? viewModel = state.extra as HotelSearchDetailPageViewModel?;
        //   return CustomTransitionPage(
        //     child: HotelSearchDetailPage(
        //     key: state.pageKey,
        //     viewModel: viewModel ?? HotelSearchDetailPageViewModel(),
        //   ),
        //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //       return Align(child: SizeTransition(sizeFactor: animation, child: child,),);

        //     },
        //   );
        // },
        builder: (context, state) {
          HotelSearchDetailPageViewModel? viewModel = state.extra as HotelSearchDetailPageViewModel?;
          return HotelSearchDetailPage(
            key: state.pageKey,
            viewModel: viewModel ?? HotelSearchDetailPageViewModel(),
          );
        },
      ),

      GoRoute(
        parentNavigatorKey: rootKey,
        path: HotelSearchRoomDetailPage.route,
        builder: (context, state) {
          HotelSearchRoomDetailPageViewModel? viewModel = state.extra as HotelSearchRoomDetailPageViewModel?;
          return HotelSearchRoomDetailPage(
            key: state.pageKey,
            viewModel: viewModel ?? HotelSearchRoomDetailPageViewModel(),
          );
        },
      ),

      GoRoute(
        parentNavigatorKey: rootKey,
        path: HotelCheckoutPage.route,
        builder: (context, state) {
          HotelCheckoutPageViewModel? viewModel = state.extra as HotelCheckoutPageViewModel?;
          return HotelCheckoutPage(
            key: state.pageKey,
            viewModel: viewModel!,
          );
        },
      ),

      GoRoute(
        parentNavigatorKey: rootKey,
        path: HotelSSRSelectionPage.route,
        builder: (context, state) {
          HotelSSRSelectionPageViewModel? viewModel = state.extra as HotelSSRSelectionPageViewModel?;
          return HotelSSRSelectionPage(
            key: state.pageKey,
            viewModel: viewModel!,
          );
        },
      ),

      //COMBO
      GoRoute(
        parentNavigatorKey: rootKey,
        path: SearchComboPage.route,
        builder: (context, state) {
          SearchComboPageViewModel? viewModel = state.extra as SearchComboPageViewModel?;
          return SearchComboPage(
            key: state.pageKey,
            viewModel: viewModel ?? SearchComboPageViewModel(),
          );
        },
      ),

      GoRoute(
        parentNavigatorKey: rootKey,
        path: ComboSearchingLoadingPage.route,
        builder: (context, state) {
          ComboSearchingLoadingPageViewModel? viewModel = state.extra as ComboSearchingLoadingPageViewModel?;
          return ComboSearchingLoadingPage(
            key: state.pageKey,
            viewModel: viewModel!,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: ComboSearchResultPage.route,
        builder: (context, state) {
          ComboSearchResultPageViewModel? viewModel = state.extra as ComboSearchResultPageViewModel?;
          return ComboSearchResultPage(
            key: state.pageKey,
            viewModel: viewModel!,
          );
        },
      ),

      GoRoute(
        parentNavigatorKey: rootKey,
        path: ComboCheckoutPage.route,
        builder: (context, state) {
          ComboCheckoutPageViewModel? viewModel = state.extra as ComboCheckoutPageViewModel?;
          return ComboCheckoutPage(
            key: state.pageKey,
            viewModel: viewModel!,
          );
        },
      ),
    ];
    return bookingRouters;
  }
}

// final _rootNavigatorKey = GlobalKey<NavigatorState>();
final bookingWithRootKeyRouters = GtdBookingRouter.bookingBaseRouters();
final appBookingRouter = AppRouter(initialLocation: SearchFlightPage.route, routers: bookingWithRootKeyRouters);
final appVIBRouter = AppRouter(initialLocation: "/homeVIB", routers: bookingWithRootKeyRouters);
