import 'package:english_app_bme/home/app_bottom_bar.dart';
import 'package:english_app_bme/home/view/input_text_field.dart';
import 'package:english_app_bme/home/view_model/add_course_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_lunar_calendar/gtd_calendar_helper.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_lunar_calendar/gtd_lunar_calendar.dart';
import 'package:gtd_utils/utils/popup/gtd_loading.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';
import 'package:intl/intl.dart';

class AddCoursePage extends BaseStatelessPage<AddCoursePageViewModel> {
  static const String route = '/addCourse';
  const AddCoursePage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return ColoredBox(
          color: Colors.white,
          child: SizedBox(
              child: Column(
            children: [
              Text(viewModel.isAddLesson ? "Add a lesson" : "Add a course",
                  style: const TextStyle(fontSize: 24, color: appBlueDeepColor, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InputTextField(
                    hintText: viewModel.isAddLesson ? 'Lesson name' : 'Please input course title',
                    labelText: "Course title",
                    leadingIcon: Icon(
                      Icons.note_alt,
                      color: Colors.grey.shade400,
                    ),
                    onChanged: (value) {
                      viewModel.titleField = value;
                    }),
              ),
              viewModel.isAddLesson
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InputTextField(
                          hintText: 'Please input mentor name',
                          labelText: "Mentor name",
                          leadingIcon: Icon(
                            Icons.person,
                            color: Colors.grey.shade400,
                          ),
                          onChanged: (value) {}),
                    ),
              InkWell(
                onTap: () {
                  GtdCalendarHelper.presentLunaCalendar(
                    context: pageContext,
                    lunaDateMode: GtdLunarDateMode.single,
                    title: "Choose Date",
                    dayStartLabel: "Start",
                    selectDayViewStartLabel: "Selected Date",
                    initStartDate: viewModel.startDate,
                    onSelected: (value) {
                      if (value.startDate != null) {
                        viewModel.setStartDate(value.startDate!);
                      }
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const SizedBox(
                        height: 48,
                        width: 48,
                        child: Card(
                          shadowColor: Colors.black,
                          child: Icon(Icons.calendar_month, color: appBlueDeepColor),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(dateFormat.format(viewModel.startDate))
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await showTimePicker(
                    context: pageContext,
                    initialTime: TimeOfDay(hour: viewModel.startDate.hour, minute: viewModel.startDate.minute),
                    // initialEntryMode: TimePickerEntryMode.inputOnly,
                  ).then((value) {
                    if (value != null) {
                      viewModel.setHourDate(value);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const SizedBox(
                        height: 48,
                        width: 48,
                        child: Card(
                          shadowColor: Colors.black,
                          child: Icon(Icons.timer, color: appOrangeDarkColor),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(DateFormat('hh:mm a').format(viewModel.startDate))
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GtdButton(
                          text: "Cancel",
                          fontSize: 18,
                          borderRadius: 18,
                          colorText: Colors.red,
                          color: Colors.red.shade50,
                          height: 60,
                          onPressed: (value) {
                            pageContext.pop();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GtdButton(
                          text: "Confirm",
                          fontSize: 18,
                          borderRadius: 18,
                          colorText: Colors.white,
                          color: Colors.orange,
                          height: 60,
                          onPressed: (value) async {
                            if (viewModel.validateForm()) {
                              await viewModel.createLessonRoadmap().then((value) => pageContext.pop());
                            } else {
                              GtdPopupMessage(context).showError(error: "Please input full field!");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
        );
      },
    );
  }
}
