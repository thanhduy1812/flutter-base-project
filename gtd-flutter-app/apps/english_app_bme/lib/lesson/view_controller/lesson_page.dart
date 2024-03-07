import 'package:english_app_bme/home/app_bottom_bar.dart';
import 'package:english_app_bme/lesson/view_controller/lesson_detail_page.dart';
import 'package:english_app_bme/lesson/view_model/lesson_detail_page_viewmodel.dart';
import 'package:english_app_bme/lesson/view_model/lesson_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';

class LessonPage extends BaseStatelessPage<LessonPageViewModel> {
  static const String route = '/lessons';
  const LessonPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomScrollView(
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
                const Text("Beginner Course",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: appBlueDeepColor)),
                const SizedBox(height: 8),
                const Text("Jul 4, 2023"),
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
                          title: const Text("Josie"),
                          subtitle: Text("Teacher", style: TextStyle(color: AppColors.subText)),
                        ),
                      ),
                      const Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text("9h 33m",
                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.deepOrangeAccent)),
                          subtitle: Text("45 Lessons", style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                      ),
                      Expanded(child: rowIconRating(pageContext)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                  width: 125,
                  child: Card(
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      color: appOrangeDarkColor,
                      child: Center(
                        child: Text(
                          "45 Lessons",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                      )),
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
                    return SizedBox(
                        height: 65,
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          child: ListTile(
                            onTap: () {
                              var detailPageViewModel = LessonDetailPageViewModel(title: "Lesson 1");
                              context.push(LessonDetailPage.route, extra: detailPageViewModel);
                            },
                            leading: const Icon(
                              Icons.play_circle_outline,
                              color: appBlueDeepColor,
                            ),
                            title: const Text("Lesson 1", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
                            subtitle: const Text("1h30m"),
                            trailing: (index == 0)
                                ? const Icon(
                                    Icons.check_box_rounded,
                                    color: appOrangeDarkColor,
                                  )
                                : const Icon(
                                    Icons.lock,
                                    color: appBlueDeepColor,
                                  ),
                          ),
                        ));
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemCount: 40),
            ),
          )
        ],
      ),
    );
  }

  static Widget rowIconRating(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GtdImage.svgFromAsset(assetPath: "assets/image/ico-sad.svg", color: appBlueLightColor, width: 32),
        GtdImage.svgFromAsset(assetPath: "assets/image/ico-normal.svg", color: appBlueLightColor, width: 32),
        GtdImage.svgFromAsset(assetPath: "assets/image/ico-happy.svg", color: appBlueDeepColor, width: 32)
      ],
    );
  }
}
