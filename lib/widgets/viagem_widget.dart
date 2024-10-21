import 'package:flutter/material.dart';

class ViagemWidget extends StatelessWidget {
  final String departureAddress;
  final String destinationAddress;
  const ViagemWidget({
    super.key,
    required this.departureAddress,
    required this.destinationAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(departureAddress),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_downward_outlined),
                Text(
                  "R\$ 10.00",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.circle),
            title: Text(destinationAddress),
          ),
        ],
      ),
    );
    ;
  }
}
