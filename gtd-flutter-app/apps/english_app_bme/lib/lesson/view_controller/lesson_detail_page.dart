import 'package:english_app_bme/home/app_bottom_bar.dart';
import 'package:english_app_bme/home/cubit/bme_user_cubit.dart';
import 'package:english_app_bme/home/view/feed_back_view.dart';
import 'package:english_app_bme/home/view/user_list_view.dart';
import 'package:english_app_bme/home/view_model/feed_back_viewmodel.dart';
import 'package:english_app_bme/home/view_model/user_list_viewmodel.dart';
import 'package:english_app_bme/lesson/view_model/lesson_detail_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';

class LessonDetailPage extends BaseStatelessPage<LessonDetailPageViewModel> {
  static const String route = '/lessonDetail';
  const LessonDetailPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocProvider(
      create: (context) => BmeUserCubit()..loadBmeUsersByClassCode(viewModel.course.maLop ?? ""),
      child: BlocBuilder<BmeUserCubit, BmeUserState>(
        builder: (context, state) {
          if (state is BmeUserLoading) {
            return const CircularProgressIndicator();
          }
          if (state is BmeUserInitial) {
            viewModel.bmeUsers = state.bmeUsers;
          }
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
                        UserListView(viewModel: UserListViewModel(bmeUsers: viewModel.bmeUsers)),
                        FeedbackView(viewModel: FeedbackViewModel()),
                      ]),
                    )
                  ],
                )),
          );
        },
      ),
    );
  }
}
