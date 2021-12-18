import 'package:digiloger/models/digilog.dart';
import 'package:flutter/material.dart';

class DigilogProvider extends ChangeNotifier {
  late Digilog _digilog;

  void onUpdatedigi(Digilog digi) {
    _digilog = digi;
    notifyListeners();
  }

  Digilog get currentdigilog => _digilog;
}
