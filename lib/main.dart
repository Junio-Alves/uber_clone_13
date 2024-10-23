import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_13/provider/driver_location_provider.dart';
import 'package:uber_clone_13/provider/driver_provider.dart';
import 'package:uber_clone_13/provider/user_provider.dart';
import 'package:uber_clone_13/provider/viagem_provider.dart';
import 'package:uber_clone_13/user_pages/login_page.dart';
import 'package:uber_clone_13/utils/routeGenerator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DriverLocationProvider()),
      ChangeNotifierProvider(create: (_) => ViagemProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => DriverProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      onGenerateRoute: RouteGenerator.generate,
      initialRoute: "/",
    );
  }
}
