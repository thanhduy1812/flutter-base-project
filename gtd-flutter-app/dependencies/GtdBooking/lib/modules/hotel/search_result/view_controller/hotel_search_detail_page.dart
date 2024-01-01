import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/combo/search_result/view_model/combo_hotel_search_detail_page_viewmodel.dart';
import 'package:gtd_booking/modules/flight/search_result/view_model/flight_header_expand_view_model.dart';
import 'package:gtd_booking/modules/flight/search_result/views/flight_header_expand_view.dart';
import 'package:gtd_booking/modules/hotel/search_result/cubit/hotel_search_detail_cubit.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_search_detail_view/view/hotel_search_detail_list_room_view.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_search_detail_view/view/hotel_search_intro_view.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_search_detail_view/view/hotel_search_policy_view.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_search_detail_view/view/hotel_search_room_amenity_view.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_search_detail_view/view_model/hotel_search_intro_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_search_detail_view/view_model/hotel_search_policy_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/view/hotel_search_detail_view/view_model/hotel_search_room_amenity_viewmodel.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/base/view/gtd_flutter_map/gtd_flutter_map.dart';
import 'package:gtd_utils/base/view/gtd_flutter_map/gtd_map_controller.dart';
import 'package:gtd_utils/base/view/gtd_flutter_map/gtd_map_point.dart';
import 'package:gtd_utils/base/view/gtd_tabbar/view/gtd_tab.dart';
import 'package:gtd_utils/base/view/gtd_tabbar/view/gtd_tabbar_helper.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/configuration/color_config/colors_extension.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_dots_paging_listview/gtd_dots_paging_listview.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_html_view.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_rating_bar.dart';

import '../view_model/hotel_search_detail_page_viewmodel.dart';

class HotelSearchDetailPage extends BaseStatelessPage<HotelSearchDetailPageViewModel> {
  static const String route = '/hotelSearchDetailPage';
  HotelSearchDetailPage({super.key, required super.viewModel});
  final ScrollController scrollController = ScrollController();
  @override
  AppBar? buildAppbar(BuildContext pageContext) {
    return null;
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocProvider(
      create: (context) => HotelSearchDetailCubit()..searchHotelAllRate(viewModel.searchAllRateRq),
      child: BlocBuilder<HotelSearchDetailCubit, HotelSearchDetailState>(
        builder: (context, state) {
          if (state is HotelSearchDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // if (state is HotelSearchDetailError) {
          //   GtdPopupMessage(context).showError(error: state.apiError.message);
          // }
          if (state is HotelSearchDetailLoaded) {
            viewModel.hotelSearchDetailDTO = state.searchDetailDTO;
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              var hotelSearchDetailDTO = viewModel.hotelSearchDetailDTO;
              return ColoredBox(
                color: Colors.grey.shade200,
                child: StatefulBuilder(builder: (context, setStateScrollView) {
                  return CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      //APPBAR List Images
                      SliverAppBar(
                        pinned: false,
                        snap: false,
                        floating: false,
                        scrolledUnderElevation: 0,
                        // automaticallyImplyLeading: false,
                        leading: InkWell(
                          onTap: () {
                            context.pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: GtdAppIcon.iconNamedSupplier(iconName: "icon-back-circle.svg", height: 40),
                          ),
                        ),
                        expandedHeight: (constraints.maxWidth / 2),
                        backgroundColor: Colors.white,
                        flexibleSpace: FlexibleSpaceBar(
                          background: GtdDotsPagingListView(
                              builder: (index) {
                                return SizedBox(
                                  child: GtdImage.cachedImgUrlWithPlaceholder(
                                      url: viewModel.hotelImages[index], fit: BoxFit.cover),
                                );
                              },
                              itemCount: viewModel.hotelImages.length),
                        ),
                      ),

                      // HEADER FLIGHT FOR COMBO
                      Builder(
                        builder: (context) {
                          if (viewModel is ComboHotelSearchDetailPageViewModel) {
                            return SliverToBoxAdapter(
                              child: FlightHeaderExpandView(
                                  viewModel: FlightheaderExpandViewModel.fromFlightSummaryItemViewModel(
                                      flighItems: (viewModel as ComboHotelSearchDetailPageViewModel).flightItems)),
                            );
                          } else {
                            return const SliverToBoxAdapter();
                          }
                        },
                      ),

                      // HEADER HOTEL
                      SliverToBoxAdapter(
                        child: ColoredBox(
                          color: Colors.white,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child: Row(
                                children: [
                                  Text(
                                    // "viewModel.hotelItemModel.hotelName",
                                    hotelSearchDetailDTO.hotelItemDTO?.hotelName ?? "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 17, color: Colors.grey.shade900),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  const IconButton(onPressed: null, icon: Icon(Icons.ios_share))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: IntrinsicWidth(
                                child: Row(
                                  children: [
                                    Text(
                                      // "viewModel.hotelItemModel.hotelType",
                                      hotelSearchDetailDTO.hotelItemDTO?.hotelType ?? "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: Colors.grey.shade900,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    const SizedBox(width: 8),
                                    GtdRatingBar.ratingWithValue(hotelSearchDetailDTO.hotelItemDTO?.rating ?? 0,
                                        itemSize: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      // "2.5/5 Tốt",
                                      viewModel.hotelSearchDetailDTO.hotelItemDTO?.guestRating ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400, fontSize: 13, color: CustomColors.mainOrange),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: SizedBox(
                                  width: double.infinity,
                                  height: 80,
                                  child: GtdFlutterMap(
                                    mapController: GtdMapController(),
                                    initMapPoint: GtdMapPoint(
                                        latitude: viewModel.hotelSearchDetailDTO.hotelItemDTO?.latitude ?? 10.7757644,
                                        longitude: hotelSearchDetailDTO.hotelItemDTO?.longitude ?? 106.6885314),
                                    zoom: 14,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  GtdAppIcon.iconNamedSupplier(iconName: "hotel/hotel-search-location.svg", height: 24),
                                  Flexible(
                                    child: Text(
                                      hotelSearchDetailDTO.hotelItemDTO?.address?.lineOne ?? "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.boldText),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: viewModel.nearByInfo.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Xung quanh có gì?",
                                          style: TextStyle(color: AppColors.subText),
                                        ),
                                        GtdHtmlView(
                                          htmlString: viewModel.nearByInfo,
                                        )
                                      ],
                                    )
                                  : const SizedBox(),
                            )
                          ]),
                        ),
                      ),

                      //ROOM AMENITIES
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 4),
                          child: ColoredBox(
                            color: Colors.white,
                            child: SizedBox(
                              height: 75,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: (viewModel.hotelSearchDetailDTO.hotelItemDTO?.amenities ?? []).length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.tv),
                                      Text(viewModel.hotelSearchDetailDTO.hotelItemDTO?.amenities[index].name ?? "",
                                          style: TextStyle(
                                              fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // HotelI INFO
                      SliverToBoxAdapter(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ColoredBox(
                              color: Colors.white,
                              child: SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text.rich(TextSpan(
                                                text: "Phòng & khách \n",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.subText),
                                                children: [
                                                  TextSpan(
                                                      text: viewModel.searchInfoTitle,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w600,
                                                          color: CustomColors.mainOrange))
                                                ])),
                                          ),
                                          GtdAppIcon.iconNamedSupplier(iconName: "hotel/hotel-change.svg", height: 24)
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Card(
                                        margin: EdgeInsets.zero,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(color: Colors.grey.shade200, width: 1),
                                            borderRadius: BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13.5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text.rich(TextSpan(
                                                  text: "Nhận phòng \n",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400,
                                                      color: AppColors.subText),
                                                  children: [
                                                    TextSpan(
                                                        text: viewModel.checkin,
                                                        style: const TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600,
                                                            color: CustomColors.mainOrange))
                                                  ])),
                                              Column(
                                                children: [
                                                  GtdAppIcon.iconNamedSupplier(
                                                      iconName: "icon-clock-grey.svg", width: 24),
                                                  const SizedBox(height: 4),
                                                  Card(
                                                    margin: EdgeInsets.zero,
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                        side: BorderSide(color: Colors.grey.shade200, width: 1),
                                                        borderRadius: BorderRadius.circular(100)),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                      child: Text(
                                                        "${viewModel.countNights} đêm",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600,
                                                            color: AppColors.boldText),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                    text: "Trả phòng \n",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w400,
                                                        color: AppColors.subText),
                                                    children: [
                                                      TextSpan(
                                                          text: viewModel.checkout,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w600,
                                                              color: CustomColors.mainOrange))
                                                    ]),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ),
                      //LIST ROOMS
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ColoredBox(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Text.rich(
                                      TextSpan(
                                          text: "Mẹo ",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: CustomColors.mainOrange),
                                          children: [
                                            TextSpan(
                                                text: "Chọn phòng nhanh hơn",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.boldText))
                                          ]),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: GtdTabbarHelper.gotadiSelectTabbars<String>(
                                    tabs: [
                                      const GtdTab(
                                        data: "isHoanHuy",
                                        text: "Hoàn huỷ miễn phí",
                                      ),
                                      const GtdTab(
                                        data: "isHaveBreakfast",
                                        text: "Bao gồm ăn sáng",
                                      )
                                    ],
                                    onSelected: (value) {
                                      print(value.data);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              const Center(child: Text("Giá 1 phòng / 1 đêm, đã bao gồm thuế, phí.")),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                child: ListView.separated(
                                    padding: const EdgeInsets.only(top: 16),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return HotelSearchDetailListRoomView(
                                        viewModel: viewModel.listRoomViewModels[index],
                                      );
                                    },
                                    separatorBuilder: (context, index) => const SizedBox(
                                          height: 8,
                                        ),
                                    itemCount: viewModel.listRoomViewModels.length),
                              )
                            ],
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                          child: HotelSearchRoomAmenityView(
                              viewModel: HotelSearchRoomAmenityViewModel.fromAmenities(
                                  viewModel.hotelSearchDetailDTO.hotelAmenities)),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                          child: HotelSearchIntroView(
                              viewModel: HotelSearchIntroViewModel.fromContent(
                                  viewModel.hotelSearchDetailDTO.hotelItemDTO?.hotelIntroContent ?? "")),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                          child: HotelSearchPolicyView(
                              viewModel: HotelSearchPolicyViewModel.fromPolicies(
                                  policies: viewModel.hotelSearchDetailDTO.hotelItemDTO?.policies ?? [],
                                  checkin: viewModel.hotelSearchDetailDTO.hotelItemDTO?.checkin ?? "",
                                  checkout: viewModel.hotelSearchDetailDTO.hotelItemDTO?.checkout ?? "")),
                        ),
                      ),

                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 100,
                        ),
                      )
                    ],
                  );
                }),
              );
            },
          );
        },
      ),
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}
