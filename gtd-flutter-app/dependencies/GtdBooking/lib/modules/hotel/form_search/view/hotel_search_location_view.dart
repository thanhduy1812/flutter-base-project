import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_model/hotel_search_location_viewmodel.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view/gtd_info_row/gtd_info_row.dart';
import 'package:gtd_utils/base/view/gtd_input_select/gtd_input_select_cell.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_location_dto.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_call_back.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../cubit/hotel_search_location_cubit.dart';

class HotelSearchLocationView extends BaseView<HotelSearchLocationViewModel> {
  final GtdCallback<GtdHotelLocationDTO>? onSelect;
  const HotelSearchLocationView({super.key, required super.viewModel, this.onSelect});

  @override
  Widget buildWidget(BuildContext context) {
    return BlocProvider(
      create: (context) => HotelSearchLocationCubit()..getListPopularHotel(),
      child: BlocBuilder<HotelSearchLocationCubit, HotelSearchLocationState>(
        builder: (locationContext, locationState) {
          if (locationState is HotelSearchLocationLoading) {
            return const SizedBox(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (locationState is HotelPopularLocationLoaded) {
            if (locationState.hotelLocations.isNotEmpty) {
              viewModel.popularHotelLocations = locationState.hotelLocations;
            }
          }
          if (locationState is HotelSearchLocationLoaded) {
            viewModel.searchedHotelLocations = locationState.hotelLocations;
          }
          return Column(
            children: [
              ColoredBox(
                color: Colors.white,
                child: SizedBox(
                  height: 64,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                        hintText: 'Nhập nơi đến / khách sạn',
                        hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      onChanged: (value) {
                        // viewModel.querySearchController.sink.add(value);
                        BlocProvider.of<HotelSearchLocationCubit>(locationContext)
                            .querySearchController
                            .sink
                            .add(value);
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: buildLocationSearchView(locationContext, locationState),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildLocationSearchView(BuildContext context, HotelSearchLocationState state) {
    if (state is HotelPopularLocationLoaded) {
      return buildHotelPopularView();
    } else {
      return ListView.separated(
          itemBuilder: (context, index) {
            var hotelLocation = viewModel.searchedHotelLocations[index];
            return SizedBox(
              child: GtdInputSelectCell(
                leadingIcon: SizedBox(
                    height: 24, child: GtdAppIcon.iconNamedSupplier(iconName: hotelLocation.pathIcon, height: 24)),
                title: hotelLocation.name,
                subTitle: hotelLocation.addressLine,
                trailingIcon: const SizedBox(),
                onSelect: () {
                  onSelect?.call(hotelLocation);
                  context.pop();
                },
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: viewModel.searchedHotelLocations.length);
    }
  }

  Material buildHotelPopularView() {
    return Material(
      color: Colors.grey.shade50,
      child: Column(
        children: [
          ColoredBox(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Vị trí của bạn",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(child: GtdAppIcon.iconNamedSupplier(iconName: "hotel/hotel-my-location.svg"))
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                //Recent Hotel
                viewModel.recentHotelLocations.isNotEmpty
                    ? SliverToBoxAdapter(
                        child: ColoredBox(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Tìm kiếm gần đây",
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 16),
                                LayoutBuilder(
                                  builder: (context, constraints) => Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: viewModel.recentHotelLocations
                                        .map(
                                            (e) => buildRecentHotel(constraints, hotelLocationDTO: e, context: context))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SliverToBoxAdapter(),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 8,
                  ),
                ),
                // Popular Hotel
                SliverToBoxAdapter(
                  child: ColoredBox(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Text(
                            "Địa điểm phổ biến",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                        ),
                        ListView.separated(
                          itemCount: viewModel.popularHotelLocations.length,
                          shrinkWrap: true,
                          cacheExtent: 100,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var popularLocation = viewModel.popularHotelLocations[index];
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: InkWell(
                                onTap: () {
                                  onSelect?.call(popularLocation);
                                  context.pop();
                                },
                                child: GtdInfoRow(
                                  leftText: popularLocation.name,
                                  leftTextStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                  rightText: popularLocation.addressLine,
                                  rightTextStyle:
                                      TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.subText),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecentHotel(BoxConstraints constraints,
      {required GtdHotelLocationDTO hotelLocationDTO, required BuildContext context}) {
    return InkWell(
      onTap: () {
        onSelect?.call(hotelLocationDTO);
        context.pop();
      },
      child: SizedBox(
        height: 57,
        width: constraints.maxWidth / 2 - 4,
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.shade200, width: 1), borderRadius: BorderRadius.circular(6)),
          color: const Color.fromRGBO(255, 255, 255, 1),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: "${hotelLocationDTO.name} \n",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade900),
                    children: [
                      TextSpan(
                          text: hotelLocationDTO.addressLine,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.subText,
                          ))
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension HotelSearchLocationViewHelper on HotelSearchLocationView {
  static void showHotelSearchLocation(
      {required BuildContext pageContext, GtdCallback<GtdHotelLocationDTO>? onSelected}) {
    GtdPresentViewHelper.presentView(
        title: "Điểm đến / Khách sạn",
        context: pageContext,
        contentPadding: EdgeInsets.zero,
        hasInsetBottom: false,
        builder: Builder(
          builder: (context) {
            return HotelSearchLocationView(
              viewModel: HotelSearchLocationViewModel(),
              onSelect: (value) {
                onSelected?.call(value);
              },
            );
          },
        ));
  }
}
