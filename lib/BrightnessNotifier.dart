// brightnessNotifier.dart
import 'package:flutter/material.dart';

class BrightnessNotifier with ChangeNotifier {
  double _brightnessValue = 1.0;  // Initial value set to full brightness

  double get brightnessValue => _brightnessValue;

  void setBrightness(double value) {
    _brightnessValue = value.clamp(0.1, 1.0); // Clamp the value between 0.1 and 1.0
    notifyListeners();
  }
}
