import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_model/hotel_searching_loading_page_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/search_result/cubit/hotel_search_cubit.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_controller/hotel_search_result_page.dart';
import 'package:gtd_booking/modules/hotel/search_result/view_model/hotel_search_result_page_viewmodel.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/helpers/extension/icon_extension.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';

class HotelSearchingLoadingPage extends BaseStatelessPage<HotelSearchingLoadingPageViewModel> {
  static const String route = '/hotelSearchingLoadingPage';
  const HotelSearchingLoadingPage({super.key, required super.viewModel});
  @override
  AppBar? buildAppbar(BuildContext pageContext) {
    // return AppBar(
    //   backgroundColor: Colors.transparent,
    //   elevation: 0,
    // );
    return null;
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return PopScope(
      onPopInvoked: (didPop) => false,
      child: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => HotelSearchCubit()
                  ..searchHotelBestRate(viewModel.searchHotelFormModel.createHotelSearchRequest().toMap())),
          ],
          child: BlocListener<HotelSearchCubit, HotelSearchState>(
            listener: (searchContext, searchState) {
              if (searchState is HotelSearchError) {
                GtdPopupMessage(pageContext).showError(
                  title: "Có lỗi xảy ra!",
                  error: searchState.apiError.message,
                  onCancel: () => pageContext.pop(),
                  onConfirm: (value) => pageContext.pop(),
                );
              }
              if (searchState is HotelSearchLoaded) {
                var searchResultViewModel = HotelSearchResultPageViewModel.fromGtdHotelSearchResultDTO(
                    hotelSearchResultDTO: searchState.hotelSearchResultDTO,
                    searchHotelFormModel: viewModel.searchHotelFormModel);
                pageContext.pushReplacement(HotelSearchResultPage.route, extra: searchResultViewModel);
              }
            },
            child: Scaffold(
              body: SafeArea(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                          child: GtdImage.giftFromSupplier(
                            assetName: 'assets/icons/loading.gif',
                          ),
                        ),
                        const Text(
                          'Đang tìm khách sạn…',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: 16,
                          children: [
                            Text(
                              'Phòng: ${viewModel.roomCount} ',
                              style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Người lớn: ${viewModel.adult}',
                              style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Trẻ em: ${viewModel.child}',
                              style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Transform.translate(
                          offset: const Offset(0, -25),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                  child:
                                      GtdAppIcon.iconNamedSupplier(iconName: "/hotel/hotel-searching-background.svg")),
                              SizedBox(
                                height: 120,
                                child:
                                    GtdImage.assetAnimated(assetName: "assets/icons/hotel/hotel-search-animated.json"),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Wrap(
                                direction: Axis.vertical,
                                children: [
                                  Text(
                                    'Điểm đến / Khách sạn',
                                    style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    viewModel.locationTitle,
                                    style: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            runSpacing: 8,
                            direction: Axis.vertical,
                            children: [
                              Text(
                                'Ngày nhận phòng: ${viewModel.fromDate}',
                                style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Ngày trả phòng:  ${viewModel.toDate}',
                                style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: GtdButton(
                        text: "Huỷ tìm kiếm",
                        height: 50,
                        colorText: Colors.black,
                        border: const Border.fromBorderSide(
                          BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        borderRadius: 25,
                        onPressed: (value) {
                          pageContext.pop();
                        },
                      ),
                    ),
                  )
                ],
              )),
            ),
          )),
    );
  }
}
