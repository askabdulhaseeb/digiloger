import 'package:digiloger/models/digilog.dart';
import 'package:flutter/material.dart';

class DigilogProvider extends ChangeNotifier {
  late Digilog _digilog;
  late int _index;
  void onUpdatedigi(Digilog digi) {
    _digilog = digi;
    notifyListeners();
  }

  void onUpdateindex(int index) {
    _index = index;
    notifyListeners();
  }

  int get currentIndex => _index;
  Digilog get currentdigilog => _digilog;
}
