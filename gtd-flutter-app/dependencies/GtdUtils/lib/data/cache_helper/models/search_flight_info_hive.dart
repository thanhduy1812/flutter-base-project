// // ignore_for_file: public_member_api_docs, sort_constructors_first

// class SearchFlightInfoHive {
//   String departLocationCode;

//   String departLocationName;

//   String returnLocationCode;

//   String returnLocationName;

//   bool isRoundTrip;

//   bool isDome;

//   int adult;

//   int child;

//   int infant;

//   DateTime? departFlightDate;

//   DateTime? returnFlightDate;

//   String? bookingNumber;

//   SearchFlightInfoHive({
//     this.departLocationCode = "",
//     this.departLocationName = "",
//     this.returnLocationCode = "",
//     this.returnLocationName = "",
//     this.isRoundTrip = false,
//     this.isDome = true,
//     this.adult = 1,
//     this.child = 0,
//     this.infant = 0,
//     this.departFlightDate,
//     this.returnFlightDate,
//     this.bookingNumber,
//   });

//   SearchFlightInfoHive copyWith({
//     String? departLocationCode,
//     String? departLocationName,
//     String? returnLocationCode,
//     String? returnLocationName,
//     bool? isRoundTrip,
//     bool? isDome,
//     int? adult,
//     int? child,
//     int? infant,
//     DateTime? departFlightDate,
//     DateTime? returnFlightDate,
//     String? bookingNumber,
//   }) {
//     return SearchFlightInfoHive(
//       departLocationCode: departLocationCode ?? this.departLocationCode,
//       departLocationName: departLocationName ?? this.departLocationName,
//       returnLocationCode: returnLocationCode ?? this.returnLocationCode,
//       returnLocationName: returnLocationName ?? this.returnLocationName,
//       isRoundTrip: isRoundTrip ?? this.isRoundTrip,
//       isDome: isDome ?? this.isDome,
//       adult: adult ?? this.adult,
//       child: child ?? this.child,
//       infant: infant ?? this.infant,
//       departFlightDate: departFlightDate ?? this.departFlightDate,
//       returnFlightDate: returnFlightDate ?? this.returnFlightDate,
//       bookingNumber: bookingNumber ?? this.bookingNumber,
//     );
//   }

//   int get typeId => 0;

//   @override
//   String toString() {
//     return 'SearchFlightInfoHive(departLocationCode: $departLocationCode, departLocationName: $departLocationName, returnLocationCode: $returnLocationCode, returnLocationName: $returnLocationName, isRoundTrip: $isRoundTrip, isDome: $isDome, adult: $adult, child: $child, infant: $infant, departFlightDate: $departFlightDate, returnFlightDate: $returnFlightDate, bookingNumber: $bookingNumber)';
//   }
// }
