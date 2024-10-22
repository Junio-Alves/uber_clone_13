import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/models/viagem_model.dart';
import 'package:uber_clone_13/widgets/drawer_widget.dart';

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
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: GoogleMap(
              onMapCreated: onCreated,
              initialCameraPosition:
                  CameraPosition(target: initialPosition, zoom: 15),
              myLocationEnabled: true,
              markers: markers,
              polylines: polylines,
            ),
          ),
          const Text("Confirmar viagem?"),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/home");
            },
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => confirmTravel(),
            child: const Text("Confirmar"),
          )
        ],
      ),
    );
  }
}
