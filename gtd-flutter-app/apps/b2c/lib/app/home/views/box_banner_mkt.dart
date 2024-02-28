import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/checkout/view_controller/flight_checkout_page.dart';
import 'package:gtd_booking/modules/combo/form_search/view_controller/search_combo_page.dart';
import 'package:gtd_booking/modules/combo/form_search/view_model/search_combo_page_viewmodel.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_controller/search_hotel_page.dart';
import 'package:gtd_booking/modules/hotel/form_search/view_model/search_hotel_page_viewmodel.dart';
import 'package:gtd_utils/base/page/base_web_view_page.dart';
import 'package:gtd_utils/base/view/base_view.dart';
import 'package:gtd_utils/base/view_model/base_web_view_page_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/banner_resource/banner_resource.dart';
import 'package:gtd_utils/helpers/extension/image_extension.dart';
import 'package:new_gotadi/app/home/view_model/box_banner_mkt_view_model.dart';

class BoxBannerMkt extends BaseView<BoxBannerMktViewModel> {
  const BoxBannerMkt({super.key, required super.viewModel});

  ClipRRect _smallBannerCard(String url, BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: SizedBox(
        child: GtdImage.cachedImgUrlWithPlaceholder(
          url: url,
          placeholder: const Card(
            elevation: 0,
            child: SizedBox(
              width: 180,
              height: 180,
            ),
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          viewModel.headerTitle.isNotEmpty
              ? ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  title: Text(
                    viewModel.headerTitle,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                )
              : const SizedBox(),
          viewModel.largeBanner?.imageUrl != null
              ? InkWell(
                  onTap: () {
                    String? url = viewModel.largeBanner?.bannerUrl;
                    String title = viewModel.largeBanner?.bannerTitle ?? "Sponsor";
                    if (url != null) {
                      context.push(BaseWebViewPage.route, extra: BaseWebViewPageViewModel(url: url, title: title));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GtdImage.cachedImgUrlWithPlaceholder(
                      url: viewModel.largeBanner!.imageUrl!,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )
              : const SizedBox(),
          viewModel.largeBanner?.imageUrl != null
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "Tài trợ bởi Gotadi",
                    style: TextStyle(color: Color.fromRGBO(133, 133, 133, 1), fontSize: 12),
                    textAlign: TextAlign.left,
                  ),
                )
              : const SizedBox(),
          viewModel.smallImageUrls.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    height: 180,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                String? url = viewModel.banners[index].bannerUrl;
                                String title = viewModel.banners[index].bannerTitle;
                                GtdBannerProductType bannerProductType = viewModel.banners[index].bannerType;
                                if (bannerProductType == GtdBannerProductType.flight) {
                                  context.push(FlightCheckoutPage.route);
                                } else if (bannerProductType == GtdBannerProductType.hotel) {
                                  SearchHotelPageViewModel viewModel = SearchHotelPageViewModel();
                                  context.push(SearchHotelPage.route, extra: viewModel);
                                } else if (bannerProductType == GtdBannerProductType.combo) {
                                  SearchComboPageViewModel viewModel = SearchComboPageViewModel();
                                  context.push(SearchComboPage.route, extra: viewModel);
                                } else if (url != null) {
                                  context.push(BaseWebViewPage.route,
                                      extra: BaseWebViewPageViewModel(url: url, title: title));
                                }
                              },
                              child: _smallBannerCard(viewModel.smallImageUrls[index], context));
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 16);
                        },
                        itemCount: viewModel.smallImageUrls.length),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
