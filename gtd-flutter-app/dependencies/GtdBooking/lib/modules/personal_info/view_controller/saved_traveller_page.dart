import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/personal_info/cubit/saved_traveller_cubit.dart';
import 'package:gtd_booking/modules/personal_info/view_model/saved_traveller_list_viewmodel.dart';
import 'package:gtd_booking/modules/personal_info/view_model/saved_traveller_page_view_model.dart';
import 'package:gtd_booking/modules/personal_info/views/saved_traveller_list.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/customer_resource/customer_resource.dart';

class SavedTravellerPage extends BaseStatelessPage<SavedTravellerPageViewModel> {
  static const String route = '/savedTravellerPage';
  const SavedTravellerPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocProvider(
      create: (context) => SavedTravellerCubit()..getListSavedTraveller(),
      child: BlocBuilder<SavedTravellerCubit, SavedTravellerState>(
        builder: (context, state) {
          List<GtdSavedTravellerRs> travellers = [];
          if (state is SavedTravellerStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SavedTravellerInitial) {
            travellers = state.travellers;
          }
          return SizedBox(
            child: SavedTravellerList(viewModel: SaveTravellerListViewModel(travellers: travellers)),
          );
        },
      ),
    );
  }
}
