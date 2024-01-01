import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GtdMarker {
  final String value;
  late final LatLng point;
  final double latitude;
  final double longitude;
  bool isHightlight = false;
  GtdMarker({required this.value, required this.latitude, required this.longitude}) {
    point = LatLng(latitude, longitude);
  }

  Marker toMarker() {
    double widthMarker = _calWidthMarker;
    return Marker(
        width: widthMarker,
        height: 36,
        point: point,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Card(
                color: isHightlight ? Colors.orange : Colors.white,
                child: Center(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ));
  }

  double get _calWidthMarker {
    return value.characters.length * 11;
  }
}
