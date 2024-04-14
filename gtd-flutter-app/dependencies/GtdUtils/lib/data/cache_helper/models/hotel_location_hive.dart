// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class HotelLocationHive {
//   String name;
//   String searchCode;
//   String searchType;
//   String supplier;
//   String lineOne;

//   HotelLocationHive({
//     required this.name,
//     required this.searchCode,
//     required this.searchType,
//     required this.supplier,
//     required this.lineOne,
//   });

//   int get typeId => 1;

//   String toJson() => json.encode(toMap());

//   factory HotelLocationHive.fromJson(String source) =>
//       HotelLocationHive.fromMap(json.decode(source) as Map<String, dynamic>);

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'name': name,
//       'searchCode': searchCode,
//       'searchType': searchType,
//       'supplier': supplier,
//       'lineOne': lineOne,
//     };
//   }

//   factory HotelLocationHive.fromMap(Map<String, dynamic> map) {
//     return HotelLocationHive(
//       name: map['name'] as String,
//       searchCode: map['searchCode'] as String,
//       searchType: map['searchType'] as String,
//       supplier: map['supplier'] as String,
//       lineOne: map['lineOne'] as String,
//     );
//   }
// }
