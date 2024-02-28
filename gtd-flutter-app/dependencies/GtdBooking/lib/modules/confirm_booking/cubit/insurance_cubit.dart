import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/confirm_booking/views/final_booking_detail_view/views/insurance_view/view_model/insurance_viewmodel.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/inventory_resource/models/request/gtd_insurance_plan_rq.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/inventory_resource/models/response/gtd_insurance_detail_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/inventory_resource/models/response/gtd_insurance_plans_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_utility_repository/gtd_utility_repository.dart';

part 'insurance_state.dart';

class InsuranceCubit extends Cubit<InsuranceState> {
  List<InsuranceViewModel> insuranceViewModels = [];
  InsuranceCubit() : super(InsuranceInitial());

  void getInsuraceDetail({required String bookingNumber}) async {
    emit(InsuranceLoading());
    var result = await GtdUtilityRepository.shared.getInsuranceDetail(bookingNumber: bookingNumber);
    result.when((success) {
      emit(InsuranceDetailLoaded(success));
    }, (error) {
      emit(InsuranceError());
    });
  }

  Future<void> getInsuracePlans({required GtdInsurancePlanRq insurancePlanRq}) async {
    emit(InsuranceLoading());
    var result = await GtdUtilityRepository.shared.getInsurancePlans(insurancePlanRq: insurancePlanRq);
    result.when((success) {
      insuranceViewModels = success.map((e) => InsuranceViewModel.fromInsurancePlan(insurancePlan: e)).toList();
      emit(InsurancePlanLoaded(success));
    }, (error) {
      emit(InsuranceError());
    });
  }
}
