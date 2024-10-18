import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Brasilia
  LatLng initialPosition = const LatLng(-15.790255, -47.888944);
  GoogleMapController? _controller;
  final textController = TextEditingController();
  LatLng? driver;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

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
    });
  }

  @override
  Widget build(BuildContext context) {
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
      drawer: DrawerWidget(
        deslogar: signOut,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.60,
            child: GoogleMap(
              onMapCreated: onCreated,
              initialCameraPosition:
                  CameraPosition(target: initialPosition, zoom: 15),
              myLocationEnabled: true,
              markers: markers,
              polylines: polylines,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              "Bom dia,Francisco!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              onTap: () => search(),
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.search),
                hintText: "Para onde você quer ir?",
                focusColor: Colors.black,
                filled: true,
                fillColor: Colors.grey.shade200,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
