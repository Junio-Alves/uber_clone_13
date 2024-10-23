import 'package:flutter/material.dart';
import 'package:uber_clone_13/models/driver_model.dart';

class OntravelWidget extends StatefulWidget {
  final String driverId;
  const OntravelWidget({super.key, required, required this.driverId});

  @override
  State<OntravelWidget> createState() => _OntravelWidgetState();
}

class _OntravelWidgetState extends State<OntravelWidget> {
  Motorista? driver;
  getDriveData() async {
    driver = await Motorista.getData(widget.driverId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDriveData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(driver!.nome),
        Text(driver!.carroModelo),
        Text(driver!.placa),
        const Text("Viagem aceita!"),
      ],
    );
  }
}
