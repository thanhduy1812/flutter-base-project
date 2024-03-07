import 'package:english_app_bme/home/app_bottom_bar.dart';
import 'package:english_app_bme/home/view/feed_back_view.dart';
import 'package:english_app_bme/home/view/user_list_view.dart';
import 'package:english_app_bme/home/view_model/feed_back_viewmodel.dart';
import 'package:english_app_bme/home/view_model/user_list_viewmodel.dart';
import 'package:english_app_bme/lesson/view_model/lesson_detail_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';

class LessonDetailPage extends BaseStatelessPage<LessonDetailPageViewModel> {
  static const String route = '/lessonDetail';
  const LessonDetailPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return ColoredBox(
      color: Colors.white,
      child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const ColoredBox(
                color: appBlueDeepColor,
                child: TabBar(
                  labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  tabs: [
                    Tab(text: "Students"),
                    Tab(text: "Rating"),
                  ],
                  unselectedLabelColor: Colors.orangeAccent,
                  labelColor: Colors.orangeAccent,
                  indicatorColor: Colors.orangeAccent,
                  // dividerColor: appBlueDeepColor,
                ),
              ),
              Expanded(
                child: TabBarView(children: [
                  UserListView(viewModel: UserListViewModel()),
                  FeedbackView(viewModel: FeedbackViewModel()),
                ]),
              )
            ],
          )),
    );
  }
}
