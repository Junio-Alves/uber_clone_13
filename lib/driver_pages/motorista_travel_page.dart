import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/models/viagem_model.dart';
import 'package:uber_clone_13/utils/const.dart';
import 'package:uber_clone_13/widgets/drawer_widget.dart';

class TravelPage extends StatefulWidget {
  final Viagem viagem;
  const TravelPage({super.key, required this.viagem});

  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  GoogleMapController? _controller;
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};

  signOut() {
    final auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
  }

  onCreated(GoogleMapController controller) {
    _controller = controller;
  }

  getPolylinePoints() async {
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
          polylineId: const PolylineId("rota"), points: points, width: 5);
      setState(() {
        polylines.add(polyline);
      });
    }
  }

  createMarkers() {
    Marker departureMarker = Marker(
      markerId: const MarkerId("departure_marker"),
      position: widget.viagem.departure,
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destination_marker"),
      position: widget.viagem.destination,
    );
    setState(() {
      markers.addAll({
        departureMarker,
        destinationMarker,
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getPolylinePoints();
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
                  CameraPosition(target: initialPosition, zoom: 18, tilt: 90),
              myLocationEnabled: true,
              polylines: polylines,
              markers: markers,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
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
          ),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/driver_home"),
              child: const Text("Viagens"))
        ],
      ),
    );
    ;
  }
}
