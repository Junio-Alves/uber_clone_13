import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone_13/driver_pages/motorista_cadastro_page.dart';
import 'package:uber_clone_13/user_pages/cadastro_page.dart';
import 'package:uber_clone_13/user_pages/home_page.dart';
import 'package:uber_clone_13/user_pages/login_page.dart';
import 'package:uber_clone_13/user_pages/search_page.dart';

class RouteGenerator {
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case "/cadastro":
        return MaterialPageRoute(
          builder: (context) => const UserRegisterPage(),
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
      case "/cadastroMotorista":
        return MaterialPageRoute(
          builder: (context) => const CadastroDriverPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const UserRegisterPage(),
        );
    }
  }
}
