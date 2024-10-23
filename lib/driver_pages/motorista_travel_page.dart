import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_13/models/viagem_model.dart';
import 'package:uber_clone_13/provider/driver_location_provider.dart';
import 'package:uber_clone_13/widgets/drawer_widget.dart';

class MotoristaTravelPage extends StatefulWidget {
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  final Viagem viagem;
  final LatLng initialPosition;
  const MotoristaTravelPage({
    super.key,
    required this.polylines,
    required this.markers,
    required this.viagem,
    required this.initialPosition,
  });

  @override
  State<MotoristaTravelPage> createState() => _MotoristaTravelPageState();
}

class _MotoristaTravelPageState extends State<MotoristaTravelPage> {
  GoogleMapController? _controller;
  final driverLocationProvider = Provider.of<DriverLocationProvider>;
  double distancia = 0;
  onCreated(GoogleMapController controller) {
    _controller = controller;
    addListenerDriverLocation();
  }

  addListenerDriverLocation() {
    driverLocationProvider(context, listen: false)
        .addListenerDriverLocation(_controller!);
  }

  stopListenerDriverLocation() {
    driverLocationProvider(context).stopListenerDriverLocation();
  }

  teste() {
    double distance = Geolocator.distanceBetween(
      widget.viagem.departure.latitude,
      widget.viagem.departure.longitude,
      widget.viagem.destination.latitude,
      widget.viagem.destination.longitude,
    );
    print(distance);
    setState(() {
      distancia = distance;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopListenerDriverLocation();
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
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.80,
            child: GoogleMap(
              onMapCreated: onCreated,
              initialCameraPosition: CameraPosition(
                  target: widget.initialPosition, zoom: 18, tilt: 90),
              myLocationEnabled: true,
              polylines: widget.polylines,
              markers: widget.markers,
            ),
          ),
          ElevatedButton(
              onPressed: () => teste(), child: const Text("distancia")),
          Text(distancia.toString()),
        ],
      ),
    );
  }
}
