import 'package:beme_english/home/app_bottom_bar.dart';
import 'package:beme_english/home/cubit/bme_user_cubit.dart';
import 'package:beme_english/home/view/feed_back_view.dart';
import 'package:beme_english/home/view/user_list_view.dart';
import 'package:beme_english/home/view_model/feed_back_viewmodel.dart';
import 'package:beme_english/home/view_model/user_list_viewmodel.dart';
import 'package:beme_english/lesson/view_model/lesson_detail_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/bme_client.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

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
                      child: TabBarView(children: _generateTabarView(pageContext)),
                    )
                  ],
                )),
          );
        },
      ),
    );
  }

  List<Widget> _tabViews() {
    if (viewModel.role.toUpperCase() == BmeUserRole.admin.roleValue) {
      return [
        const Tab(text: "Students"),
        const Tab(text: "Mentors"),
      ];
    } else if (viewModel.role.toUpperCase() == BmeUserRole.mentor.roleValue) {
      return [
        const Tab(text: "Students"),
        // const Tab(text: "Rating"),
      ];
    } else {
      return [const Tab(text: "Rating")];
    }
  }

  List<Widget> _generateTabarView(BuildContext context) {
    if (viewModel.role.toUpperCase() == BmeUserRole.admin.roleValue) {
      return [
        UserListView(
            viewModel: UserListViewModel(
                bmeUsers: viewModel.bmeUsers
                    .where((element) => element.role?.toUpperCase() == BmeUserRole.user.roleValue)
                    .toList(),
                userFeedbacks: viewModel.userFeedbacks),
            onSelected: (value) {
              var userFeedbacks = viewModel.userFeedbacksByUserName(value.username!);
              if (userFeedbacks.isEmpty) {
                return;
              }
              GtdPresentViewHelper.presentView(
                title: "${value.fullName} feedback!",
                context: context,
                builder: Builder(
                  builder: (context) {
                    return FeedbackView(
                        viewModel:
                            FeedbackViewModel.loadExistFeedback(viewModel.lessonRoadmapRs.id ?? 0, userFeedbacks));
                  },
                ),
              );
            },
            isShowRating: true),
        UserListView(
            viewModel: UserListViewModel(
                bmeUsers: viewModel.bmeUsers
                    .where((element) => element.role?.toUpperCase() == BmeUserRole.user.roleValue)
                    .toList(),
                userFeedbacks: viewModel.userFeedbacks,
                viewMode: UserListViewMode.mentor),
            onSelected: (value) {
              var userFeedbacks = viewModel.userFeedbacksByFeedbackTo(value.username!);
              if (userFeedbacks.isEmpty) {
                return;
              }
              GtdPresentViewHelper.presentView(
                title: "${value.fullName} feedback!",
                context: context,
                builder: Builder(
                  builder: (context) {
                    return FeedbackView(
                        viewModel:
                            FeedbackViewModel.loadExistFeedback(viewModel.lessonRoadmapRs.id ?? 0, userFeedbacks));
                  },
                ),
              );
            },
            isShowRating: true),
      ];
    } else if (viewModel.role.toUpperCase() == BmeUserRole.mentor.roleValue) {
      return [
        UserListView(
            viewModel: UserListViewModel(
                bmeUsers: viewModel.bmeUsers
                    .where((element) => element.role?.toUpperCase() == BmeUserRole.user.roleValue)
                    .toList(),
                userFeedbacks: viewModel.userFeedbacks),
            onSelected: (value) {
              var userFeedbacks = viewModel.userFeedbacksByFeedbackTo(value.username!);
              // if (userFeedbacks.isEmpty) {
              //   return;
              // }
              GtdPresentViewHelper.presentView(
                title: "${value.fullName} feedback!",
                context: context,
                builder: Builder(
                  builder: (context) {
                    return FeedbackView(
                      viewModel: FeedbackViewModel.loadExistFeedback(viewModel.lessonRoadmapRs.id ?? 0, userFeedbacks,
                          feedbackTo: value.username),
                    );
                  },
                ),
              );
            },
            isShowRating: true),
        // FeedbackView(viewModel: FeedbackViewModel(viewModel.lessonRoadmapRs.id ?? 0))
      ];
    } else {
      return [FeedbackView(viewModel: FeedbackViewModel(viewModel.lessonRoadmapRs.id ?? 0))];
    }
  }
}
