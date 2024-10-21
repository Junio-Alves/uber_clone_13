import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/models/viagem_model.dart';
import 'package:uber_clone_13/widgets/viagem_widget.dart';

class ListTravelsPage extends StatefulWidget {
  const ListTravelsPage({super.key});

  @override
  State<ListTravelsPage> createState() => _ListTravelsPageState();
}

class _ListTravelsPageState extends State<ListTravelsPage> {
  final controller = StreamController<QuerySnapshot>.broadcast();
  final store = FirebaseFirestore.instance;
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

  adicionarListenerViagens() async {
    final stream = store.collection("viagens").snapshots();
    stream.listen((dados) {
      controller.add(dados);
    });
  }

  startTravel(Viagem viagem) {
    Navigator.pushReplacementNamed(
      context,
      "/travel_page",
      arguments: viagem,
    );
  }

  @override
  void initState() {
    adicionarListenerViagens();
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
      body: StreamBuilder(
        stream: controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Expanded(
                  child: Center(
                    child: Text("Erro ao carregar base de dados!"),
                  ),
                );
              } else {
                final querySnapshot = snapshot.data;
                List<Viagem> viagens = [];
                for (final viagem in querySnapshot!.docs) {
                  //Verifica se a viagem está no modo pendente!
                  if (viagem["status"] == "pending") {
                    final data = viagem.data() as Map<String, dynamic>;
                    viagens.add(Viagem.fromFireStore(data));
                  }
                }
                return ListView.builder(
                  itemCount: viagens.length,
                  itemBuilder: (context, index) {
                    final viagem = viagens[index];
                    return ViagemWidget(
                      onTap: () => startTravel(viagem),
                      departureAddress: viagem.departureAddress,
                      destinationAddress: viagem.destinationAddress,
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}
