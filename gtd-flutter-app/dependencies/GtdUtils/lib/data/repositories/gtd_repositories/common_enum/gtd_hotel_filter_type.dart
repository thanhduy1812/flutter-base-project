class ClassName {}

enum FilterRequestType { single, array, range }

enum GtdHotelFilterType {
  prices("filterFromPrice,filterToPrice", FilterRequestType.range),
  guestRatings("filterFromGuestRating,filterToGuestRating", FilterRequestType.range),
  propertyRatings("filterFromStarRating,filterToStarRating", FilterRequestType.range),
  propertyAmenities("filterAmenities", FilterRequestType.array),
  rateAmenities("filterRateAmenities", FilterRequestType.array),
  propertyCategories("filterHotelCategories", FilterRequestType.array),
  roomAmenities("filterRoomAmenities", FilterRequestType.array),
  roomViews("filterRoomViews", FilterRequestType.array),
  themes("filterThemes", FilterRequestType.array),
  mealPlans("filterMealPlans", FilterRequestType.array),
  bedTypes("filterBedTypes", FilterRequestType.array),
  propertyDistance("filterFromDistance,filterToDistance", FilterRequestType.range),
  offerOptions("filterOfferOptions", FilterRequestType.single);

  final String requestKey;
  final FilterRequestType requestType;
  const GtdHotelFilterType(this.requestKey, this.requestType);

  String get title {
    switch (this) {
      case GtdHotelFilterType.prices:
        return "Theo khoảng giá (VND) / 1 phòng / 1 đêm";
      case GtdHotelFilterType.guestRatings:
        return "Đánh giá của khách";
      case GtdHotelFilterType.propertyRatings:
        return "Tìm theo hạng sao";
      case GtdHotelFilterType.propertyAmenities:
        return "Tiện nghi khách sạn";
      case GtdHotelFilterType.rateAmenities:
        return "Phòng bao gồm";
      case GtdHotelFilterType.propertyCategories:
        return "Loại hình cư trú";
      case GtdHotelFilterType.roomAmenities:
        return "Tiện nghi phòng";
      case GtdHotelFilterType.roomViews:
        return "Quang cảnh";
      case GtdHotelFilterType.bedTypes:
        return "Loại giường";
      case GtdHotelFilterType.propertyDistance:
        return "Tìm theo khoảng cách";
      case GtdHotelFilterType.offerOptions:
        return "Quy định đặt phòng";
      default:
        return "";
    }
  }

  static List<GtdHotelFilterType> listHotelFilterSorted() => [
        propertyRatings,
        prices,
        guestRatings,
        propertyAmenities,
        rateAmenities,
        roomAmenities,
        roomViews,
        bedTypes,
        propertyDistance,
        offerOptions
      ];
}
