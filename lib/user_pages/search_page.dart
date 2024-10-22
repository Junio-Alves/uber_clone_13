import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/models/viagem_model.dart';
import 'package:uber_clone_13/utils/geolocator.dart';
import 'package:uber_clone_13/widgets/popUp_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  LatLng? departure;
  LatLng? destination;
  final departureController = TextEditingController();
  final destinationController =
      TextEditingController(text: "Parnaíba Shopping");

  //Recupera localização com base no endereço
  Future getGeolocationFromAddress(
    String departureAddress,
    String destinationAddres,
  ) async {
    List<Location> locationsDeparture = [];
    List<Location> locationsDestination = [];
    //Tratamento de erro para o destino de saída!
    try {
      locationsDeparture = await locationFromAddress(departureAddress);
    } catch (e) {
      if (mounted) {
        popUpDialog(
            context, "Erro", "Endereço de partida não localizado!", null);
      }
    }
    //Tratamento de erro para o destino de chega!
    try {
      locationsDestination = await locationFromAddress(destinationAddres);
    } catch (e) {
      if (mounted) {
        popUpDialog(
            context, "Erro", "Endereço de destino não localizado!", null);
      }
    }

    //Verifica se ambos não foram nulos.
    if (locationsDeparture.isNotEmpty && locationsDestination.isNotEmpty) {
      departure = LatLng(locationsDeparture.first.latitude,
          locationsDeparture.first.longitude);
      destination = LatLng(locationsDestination.first.latitude,
          locationsDestination.first.longitude);
    }
  }

  getAddressFromGeolocation() async {
    List<Placemark> locationsDeparture = [];
    final departure = await Locator.getUserCurrentPosition();
    try {
      locationsDeparture = await placemarkFromCoordinates(
          departure.latitude, departure.longitude);
    } catch (e) {
      if (mounted) {
        popUpDialog(
            context, "Erro", "Endereço de destino não localizado!", null);
      }
    }
    if (locationsDeparture.isNotEmpty) {
      Placemark place = locationsDeparture[0];
      setState(() {
        departureController.text =
            "${place.street},${place.name},${place.subAdministrativeArea}";
      });
    }
  }

  iniciarViagem() async {
    await getGeolocationFromAddress(
        departureController.text, destinationController.text);
    if (departure != null && departure != null) {
      final auth = FirebaseAuth.instance;
      final viagem = Viagem(
        userId: auth.currentUser!.uid,
        departureAddress: departureController.text,
        departure: departure!,
        destinationAddress: destinationController.text,
        destination: destination!,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          "/user_travel_confirmation_page",
          arguments: viagem,
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddressFromGeolocation();
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
