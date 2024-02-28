import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/confirm_booking/view_controller/booking_result.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/base/page/base_web_view_page.dart';
import 'package:gtd_utils/base/view/gtd_tabbar/view/gtd_tabbar_helper.dart';
import 'package:gtd_utils/base/view_model/base_web_view_page_view_model.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/utility_resource/utility_resource.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/helpers/extension/loadmore_list_extention.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_html_view.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_shimmer.dart';
import 'package:new_gotadi/app/notifications/cubit/notifications_cubit.dart';
import 'package:new_gotadi/app/notifications/model/notification_item.dart';
import 'package:new_gotadi/app/notifications/view_model/notifications_page_view_model.dart';

class NotificationsPage extends BaseStatelessPage<NotificationsPageViewModel> {
  static const String route = '/notificationsPage';
  final ScrollController privateController = ScrollController(debugLabel: "private");
  final ScrollController broadCastController = ScrollController(debugLabel: "broadcast");
  NotificationsPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    var tabs = [GtdNotifySenderMethod.private, GtdNotifySenderMethod.broadcast].indexed.map((e) {
      return Builder(
        builder: (context) {
          TabController tabController = DefaultTabController.of(context);
          return InkWell(
            onTap: () {
              if (tabController.index != e.$1) {
                viewModel.selectedSenderMethod = e.$2;
                viewModel.resetItems();
                viewModel.updateFirstLoad(viewModel.selectedSenderMethod);

                DefaultTabController.of(context).animateTo(e.$1);
                BlocProvider.of<NotificationsCubit>(context).loadNotifications(viewModel.selectedSenderMethod);
              }
            },
            child: Tab(
              text: e.$2.notifyTabTitle,
            ),
          );
        },
      );
    }).toList();
    return DefaultTabController(
        length: tabs.length,
        child: BlocProvider(
          create: (context) => NotificationsCubit()..loadAccountInfo(),
          child: Column(
            children: [
              ColoredBox(
                color: Colors.white,
                child: GtdTabbarHelper.buildGotadiUnderLineTabbar(tabs: tabs, isScrollable: false),
              ),
              Expanded(
                  child: TabBarView(children: [
                _myNotificationsList(pageContext, GtdNotifySenderMethod.private),
                _myNotificationsList(pageContext, GtdNotifySenderMethod.broadcast)
              ]))
            ],
          ),
        ));
  }

  Widget _myNotificationsList(BuildContext context, GtdNotifySenderMethod senderMethod) {
    var storeKey = PageStorageKey(senderMethod.rawValue);
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      buildWhen: (previous, current) =>
          previous.senderMethod == current.senderMethod && current.senderMethod == senderMethod,
      builder: (context, state) {
        if (!viewModel.isFirstLoadBroadcast && senderMethod == GtdNotifySenderMethod.broadcast) {
          viewModel.isFirstLoadBroadcast = true;
          BlocProvider.of<NotificationsCubit>(context).loadNotifications(senderMethod);
        }
        if (state is NotificationsLoading) {
          //Reset storekey for avoid keep scroll position
          storeKey = PageStorageKey(UniqueKey().toString());

          return ListView.separated(
              key: key,
              itemBuilder: (context, index) {
                return _notificationItemLoading();
              },
              separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
              itemCount: 4);
        }

        if (state is NotificationsInitial) {
          if (state.notificationsRs != null) {
            viewModel.updateListNotificationsBySender(state.notificationsRs!, senderMethod);
          }
        }
        return RefreshIndicator(
          onRefresh: () async {
            viewModel.resetItems();
            BlocProvider.of<NotificationsCubit>(context).loadNotifications(senderMethod);
          },
          child: GtdLoadMoreExtention(
            key: storeKey,
            controller: senderMethod == GtdNotifySenderMethod.private ? privateController : broadCastController,
            hasMore: () => viewModel.currentListSender(senderMethod).hasNextPage,
            loadMore: () async {
              if (state is! NotificationsLoadingMore) {
                await BlocProvider.of<NotificationsCubit>(context)
                    .loadMoreNotifications(senderMethod, page: viewModel.currentListSender(senderMethod).page + 1);
              }
            },
            onLoadMore: () {
              viewModel.addLoading(senderMethod);
            },
            onLoadMoreFinished: () {
              viewModel.finishLoading(senderMethod);
            },
            itemBuilder: (context, index) {
              var item = viewModel.currentListSender(senderMethod).data[index];
              if (item.isLoadingItem) {
                return _notificationItemLoading();
              } else {
                return InkWell(
                    onTap: () {
                      var redirectTuple = item.itemRs.getRedirectTuple();
                      if (redirectTuple != null) {
                        if (redirectTuple.notifType == NotificationRedirectType.bookingNumber) {
                          context.push(BookingResultPage.route, extra: {
                            'bookingNumber': redirectTuple.value,
                          });
                        }
                        if (redirectTuple.notifType == NotificationRedirectType.url) {
                          context.push(BaseWebViewPage.route,
                              extra: BaseWebViewPageViewModel(url: redirectTuple.value)..title = item.itemRs.name);
                        }
                      }
                    },
                    child: _notificationItem(viewModel.currentListSender(senderMethod).data[index]));
              }
            },
            itemCount: () => viewModel.currentListSender(senderMethod).data.length,
            separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
          ),
        );
      },
    );
  }

  Widget _notificationItem(NotificationItem item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            // child: GtdImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-flight.svg"),
            child: item.notifyIconFromType,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    item.itemRs.name ?? "",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                GtdHtmlView(
                  htmlString: item.itemRs.excerpt ?? "",
                ),
                (item.itemRs.imgUrl ?? "").isNotEmpty
                    ? GtdImage.cachedImgUrlWithPlaceholder(url: item.itemRs.imgUrl!)
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 8),
                  child: Text(
                    // "13:34, Thứ sáu 02/01/2022",
                    item.itemRs.createdDate != null ? dateFormatFlight.format(item.itemRs.createdDate!) : "",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.strikeText),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _notificationItemLoading() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GtdShimmer(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GtdImage.svgFromAsset(assetPath: "assets/images/icons/ico-noti-flight.svg"),
            ),
          ),
          Expanded(
            child: GtdShimmer(child: SizedBox(height: 80, width: double.infinity, child: GtdShimmer.cardLoading())),
          )
        ],
      ),
    );
  }
}
