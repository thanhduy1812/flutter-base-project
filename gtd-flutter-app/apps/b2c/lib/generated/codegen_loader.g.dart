// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "global": {
    "setting": "Setting",
    "homepage": "Home",
    "myBooking": "My Booking",
    "promotions": "Promotions",
    "account": "Account"
  },
  "setting": {
    "themeSetting": "Theme setting",
    "themeMode": "Theme mode",
    "template": "Template",
    "swapColors": "Swap colors",
    "persistenceSetting": "Persistence",
    "persistenceDescriptionSetting": "You can use volatile memory or Shared Preferences and Hive to persist the settings. You can toggle the used implementation dynamically in the app.",
    "language": "Language"
  }
};
static const Map<String,dynamic> vi = {
  "global": {
    "setting": "Cài đặt",
    "homepage": "Trang chủ",
    "myBooking": "Đặt chỗ",
    "promotions": "Ưu đãi",
    "account": "Tài khoản",
    "bookFlight": "Đặt vé máy bay",
    "bookHotel": "Đặt khách sạn",
    "search": "Tìm kiếm",
    "next": "Tiếp tục"
  },
  "setting": {
    "themeSetting": "Cài đặt giao diện",
    "themeMode": "Chế độ",
    "template": "Phong cách giao diện",
    "swapColors": "Đổi màu",
    "persistenceSetting": "Lưu trữ",
    "persistenceDescriptionSetting": "Bạn có thể sử dụng Memory để lưu trữ dữ liệu tạm thời hoặc Hive & Shared Persistences để ghi nhớ dữ liệu lâu dài",
    "language": "Ngôn ngữ"
  },
  "flight": {
    "ROUNDTRIP": "Khứ hồi",
    "ONEWAY": "Một chiều",
    "formSearch": {
      "departure": "Nơi đi",
      "destination": "Nơi đến",
      "departureDate": "Ngày đi",
      "returnDate": "Ngày về",
      "adult": "Người lớn",
      "child": "Trẻ em (2 - 12 tuổi)",
      "infant": "Em bé (dưới 2 tuổi)",
      "btnSearch": "Tìm kiếm chuyến bay",
      "gtdSupplier": "<div style='text-align: center'>Vé máy bay cung cấp bởi <span style='color: #121826'>Gotadi</span> <br> Thông tin vé máy bay vui lòng liên hệ 1900-9002</div>",
      "recentSearch": "Chuyến bay gần nhất",
      "choose": {
        "departure": "Chọn điểm đi",
        "destination": "Chọn điểm đến"
      }
    },
    "searchResult": {
      "departure": "Chuyến bay đi",
      "return": "Chuyến bay về"
    }
  },
  "checkout": {
    "travellerInfo": "Thông tin khách hàng",
    "flightInfo": "Thông tin chuyến bay",
    "gender": "Giới tính",
    "dob": "Ngày sinh",
    "setContactInfo": "Đặt làm thông tin liên hệ",
    "baggageDeparture": "Hành lý chuyến đi",
    "baggageReturn": "Hành lý chuyến về",
    "totalAmount": "Tổng tiền"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "vi": vi};
}
