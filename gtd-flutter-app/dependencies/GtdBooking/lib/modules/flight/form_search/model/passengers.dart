// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Passengers {
  int? adult;
  int? child;
  int? infant;
  Passengers({
    this.adult = 1,
    this.child = 0,
    this.infant = 0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adult': adult,
      'child': child,
      'infant': infant,
    };
  }

  factory Passengers.fromMap(Map<String, dynamic> map) {
    return Passengers(
      adult: map['adult'] != null ? map['adult'] as int : null,
      child: map['child'] != null ? map['child'] as int : null,
      infant: map['infant'] != null ? map['infant'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Passengers.fromJson(String source) => Passengers.fromMap(json.decode(source) as Map<String, dynamic>);
}
