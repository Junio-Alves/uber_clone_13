import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/models/user_model.dart';
import 'package:uber_clone_13/models/viagem_model.dart';
import 'package:uber_clone_13/utils/geolocator.dart';
import 'package:uber_clone_13/widgets/drawer_widget.dart';
import 'package:uber_clone_13/widgets/onTravel_widget.dart';
import 'package:uber_clone_13/widgets/pending_travel_widget.dart';

class UserTravelPage extends StatefulWidget {
  final Viagem viagem;
  const UserTravelPage({super.key, required this.viagem});

  @override
  State<UserTravelPage> createState() => _UserTravelPageState();
}

class _UserTravelPageState extends State<UserTravelPage> {
  GoogleMapController? _controller;
  final textController = TextEditingController();
  final store = FirebaseFirestore.instance;
  final controllerViagem = StreamController<DocumentSnapshot>.broadcast();
  StreamSubscription<DocumentSnapshot>? driverLocationController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Profile? usuario;
  LatLng? driverLocation;
  bool isListening = false;

  adicionarListenerViagem() {
    print(widget.viagem.userId);
    final stream =
        store.collection("viagens").doc(widget.viagem.userId).snapshots();
    stream.listen((dados) {
      controllerViagem.add(dados);
    });
  }

  onCreated(GoogleMapController controller) {
    getUserCurrentPosition();
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
    usuario = await Profile.getUserData();
  }

  getUserCurrentPosition() async {
    final userPosition = await GeoLocator.getUserCurrentPosition();
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

  onTravelAccepted(String driverId) {
    addListenerDriverLocation(driverId);
  }

  addListenerDriverLocation(String driverId) async {
    if (isListening == false) {
      isListening = true;
      driverLocationController = store
          .collection("Motoristas")
          .doc(driverId)
          .snapshots()
          .listen((data) async {
        final driveData = data.data() as Map<String, dynamic>;
        driverLocation = LatLng(driveData["latitude"], driveData["longitude"]);
        //Cria marcador do motorista
        final driveMarker = Marker(
          markerId: const MarkerId(
            "Drive_Marker",
          ),
          icon: await BitmapDescriptor.asset(
              const ImageConfiguration(size: Size(48, 48)),
              "assets/images/driver_position_icon.png"),
          position: driverLocation!,
          infoWindow: const InfoWindow(title: "Motorista"),
        );
        setState(() {
          markers.add(driveMarker);
        });
      });
    }
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
      getUserData();
      adicionarListenerViagem();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    driverLocationController!.cancel();
    isListening = false;
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
            height: MediaQuery.of(context).size.height * 0.55,
            child: GoogleMap(
              onMapCreated: onCreated,
              initialCameraPosition:
                  CameraPosition(target: initialPosition, zoom: 15),
              myLocationEnabled: true,
              markers: markers,
              polylines: polylines,
            ),
          ),
          StreamBuilder(
            stream: controllerViagem.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case (ConnectionState.none):
                case (ConnectionState.waiting):
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case (ConnectionState.active):
                case (ConnectionState.done):
                  final viagem = snapshot.data!.data() as Map<String, dynamic>;
                  switch (viagem["status"]) {
                    case "pending":
                      return PendingTravelWidget(cancelTravel: cancelTravel);
                    case "onTravel":
                      onTravelAccepted(viagem["driverId"]);
                      return OntravelWidget(driverId: viagem["driverId"]);
                    case "RideStarted":
                      onTravelAccepted(viagem["driverId"]);
                      return OntravelWidget(
                        driverId: viagem["driverId"],
                        textAlert: "Viagem Iniciada",
                      );
                    case "RideCompleted":
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/home", (_) => false);
                  }
                  return Container();
              }
            },
          )
          //default
        ],
      ),
    );
  }
}
