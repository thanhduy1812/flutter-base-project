import 'dart:collection';

import 'package:gtd_utils/base/view_model/base_view_model.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/banner_resource/banner_resource.dart';

const String bannerUrl =
    "https://cms-origin.gotadi.com/wp-content/uploads/2023/12/sl63-t12-tourtet-ThaiLan-BANGKOK-PATTAYA-NONG-NOOCH-ARTZaloOA.jpg";
const String smallBannerUrl = "https://cms-origin.gotadi.com/wp-content/uploads/2023/04/COMBO-DALAT.jpg";

class BoxBannerMktViewModel extends BaseViewModel {
  final String headerTitle;
  final GtdBannerRs? largeBanner;
  late final List<String> smallImageUrls;
  List<GtdBannerRs> banners = [];

  BoxBannerMktViewModel({
    this.headerTitle = "Khách sạn hot",
    this.largeBanner,
    this.banners = const [],
  }) {
    // smallImageUrls = List.generate(10, (index) => smallBannerUrl);
    smallImageUrls = banners.map((e) => e.yoastHeadJson?.ogImage?.first.url).whereType<String>().toList();
    // this.banners = banners;
  }

  factory BoxBannerMktViewModel.fullBanner({
    List<GtdBannerRs> banners = const [],
  }) {
    final model = BoxBannerMktViewModel();
    return model;
  }

  Uri? getWebURL(String urlStr) {
    final uri = Uri.tryParse(urlStr);
    uri?.queryParameters["layout"] = "SINGLE";
    return uri;
  }
}

extension GtdBannerRsHelper on GtdBannerRs {
  Uri? getWebURL(String urlStr) {
    final uri = Uri.tryParse(urlStr);
    if (uri == null) {
      return uri;
    }
    HashMap<String, String> queries = HashMap.from(uri.queryParameters);
    // queries.addAll({"layout": "SINGLE"});
    queries["layout"] = "SINGLE";
    // uri.queryParameters.addAll(queries);
    final newUri = Uri.https(uri.host, uri.path, queries);
    return newUri;
  }

  String? get imageUrl => yoastHeadJson?.ogImage?.first.url;
  String? get bannerUrl => getWebURL(acf?.linkBanner ?? "").toString();
  String get bannerTitle => yoastHeadJson?.title ?? "Banner";

  GtdBannerProductType get bannerType {
    final uri = Uri.tryParse(bannerUrl ?? "");
    if (uri == null) {
      return GtdBannerProductType.banner;
    }
    final firstPath = uri.pathSegments.firstOrNull;
    return GtdBannerProductType.findByValue(firstPath ?? "'");
  }
}
