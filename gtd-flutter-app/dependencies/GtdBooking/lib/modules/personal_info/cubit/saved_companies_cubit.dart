import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dvt_helper/dvt_helper.dart';
import 'package:gtd_repository/gtd_repository.dart';

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
