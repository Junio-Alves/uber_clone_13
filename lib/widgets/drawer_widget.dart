import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  signOut() {
    final auth = FirebaseAuth.instance;
    auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
  }

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
            onTap: () => signOut,
          ),
        ],
      ),
    );
  }
}
