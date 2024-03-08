import 'package:english_app_bme/home/app_bottom_bar.dart';
import 'package:english_app_bme/home/view_model/feed_back_viewmodel.dart';
import 'package:english_app_bme/lesson/view_controller/lesson_page.dart';
import 'package:english_app_bme/lesson/view_model/lesson_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';

class FeedbackView extends BaseView<FeedbackViewModel> {
  final GtdCallback<LessonRating>? onChanged;
  const FeedbackView({super.key, required super.viewModel, this.onChanged});

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
              child: StatefulBuilder(builder: (context, setState) {
                return SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Column(
                      children: [
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var feedBackModel = viewModel.feedbackModels[index];
                              return Column(
                                children: [
                                  SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        feedBackModel.question,
                                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                                      )),
                                  const SizedBox(height: 16),
                                  LessonPage.rowIconRating(
                                    context,
                                    spacing: 16,
                                    groupRating: feedBackModel.rating,
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          feedBackModel.rating = value;
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                            itemCount: viewModel.feedbackModels.length),
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
                            hintStyle:
                                TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade300),
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
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
