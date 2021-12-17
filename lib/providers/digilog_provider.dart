import 'package:flutter/material.dart';

class DigilogProvider extends ChangeNotifier {
  int _index = 0;
  void onUpdate(int index) {
    _index = index;
    notifyListeners();
  }

  int get currentid => _index;
}
