import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/models/user_model.dart';
import 'package:uber_clone_13/utils/geolocator.dart';
import 'package:uber_clone_13/widgets/choose_travel_widget.dart';
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
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Profile? usuario;

  onCreated(GoogleMapController controller) {
    _controller = controller;
    getUserCurrentPosition();
  }

  search() {
    Navigator.pushNamed(context, "/search");
  }

  getUserData() async {
    usuario = await Profile.getUserData();
    setState(() {});
  }

  getUserCurrentPosition() async {
    final userPosition = await Locator.getUserCurrentPosition();
    setState(() {
      _controller!.animateCamera(CameraUpdate.newLatLng(userPosition));
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      drawer: DrawerWidget(),
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
          ChooseTravelWidget(userName: usuario?.nome ?? "", search: search),
        ],
      ),
    );
  }
}
