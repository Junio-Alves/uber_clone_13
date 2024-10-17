import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng initialPosition = const LatLng(-2.910567, -41.753821);
  GoogleMapController? _controller;
  final textController = TextEditingController();

  onCreated(GoogleMapController controller) {
    _controller = controller;
  }

  pesquisar() {
    Navigator.pushNamed(context, "/search");
  }

  deslogar() {
    final auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
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
        deslogar: deslogar,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child: GoogleMap(
              onMapCreated: onCreated,
              initialCameraPosition:
                  CameraPosition(target: initialPosition, zoom: 15),
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
              onTap: () => pesquisar(),
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
