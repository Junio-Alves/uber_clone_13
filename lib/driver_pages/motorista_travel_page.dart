import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_13/models/viagem_model.dart';
import 'package:uber_clone_13/provider/driver_location_provider.dart';
import 'package:uber_clone_13/widgets/drawer_widget.dart';

class MotoristaTravelPage extends StatefulWidget {
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  final LatLng initialPosition;
  final Viagem viagem;
  const MotoristaTravelPage(
      {super.key,
      required this.polylines,
      required this.markers,
      required this.initialPosition,
      required this.viagem});

  @override
  State<MotoristaTravelPage> createState() => _MotoristaTravelPageState();
}

class _MotoristaTravelPageState extends State<MotoristaTravelPage> {
  GoogleMapController? _controller;
  final store = FirebaseFirestore.instance;
  final driverLocationProvider = Provider.of<DriverLocationProvider>;
  bool rideStarted = false;
  onCreated(GoogleMapController controller) {
    _controller = controller;
    addListenerDriverLocation();
    driverLocationProvider(context).setViagem(widget.viagem);
  }

  addListenerDriverLocation() {
    driverLocationProvider(context, listen: false)
        .addListenerDriverLocation(_controller!);
  }

  stopListenerDriverLocation() {
    driverLocationProvider(context).stopListenerDriverLocation();
  }

  iniciarViagem() async {
    setState(() {
      rideStarted = true;
    });
    final viagem = widget.viagem;
    viagem.status = "RideStarted";
    await store.collection("viagens").doc(viagem.userId).update(viagem.toMap());
  }

  finalizarViagem() async {
    final viagem = widget.viagem;
    viagem.status = "RideCompleted";
    await store.collection("viagens").doc(viagem.userId).update(viagem.toMap());
    if (mounted)
      Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopListenerDriverLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Uber Motorista",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        backgroundColor: Colors.black,
      ),
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.80,
            child: GoogleMap(
              onMapCreated: onCreated,
              initialCameraPosition: CameraPosition(
                  target: widget.initialPosition, zoom: 18, tilt: 90),
              myLocationEnabled: true,
              polylines: widget.polylines,
              markers: widget.markers,
            ),
          ),
          rideStarted
              ? ElevatedButton(
                  onPressed: () => finalizarViagem(),
                  child: const Text("Finalizar Viagem"))
              : ElevatedButton(
                  onPressed: () => iniciarViagem(),
                  child: const Text("Iniciar Viagem"))
        ],
      ),
    );
  }
}
