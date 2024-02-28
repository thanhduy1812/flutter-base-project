import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/flight/form_search/view_model/date_itinerary_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_lunar_calendar/gtd_calendar_helper.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_lunar_calendar/gtd_lunar_calendar.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_switch.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_text_field.dart';

class DateItineraryView extends BaseView<DateItineraryViewModel> {
  final GtdCallback<bool>? onChangedRoundTrip;

  const DateItineraryView({
    super.key,
    required super.viewModel,
    this.onChangedRoundTrip,
  });

  @override
  Widget buildWidget(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Card(
          margin: EdgeInsets.zero,
          elevation: 1,
          child: Column(
            children: [
              _roundTripSelection(context, setState),
              const Divider(
                color: Color.fromRGBO(241, 241, 241, 1),
                height: 0,
              ),
              _departureDate(context, setState),
              if (viewModel.isRoundTrip)
                const Divider(
                  color: Color.fromRGBO(241, 241, 241, 1),
                  height: 0,
                ),
              _backDate(context, setState),
            ],
          ),
        );
      },
    );
  }

  AnimatedSize _backDate(BuildContext context, StateSetter setState) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: viewModel.isRoundTrip
          ? GtdTextField(
              viewModel: viewModel.returnDate,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              leftIcon: GtdAppIcon.iconNamedSupplier(
                iconName: "flight/calendar-flight.svg",
                width: 30,
              ),
              rightIcon: const Icon(Icons.chevron_right),
              onSelect: () => GtdCalendarHelper.presentLunaCalendar(
                context: context,
                lunaDateMode: viewModel.isRoundTrip
                    ? GtdLunarDateMode.range
                    : GtdLunarDateMode.single,
                title: "Chọn ngày",
                dayStartLabel: "Đi",
                dayEndLabel: "Về",
                selectDayViewStartLabel: "Chọn ngày đi",
                selectDayViewEndLabel: "Chọn ngày về",
                initStartDate: viewModel.departDate.selectedDate,
                initEndate: viewModel.returnDate.selectedDate,
                onSelected: (value) {
                  setState(
                    () {
                      viewModel.departDate.selectedDate = value.startDate;
                      viewModel.returnDate.selectedDate = value.endDate;
                      viewModel.validateForm();
                    },
                  );
                },
              ),
            )
          : const SizedBox(),
    );
  }

  GtdTextField _departureDate(BuildContext context, StateSetter setState) {
    return GtdTextField(
      viewModel: viewModel.departDate,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      leftIcon: GtdAppIcon.iconNamedSupplier(
        iconName: "flight/calendar-flight.svg",
        width: 30,
      ),
      rightIcon: const Icon(Icons.chevron_right),
      onSelect: () => GtdCalendarHelper.presentLunaCalendar(
        context: context,
        lunaDateMode: viewModel.isRoundTrip
            ? GtdLunarDateMode.range
            : GtdLunarDateMode.single,
        title: "Chọn ngày",
        dayStartLabel: "Đi",
        dayEndLabel: "Về",
        selectDayViewStartLabel: "Chọn ngày đi",
        selectDayViewEndLabel: "Chọn ngày về",
        initStartDate: viewModel.departDate.selectedDate,
        initEndate: viewModel.returnDate.selectedDate,
        onSelected: (value) {
          setState(
            () {
              viewModel.departDate.selectedDate = value.startDate;
              viewModel.returnDate.selectedDate = value.endDate;
              viewModel.validateForm();
            },
          );
        },
      ),
    );
  }

  Container _roundTripSelection(BuildContext context, StateSetter setState) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Text(
            'flight.formSearch.roundTripTicket',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.grey.shade900,
            ),
          ).tr()),
          GtdCustomSwitch(
            value: viewModel.isRoundTrip,
            activeToggleColor: Colors.white,
            activeToggleColorGradient: GtdColors.appGradient(context),
            switchBorder: Border.all(
              color: Colors.grey.shade200,
              width: 2.0,
            ),
            onToggle: (val) {
              setState(() {
                viewModel.isRoundTrip = val;
                if (val == false) {
                  viewModel.returnDate.selectedDate = null;
                }
                viewModel.validateForm();
                onChangedRoundTrip?.call(val);
              });
            },
          ),
        ],
      ),
    );
  }
}
