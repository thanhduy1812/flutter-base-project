import 'package:flutter/foundation.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/banner_resource/banner_resource.dart';

class PromotionPageViewModel extends BasePageViewModel {
  List<GtdBannerRs> hotelBanners = [];
  List<GtdBannerRs> comboBanners = [];
  List<GtdBannerRs> chillBanners = [];
  bool isFristLoad = false;
  PromotionPageViewModel() {
    debugPrint("inite PromotionPageViewModel");
  }
}
