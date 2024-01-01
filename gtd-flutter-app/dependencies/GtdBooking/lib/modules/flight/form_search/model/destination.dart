// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Destination {
  String? code;
  String? name;
  String? nameEn;
  String? country;
  String? countryEn;
  String? airportName;
  String? airportNameEn;
  String? type;
  Destination({
    this.code,
    this.name,
    this.nameEn,
    this.country,
    this.countryEn,
    this.airportName,
    this.airportNameEn,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'name': name,
      'nameEn': nameEn,
      'country': country,
      'countryEn': countryEn,
      'airportName': airportName,
      'airportNameEn': airportNameEn,
      'type': type,
    };
  }

  factory Destination.fromMap(Map<String, dynamic> map) {
    return Destination(
      code: map['code'] != null ? map['code'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      nameEn: map['nameEn'] != null ? map['nameEn'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      countryEn: map['countryEn'] != null ? map['countryEn'] as String : null,
      airportName: map['airportName'] != null ? map['airportName'] as String : null,
      airportNameEn: map['airportNameEn'] != null ? map['airportNameEn'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Destination.fromJson(String source) => Destination.fromMap(json.decode(source) as Map<String, dynamic>);
}
