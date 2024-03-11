import 'package:english_app_bme/home/app_bottom_bar.dart';
import 'package:english_app_bme/home/view_controller/add_course_page.dart';
import 'package:english_app_bme/home/view_model/add_course_page_viewmodel.dart';
import 'package:english_app_bme/lesson/view_controller/lesson_detail_page.dart';
import 'package:english_app_bme/lesson/view_model/lesson_detail_page_viewmodel.dart';
import 'package:english_app_bme/lesson/view_model/lesson_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';

class LessonPage extends BaseStatelessPage<LessonPageViewModel> {
  static const String route = '/lessons';
  const LessonPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return CustomScrollView(
            slivers: [
              //Image
              SliverToBoxAdapter(
                  child: SizedBox(
                      height: 170,
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        color: appBlueDeepColor,
                        child: GtdImage.imgFromAsset(
                            assetPath: "assets/image/course-bg.jpg", fit: BoxFit.fitWidth, width: double.infinity),
                      ))),
              //HeaderTitle
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(viewModel.course.maLop ?? "-----",
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: appBlueDeepColor)),
                    const SizedBox(height: 8),
                    Text(viewModel.course.ngayKhaiGiang ?? "----"),
                    SizedBox(
                      height: 70,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: GtdImage.svgFromAsset(
                                  assetPath: "assets/image/ico-contact.svg", color: appBlueDeepColor, width: 32),
                              title: Text(viewModel.course.giaoVienHienTai ?? "---"),
                              subtitle: Text("Teacher", style: TextStyle(color: AppColors.subText)),
                            ),
                          ),
                          const Spacer(),
                          // const Expanded(
                          //   child: ListTile(
                          //     contentPadding: EdgeInsets.zero,
                          //     title: Text("9h 33m",
                          //         style: TextStyle(fontWeight: FontWeight.w500, color: Colors.deepOrangeAccent)),
                          //     subtitle: Text("45 Lessons", style: TextStyle(fontWeight: FontWeight.w500)),
                          //   ),
                          // ),
                          // Expanded(child: rowIconRating(pageContext)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 125,
                          child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 0,
                              color: appOrangeDarkColor,
                              child: Center(
                                child: Text(
                                  "${viewModel.lessonRoadmaps.length} Lessons",
                                  style:
                                      const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                                ),
                              )),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 50,
                          width: 125,
                          child: InkWell(
                            onTap: () async {
                              await pageContext
                                  .push(AddCoursePage.route,
                                      extra: AddCoursePageViewModel(
                                          title: "", isAddLesson: true, course: viewModel.course))
                                  .then((value) {
                                if (value != null) {
                                  viewModel.loadLessonRoadmaps();
                                }
                              });
                            },
                            child: const Card(
                                margin: EdgeInsets.zero,
                                elevation: 0,
                                color: appBlueDeepColor,
                                child: Center(
                                  child: Text(
                                    "Add lesson",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                                  ),
                                )),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),

              //List Lessons
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var lesson = viewModel.lessonRoadmaps[index];
                        return SizedBox(
                            height: 65,
                            child: Card(
                              elevation: 0,
                              margin: EdgeInsets.zero,
                              child: ListTile(
                                onTap: () {
                                  var detailPageViewModel =
                                      LessonDetailPageViewModel(course: viewModel.course, lessonRoadmapRs: lesson);
                                  context.push(LessonDetailPage.route, extra: detailPageViewModel);
                                },
                                leading: const Icon(
                                  Icons.play_circle_outline,
                                  color: appBlueDeepColor,
                                ),
                                title: Text(lesson.lessonName ?? "",
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
                                subtitle: Text(dateFormat.format(lesson.startDate ?? DateTime.now())),
                                trailing: rowIconRating(pageContext),
                                // trailing: (index == 0)
                                //     ? const Icon(
                                //         Icons.check_box_rounded,
                                //         color: appOrangeDarkColor,
                                //       )
                                //     : const Icon(
                                //         Icons.lock,
                                //         color: appBlueDeepColor,
                                //       ),
                              ),
                            ));
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemCount: viewModel.lessonRoadmaps.length),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  static Widget rowIconRating(BuildContext context,
      {double spacing = 0, LessonRating groupRating = LessonRating.happy, GtdCallback<LessonRating>? onChanged}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => onChanged?.call(LessonRating.sad),
          child: GtdImage.svgFromAsset(
              assetPath: "assets/image/ico-sad.svg",
              color: groupRating == LessonRating.sad ? appBlueDeepColor : appBlueLightColor,
              width: 32),
        ),
        SizedBox(width: spacing),
        InkWell(
          onTap: () => onChanged?.call(LessonRating.normal),
          child: GtdImage.svgFromAsset(
              assetPath: "assets/image/ico-normal.svg",
              color: groupRating == LessonRating.normal ? appBlueDeepColor : appBlueLightColor,
              width: 32),
        ),
        SizedBox(width: spacing),
        InkWell(
          onTap: () => onChanged?.call(LessonRating.happy),
          child: GtdImage.svgFromAsset(
              assetPath: "assets/image/ico-normal.svg",
              color: groupRating == LessonRating.happy ? appBlueDeepColor : appBlueLightColor,
              width: 32),
        ),
      ],
    );
  }
}
