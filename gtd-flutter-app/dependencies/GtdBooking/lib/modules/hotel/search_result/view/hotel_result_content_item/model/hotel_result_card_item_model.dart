import 'package:gtd_utils/base/view/gtd_flutter_map/gtd_map_point.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/dto/gtd_hotel_item_dto.dart';

class HotelResultCardItemModel {
  List<String> hotelImages = Iterable<int>.generate(10)
      .map((e) =>
          "https://s3-ap-southeast-1.amazonaws.com/resources.axisrooms/extranet/gotadi/static/staging/staging/staging/hotels/3655/f.jpg")
      .toList();
  String hotelName = "Biệt thự & Khu nghỉ dưỡng The Five";
  String hotelType = "Biệt thự nghỉ dưỡng";
  String hotelAddress = "Lac Long Quan, Dien Ngoc, Dien Ban, Quang Nam...";
  double ratingValue = 3.5;
  List<String> hotelAttachments = [
    "Bao gồm bữa sáng",
    "Huỷ miễn phí",
    "Ở miễn phí",
    "Không hút thuốc",
    "Không đi chơi đêm"
  ];
  List<String> hotelAmentites = [
    "Wifi free",
    "Spa xông hơi",
    "Xe đưa đón",
    "Massage tận nơi",
    "Đồ nhậu tận răng"
  ];
  bool isEmptyRoom = false;
  String hotelRoomNumberWarning = "Chỉ còn X phòng";
  double netAmount = 123456;
  double totalAmount = 123456;
  double baseAmount = 123456;
  bool hasPromo = false;
  GtdMapPoint? mapPoint;
  String propertyId = "";
  String supplier = "";
  int roomCount = 1;
  String? availableType;

  HotelResultCardItemModel();

  factory HotelResultCardItemModel.fromHotelItemDTO(
      GtdHotelItemDTO hotelItemDTO) {

    HotelResultCardItemModel hotelResultCardItemModel =
        HotelResultCardItemModel()
          ..hotelName = hotelItemDTO.hotelName
          ..hotelAddress = hotelItemDTO.address?.lineOne ?? ""
          ..hotelType = hotelItemDTO.hotelType
          ..ratingValue = hotelItemDTO.rating
          ..hotelAmentites = hotelItemDTO.amenities
              .map((e) => e.name)
              .whereType<String>()
              .toList()
          ..hotelAttachments = hotelItemDTO.additionAmenities
          ..hotelImages = hotelItemDTO.hotelUrlImgs
          ..netAmount = (hotelItemDTO.totalPrice ?? 0)
          ..totalAmount = (hotelItemDTO.basePriceBeforePromo ?? 0)
          ..baseAmount = (hotelItemDTO.basePrice ?? 0)
          ..hasPromo = hotelItemDTO.hasPromo
          ..isEmptyRoom = hotelItemDTO.totalRooms == 0
          ..roomCount = hotelItemDTO.totalRooms
          ..mapPoint =
              (hotelItemDTO.latitude != null && hotelItemDTO.longitude != null)
                  ? GtdMapPoint(
                      latitude: hotelItemDTO.latitude!,
                      longitude: hotelItemDTO.longitude!)
                  : null
          ..hotelRoomNumberWarning = "Chỉ còn ${hotelItemDTO.totalRooms} phòng"
          ..propertyId = hotelItemDTO.propertyId
          ..availableType = hotelItemDTO.availableType
          ..supplier = hotelItemDTO.supplier;
    return hotelResultCardItemModel;
  }

  bool get available => availableType == 'AVAILABLE';

  String discountPercent() {
    if (!hasPromo) return '';
    final discountAmount = totalAmount - baseAmount;
    final percentage = ((discountAmount / totalAmount) * 100).round();

    return '-$percentage%';
  }
}
