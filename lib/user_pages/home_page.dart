import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/models/user_model.dart';
import 'package:uber_clone_13/models/viagem_model.dart';
import 'package:uber_clone_13/utils/geolocator.dart';
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
  Usuario? usuario;

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
    final auth = FirebaseAuth.instance;
    final store = FirebaseFirestore.instance;
    final userId = auth.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await store.collection("usuarios").doc(userId).get();
    Map<String, dynamic> dadosUsuario = snapshot.data() as Map<String, dynamic>;
    setState(() {
      usuario = Usuario(
        userUid: userId,
        nome: dadosUsuario["Nome"],
        email: dadosUsuario["Email"],
        profileUrl: dadosUsuario["profileUrl"],
      );
    });
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
    final store = FirebaseFirestore.instance;
    store.collection("viagens").doc(usuario!.userUid).set(viagem.toMap());
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
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              "Bom dia,${usuario?.nome ?? ""}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
