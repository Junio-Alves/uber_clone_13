import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/widgets/drawer_widget.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  //Brasilia
  LatLng initialPosition = const LatLng(-15.790255, -47.888944);
  GoogleMapController? _controller;
  final textController = TextEditingController();
  LatLng? driver;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  String userName = "";

  onCreated(GoogleMapController controller) {
    _controller = controller;
  }

  search() {
    Navigator.pushNamed(context, "/search", arguments: startTravel);
  }

  signOut() {
    final auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
  }

  getDriverName() async {
    final auth = FirebaseAuth.instance;
    final store = FirebaseFirestore.instance;
    final userId = auth.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await store.collection("Motoristas").doc(userId).get();
    Map<String, dynamic> dadosUsuario = snapshot.data() as Map<String, dynamic>;
    setState(() {
      userName = dadosUsuario["Nome_Motorista"];
    });
  }

  getUserCurrentPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(
        () {
          _controller!.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(position.latitude, position.longitude),
            ),
          );
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  startTravel(LatLng departure, LatLng destination) {
    Marker departureMarker = Marker(
      markerId: const MarkerId("departure_marker"),
      position: departure,
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destination_marker"),
      position: destination,
    );
    setState(() {
      markers.addAll({
        departureMarker,
        destinationMarker,
      });
      createPolyline(departure, destination);
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
      getDriverName();
    });
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
      drawer: DrawerWidget(
        deslogar: signOut,
      ),
    );
  }
}
