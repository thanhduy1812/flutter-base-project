import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/combo/search_result/view_model/combo_hotel_search_detail_page_viewmodel.dart';
import 'package:gtd_booking/modules/combo/search_result/view_model/combo_search_result_page_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/cubit/hotel_search_cubit.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_result_content_item/view/hotel_result_card_item_view.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_search_detail_page_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_search_result_page_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/helpers/extension/build_context_extension.dart';
import 'package:gtd_utils/helpers/extension/loadmore_sliver_list_extension.dart';

import '../view_controller/hotel_search_detail_page.dart';
import '../view_model/hotel_result_content_vertical_viewmodel.dart';

class HotelResultContentVerticalView
    extends BaseView<HotelResultContentVerticalViewModel> {
  final ScrollController? scrollController;

  const HotelResultContentVerticalView(
      {super.key, required super.viewModel, this.scrollController});

  @override
  Widget buildWidget(BuildContext context) {
    var parentViewModel = context.viewModelOf<HotelSearchResultPageViewModel>();
    return RefreshIndicator(
      onRefresh: () async {
        if (parentViewModel != null) {
          BlocProvider.of<HotelSearchCubit>(context).searchHotelBestRate(
              parentViewModel.createSearchRequest(isRefesh: true));
        }
      },
      child: CustomScrollView(
        controller: scrollController,
        cacheExtent: 200,
        slivers: [
          SliverToBoxAdapter(
            child: (parentViewModel is ComboSearchResultPageViewModel)
                ? const SizedBox(height: 16)
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 49, vertical: 20),
                    child: Center(
                      child: Text(
                        "Giá ${viewModel.totalRoom} phòng/"
                        "${viewModel.totalNights} đêm, đã bao gồm thuế, phí. "
                        "Đã tìm thấy ${viewModel.totalItem} kết quả",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.subText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ),
          GtdLoadMoreSliverExtention(
            hasMore: () => viewModel.hasNextPage,
            loadMore: () async {
              if (parentViewModel != null) {
                await BlocProvider.of<HotelSearchCubit>(context)
                    .searchLoadMoreHotelBestRate(
                        parentViewModel.createLoadmoreRequest());
              }
            },
            onLoadMore: () {
              viewModel.addLoadingItems();
            },
            onLoadMoreFinished: () {
              viewModel.finishLoadingItems();
            },
            itemBuilder: (itemContext, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: HotelResultCardItemView(
                  viewModel: viewModel.hotelCardItemViewModels[index],
                  onSelect: (value) {
                    var parentViewModel = context.viewModelOf();
                    if (parentViewModel != null) {
                      if (parentViewModel is ComboSearchResultPageViewModel) {
                        ComboHotelSearchDetailPageViewModel
                            detailPageViewModel =
                            ComboHotelSearchDetailPageViewModel
                                .fromSearchDetailDTO(
                                    flightSearchResultDTO: parentViewModel
                                        .flightSearchSubject.value.data,
                                    searchFlightFormModel:
                                        parentViewModel.searchFlightFormModel,
                                    searchHotelFormModel:
                                        parentViewModel.searchHotelFormModel)
                              ..searchAllRateRq =
                                  parentViewModel.createSearchAllRateRq(value);
                        context.push(HotelSearchDetailPage.route,
                            extra: detailPageViewModel);
                      } else if (parentViewModel
                          is HotelSearchResultPageViewModel) {
                        HotelSearchDetailPageViewModel detailPageViewModel =
                            HotelSearchDetailPageViewModel()
                              ..searchAllRateRq =
                                  parentViewModel.createSearchAllRateRq(value);
                        context.push(
                          HotelSearchDetailPage.route,
                          extra: detailPageViewModel,
                        );
                      }
                    }
                  },
                ),
              );
            },
            itemCount: () => viewModel.hotelCardItemViewModels.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          ),
        ],
      ),
    );
  }

  static Widget hotelContentLoading() {
    return CustomScrollView(
      slivers: [
        SliverList.separated(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: HotelResultCardItemView.hotelResultCardLoading(),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: 16,
          ),
        )
      ],
    );
  }
}
