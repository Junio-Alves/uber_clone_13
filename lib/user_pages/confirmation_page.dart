import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/models/viagem_model.dart';
import 'package:uber_clone_13/widgets/drawer_widget.dart';
import 'package:uber_clone_13/widgets/viagem_widget.dart';

class ConfirmationPage extends StatefulWidget {
  final Viagem viagem;
  const ConfirmationPage({
    super.key,
    required this.viagem,
  });

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  GoogleMapController? _controller;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  onCreated(GoogleMapController controller) {
    _controller = controller;
  }

  createTravel(Viagem viagem) async {
    final store = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    await store
        .collection("viagens")
        .doc(auth.currentUser!.uid)
        .set(viagem.toMap());
  }

  confirmTravel() {
    createTravel(widget.viagem);
    Navigator.pushReplacementNamed(context, "/user_travel_page",
        arguments: widget.viagem);
  }

  createMarkers() {
    Marker departureMarker = Marker(
      markerId: const MarkerId("departure_marker"),
      position: widget.viagem.departure,
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destination_marker"),
      position: widget.viagem.destination,
    );
    markers.addAll({
      departureMarker,
      destinationMarker,
    });
  }

  createPolyline() {
    polylines.add(
      Polyline(
          polylineId: const PolylineId("caminho"),
          points: [widget.viagem.departure, widget.viagem.destination],
          color: Colors.black,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          width: 3),
    );
  }

  @override
  void initState() {
    super.initState();
    createMarkers();
    createPolyline();
  }

  @override
  Widget build(BuildContext context) {
    LatLng initialPosition = widget.viagem.departure;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Uber",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.50,
            child: GoogleMap(
              onMapCreated: onCreated,
              initialCameraPosition:
                  CameraPosition(target: initialPosition, zoom: 15),
              myLocationEnabled: true,
              markers: markers,
              polylines: polylines,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Confirme sua viagem",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                ViagemWidget(
                    departureAddress: widget.viagem.departureAddress,
                    destinationAddress: widget.viagem.destinationAddress,
                    onTap: () {}),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: Image.asset("assets/images/car_icon.png"),
                  title: const Text(
                    "Carro Particular",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Text(
                    "R\$ 10,00",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => confirmTravel(),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.black),
                  child: const Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
