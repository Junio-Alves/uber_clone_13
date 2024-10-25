import 'package:flutter/material.dart';
import 'package:uber_clone_13/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  Profile? _user;

  get user => _user;

  updateUser(Profile newUser) {
    _user = newUser;
    notifyListeners();
  }
}
