import 'package:flutter/foundation.dart';
import 'package:uber_clone_13/models/driver_model.dart';

class DriverProvider extends ChangeNotifier {
  Driver? _driver;

  get driver => _driver;

  updateDriver(Driver newDriver) {
    _driver = newDriver;
    notifyListeners();
  }
}
