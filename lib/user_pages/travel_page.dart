import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/models/user_model.dart';
import 'package:uber_clone_13/models/viagem_model.dart';
import 'package:uber_clone_13/utils/geolocator.dart';
import 'package:uber_clone_13/widgets/drawer_widget.dart';
import 'package:uber_clone_13/widgets/pending_travel_widget.dart';

class UserTravelPage extends StatefulWidget {
  final Viagem viagem;
  const UserTravelPage({super.key, required this.viagem});

  @override
  State<UserTravelPage> createState() => _UserTravelPageState();
}

class _UserTravelPageState extends State<UserTravelPage> {
  //Brasilia
  GoogleMapController? _controller;
  final textController = TextEditingController();
  final store = FirebaseFirestore.instance;
  LatLng? driver;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Usuario? usuario;
  bool isPending = true;
  bool isOnTravel = false;

  onCreated(GoogleMapController controller) {
    _controller = controller;
  }

  search() {
    Navigator.pushNamed(context, "/search", arguments: createTravel);
  }

  signOut() {
    final auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
  }

  getUserData() async {
    usuario = await Usuario.getUserData();
  }

  getUserCurrentPosition() async {
    final userPosition = await Locator.getUserCurrentPosition();
    setState(() {
      _controller!.animateCamera(CameraUpdate.newLatLng(userPosition));
    });
  }

  createTravel(Viagem viagem) {
    startTravel(viagem);
    setState(() {
      createMarkers(viagem.departure, viagem.destination);
      createPolyline(viagem.departure, viagem.destination);
    });
  }

  startTravel(Viagem viagem) {
    store.collection("viagens").doc(usuario!.userUid).set(viagem.toMap());
  }

  cancelTravel() {
    store.collection("viagens").doc(usuario!.userUid).delete();
    Navigator.pushReplacementNamed(context, "/home");
  }

  createMarkers(LatLng departure, LatLng destination) {
    Marker departureMarker = Marker(
      markerId: const MarkerId("departure_marker"),
      position: departure,
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destination_marker"),
      position: destination,
    );
    markers.addAll({
      departureMarker,
      destinationMarker,
    });
  }

  createPolyline(LatLng departure, LatLng destination) {
    polylines.add(
      Polyline(
          polylineId: const PolylineId("caminho"),
          points: [departure, destination],
          color: Colors.black,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          width: 3),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserCurrentPosition();
      getUserData();
    });
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
          PendingTravelWidget(cancelTravel: cancelTravel),
          //default
        ],
      ),
    );
  }
}
