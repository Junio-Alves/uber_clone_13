import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/widgets/popUp_widget.dart';

class SearchPage extends StatefulWidget {
  final Function(LatLng, LatLng) startTravel;
  const SearchPage({super.key, required this.startTravel});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  LatLng? departure;
  LatLng? destination;
  final departureController =
      TextEditingController(text: "Rua do Cajueiro,Santa Luzia,Parnaíba");
  final destinationController =
      TextEditingController(text: "Parnaíba Shopping");
  Future getGeolocationFromAddress(
    String departureAddress,
    String destinationAddres,
  ) async {
    List<Location> locationsDeparture = [];
    List<Location> locationsDestination = [];
    try {
      locationsDeparture = await locationFromAddress(departureAddress);
    } catch (e) {
      if (mounted) {
        popUpDialog(
            context, "Erro", "Endereço de partida não localizado!", null);
      }
    }
    try {
      locationsDestination = await locationFromAddress(destinationAddres);
    } catch (e) {
      if (mounted) {
        popUpDialog(
            context, "Erro", "Endereço de destino não localizado!", null);
      }
    }

    if (locationsDeparture.isNotEmpty && locationsDestination.isNotEmpty) {
      departure = LatLng(locationsDeparture.first.latitude,
          locationsDeparture.first.longitude);
      destination = LatLng(locationsDestination.first.latitude,
          locationsDestination.first.longitude);
    }
  }

  iniciarViagem() async {
    await getGeolocationFromAddress(
        departureController.text, destinationController.text);
    if (departure != null && departure != null) {
      widget.startTravel(departure!, destination!);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Selecione o Destino",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Partida",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                TextFormField(
                  controller: departureController,
                ),
                const Text(
                  "Chegada",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                TextFormField(
                  controller: destinationController,
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () => iniciarViagem(),
                child: const Text(
                  "Iniciar",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
