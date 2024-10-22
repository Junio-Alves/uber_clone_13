import 'package:flutter/material.dart';

class PendingTravelWidget extends StatefulWidget {
  final VoidCallback cancelTravel;
  const PendingTravelWidget({super.key, required this.cancelTravel});

  @override
  State<PendingTravelWidget> createState() => _PendingTravelWidgetState();
}

class _PendingTravelWidgetState extends State<PendingTravelWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LinearProgressIndicator(),
        const SizedBox(
          height: 20,
        ),
        Image.asset(
          "assets/images/car_icon.png",
          width: 100,
        ),
        const Text("Procurando um motorista!"),
        ElevatedButton(
            onPressed: () => widget.cancelTravel(),
            child: const Text("Cancelar Viagem")),
      ],
    );
  }
}
