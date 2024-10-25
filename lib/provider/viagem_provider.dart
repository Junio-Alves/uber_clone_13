import 'package:flutter/material.dart';
import 'package:uber_clone_13/models/viagem_model.dart';

class ViagemProvider extends ChangeNotifier {
  Viagem? _viagem;

  get viagem => _viagem;

  atualizarViagem(Viagem viagem) {
    _viagem = viagem;
    notifyListeners();
  }
}
