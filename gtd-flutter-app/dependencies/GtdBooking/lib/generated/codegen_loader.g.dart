// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "global": {
    "setting": "Setting",
    "homepage": "Home",
    "myBooking": "My Booking",
    "promotions": "Promotions",
    "account": "Account",
    "bookFlight": "Book Flight",
    "bookHotel": "Đặt khách sạn",
    "search": "Tìm kiếm",
    "next": "Tiếp tục",
    "cancel": "Hủy",
    "delete": "Xóa",
    "confirm": "Xác nhận",
    "saveChange": "Lưu thay đổi",
    "currentAppVersion": "Phiên bản hiện tại {}",
    "generalErrorMessage": "Đã xảy ra lỗi, vui lòng thử lại!",
    "male": "Nam",
    "female": "Nữ",
    "enter": "Nhập",
    "close": "Đóng"
  },
  "setting": {
    "themeSetting": "Theme setting",
    "themeMode": "Theme mode",
    "template": "Template",
    "swapColors": "Swap colors",
    "persistenceSetting": "Persistence",
    "persistenceDescriptionSetting": "You can use volatile memory or Shared Preferences and Hive to persist the settings. You can toggle the used implementation dynamically in the app.",
    "language": "Language"
  },
  "flight": {
    "ROUNDTRIP": "Khứ hồi",
    "ONEWAY": "Một chiều",
    "flightDirection": {
      "departure": "Chuyến đi",
      "return": "Chuyến về",
      "departure_ssr": "Hành lý chuyến đi",
      "return_ssr": "Hành lý chuyến về"
    },
    "formSearch": {
      "departure": "Nơi đi/Sân bay",
      "destination": "Nơi đến/Sân bay",
      "roundTripTicket": "Vé khứ hồi",
      "departureDate": "Ngày đi",
      "chooseDepartureDate": "Chọn ngày đi",
      "chooseReturnDateDate": "Chọn ngày về",
      "returnDate": "Ngày về",
      "adult": "Người lớn",
      "over17": "Trên 17 tuổi",
      "child": "Trẻ em",
      "from12to17": "Từ 2 đến 17 tuổi",
      "infant": "Em bé",
      "under2": "Dưới 2 tuổi",
      "btnSearch": "Tìm vé máy bay",
      "gtdSupplier": "<div style='text-align: center'>Vé máy bay cung cấp bởi <span style='color: #121826'>Gotadi</span> <br> Thông tin vé máy bay vui lòng liên hệ 1900-9002</div>",
      "recentSearch": "Tìm kiếm gần đây",
      "popularSearch": "Địa điểm phổ biến",
      "vietNam": "Việt Nam",
      "choose": {
        "departure": "Chọn nơi đi",
        "destination": "Chọn nơi đến"
      }
    },
    "searchResult": {
      "departure": "Chuyến bay đi",
      "return": "Chuyến bay về"
    },
    "item": {
      "cabinClassName": {
        "ECONOMY": "Phổ thông",
        "PREMIUM": "Phổ thông đặc biệt",
        "PROMO": "Khuyến mãi",
        "BUSINESS": "Thương gia"
      }
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
  },
  "bookingResult": {
    "flight": {
      "title": "Chi tiết chuyến bay"
    }
  },
  "account": {
    "logInOrSignUp": "Đăng nhập/đăng ký",
    "logInDescription": "Rất nhiều ưu đãi đang chờ đón bạn!",
    "memberBenefit": "Quyền lợi thành viên",
    "savedPassengers": "Hành khách đã lưu",
    "savedBusiness": "Doanh nghiệp đã lưu",
    "yourBooking": "Đặt chỗ của bạn",
    "notification": "Thông báo",
    "receiptHistory": "Lịch sử xuất hóa đơn",
    "support": "Hỗ trợ",
    "contactAndFeedback": "Liên hệ - góp ý",
    "settingsAndGeneralInfo": "Settings & general info",
    "logOut": "Đăng xuất",
    "logOutConfirmMessage": "Bạn thật sự muốn đăng xuất?",
    "logIn": "Đăng nhập",
    "logInPageMessage": "Nhiều ưu đãi hấp dẫn và giúp bạn thao tác nhanh chóng hơn!",
    "phoneOrEmail": "Điện thoại/Email",
    "phoneOrEmailHint": "Nhập số điện thoại hoặc email",
    "phoneOrEmailError": {
      "required": "Bắt buộc nhập",
      "invalid": "Số điện thoại/Email không hợp lệ",
      "emailInvalid": "Email không hợp lệ",
      "phoneInvalid": "Số điện thoại không hợp lệ"
    },
    "password": "Mật khẩu",
    "passwordError": {
      "required": "Bắt buộc nhập",
      "invalid": "Mật khẩu không hợp lệ",
      "notMatched": "Mật khẩu không trùng khớp"
    },
    "forgotPassword": "Quên mật khẩu",
    "orLogInWith": "hoặc đăng nhập với",
    "noAccountMessage": {
      "noAccount": "Bạn chưa có tài khoản, ",
      "signUpNow": "đăng ký ngay!"
    },
    "termsAndConditionsMessage": {
      "first": "Việc sử dụng ứng dụng gotadi đồng nghĩa với việc bạn đồng ý với các ",
      "termsAndConditions": "Điều khoản & Chính sách sử dụng",
      "second": " của Gotadi. Xem ",
      "details": "chi tiết",
      "last": " để nắm rõ quyền lợi của mình"
    },
    "membershipClass": "Hạng {}",
    "registerTitle": "Đăng ký thành viên",
    "phoneNumber": "Số điện thoại",
    "confirmPassword": "Xác nhận lại mật khẩu",
    "register": {
      "description": {
        "first": "Đăng ký tài khoản ",
        "byEmail": "bằng Email",
        "byPhoneNumber": "bằng số điện thoại",
        "second": " của bạn.\nRất nhiều ưu đãi hấp dẫn đang đón chờ!"
      },
      "lastName": "Họ",
      "yourLastName": "Họ của bạn",
      "yourFirstName": "Tên đệm & tên",
      "termsAndConditionsMessage": {
        "first": "Việc tạo tại khoản, tôi đồng ý & chấp nhận với các ",
        "termsAndConditions": "Điều khoản & Chính sách sử dụng",
        "second": " của Gotadi."
      },
      "haveAccountMessage": {
        "isMember": "Bạn là thành viên, ",
        "logInNow": "đăng nhập ngay!"
      },
      "success": {
        "title": "Đã gửi thông tin kích hoạt",
        "first": "Chúng tôi đã gửi đến địa chỉ Email ",
        "second": " một liên kết để kích hoạt tài khoản của bạn.\nVui lòng kiểm tra hộp thư, nếu không nhận được email, vui lòng kiểm tra thư mục spam"
      }
    },
    "registerText": "Đăng ký",
    "quickSupport": "Hỗ trợ nhanh",
    "supportMethods": {
      "phone": "Hỗ trợ qua Hotline 1900-9002",
      "zalo": "Hỗ trợ qua Zalo gotadi ",
      "facebook": "Hỗ trợ qua Facebook"
    },
    "contactFeedbackContent": {
      "supportTime": "08:00 - 22:00 Thứ hai - Thứ bảy",
      "supportTimeContent": "Có hỗ trợ ngoài giờ, CN & Ngày lễ",
      "support247": "Hỗ trợ 24/7",
      "hotline1": "Hotline 1: 1900-9002",
      "hotline2": "Hotline 2: 028 62 857 857",
      "hcmOffice": "Văn phòng Hồ Chí Minh",
      "hcmOfficeInfo": "194 Nguyễn Thị Minh Khai, P. Võ Thị Sáu, Q3\nĐiện thoại: (+84) 28 62 850 850\nFax: (+84) 28 62 580 555\nEmail: lienhe@gotadi.com",
      "hnOffice": "Văn phòng Hà Nội",
      "hnOfficeInfo": "47 Phan Chu Trinh, Q. Hoàn Kiếm\nĐiện thoại: (+84) 24 71 069 069\nFax: (+84) 24 37 333 337\nEmail: sales.han@gotadi.com"
    },
    "settingsPage": {
      "aboutGotadi": "About Gotadi",
      "termsAndConditions": "Terms and Conditions",
      "rateGotadi": "Rate Gotadi",
      "changePassword": "Change password",
      "currentPassword": "Mật khẩu hiện tại",
      "newPassword": "Mật khẩu mới",
      "selectLanguage": "Select language",
      "biometricLogIn": "Log in with Face ID / Touch ID",
      "vi": "Tiếng Việt",
      "en": "English",
      "sharePasswordWarning": "Vui lòng không chia sẻ mật khẩu của bạn với người khác."
    },
    "yourAccountInfo": "Hồ sơ của bạn",
    "accountEditPage": {
      "changeAvatar": "Thay ảnh",
      "yourInfo": "Thông tin của bạn",
      "dateOfBirth": "Ngày tháng năm sinh",
      "nationality": "Quốc tịch",
      "paperworkInfo": "Thông tin giấy tờ",
      "passportInfo": "Thông tin passport",
      "passportCountry": "Quốc gia cấp",
      "passportExpireDate": "Ngày hết hạn",
      "memberAccount": "Tài khoản khách hàng thân thiết",
      "chooseAccountType": "Chọn loại tài khoản",
      "inputAccountNumber": "Nhập số thẻ thành viên",
      "deleteAccount": {
        "title": "Xóa tài khoản",
        "message": "Lưu ý rằng việc xoá tài khoản sẽ đồng thời xoá các thông tin của bạn với tài khoản này. Bạn sẽ không thể khôi phục lại được.",
        "confirmMessage": "Bạn có chắc muốn xoá tài khoản?",
        "confirm": "Đồng ý, xoá"
      }
    }
  },
  "hotel": {
    "cancelPenalties": {
      "policies": "Hoàn/Huỷ theo chính sách",
      "free": "Miễn phí hoàn huỷ",
      "title": "Thông tin hủy phòng",
      "description": "(Thời gian được tính theo địa phương của Khách sạn)",
      "cancelRoomDate": "• Hủy phòng từ {} đến {}",
      "noShow": "• Không đến nhận phòng",
      "losePercent": "Mất {} phí",
      "loseAmount": "Mất {}",
      "loseAll": "Mất 100% phí"
    }
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
    "next": "Tiếp tục",
    "cancel": "Hủy",
    "delete": "Xóa",
    "confirm": "Xác nhận",
    "saveChange": "Lưu thay đổi",
    "currentAppVersion": "Phiên bản hiện tại {}",
    "generalErrorMessage": "Đã xảy ra lỗi, vui lòng thử lại!",
    "male": "Nam",
    "female": "Nữ",
    "enter": "Nhập",
    "close": "Đóng"
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
    "flightDirection": {
      "departure": "Chuyến đi",
      "return": "Chuyến về",
      "departure_ssr": "Hành lý chuyến đi",
      "return_ssr": "Hành lý chuyến về"
    },
    "passengers": {
      "DEPARTURE": "Hành khách chuyến đi",
      "RETURN": "Hành khách chuyến về"
    },
    "formSearch": {
      "departure": "Nơi đi/Sân bay",
      "destination": "Nơi đến/Sân bay",
      "roundTripTicket": "Vé khứ hồi",
      "departureDate": "Ngày đi",
      "chooseDepartureDate": "Chọn ngày đi",
      "chooseReturnDateDate": "Chọn ngày về",
      "returnDate": "Ngày về",
      "adult": "Người lớn",
      "over17": "Trên 17 tuổi",
      "child": "Trẻ em",
      "from12to17": "Từ 2 đến 17 tuổi",
      "infant": "Em bé",
      "under2": "Dưới 2 tuổi",
      "btnSearch": "Tìm vé máy bay",
      "cancel": "Huỷ tìm kiếm",
      "gtdSupplier": "<div style='text-align: center'>Vé máy bay cung cấp bởi <span style='color: #121826'>Gotadi</span> <br> Thông tin vé máy bay vui lòng liên hệ 1900-9002</div>",
      "recentSearch": "Tìm kiếm gần đây",
      "popularSearch": "Địa điểm phổ biến",
      "vietNam": "Việt Nam",
      "choose": {
        "departure": "Chọn nơi đi",
        "destination": "Chọn nơi đến"
      }
    },
    "searchResult": {
      "departure": "Chuyến bay đi",
      "return": "Chuyến bay về"
    },
    "item": {
      "cabinClassName": {
        "ECONOMY": "Phổ thông",
        "PREMIUM": "Phổ thông đặc biệt",
        "PROMO": "Khuyến mãi",
        "BUSINESS": "Thương gia"
      }
    },
    "filter": {
      "departureDateAsc": "Sớm nhất",
      "departureDateDesc": "Muộn nhất",
      "priceAsc": "Giá thấp",
      "priceDesc": "Giá cao",
      "durationAsc": "Ngắn nhất",
      "durationDesc": "Dài nhất",
      "filterOptions": "Bộ lọc",
      "airline": "Hãng hàng không",
      "cabin": "Hạng vé",
      "departureDateTime": "Khung giờ khởi hành",
      "arrivalDateTime": "Khung giờ hạ cánh",
      "filterName": {
        "time_6": "00:00 - 06:00",
        "time_612": "06:00 - 12:00",
        "time_1218": "12:00 - 18:00",
        "time_18": "18:00 - 24:00",
        "economy": "Phổ thông",
        "premium": "Phổ thông đặc biệt",
        "promo": "Khuyến mãi",
        "business": "Thương gia"
      }
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
  },
  "bookingResult": {
    "flight": {
      "title": "Chi tiết chuyến bay",
      "DEPARTURE": "Chuyến đi",
      "RETURN": "Chuyến về",
      "pnr": "Mã đặt chỗ (PNR)"
    }
  },
  "myBooking": {
    "title": "",
    "flightTitle": "Quản lý vé máy bay",
    "bookingStatus": {
      "AIR": {
        "EXPIRED": "Hết Hiệu Lực",
        "SUCCEEDED": "Giao dịch thành công",
        "PAYMENT_FAILED": "Giao dịch thất bại",
        "FAILED": "Thất bại",
        "PAYMENT_REFUNDED": "Hủy đặt chỗ & Hoàn tiền",
        "CANCELLED": "Đã hủy",
        "PENDING": "Chưa thực hiện đặt vé",
        "BOOKED": "Giao dịch chờ thanh toán",
        "TICKED_ON_PROCESS": "Đang chờ xử lý",
        "PAYMENT_SUCCESS_COMMIT_FAILED": "Xuất vé lỗi"
      },
      "HOTEL": {
        "EXPIRED": "Hết Hiệu Lực",
        "SUCCEEDED": "Giao dịch thành công",
        "PAYMENT_FAILED": "Giao dịch thất bại",
        "FAILED": "Thất bại",
        "PAYMENT_REFUNDED": "Hủy đặt chỗ & Hoàn tiền",
        "CANCELLED": "Đã hủy",
        "PENDING": "Chưa thực hiện đặt vé",
        "BOOKED": "Giao dịch chờ thanh toán",
        "TICKED_ON_PROCESS": "Đang chờ xử lý",
        "PAYMENT_SUCCESS_COMMIT_FAILED": "Xuất phòng lỗi"
      },
      "COMBO": {
        "EXPIRED": "Hết Hiệu Lực",
        "SUCCEEDED": "Giao dịch thành công",
        "PAYMENT_FAILED": "Giao dịch thất bại",
        "FAILED": "Thất bại",
        "PAYMENT_REFUNDED": "Hủy đặt chỗ & Hoàn tiền",
        "CANCELLED": "Đã hủy",
        "PENDING": "Chưa thực hiện đặt vé",
        "BOOKED": "Giao dịch chờ thanh toán",
        "TICKED_ON_PROCESS": "Đang chờ xử lý",
        "PAYMENT_SUCCESS_COMMIT_FAILED": "Xuất phòng lỗi"
      },
      "TOUR": {
        "EXPIRED": "Hết Hiệu Lực",
        "SUCCEEDED": "Giao dịch thành công",
        "PAYMENT_FAILED": "Giao dịch thất bại",
        "FAILED": "Thất bại",
        "PAYMENT_REFUNDED": "Hủy đặt chỗ & Hoàn tiền",
        "CANCELLED": "Đã hủy",
        "BOOKED": "Giao dịch chờ thanh toán",
        "BOOKING_ACCEPTED": "Giao dịch được tiếp nhận",
        "BOOKING_PROCESSED": "Đang chờ xử lý",
        "BOOKING_PAYLATER": "Giữ chỗ, chờ thanh toán"
      }
    }
  },
  "traveler": {
    "ADT": "Người lớn",
    "CHD": "Trẻ em",
    "INF": "Em bé",
    "gender": "Giới tính",
    "MALE": "Nam",
    "FEMALE": "Nữ",
    "BOY": "Nam",
    "GIRL": "Nữ"
  },
  "account": {
    "logInOrSignUp": "Đăng nhập/đăng ký",
    "logInDescription": "Rất nhiều ưu đãi đang chờ đón bạn!",
    "memberBenefit": "Quyền lợi thành viên",
    "savedPassengers": "Hành khách đã lưu",
    "savedBusiness": "Doanh nghiệp đã lưu",
    "yourBooking": "Đặt chỗ của bạn",
    "notification": "Thông báo",
    "receiptHistory": "Lịch sử xuất hóa đơn",
    "support": "Hỗ trợ",
    "contactAndFeedback": "Liên hệ - góp ý",
    "settingsAndGeneralInfo": "Cài đặt & thông tin chung",
    "logOut": "Đăng xuất",
    "logOutConfirmMessage": "Bạn thật sự muốn đăng xuất?",
    "logIn": "Đăng nhập",
    "logInPageMessage": "Nhiều ưu đãi hấp dẫn và giúp bạn thao tác nhanh chóng hơn!",
    "phoneOrEmail": "Điện thoại/Email",
    "phoneOrEmailHint": "Nhập số điện thoại hoặc email",
    "phoneOrEmailError": {
      "required": "Bắt buộc nhập",
      "invalid": "Số điện thoại/Email không hợp lệ",
      "emailInvalid": "Email không hợp lệ",
      "phoneInvalid": "Số điện thoại không hợp lệ"
    },
    "password": "Mật khẩu",
    "passwordError": {
      "required": "Bắt buộc nhập",
      "invalid": "Mật khẩu không hợp lệ",
      "notMatched": "Mật khẩu không trùng khớp"
    },
    "forgotPassword": "Quên mật khẩu",
    "orLogInWith": "hoặc đăng nhập với",
    "noAccountMessage": {
      "noAccount": "Bạn chưa có tài khoản, ",
      "signUpNow": "đăng ký ngay!"
    },
    "termsAndConditionsMessage": {
      "first": "Việc sử dụng ứng dụng gotadi đồng nghĩa với việc bạn đồng ý với các ",
      "termsAndConditions": "Điều khoản & Chính sách sử dụng",
      "second": " của Gotadi. Xem ",
      "details": "chi tiết",
      "last": " để nắm rõ quyền lợi của mình"
    },
    "membershipClass": "Hạng {}",
    "registerTitle": "Đăng ký thành viên",
    "phoneNumber": "Số điện thoại",
    "confirmPassword": "Xác nhận lại mật khẩu",
    "register": {
      "description": {
        "first": "Đăng ký tài khoản ",
        "byEmail": "bằng Email",
        "byPhoneNumber": "bằng số điện thoại",
        "second": " của bạn.\nRất nhiều ưu đãi hấp dẫn đang đón chờ!"
      },
      "lastName": "Họ",
      "yourLastName": "Họ của bạn",
      "yourFirstName": "Tên đệm & tên",
      "termsAndConditionsMessage": {
        "first": "Việc tạo tại khoản, tôi đồng ý & chấp nhận với các ",
        "termsAndConditions": "Điều khoản & Chính sách sử dụng",
        "second": " của Gotadi."
      },
      "haveAccountMessage": {
        "isMember": "Bạn là thành viên, ",
        "logInNow": "đăng nhập ngay!"
      },
      "success": {
        "title": "Đã gửi thông tin kích hoạt",
        "first": "Chúng tôi đã gửi đến địa chỉ Email ",
        "second": " một liên kết để kích hoạt tài khoản của bạn.\nVui lòng kiểm tra hộp thư, nếu không nhận được email, vui lòng kiểm tra thư mục spam"
      }
    },
    "registerText": "Đăng ký",
    "quickSupport": "Hỗ trợ nhanh",
    "supportMethods": {
      "phone": "Hỗ trợ qua Hotline 1900-9002",
      "zalo": "Hỗ trợ qua Zalo gotadi ",
      "facebook": "Hỗ trợ qua Facebook"
    },
    "contactFeedbackContent": {
      "supportTime": "08:00 - 22:00 Thứ hai - Thứ bảy",
      "supportTimeContent": "Có hỗ trợ ngoài giờ, CN & Ngày lễ",
      "support247": "Hỗ trợ 24/7",
      "hotline1": "Hotline 1: 1900-9002",
      "hotline2": "Hotline 2: 028 62 857 857",
      "hcmOffice": "Văn phòng Hồ Chí Minh",
      "hcmOfficeInfo": "194 Nguyễn Thị Minh Khai, P. Võ Thị Sáu, Q3\nĐiện thoại: (+84) 28 62 850 850\nFax: (+84) 28 62 580 555\nEmail: lienhe@gotadi.com",
      "hnOffice": "Văn phòng Hà Nội",
      "hnOfficeInfo": "47 Phan Chu Trinh, Q. Hoàn Kiếm\nĐiện thoại: (+84) 24 71 069 069\nFax: (+84) 24 37 333 337\nEmail: sales.han@gotadi.com"
    },
    "settingsPage": {
      "aboutGotadi": "Về Gotadi",
      "termsAndConditions": "Điều kiện và chính sách sử dụng",
      "rateGotadi": "Đánh giá Gotadi",
      "changePassword": "Thay đổi mật khấu",
      "currentPassword": "Mật khẩu hiện tại",
      "newPassword": "Mật khẩu mới",
      "selectLanguage": "Chọn ngôn ngữ",
      "biometricLogIn": "Đăng nhập bằng Face ID / Touch ID",
      "vi": "Tiếng Việt",
      "en": "English",
      "sharePasswordWarning": "Vui lòng không chia sẻ mật khẩu của bạn với người khác."
    },
    "yourAccountInfo": "Hồ sơ của bạn",
    "accountEditPage": {
      "changeAvatar": "Thay ảnh",
      "yourInfo": "Thông tin của bạn",
      "dateOfBirth": "Ngày tháng năm sinh",
      "nationality": "Quốc tịch",
      "paperworkInfo": "Thông tin giấy tờ",
      "passportInfo": "Thông tin passport",
      "passportCountry": "Quốc gia cấp",
      "passportExpireDate": "Ngày hết hạn",
      "memberAccount": "Tài khoản khách hàng thân thiết",
      "chooseAccountType": "Chọn loại tài khoản",
      "inputAccountNumber": "Nhập số thẻ thành viên",
      "deleteAccount": {
        "title": "Xóa tài khoản",
        "message": "Lưu ý rằng việc xoá tài khoản sẽ đồng thời xoá các thông tin của bạn với tài khoản này. Bạn sẽ không thể khôi phục lại được.",
        "confirmMessage": "Bạn có chắc muốn xoá tài khoản?",
        "confirm": "Đồng ý, xoá"
      }
    }
  },
  "hotel": {
    "cancelPenalties": {
      "policies": "Hoàn/Huỷ theo chính sách",
      "free": "Miễn phí hoàn huỷ",
      "title": "Thông tin hủy phòng",
      "description": "(Thời gian được tính theo địa phương của Khách sạn)",
      "cancelRoomDate": "• Hủy phòng từ {} đến {}",
      "noShow": "• Không đến nhận phòng",
      "losePercent": "Mất {} phí",
      "loseAmount": "Mất {}",
      "loseAll": "Mất 100% phí"
    }
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "vi": vi};
}
