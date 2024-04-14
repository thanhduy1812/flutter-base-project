import 'dart:async';

import 'package:dvt_helper/dvt_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/pricing_bottom_page_viewmodel.dart';
import 'package:gtd_repository/gtd_repository.dart';

import 'flight_checkout_cubit.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutStateInitial());

  void initPassengers(PricingBottomPageViewModel viewModel) {}

  @protected
  Future<Result<String, GtdApiError>> addBookingTraveller() async {
    throw UnimplementedError();
  }
}
