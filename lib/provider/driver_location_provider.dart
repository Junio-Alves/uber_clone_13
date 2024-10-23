import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverLocationProvider extends ChangeNotifier {
  StreamSubscription<Position>? positionStream;
  LatLng driverPosition = const LatLng(-15.790255, -47.888944);

  addListenerDriverLocation(GoogleMapController controller) {
    LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 10);
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      driverPosition = LatLng(position.latitude, position.longitude);
      updateCamera(controller);
      updateDriveLocation(driverPosition);
      notifyListeners();
    });
  }

  //Atualiza a posição do motorista(usuario) no FireBase
  updateDriveLocation(LatLng driverPosition) async {
    final auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection("Motoristas")
        .doc(auth.currentUser!.uid)
        .update({
      "latitude": driverPosition.latitude,
      "longitude": driverPosition.longitude,
    });
  }

  updateCamera(GoogleMapController controller) {
    controller.animateCamera(CameraUpdate.newLatLng(driverPosition));
  }

  stopListenerDriverLocation() {
    positionStream!.cancel();
    notifyListeners();
  }
}
