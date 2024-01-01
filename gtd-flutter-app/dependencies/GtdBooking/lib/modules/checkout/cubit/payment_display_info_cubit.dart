import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/pricing_bottom_page_viewmodel.dart';
import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_booking_repository/dto/booking_detail_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:rxdart/rxdart.dart';

import '../view_model/gtd_display_price_item_vm.dart';

part 'payment_display_info_state.dart';

class PaymentDisplayInfoCubit extends Cubit<PaymentDisplayInfoState> {
  // final InfoFormValidationCubit checkoutCubit;
  // PaymentDisplayInfoCubit(this.checkoutCubit) : super(PaymentDisplayInfoInitial()) {
  //   BookingDetailDTO bookingDetailDTO = checkoutCubit.bookingDetailDTO;
  //   inititalTempAmount = bookingDetailDTO.tempAmount;
  //   initListGtdDisplayPriceItemVM(bookingDetailDTO: bookingDetailDTO);
  //   checkoutCubit.selectedSsrItemsStream.listen((event) {
  //     updateServiceRequest(event);
  //   });
  // }

  PaymentDisplayInfoCubit(PricingBottomPageViewModel viewModel) : super(PaymentDisplayInfoInitial()) {
    if (viewModel.bookingDetailDTO == null) {
      Logger.e("initPassengers-BookingDetailDTO is null");
      // throw GtdApiError(message: "BookingDetailDTO is null");
    } else {
      BookingDetailDTO bookingDetailDTO = viewModel.bookingDetailDTO!;
      inititalTempAmount = bookingDetailDTO.tempAmount;
      initListGtdDisplayPriceItemVM(bookingDetailDTO: bookingDetailDTO);
      updateServiceRequest(viewModel.selectedSsrItems);
      // checkoutCubit.selectedSsrItemsStream.listen((event) {
      //   updateServiceRequest(event);
      // });
    }
  }
  double inititalTempAmount = 0;
  BehaviorSubject<List<GtdDisplayPriceItemVM>> paymentInfoSubject = BehaviorSubject();
  Stream<List<GtdDisplayPriceItemVM>> get paymentInfoStream => paymentInfoSubject.stream;

  List<GtdDisplayPriceItemVM> initialItems = [];

  Stream<double> get totalAmount => paymentInfoStream.map((event) => event
      .where((element) => element.type == GtdDisplayItemType.totalPrice)
      .map((e) => e.price)
      .reduce((value, element) => value + element));

  void initListGtdDisplayPriceItemVM({required BookingDetailDTO bookingDetailDTO}) {
    List<GtdDisplayPriceItemVM> priceItems = GtdDisplayPriceItemVM.fromBookingDetailDTO(bookingDetailDTO);
    priceItems.add(GtdDisplayPriceItemVM(
        shortTitle: "Tổng cộng", price: bookingDetailDTO.tempAmount, type: GtdDisplayItemType.totalPrice));
    inititalTempAmount = bookingDetailDTO.tempAmount;
    initialItems = priceItems;
    paymentInfoSubject.sink.add(priceItems);
  }

  void updateServiceRequest(List<SsrOfferDTO> ssrItems) {
    List<GtdDisplayPriceItemVM> serviceItems = ssrItems.map((e) {
      String title = e.bookingDirection == FlightDirection.d ? "Hành lý chuyến đi" : "Hành lý chuyến về";
      return GtdDisplayPriceItemVM(
          shortTitle: title, flightDirection: e.bookingDirection, price: e.ssrAmount, type: GtdDisplayItemType.baggage);
    }).toList();
    double serviceSSR = serviceItems.map((e) => e.price).toList().sum;
    initialItems
        .map((e) => e)
        .where((element) => element.type == GtdDisplayItemType.totalPrice)
        .map((e) => e.price = inititalTempAmount + serviceSSR)
        .toList();
    List<GtdDisplayPriceItemVM> priceItems = [...initialItems, ...serviceItems];
    paymentInfoSubject.sink.add(priceItems);
  }

  List<GtdDisplayPriceItemVM> get listPriceItems => paymentInfoSubject.value
      // .where((element) => element.price != 0)
      .map((item) {
        return item;
      })
      .toList()
      .sorted((a, b) => (a.type.position.compareTo(b.type.position)));

  @override
  Future<void> close() {
    paymentInfoSubject.close();
    return super.close();
  }
}
