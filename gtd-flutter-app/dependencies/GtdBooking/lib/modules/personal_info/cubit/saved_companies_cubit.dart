import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/network/network.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/customer_resource/models/response/gtd_saved_company_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_customer_repository/gtd_customer_repository.dart';

part 'saved_companies_state.dart';

class SavedCompaniesCubit extends Cubit<SavedCompaniesState> {
  SavedCompaniesCubit() : super(const SavedCompaniesInitial());

  Future<void> getListSavedCompany() async {
    emit(SavedCompaniesLoading());
    var result = await GtdCustomerRepository.shared.getSavedCompanies();
    result.when((success) {
      emit(SavedCompaniesInitial(savedCompanies: success));
    }, (error) {
      Logger.e(error.message);
      emit(const SavedCompaniesInitial(savedCompanies: []));
    });
  }
}
