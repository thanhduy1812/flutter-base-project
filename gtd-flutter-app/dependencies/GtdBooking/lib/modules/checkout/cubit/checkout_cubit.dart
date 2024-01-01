import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/confirm_booking/view_model/pricing_bottom_page_viewmodel.dart';
import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_repository_error/gtd_api_error.dart';

import 'flight_checkout_cubit.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutStateInitial());

  void initPassengers(PricingBottomPageViewModel viewModel) {}

  @protected
  Future<Result<String, GtdApiError>> addBookingTraveller() async {
    throw UnimplementedError();
  }
}
