import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/my_booking/bloc_cubit/my_booking_cubit.dart';
import 'package:gtd_booking/modules/my_booking/view_model/my_booking_item_viewmodel.dart';
import 'package:gtd_booking/modules/my_booking/views/my_booking_flight_item.dart';
import 'package:gtd_booking/modules/my_booking/views/my_booking_loading.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/booking_resource/models/response/search_booking_rs.dart';
import 'package:gtd_utils/helpers/extension/loadmore_list_extention.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';

class VibMyBookingPage extends StatefulWidget {
  const VibMyBookingPage({super.key});

  static const String route = '/myBooking';

  @override
  State<VibMyBookingPage> createState() => _VibMyBookingState();
}

class _VibMyBookingState extends State<VibMyBookingPage> {
  late final ScrollController scrollController;

  List<Widget> loadingItems = [1, 2, 3, 4].map((e) => MyBookingListLoading.myBookingItemLoadingWidget()).toList();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(
      keepScrollOffset: true,
      debugLabel: 'pageBodyScroll',
    )..addListener(() {});
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return BlocConsumer(builder: builder, listener: listener,)
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => MyBookingCubit()..initSearchMyBooking()),
        ],
        child: BlocConsumer<MyBookingCubit, MyBookingState>(
          listener: (contextMyBooking, state) {
            if (state is MyBookingErrorState) {
              GtdPopupMessage.showConfirm(
                context: contextMyBooking,
                error: state.apiError.message,
                onCancel: () => context.pop(),
                onConfirm: () => context.pop(),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                scrolledUnderElevation: 0,
                title: const Text('myBooking.flightTitle').tr(),
              ),
              body: SafeArea(
                  child: Container(
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<MyBookingCubit, MyBookingState>(builder: (myBookingContext, vibMyBookingState) {
                  if (vibMyBookingState is MyBookingLoadingState) {
                    if (vibMyBookingState.status == MyBookingStatus.success ||
                        vibMyBookingState.status == MyBookingStatus.isLoadMore) {
                      final myBookingStateItem =
                          BlocProvider.of<MyBookingCubit>(myBookingContext).myBookingSubject.value;
                      var listItems = [];
                      if (!(myBookingStateItem.last)!) {
                        listItems = [...myBookingStateItem.content ?? [], ...loadingItems];
                      } else {
                        listItems = myBookingStateItem.content ?? [];
                      }
                      return RefreshIndicator(
                          onRefresh: () => _pullRefresh(myBookingContext),
                          child: GtdLoadMoreExtention(
                            hasMore: () => !(myBookingStateItem.last!),
                            itemCount: () => listItems.length,
                            loadMore: () async {
                              const MyBookingListLoading(
                                itemNumber: 4,
                              );
                            },
                            onLoadMore: () {
                              if (vibMyBookingState.status == MyBookingStatus.success) {
                                BlocProvider.of<MyBookingCubit>(myBookingContext).loadMoreMyBooking();
                              }
                            },
                            loadMoreOffsetFromBottom: 1,
                            itemBuilder: (context, index) {
                              final itemBooking = listItems[index];
                              return (listItems[index] is BookingInfoElement)
                                  ? MyBookingFlightItem(viewModel: MyBookingItemViewModel(itemBooking))
                                  : const MyBookingListLoading(isScroll: false);
                            },
                          ));
                    } else {
                      return const MyBookingListLoading(
                        itemNumber: 8,
                      );
                    }
                  } else {
                    return const MyBookingListLoading(
                      itemNumber: 8,
                    );
                  }
                }),
              )),
            );
          },
        ));
  }

  Future<void> _pullRefresh(myBookingContext) async {
    BlocProvider.of<MyBookingCubit>(myBookingContext).refreshMyBooking();
  }
}
