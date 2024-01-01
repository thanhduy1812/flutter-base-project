import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_booking/modules/flight/form_search/view_model/location_info_viewmodel.dart';
import 'package:gtd_booking/modules/flight/form_search/views/bloc/get_location_info/get_location_bloc.dart';
import 'package:gtd_booking/modules/flight/form_search/views/bloc/get_popular_info/get_popular_bloc.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_text_field.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import 'airport_search_view/airport_search_view.dart';

class LocationInfoView extends BaseView<LocationInfoViewModel> {
  const LocationInfoView({super.key, required super.viewModel});
  @override
  Widget buildWidget(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Card(
        margin: EdgeInsets.zero,
        elevation: 1,
        child: Column(
          children: [
            GtdTextField(
              viewModel: viewModel.fromLocation,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leftIcon: GtdAppIcon.iconNamedSupplier(iconName: "flight/destination_grey.svg", width: 30),
              rightIcon: const Icon(Icons.chevron_right),
              onSelect: () => GtdPresentViewHelper.presentScrollView(
                title: 'flight.formSearch'.tr(gender: 'departure'),
                physics: const NeverScrollableScrollPhysics(),
                context: context,
                slivers: [
                  SliverFillViewport(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return FractionallySizedBox(
                          heightFactor: 0.92,
                          child: MultiBlocProvider(
                              providers: [
                                BlocProvider<GetLocationBloc>(
                                  create: (context) => GetLocationBloc(),
                                ),
                                BlocProvider<GetPopularBloc>(
                                  create: (context) => GetPopularBloc(),
                                ),
                              ],
                              child: AirportSearchView(
                                flightType: 'departure',
                                onPressed: (itemLocation) {
                                  Navigator.pop(context);
                                  setState(() {
                                    viewModel.updateLocation(fromDestination: itemLocation);
                                    viewModel.validateForm();
                                  });
                                },
                              )),
                        );
                      },
                      childCount: 1,
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              color: Color.fromRGBO(241, 241, 241, 1),
              height: 0,
            ),
            GtdTextField(
              viewModel: viewModel.toLocation,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leftIcon: GtdAppIcon.iconNamedSupplier(iconName: "flight/destination_grey.svg", width: 30),
              rightIcon: const Icon(Icons.chevron_right),
              onSelect: () => GtdPresentViewHelper.presentScrollView(
                title: 'flight.formSearch'.tr(gender: 'destination'),
                physics: const NeverScrollableScrollPhysics(),
                context: context,
                slivers: [
                  SliverFillViewport(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return FractionallySizedBox(
                          heightFactor: 0.92,
                          child: MultiBlocProvider(
                              providers: [
                                BlocProvider<GetLocationBloc>(
                                  create: (context) => GetLocationBloc(),
                                ),
                                BlocProvider<GetPopularBloc>(
                                  create: (context) => GetPopularBloc(),
                                ),
                              ],
                              child: AirportSearchView(
                                flightType: 'destination',
                                onPressed: (itemLocation) {
                                  Navigator.pop(context);
                                  setState(() {
                                    viewModel.updateLocation(toDestination: itemLocation);
                                    viewModel.validateForm();
                                  });
                                },
                              )),
                        );
                      },
                      childCount: 1,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
