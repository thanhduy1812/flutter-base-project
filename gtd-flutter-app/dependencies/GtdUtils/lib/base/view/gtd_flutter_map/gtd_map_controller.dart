import 'package:flutter_map/flutter_map.dart';
import 'package:gtd_utils/base/view/gtd_flutter_map/gtd_map_point.dart';

class GtdMapController {
  final flutterMapController = MapController();

  void moveToPoint(GtdMapPoint mapPoint) {
    flutterMapController.move(mapPoint.toLatLng(), 16);
  }
}
