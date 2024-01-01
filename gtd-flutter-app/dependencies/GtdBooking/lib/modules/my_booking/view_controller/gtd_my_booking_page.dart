import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/my_booking/view_model/gtd_my_booking_page_viewmodel.dart';
import 'package:gtd_booking/modules/my_booking/views/my_booking_loading.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/base/view/gtd_outline_select_button/view/gtd_outline_select_button.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/booking_resource/booking_resource.dart';
import 'package:gtd_utils/helpers/extension/loadmore_list_extention.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';

import '../bloc_cubit/my_booking_cubit.dart';
import '../view_model/my_booking_item_viewmodel.dart';
import '../views/my_booking_flight_item.dart';

class GtdMyBookingPage extends BaseStatelessPage<GtdMyBookingPageViewModel> {
  static const String route = '/myBooking';
  final List<Widget> loadingItems = [1, 2, 3, 4].map((e) => MyBookingListLoading.myBookingItemLoadingWidget()).toList();
  GtdMyBookingPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => MyBookingCubit()
                ..initSearchMyBooking()
                ..initController()),
        ],
        child: BlocConsumer<MyBookingCubit, MyBookingState>(
          listener: (contextMyBooking, state) {
            if (state is MyBookingErrorState) {
              GtdPopupMessage.showConfirm(
                context: contextMyBooking,
                error: state.apiError.message,
                onCancel: () => pageContext.pop(),
                onConfirm: () => pageContext.pop(),
              );
            }
          },
          builder: (context, state) {
            return BlocBuilder<MyBookingCubit, MyBookingState>(
              builder: (myBookingContext, myBookingState) {
                return Column(
                  children: [
                    SizedBox(
                      height: 72,
                      child: ColoredBox(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                              hintText: 'Mã tham chiếu / Mã đặt chỗ',
                              hintStyle:
                                  TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            onChanged: (value) {
                              BlocProvider.of<MyBookingCubit>(myBookingContext).querySearchController.add(value);
                            },
                          ),
                        ),
                      ),
                    ),
                    StatefulBuilder(builder: (context, setState) {
                      return SizedBox(
                        height: 45,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ListView.separated(
                            padding: const EdgeInsets.only(left: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: viewModel.filterSupplierItems.length,
                            itemBuilder: (context, index) {
                              var item = viewModel.filterSupplierItems[index];
                              return GtdSelectItem(
                                  viewModel: viewModel.filterSupplierItems[index],
                                  onSelect: (value) {
                                    setState(
                                      () {
                                        viewModel.filterSupplierItems.where((element) => element != value).map(
                                          (e) {
                                            e.isSelected = false;
                                            return e;
                                          },
                                        ).toList();
                                        BlocProvider.of<MyBookingCubit>(context)
                                            .filterMyBooking(supplierType: value.data);
                                      },
                                    );
                                  },
                                  centerItem: Builder(
                                    builder: (context) => SizedBox(
                                      child: Center(
                                        child: Text(item.itemTitle,
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
                                      ),
                                    ),
                                  ));
                            },
                            separatorBuilder: (context, index) => const SizedBox(
                              width: 4,
                            ),
                          ),
                        ),
                      );
                    }),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Builder(builder: (myBookingContext) {
                          if (myBookingState is MyBookingLoadingState) {
                            if (myBookingState.status == MyBookingStatus.success ||
                                myBookingState.status == MyBookingStatus.isLoadMore) {
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
                                      if (myBookingState.status == MyBookingStatus.success) {
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
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ));
  }

  Future<void> _pullRefresh(myBookingContext) async {
    BlocProvider.of<MyBookingCubit>(myBookingContext).refreshMyBooking();
  }
}
