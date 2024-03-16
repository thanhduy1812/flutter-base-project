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
                length: _tabViews().length,
                child: Column(
                  children: [
                    _tabViews().length == 1
                        ? const SizedBox()
                        : ColoredBox(
                            color: appBlueDeepColor,
                            child: TabBar(
                              labelStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                              tabs: _tabViews(),
                              unselectedLabelColor: Colors.orangeAccent,
                              labelColor: Colors.orangeAccent,
                              indicatorColor: Colors.orangeAccent,
                              // dividerColor: appBlueDeepColor,
                            ),
                          ),
                    Expanded(
                      child: TabBarView(children: _generateTabarView()),
                    )
                  ],
                )),
          );
        },
      ),
    );
  }

  List<Widget> _tabViews() {
    if (viewModel.role == "ADMIN") {
      return [
        const Tab(text: "Students"),
      ];
    } else if (viewModel.role == "MENTOR") {
      return [
        const Tab(text: "Students"),
        const Tab(text: "Rating"),
      ];
    } else {
      return [const Tab(text: "Rating")];
    }
  }

  List<Widget> _generateTabarView() {
    if (viewModel.role == "ADMIN") {
      return [
        UserListView(
            viewModel: UserListViewModel(bmeUsers: viewModel.bmeUsers, userFeedbacks: viewModel.userFeedbacks),
            isShowRating: true)
      ];
    } else if (viewModel.role == "MENTOR") {
      return [
        UserListView(
            viewModel: UserListViewModel(bmeUsers: viewModel.bmeUsers, userFeedbacks: viewModel.userFeedbacks),
            isShowRating: true),
        FeedbackView(viewModel: FeedbackViewModel(viewModel.lessonRoadmapRs.id ?? 0))
      ];
    } else {
      return [FeedbackView(viewModel: FeedbackViewModel(viewModel.lessonRoadmapRs.id ?? 0))];
    }
  }
}
