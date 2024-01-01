import 'package:flutter/material.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_model/date_checkinout_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_lunar_calendar/gtd_calendar_helper.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_lunar_calendar/gtd_lunar_calendar.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_text_field.dart';

class DateCheckinoutView extends BaseView<DateCheckinoutViewModel> {
  const DateCheckinoutView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            Opacity(
              opacity: viewModel.isDisableStartDate ? 0.4 : 1,
              child: GtdTextField(
                viewModel: viewModel.fromDate,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leftIcon: GtdAppIcon.iconNamedSupplier(iconName: "calendar-grey.svg", width: 34),
                rightIcon: const Icon(
                  Icons.chevron_right,
                  size: 26,
                ),
                onSelect: viewModel.isDisableStartDate
                    ? null
                    : () {
                        showHotelCalendar(context, setState);
                      },
              ),
            ),
            const Divider(),
            Opacity(
              opacity: viewModel.isDisableEndate ? 0.4 : 1,
              child: GtdTextField(
                viewModel: viewModel.toDate,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leftIcon: GtdAppIcon.iconNamedSupplier(iconName: "calendar-grey.svg", width: 34),
                rightIcon: const Icon(
                  Icons.chevron_right,
                  size: 26,
                ),
                onSelect: viewModel.isDisableEndate
                    ? null
                    : () {
                        showHotelCalendar(context, setState);
                      },
              ),
            ),
          ],
        ),
      );
    });
  }

  void showHotelCalendar(BuildContext pageContext, StateSetter setState) {
    return GtdCalendarHelper.presentLunaCalendar(
      context: pageContext,
      lunaDateMode: (switch (viewModel.pickerMode) {
        DateCheckinoutPickerMode.both => GtdLunarDateMode.range,
        DateCheckinoutPickerMode.onlyEnd => GtdLunarDateMode.single,
        DateCheckinoutPickerMode.disable => GtdLunarDateMode.range
      }),
      lunaDayBehavior: (switch (viewModel.pickerMode) {
        DateCheckinoutPickerMode.both => GtdLunaDayBehavior.both,
        DateCheckinoutPickerMode.onlyEnd => GtdLunaDayBehavior.onlyEnd,
        DateCheckinoutPickerMode.disable => GtdLunaDayBehavior.both
      }),
      title: "Chọn ngày",
      dayStartLabel: "Vào",
      dayEndLabel: "Ra",
      selectDayViewStartLabel: "Nhận phòng",
      selectDayViewEndLabel: "Trả phòng",
      initStartDate: viewModel.fromDate.selectedDate,
      initEndate: viewModel.toDate.selectedDate,
      onSelected: (value) {
        setState(
          () {
            viewModel.fromDate.selectedDate = value.startDate;
            viewModel.toDate.selectedDate = value.endDate;
            viewModel.validForm();
          },
        );
      },
    );
  }
}
