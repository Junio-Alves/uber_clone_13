import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final VoidCallback deslogar;
  const DrawerWidget({super.key, required this.deslogar});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            child: Center(
              child: Image.asset("assets/images/uber_logo_white.png"),
            ),
          ),
          const ListTile(
            title: Text("Perfil"),
          ),
          const ListTile(
            title: Text("Sobre"),
          ),
          ListTile(
            title: const Text("Deslogar"),
            onTap: () => deslogar(),
          ),
        ],
      ),
    );
  }
}
