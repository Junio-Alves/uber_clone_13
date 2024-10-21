import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Locator {
  static Future<LatLng> getUserCurrentPosition() async {
    // default position
    LatLng latLng = const LatLng(-15.790255, -47.888944);
    try {
      Position position = await Geolocator.getCurrentPosition();
      latLng = LatLng(position.latitude, position.longitude);
      return latLng;
    } catch (e) {
      print(e.toString());
      return latLng;
    }
  }
}
