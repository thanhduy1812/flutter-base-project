import 'package:english_app_bme/home/app_bottom_bar.dart';
import 'package:english_app_bme/home/cubit/bme_course_cubit.dart';
import 'package:english_app_bme/home/cubit/bme_user_cubit.dart';
import 'package:english_app_bme/home/view/user_list_view.dart';
import 'package:english_app_bme/home/view_controller/add_course_page.dart';
import 'package:english_app_bme/home/view_controller/add_user_page.dart';
import 'package:english_app_bme/home/view_model/add_course_page_viewmodel.dart';
import 'package:english_app_bme/home/view_model/add_user_page_viewmodel.dart';
import 'package:english_app_bme/home/view_model/user_list_viewmodel.dart';
import 'package:english_app_bme/lesson/view_controller/lesson_page.dart';
import 'package:english_app_bme/lesson/view_model/lesson_page_viewmodel.dart';
import 'package:english_app_bme/login/view_controller/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/network/gtd_app_logger.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';

import '../view_model/home_page_viewmodel.dart';

class HomePage extends BaseStatelessPage<HomePageViewModel> {
  static const String route = '/home';
  const HomePage({super.key, required super.viewModel});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => BmeCourseCubit()..loadCourse(),
      ),
      BlocProvider(
        create: (context) => BmeUserCubit()..loadBmeUsers(),
      ),
    ], child: super.build(context));
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocBuilder<BmeCourseCubit, BmeCourseState>(
      builder: (context, state) {
        if (state is BmeCourseInitial) {
          viewModel.originCourses = state.courses;
          viewModel.filteredCourses = List.from(viewModel.originCourses);
        }
        return BlocBuilder<BmeUserCubit, BmeUserState>(
          builder: (context, state) {
            if (state is BmeUserInitial) {
              viewModel.originUsers = state.bmeUsers;
              viewModel.updateFilteredUser();
            }
            return Column(
              children: [
                ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: viewModel.searchFieldController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.none)),
                        hintText: 'Search...',
                        hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                        filled: false,
                        fillColor: Colors.white,
                        focusColor: appBlueDeepColor,
                        hoverColor: appBlueDeepColor,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      onTapOutside: (event) {
                        FocusScope.of(pageContext).unfocus();
                      },
                      onChanged: (value) {
                        viewModel.querySearchController.sink.add(value);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListenableBuilder(
                    listenable: viewModel,
                    builder: (context, child) {
                      switch (viewModel.seletedTab) {
                        case HomePageTab.course:
                          return _courseList(context);
                        case HomePageTab.mentor:
                          return ColoredBox(
                              color: Colors.white,
                              child: UserListView(viewModel: UserListViewModel(bmeUsers: viewModel.filteredUsers)));
                        case HomePageTab.student:
                          return ColoredBox(
                              color: Colors.white,
                              child: UserListView(viewModel: UserListViewModel(bmeUsers: viewModel.filteredUsers)));
                      }
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget? buildBottomBar(BuildContext pageContext) {
    if (viewModel.role != "ADMIN") {
      return null;
    }
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 10,
            selectedItemColor: Colors.orangeAccent,
            currentIndex: viewModel.seletedTab.tabValue,
            onTap: (value) {
              Logger.i("index");
              viewModel.selectTab(value);
            },
            items: tabs);
      },
    );
  }

  @override
  Widget? titleWidget() {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Text(viewModel.title ?? "");
      },
    );
  }

  @override
  List<Widget> buildTrailingActions(BuildContext pageContext) {
    // TODO: implement buildTrailingActions
    return [
      IconButton(
          onPressed: () {
            pageContext.pushReplacement(LoginPage.route);
          },
          icon: const Icon(Icons.exit_to_app_rounded))
    ];
  }

  @override
  Widget? floatingButton(BuildContext context) {
    if (viewModel.role != "ADMIN") {
      return null;
    }
    return FloatingActionButton(
      backgroundColor: appBlueDeepColor,
      onPressed: () => {
        switch (viewModel.seletedTab) {
          HomePageTab.course => context.push(AddCoursePage.route, extra: AddCoursePageViewModel()).then((value) {
              if (value != null) {
                BlocProvider.of<BmeCourseCubit>(context).loadCourse();
              }
            }),
          HomePageTab.mentor =>
            context.push(AddUserPage.route, extra: AddUserPageViewModel(homePageTab: HomePageTab.mentor)).then((value) {
              if (value != null) {
                BlocProvider.of<BmeUserCubit>(context).loadBmeUsers(role: "MENTOR");
              }
            }),
          HomePageTab.student => context
                .push(AddUserPage.route, extra: AddUserPageViewModel(homePageTab: HomePageTab.student))
                .then((value) {
              if (value != null) {
                BlocProvider.of<BmeUserCubit>(context).loadBmeUsers(role: "USER");
              }
            }),
        }
      },
      tooltip: 'Add ${viewModel.seletedTab.title}',
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 45,
      ),
    );
  }

  Widget _courseList(BuildContext context) {
    return BlocBuilder<BmeCourseCubit, BmeCourseState>(
      builder: (context, state) {
        if (state is BmeCourseLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
            itemBuilder: (context, index) {
              var course = viewModel.filteredCourses[index];
              return InkWell(
                onTap: () {
                  var lessonPageViewModel = LessonPageViewModel(course: course);
                  context.push(LessonPage.route, extra: lessonPageViewModel);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: ColoredBox(
                        color: appBlueDeepColor,
                        child: SizedBox(
                          height: 170,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: ColoredBox(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Card(
                                      color: appBlueLightColor,
                                      elevation: 0,
                                      margin: EdgeInsets.zero,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          course.maLop ?? "",
                                          style: const TextStyle(fontWeight: FontWeight.w800, color: appBlueDeepColor),
                                        ),
                                      ),
                                    ),
                                    Text(course.ngayKhaiGiang ?? "--",
                                        style: TextStyle(
                                            fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText)),
                                    // Text("15 Lessons", style: TextStyle(fontSize: 15, color: AppColors.subText)),
                                    Row(
                                      children: [
                                        GtdImage.svgFromAsset(
                                            assetPath: "assets/image/ico-contact.svg",
                                            color: appBlueDeepColor,
                                            width: 32),
                                        const SizedBox(width: 8),
                                        Text(course.giaoVienHienTai ?? "--",
                                            style: TextStyle(
                                                fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 0),
            itemCount: viewModel.filteredCourses.length);
      },
    );
  }

  // Widget _userList(BuildContext context) {
  //   return ListView.separated(
  //       itemBuilder: (context, index) {
  //         return SizedBox(
  //             // height: 50,
  //             child: ListTile(
  //           leading:
  //               GtdImage.svgFromAsset(assetPath: "assets/image/ico-contact.svg", color: appBlueDeepColor, width: 32),
  //           title: Text("Henry Itondo",
  //               style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.boldText)),
  //           subtitle:
  //               Text("09xxx", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.subText)),
  //         ));
  //       },
  //       separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
  //       itemCount: 40);
  // }
}
