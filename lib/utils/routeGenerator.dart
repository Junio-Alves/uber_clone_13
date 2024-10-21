import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone_13/driver_pages/motorista_home_page.dart';
import 'package:uber_clone_13/driver_pages/motorista_travel_page.dart';
import 'package:uber_clone_13/driver_pages/motorista_list_travel_page.dart';
import 'package:uber_clone_13/driver_pages/motorista_cadastro_page.dart';
import 'package:uber_clone_13/models/viagem_model.dart';
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
      case "/list_travels":
        return MaterialPageRoute(
          builder: (context) => const ListTravelsPage(),
        );
      case "/driver_home":
        return MaterialPageRoute(
          builder: (context) => const DriverHomePage(),
        );
      case "/search":
        return MaterialPageRoute(
          builder: (context) => SearchPage(
            startTravel: settings.arguments as Function(Viagem),
          ),
        );
      case "/cadastroMotorista":
        return MaterialPageRoute(
          builder: (context) => const CadastroDriverPage(),
        );
      case "/travel_page":
        return MaterialPageRoute(
          builder: (context) => TravelPage(
            viagem: settings.arguments as Viagem,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const UserRegisterPage(),
        );
    }
  }
}
