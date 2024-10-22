import 'package:flutter/material.dart';
import 'package:uber_clone_13/driver_pages/motorista_home_page.dart';
import 'package:uber_clone_13/driver_pages/motorista_travel_page.dart';
import 'package:uber_clone_13/driver_pages/motorista_list_travel_page.dart';
import 'package:uber_clone_13/driver_pages/motorista_cadastro_page.dart';
import 'package:uber_clone_13/models/viagem_model.dart';
import 'package:uber_clone_13/user_pages/cadastro_page.dart';
import 'package:uber_clone_13/user_pages/confirmation_page.dart';
import 'package:uber_clone_13/user_pages/home_page.dart';
import 'package:uber_clone_13/user_pages/login_page.dart';
import 'package:uber_clone_13/user_pages/search_page.dart';
import 'package:uber_clone_13/user_pages/travel_page.dart';
import 'package:uber_clone_13/user_pages/unknown_page.dart';

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
          //Como home é chamado em outro locais, o argumento pode ser nulo, assim, sendo necessario a verificação.
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
          builder: (context) => const SearchPage(),
        );
      case "/cadastroMotorista":
        return MaterialPageRoute(
          builder: (context) => const CadastroDriverPage(),
        );
      case "/driver_travel_page":
        return MaterialPageRoute(
          builder: (context) => DriveTravelPage(
            viagem: settings.arguments as Viagem,
          ),
        );
      case "/user_travel_page":
        return MaterialPageRoute(
          builder: (context) => UserTravelPage(
            viagem: settings.arguments as Viagem,
          ),
        );
      case "/user_travel_confirmation_page":
        return MaterialPageRoute(
          builder: (context) => ConfirmationPage(
            viagem: settings.arguments as Viagem,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const UnknownPage(),
        );
    }
  }
}
