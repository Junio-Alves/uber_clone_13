import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/driver_pages/motorista_travel_page.dart';
import 'package:uber_clone_13/models/driver_model.dart';
import 'package:uber_clone_13/models/viagem_model.dart';
import 'package:uber_clone_13/utils/const.dart';
import 'package:uber_clone_13/widgets/drawer_widget.dart';
import 'package:uber_clone_13/widgets/viagem_widget.dart';

class DriveTravelPage extends StatefulWidget {
  final Viagem viagem;
  const DriveTravelPage({super.key, required this.viagem});

  @override
  State<DriveTravelPage> createState() => _DriveTravelPageState();
}

class _DriveTravelPageState extends State<DriveTravelPage> {
  GoogleMapController? _controller;
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  final store = FirebaseFirestore.instance;

  signOut() {
    final auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
  }

  onCreated(GoogleMapController controller) {
    _controller = controller;
  }

  getPolylineRoutePoints() async {
    final polylinePoints = PolylinePoints();

    //Pega todas as latlng para gerar a rota
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
            origin: PointLatLng(
              widget.viagem.departure.latitude,
              widget.viagem.departure.longitude,
            ),
            destination: PointLatLng(
              widget.viagem.destination.latitude,
              widget.viagem.destination.longitude,
            ),
            mode: TravelMode.driving),
        googleApiKey: Const.googleApi);
    if (result.points.isNotEmpty) {
      final List<LatLng> points = [];
      for (final element in result.points) {
        points.add(LatLng(element.latitude, element.longitude));
      }
      //Cria o polyline(rota)
      Polyline polyline = Polyline(
        polylineId: const PolylineId("rota"),
        points: points,
        width: 5,
      );
      setState(() {
        polylines.add(polyline);
      });
    }
  }

  createMarkers() async {
    Marker departureMarker = Marker(
      markerId: const MarkerId("departure_marker"),
      position: widget.viagem.departure,
      icon: await BitmapDescriptor.asset(
          const ImageConfiguration(size: Size(48, 48)),
          "assets/images/home_position.png"),
      infoWindow: const InfoWindow(title: "Departure"),
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destination_marker"),
      position: widget.viagem.destination,
      icon: await BitmapDescriptor.asset(
          const ImageConfiguration(size: Size(48, 48)),
          "assets/images/location_pin.png"),
      infoWindow: const InfoWindow(title: "Destination"),
    );
    setState(() {
      markers.addAll({
        departureMarker,
        destinationMarker,
      });
    });
  }

  cancelTravel() async {
    final viagem = widget.viagem;
    //sei que é gambiarra e eu deveria ter feito getters e setters
    viagem.driverId = null;
    viagem.status = "pending";
    await store.collection("viagens").doc(viagem.userId).update(viagem.toMap());
    if (mounted) Navigator.pushNamed(context, "/driver_home");
  }

  startTravel() async {
    final viagem = widget.viagem;
    final driverId = FirebaseAuth.instance.currentUser!.uid;
    final motorista = await Motorista.getData(driverId);
    //sei que é gambiarra e eu deveria ter feito getters e setters
    viagem.driverId = motorista.driverUid;
    viagem.status = "onTravel";
    await store.collection("viagens").doc(viagem.userId).update(viagem.toMap());
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MotoristaTravelPage(
              polylines: polylines,
              markers: markers,
              viagem: viagem,
              initialPosition: widget.viagem.departure),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getPolylineRoutePoints();
    createMarkers();
  }

  @override
  Widget build(BuildContext context) {
    LatLng initialPosition = widget.viagem.departure;
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
            height: MediaQuery.of(context).size.height * 0.45,
            child: GoogleMap(
              onMapCreated: onCreated,
              initialCameraPosition:
                  CameraPosition(target: initialPosition, zoom: 18, tilt: 90),
              myLocationEnabled: true,
              polylines: polylines,
              markers: markers,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const ListTile(
                  leading: CircleAvatar(),
                  title: Text("User_name"),
                ),
                const Divider(),
                ViagemWidget(
                    departureAddress: widget.viagem.departureAddress,
                    destinationAddress: widget.viagem.destinationAddress,
                    onTap: () {}),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => cancelTravel(),
                        child: const Text("Cancelar"),
                      ),
                      ElevatedButton(
                        onPressed: () => startTravel(),
                        child: const Text("Iniciar"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
