import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/flight/form_search/view_model/passengers_inerary_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/passenger_picker.dart';

class PassengersItineraryView extends BaseView<PassengersItineraryViewModel> {
  const PassengersItineraryView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Card(
        margin: EdgeInsets.zero,
        elevation: 1,
        child: Column(
          children: [
            _adult(setState),
            const Divider(
              color: Color.fromRGBO(241, 241, 241, 1),
              height: 0,
            ),
            _children(setState),
            const Divider(
              color: Color.fromRGBO(241, 241, 241, 1),
              height: 0,
            ),
            _infant(setState),
          ],
        ),
      );
    });
  }

  Padding _infant(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _AgeTitle(
              title: 'flight.formSearch.infant'.tr(),
              age: 'flight.formSearch.under2'.tr(),
            ),
          ),
          PassengerPicker(
            defaultValue: viewModel.infantVM.value,
            max: viewModel.infantVM.max,
            min: 0,
            splashRadius: 25,
            onPressed: (value) {
              // viewModel.infantVM.value = value;
              setState(
                () {
                  viewModel.updatePassenger(infant: value);
                },
              );
            },
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Padding _children(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _AgeTitle(
              title: 'flight.formSearch.child'.tr(),
              age: 'flight.formSearch.from12to17'.tr(),
            ),
          ),
          PassengerPicker(
            defaultValue: viewModel.childVM.value,
            max: viewModel.childVM.max,
            min: 0,
            splashRadius: 25,
            onPressed: (value) {
              // viewModel.childVM.value = value;
              setState(
                () {
                  viewModel.updatePassenger(child: value);
                },
              );
            },
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Padding _adult(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _AgeTitle(
              title: 'flight.formSearch.adult'.tr(),
              age: 'flight.formSearch.over17'.tr(),
            ),
          ),
          PassengerPicker(
            defaultValue: viewModel.adultVM.value,
            max: viewModel.adultVM.max,
            min: 1,
            splashRadius: 25,
            onPressed: (value) {
              // viewModel.adultVM.value = value;
              setState(
                () {
                  viewModel.updatePassenger(adult: value);
                },
              );
            },
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AgeTitle extends StatelessWidget {
  final String title;
  final String age;

  const _AgeTitle({
    required this.title,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
        ),
        Text(
          age,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: GtdColors.stormGray,
          ),
        ),
      ],
    );
  }
}
