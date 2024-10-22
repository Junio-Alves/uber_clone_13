import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/models/driver_model.dart';
import 'package:uber_clone_13/utils/geolocator.dart';
import 'package:uber_clone_13/widgets/drawer_widget.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  //Brasilia
  LatLng driverPosition = const LatLng(-15.790255, -47.888944);
  GoogleMapController? _controller;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Motorista? driver;
  StreamSubscription<Position>? positionStream;

  onCreated(GoogleMapController controller) {
    _controller = controller;
  }

  signOut() {
    final auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
  }

  openListTravel() {
    Navigator.pushNamed(context, "/list_travels");
  }

  getUserData() async {
    driver = await Motorista.getData();
  }

  updateDriveLocation(LatLng driverPosition) async {
    final auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection("Motoristas")
        .doc(auth.currentUser!.uid)
        .update({
      "latitude": driverPosition.latitude,
      "longitude": driverPosition.longitude,
    });
    updateCamera(driverPosition);
  }

  updateCamera(LatLng driverPosition) {
    setState(() {
      _controller!.animateCamera(CameraUpdate.newLatLng(driverPosition));
    });
  }

  addListenerDriverLocation() {
    LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 0);
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      setState(() {
        driverPosition = LatLng(position.latitude, position.longitude);
        updateDriveLocation(driverPosition);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserData();
      addListenerDriverLocation();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    positionStream?.cancel();
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: FloatingActionButton(
          onPressed: () => openListTravel(),
          backgroundColor: Colors.white,
          child: const Icon(Icons.search),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child: GoogleMap(
              onMapCreated: onCreated,
              initialCameraPosition:
                  CameraPosition(target: driverPosition, zoom: 15),
              myLocationEnabled: true,
              markers: markers,
              polylines: polylines,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              "Bom dia,${driver?.nome ?? ""}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Você está offline!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                width: 50,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Iniciar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
