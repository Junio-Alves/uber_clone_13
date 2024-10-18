import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/pages/cadastro_page.dart';
import 'package:uber_clone_13/pages/home_page.dart';
import 'package:uber_clone_13/pages/login_page.dart';
import 'package:uber_clone_13/pages/search_page.dart';

class RouteGenerator {
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case "/cadastro":
        return MaterialPageRoute(
          builder: (context) => const CadastroPage(),
        );
      case "/login":
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );
      case "/home":
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
      case "/search":
        return MaterialPageRoute(
          builder: (context) => SearchPage(
            startTravel: settings.arguments as Function(LatLng, LatLng),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const CadastroPage(),
        );
    }
  }
}
