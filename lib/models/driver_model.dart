/*
{
  "driver_id": "driver123",
  "latitude": -3.7405,
  "longitude": -38.5235,
  "status": "available" // ou "on_trip"
}
 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Motorista {
  final String driverUid;
  final String nome;
  final String email;
  final String profileUrl;
  final String carroModelo;
  final String placa;
  LatLng? driverLoc;
  Motorista({
    required this.driverUid,
    required this.nome,
    required this.email,
    required this.profileUrl,
    required this.carroModelo,
    required this.placa,
    required this.driverLoc,
  });

  Map<String, dynamic> toMap() {
    return {
      "driverUid": driverUid,
      "Nome_Motorista": nome,
      "Email": email,
      "profileUrl": profileUrl,
      "Carro_Modelo": carroModelo,
      "Carro_Placa": placa,
      "latitude": driverLoc?.latitude,
      "longitude": driverLoc?.longitude,
    };
  }

  factory Motorista.fromFireStore(Map<String, dynamic> data) {
    return Motorista(
      driverUid: data["driverUid"],
      nome: data["Nome_Motorista"],
      email: data["Email"],
      profileUrl: data["profileUrl"],
      carroModelo: data["Carro_Modelo"],
      placa: data["Carro_Placa"],
      driverLoc: null,
    );
  }
  static Future<Motorista> getData() async {
    final auth = FirebaseAuth.instance;
    final store = FirebaseFirestore.instance;
    final userId = auth.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await store.collection("Motoristas").doc(userId).get();
    return Motorista.fromFireStore(snapshot.data() as Map<String, dynamic>);
  }
}
