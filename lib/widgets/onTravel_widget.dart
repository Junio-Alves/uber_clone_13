import 'package:flutter/material.dart';
import 'package:uber_clone_13/models/driver_model.dart';

class OntravelWidget extends StatefulWidget {
  final String driverId;
  final String? textAlert;
  const OntravelWidget(
      {super.key, required, required this.driverId, this.textAlert});

  @override
  State<OntravelWidget> createState() => _OntravelWidgetState();
}

class _OntravelWidgetState extends State<OntravelWidget> {
  Driver? driver;
  bool isLoading = true;
  getDriveData() async {
    driver = await Driver.getData(widget.driverId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDriveData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Boas Noticias! Viagem Aceita.\nMotorista a caminho do seu endereço.",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    radius: 50,
                  ),
                  title: Text(
                    driver!.nome,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                      "Carro: ${driver!.carroModelo}\nPlaca: ${driver!.placa}\n "),
                ),
              ),
              if (widget.textAlert != null) ...{
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    widget.textAlert!,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              }
            ],
          );
  }
}
