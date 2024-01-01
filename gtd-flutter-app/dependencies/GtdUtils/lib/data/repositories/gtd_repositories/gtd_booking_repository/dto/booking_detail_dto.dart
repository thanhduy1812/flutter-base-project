import 'package:collection/collection.dart';

import 'package:gtd_utils/data/repositories/gtd_api_client/air_tickets_resource/air_tickets_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/hotel_resource/models/json_models/hotel_product.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/booking_resource/models/response/booking_detail_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/booking_resource/models/response/search_booking_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_final_booking_status.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/payment_method_type.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/gtd_flight_repository_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_item.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_flight_repository/models/gtd_flight_search_result_dto.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_hotel_repository/models/gt_hotel_room_detail_dto.dart';

class BookingDetailDTO {
  BookingDetailDTO(
      {this.status,
      this.bookingNumber,
      this.bookingCode,
      this.supplierType,
      this.bookingType,
      this.bookingDate,
      this.roundType,
      this.flightDetailItems,
      this.paymentInfo});
  String? status;
  String? bookingNumber;
  String? bookingCode;
  String? supplierType;
  String? bookingType;
  DateTime? bookingDate;
  BookingFinalStatus? bookingFinalStatus;
  String? roundType;
  List<GtdFlightItemDetail>? flightDetailItems;
  HotelProductDetail? hotelProductDetail;

  // AddBookingTravellerRq? addBookingTravellerRq;
  GtdDisplayPaymentInfo? paymentInfo;
  GtdInvoiceBookingInfo? invoiceBookingInfo;
  GtdContactBookingInfo? contactBookingInfo;

  double get tempAmount {
    double tempAmount = paymentInfo?.totalFare ?? 0;
    return tempAmount;
  }

  bool get isOneWay => roundType == "OneWay";
  bool get isRoundTrip => roundType == "Roundtrip";
  bool get isInternational => bookingType == "INTE";
  bool get hasInsurance => (flightDetailItems ?? [])
      .map((e) => (e.travelersInfo ?? []))
      .flattened
      .map((e) => (e.serviceRequests ?? []))
      .flattened
      .where((e) => e.serviceType?.toUpperCase() == ServiceType.insurance.name)
      .toList()
      .isNotEmpty;
}

class GtdFlightItemDetail {
  final FlightDirection flightDirection;
  final GtdFlightItem flightItem;
  final TransactionInfo? transactionInfo;
  final List<AirTraveler>? airTravelersInfo;
  final List<TravelerInfoElement>? travelersInfo;
  const GtdFlightItemDetail(
      {required this.flightDirection,
      required this.flightItem,
      this.transactionInfo,
      this.travelersInfo,
      this.airTravelersInfo});

  String get inineraryCodeTitle {
    String inineraryCodeTitle =
        "${flightItem.flightItemInfo?.originLocation?.locationCode} - ${flightItem.flightItemInfo?.destinationLocation?.locationCode}";
    return inineraryCodeTitle;
  }

  String get inineraryCityTitle {
    String inineraryCodeTitle =
        "${flightItem.flightItemInfo?.originLocation?.city} - ${flightItem.flightItemInfo?.destinationLocation?.city}";
    return inineraryCodeTitle;
  }

  int get countAdult => (travelersInfo ?? []).where((e) => e.adultType == FlightAdultType.adult.value).toList().length;
  int get countChild => (travelersInfo ?? []).where((e) => e.adultType == FlightAdultType.child.value).toList().length;
  int get countInfant =>
      (travelersInfo ?? []).where((e) => e.adultType == FlightAdultType.infant.value).toList().length;
  String get inineraryPassengerTitle {
    String result = "";
    result += countAdult > 0 ? "$countAdult người lớn" : "";
    result += countChild > 0 ? ", $countChild trẻ em" : "";
    result += countInfant > 0 ? ", $countInfant em bé" : "";
    return result;
  }

  String get flightDirectionTitle => flightDirection == FlightDirection.d ? "Chiều đi" : "Chiều về";
}

class HotelProductDetail {
  final HotelProduct? hotelProduct;
  final TransactionInfo? transactionInfo;
  final List<TravelerInfoElement>? travelersInfo;

  HotelProductDetail(this.hotelProduct, this.transactionInfo, this.travelersInfo);
  factory HotelProductDetail.fromBookingDetailRs(BookingDetailRs bookingDetailRs) {
    TransactionInfo? hotelTransactionInfo = bookingDetailRs.bookingInfo?.transactionInfoHotel();
    return HotelProductDetail(
        bookingDetailRs.hotelProduct
          ?..checkinDate = bookingDetailRs.bookingInfo?.departureDate
          ..checkoutDate = bookingDetailRs.bookingInfo?.returnDate,
        hotelTransactionInfo,
        bookingDetailRs.bookingInfo?.travelerInfos);
  }

  String get bookHotelPassengerInfo {
    String info = "";
    int roomCount = totalRooms;
    info += "$roomCount phòng";
    var paxPrices = hotelProduct?.rooms?.firstOrNull?.ratePlans?.firstOrNull?.paxPrice ?? [];
    int adult = paxPrices
        .map((e) => e.paxInfo?.adultQuantity ?? 0)
        .fold(0, (previousValue, element) => previousValue + element);
    info += " - $adult người lớn";
    int child = paxPrices
        .map((e) => e.paxInfo?.childQuantity ?? 0)
        .fold(0, (previousValue, element) => previousValue + element);
    if (child > 0) {
      var childAges = paxPrices.map((e) => e.paxInfo?.childAges ?? []).flattened.toList();
      info += " - $child trẻ em ($childAges)";
    }
    return info;
  }

  int get totalRooms => (hotelProduct?.rooms?.firstOrNull?.ratePlans?.firstOrNull?.paxPrice ?? []).length;
  int get totalNight =>
      hotelProduct?.rooms?.firstOrNull?.ratePlans?.firstOrNull?.paxPrice?.firstOrNull?.nightPrices?.length ?? 0;

  String get bookHotelSumaryInfo {
    String info = "";
    int roomCount = (hotelProduct?.rooms ?? []).length;
    info += "$roomCount phòng";
    var paxPrices = hotelProduct?.rooms?.firstOrNull?.ratePlans?.firstOrNull?.paxPrice ?? [];
    int adult = paxPrices
        .map((e) => e.paxInfo?.adultQuantity ?? 0)
        .fold(0, (previousValue, element) => previousValue + element);
    int child = paxPrices
        .map((e) => e.paxInfo?.childQuantity ?? 0)
        .fold(0, (previousValue, element) => previousValue + element);
    info += ", ${adult + child} khách";
    return info;
  }

  List<GtdHotelRoomDetailDTO> get litsHotelRoomDetail =>
      (hotelProduct?.rooms ?? []).map((e) => GtdHotelRoomDetailDTO.fromGtdHotelRoom(e)).toList();
}

class GtdDisplayPaymentInfo {
  double baseFare = 0;
  double equivFare = 0;
  double? vat = 0;
  double serviceTax = 0;
  double totalFare = 0;
  double totalTax = 0;
  double agencyMarkupValue = 0;
  double markupValue = 0;
  double totalSsrValue = 0;
  double? totalCombo = 0;
  double? paymentTotalAmount = 0;
  double? paymentFee = 0;
  PaymentMethodType? paymentType;
  DateTime? paymentDate;
  String? paymentRefNumber;
  GtdDisplayPaymentInfo({
    this.baseFare = 0,
    this.equivFare = 0,
    this.vat,
    this.serviceTax = 0,
    this.totalFare = 0,
    this.totalTax = 0,
    this.agencyMarkupValue = 0,
    this.markupValue = 0,
    this.totalSsrValue = 0,
    this.totalCombo,
    this.paymentTotalAmount,
    this.paymentFee,
    this.paymentType,
    this.paymentDate,
    this.paymentRefNumber,
  });

  factory GtdDisplayPaymentInfo.fromBookingInfoRs(BookingInfoElement info) {
    GtdDisplayPaymentInfo displayPriceInfo = GtdDisplayPaymentInfo(
        baseFare: info.baseFare ?? 0,
        equivFare: info.equivFare ?? 0,
        vat: info.vat,
        serviceTax: info.serviceTax ?? 0,
        totalFare: info.totalFare ?? 0,
        totalTax: info.totalTax ?? 0,
        agencyMarkupValue: info.agencyMarkupValue ?? 0,
        markupValue: info.markupValue ?? 0,
        totalSsrValue: info.totalSsrValue ?? 0,
        totalCombo: info.totalCombo,
        paymentTotalAmount: info.paymentTotalAmount,
        paymentFee: info.paymentFee,
        paymentType: PaymentMethodType.values
            .where((element) => element.code.toUpperCase() == info.paymentType?.toUpperCase())
            .firstOrNull,
        paymentDate: info.paymentDate,
        paymentRefNumber: info.paymentRefNumber);
    return displayPriceInfo;
  }

  double get totalServiceFee => markupValue + (paymentFee ?? 0);
}

class GtdInvoiceBookingInfo {
  String? customerFirstName;
  String? customerLastName;
  String? customerPhoneNumber;
  String? customerEmail;
  String? buyerName;
  String? taxCompanyName;
  String? taxAddress;
  String? taxNumber;
  bool? taxReceiptRequest;
  String? note;
  GtdInvoiceBookingInfo({
    this.customerFirstName,
    this.customerLastName,
    this.customerPhoneNumber,
    this.customerEmail,
    this.taxCompanyName,
    this.buyerName,
    this.taxAddress,
    this.taxNumber,
    this.taxReceiptRequest = false,
    this.note,
  });

  String get fullName => "$customerLastName $customerFirstName";

  factory GtdInvoiceBookingInfo.fromBookingInfoRs(BookingInfoElement info) {
    GtdInvoiceBookingInfo invoiceBookingInfo = GtdInvoiceBookingInfo(
      customerFirstName: info.customerFirstName,
      customerLastName: info.customerLastName,
      customerPhoneNumber: info.customerPhoneNumber1,
      customerEmail: info.customerEmail,
      taxCompanyName: info.taxCompanyName,
      taxAddress: info.taxAddress1,
      taxNumber: info.taxNumber,
      taxReceiptRequest: info.taxReceiptRequest,
    );
    return invoiceBookingInfo;
  }
  TaxReceiptRequest toReceiptRequest(String bookingNumber) {
    TaxReceiptRequest taxReceiptRequest = TaxReceiptRequest()
      ..bookingNumber = bookingNumber
      ..taxCompanyName = taxCompanyName
      ..taxAddress1 = taxAddress
      ..taxNumber = taxNumber
      ..taxReceiptRequest = this.taxReceiptRequest
      ..taxPersonalInfoContact = TaxPersonalInfoContact(
        name: fullName,
        fname: fullName,
        phone: customerPhoneNumber,
        email1: customerEmail,
        buyerName: buyerName,
        note: note,
      );
    return taxReceiptRequest;
  }
}

class GtdContactBookingInfo {
  String? fullName;
  String? phoneNumber;
  String? email;
  DateTime? dob;
  GtdContactBookingInfo({
    this.fullName,
    this.phoneNumber,
    this.email,
    this.dob,
  });
  factory GtdContactBookingInfo.fromTravelerInfoContactInfo(TravelerInfoContactInfo travelerInfoContactInfo) {
    GtdContactBookingInfo contactBookingInfo = GtdContactBookingInfo()
      ..fullName = "${travelerInfoContactInfo.lastName} ${travelerInfoContactInfo.firstName}"
      ..email = travelerInfoContactInfo.email
      ..phoneNumber = travelerInfoContactInfo.phoneNumber1;
    return contactBookingInfo;
  }

  factory GtdContactBookingInfo.fromBookingInfoContactInfo(BookingInfoContactInfo contactInfo) {
    GtdContactBookingInfo contactBookingInfo = GtdContactBookingInfo()
      ..fullName = "${contactInfo.surName} ${contactInfo.firstName}"
      ..email = contactInfo.email
      ..dob = contactInfo.dob
      ..phoneNumber = contactInfo.phoneNumber1;
    return contactBookingInfo;
  }
}

extension GtdBookingDetailMapper on BookingDetailDTO {
  void mappingBookingDetail(BookingDetailRs bookingDetailRs) {
    bookingDetailRs.bookingInfo?.updateStatusItemMyBooking(bookingDetailRs.bookingInfo!);
    status = (bookingDetailRs.bookingInfo?.status)!;
    supplierType = bookingDetailRs.supplierType!;
    bookingType = bookingDetailRs.bookingType!;
    roundType = (bookingDetailRs.bookingInfo?.roundType)!;
    bookingDate = (bookingDetailRs.bookingInfo?.bookingDate)!;
    flightDetailItems = generateFlightItems(bookingDetailRs);
    bookingNumber = bookingDetailRs.bookingInfo?.bookingNumber;
    bookingCode = bookingDetailRs.bookingCode;
    paymentInfo = GtdDisplayPaymentInfo.fromBookingInfoRs(bookingDetailRs.bookingInfo!);
    invoiceBookingInfo = GtdInvoiceBookingInfo.fromBookingInfoRs(bookingDetailRs.bookingInfo!);
    bookingFinalStatus = BookingFinalStatus.findByStatus(bookingDetailRs.bookingInfo?.bookingFinalStatus ?? "");
    hotelProductDetail = HotelProductDetail.fromBookingDetailRs(bookingDetailRs);
    if (bookingDetailRs.travelerInfo?.contactInfos?.firstOrNull != null) {
      contactBookingInfo =
          GtdContactBookingInfo.fromBookingInfoContactInfo(bookingDetailRs.bookingInfo!.contactInfos!.first);
    }
  }

  List<GtdFlightItemDetail> generateFlightItems(BookingDetailRs bookingDetailRs) {
    var items = FlightDirection.values
        .map((flightDirection) {
          var groupPricedItinerary = bookingDetailRs.groupPricedItineraryDirection(flightDirection);
          return (flightDirection, groupPricedItinerary);
        })
        .whereType<(FlightDirection, GroupPricedItinerary)>()
        .map((tuple) {
          GtdFlightItem item = GtdFlightItem.fromGroupPricedItinerary(tuple.$2, tuple.$1);
          TransactionInfo? transactionInfo = bookingDetailRs.bookingInfo?.transactionInfoFlight(tuple.$1);
          GtdFlightItemDetail flightItemDetail = GtdFlightItemDetail(
              flightItem: item,
              flightDirection: tuple.$1,
              transactionInfo: transactionInfo!,
              travelersInfo: bookingDetailRs.bookingInfo?.travelerInfos,
              airTravelersInfo: bookingDetailRs.travelerInfo?.airTravelers);
          return flightItemDetail;
        })
        .toList();
    return items;
  }
}
