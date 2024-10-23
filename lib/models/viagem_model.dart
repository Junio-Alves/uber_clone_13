/*
{
  "ride_id": "ride789",
  "passenger_id": "passenger123",
  "origin": {"latitude": -3.7405, "longitude": -38.5235},
  "destination": {"latitude": -3.7550, "longitude": -38.5265},
  "driver_id": null,  // Será preenchido quando o motorista aceitar
  "status":
    1. **Ride Request**:
      - "Your ride request has been received. We are looking for a nearby driver."

    2. **Driver Assigned**:
      - "Great news! A driver has been assigned to your ride: [Driver's Name]."

    3. **Driver on the Way**:
      - "[Driver's Name] is on the way! Estimated time of arrival: [XX minutes]."

    4. **Ride Started**:
      - "The ride has begun! Destination: [Destination Address]."

    5. **Ride in Progress**:
      - "You are on your way to [Destination Address]. Enjoy the ride!"

    6. **Ride Completed**:
      - "You have arrived at your destination: [Destination Address]. We hope you enjoyed your ride!"

    9. **Ride Canceled**:
      - "Your ride has been canceled. If you need assistance, please contact support."

    10. **Issue with Ride**:
        - "There was a problem during the ride. Please contact support for more information."
} 
*/

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Viagem {
  final String userId;
  final String departureAddress;
  final LatLng departure;
  final String destinationAddress;
  final LatLng destination;
  String? driverId;
  String status;
  Viagem({
    required this.userId,
    required this.departureAddress,
    required this.departure,
    required this.destinationAddress,
    required this.destination,
    this.driverId,
    this.status = "pending",
  });
  //Converter objeto viagem em um map.
  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "departureAddress": departureAddress,
      "departureLatLng": {
        "latitude": departure.latitude,
        "longitude": departure.longitude
      },
      "destinatioAddress": destinationAddress,
      "destinationLatLng": {
        "latitude": destination.latitude,
        "longitude": destination.longitude
      },
      "driverId": driverId,
      "status": status,
    };
  }

  //Converter o dados do fireStore em um objeto viagem!
  factory Viagem.fromFireStore(Map<String, dynamic> data) {
    return Viagem(
      userId: data["userId"],
      departureAddress: data["departureAddress"],
      departure: LatLng(data["departureLatLng"]["latitude"],
          data["departureLatLng"]["longitude"]),
      destinationAddress: data["destinatioAddress"],
      destination: LatLng(data["destinationLatLng"]["latitude"],
          data["destinationLatLng"]["longitude"]),
    );
  }
}
