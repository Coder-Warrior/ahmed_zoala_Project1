import 'package:flutter/material.dart';

class Themey with ChangeNotifier {
  String mode = 'Light';
  changeToLight() {
    mode = "Light";
    notifyListeners();
  }
    changeToDark() {
    mode = "Dark";
    notifyListeners();
  }
}