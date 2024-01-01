// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'destination.dart';

class Location {
  Destination? origin;
  Destination? destination;
  Location({
    this.origin,
    this.destination,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'origin': origin?.toMap(),
      'destination': destination?.toMap(),
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      origin: map['origin'] != null ? Destination.fromMap(map['origin'] as Map<String,dynamic>) : null,
      destination: map['destination'] != null ? Destination.fromMap(map['destination'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) => Location.fromMap(json.decode(source) as Map<String, dynamic>);
}
