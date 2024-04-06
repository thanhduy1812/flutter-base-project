import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/personal_info/cubit/saved_companies_cubit.dart';
import 'package:gtd_booking/modules/personal_info/view_model/saved_company_list_viewmodel.dart';
import 'package:gtd_booking/modules/personal_info/view_model/saved_company_page_view_model.dart';
import 'package:gtd_booking/modules/personal_info/views/saved_company_list.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/customer_resource/models/response/gtd_saved_company_rs.dart';

class SavedCompanyPage extends BaseStatelessPage<SavedCompanyPageViewModel> {
  static const String route = '/savedCompanyPage';
  const SavedCompanyPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocProvider(
      create: (context) => SavedCompaniesCubit()..getListSavedCompany(),
      child: BlocBuilder<SavedCompaniesCubit, SavedCompaniesState>(
        builder: (context, state) {
          List<GtdSavedCompanyRs> companies = [];
          if (state is SavedCompaniesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SavedCompaniesInitial) {
            companies = state.savedCompanies;
          }
          return SizedBox(
            child: SavedCompanyList(viewModel: SavedCompanyListViewModel(companies: companies)),
          );
        },
      ),
    );
  }
}
