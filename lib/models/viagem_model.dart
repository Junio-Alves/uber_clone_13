/*
{
  "ride_id": "ride789",
  "passenger_id": "passenger123",
  "origin": {"latitude": -3.7405, "longitude": -38.5235},
  "destination": {"latitude": -3.7550, "longitude": -38.5265},
  "driver_id": null,  // Será preenchido quando o motorista aceitar
  "status": "pending", // Aguardando motorista
} 
*/

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Viagem {
  final String userId;
  final String departureAddress;
  final LatLng departure;
  final String destinationAddress;
  final LatLng destination;
  final String? driverId;
  final String status;
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
      "driverId": null,
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
