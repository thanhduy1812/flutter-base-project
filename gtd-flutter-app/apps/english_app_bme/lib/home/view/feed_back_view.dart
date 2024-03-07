import 'package:english_app_bme/home/app_bottom_bar.dart';
import 'package:english_app_bme/lesson/view_controller/lesson_page.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';

class FeedbackView extends BaseView {
  const FeedbackView({super.key, required super.viewModel});

  @override
  Widget buildWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          var focusNode = FocusNode();
          return Material(
            child: Ink(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: appBlueDeepColor),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white),
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Hoc vien hieu bai khong?",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                          )),
                      const SizedBox(height: 16),
                      LessonPage.rowIconRating(context),
                      const SizedBox(height: 16),
                      const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Hoc vien hieu bai khong?",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                          )),
                      const SizedBox(height: 16),
                      LessonPage.rowIconRating(context),
                      const SizedBox(height: 16),
                      const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Hoc vien hieu bai khong?",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                          )),
                      const SizedBox(height: 16),
                      LessonPage.rowIconRating(context),
                      const SizedBox(height: 16),
                      TextField(
                        focusNode: focusNode,
                        onTapOutside: (event) {
                          focusNode.unfocus();
                        },
                        maxLines: 20,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        maxLength: 1000,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade500, width: 1.0, style: BorderStyle.solid)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade500, width: 1.0, style: BorderStyle.solid)),
                          hintText: 'Please input your feedback',
                          hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade300),
                          filled: false,
                          fillColor: Colors.white,
                          focusColor: appBlueDeepColor,
                          hoverColor: appBlueDeepColor,
                        ),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(
                        width: double.infinity,
                        child: GtdButton(
                            text: "Submit",
                            height: 60,
                            color: appOrangeDarkColor,
                            colorText: Colors.white,
                            fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
