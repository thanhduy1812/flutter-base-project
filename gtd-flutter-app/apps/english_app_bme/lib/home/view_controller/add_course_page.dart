import 'package:english_app_bme/home/app_bottom_bar.dart';
import 'package:english_app_bme/home/view/input_text_field.dart';
import 'package:english_app_bme/home/view_model/add_course_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_lunar_calendar/gtd_calendar_helper.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_lunar_calendar/gtd_lunar_calendar.dart';

class AddCoursePage extends BaseStatelessPage<AddCoursePageViewModel> {
  static const String route = '/addCourse';
  const AddCoursePage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return ColoredBox(
      color: Colors.white,
      child: SizedBox(
          child: Column(
        children: [
          const Text("Add a course",
              style: TextStyle(fontSize: 24, color: appBlueDeepColor, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InputTextField(
                hintText: 'Please input course title',
                labelText: "Course title",
                leadingIcon: Icon(
                  Icons.note_alt,
                  color: Colors.grey.shade400,
                ),
                onChanged: (value) {}),
          ),
          Padding(
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
                // initStartDate: DateTime.now(),
                onSelected: (value) {},
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: Card(
                      shadowColor: Colors.black,
                      child: Icon(Icons.calendar_month, color: appBlueDeepColor),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text("Fri 25, Septemper, 2023")
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showTimePicker(
                context: pageContext,
                initialTime: TimeOfDay.now(),
                // initialEntryMode: TimePickerEntryMode.inputOnly,
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: Card(
                      shadowColor: Colors.black,
                      child: Icon(Icons.timer, color: appOrangeDarkColor),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text("9:30 AM")
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
                      onPressed: (value) {
                        pageContext.pop();
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
  }
}
