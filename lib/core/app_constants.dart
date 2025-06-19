import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();
  static final instance = AppConstants._();
  double _screenHeight = 0;
  double _screenWidth = 0;

  double get screenHeight => _screenHeight;
  double get screenWidth => _screenWidth;

  set screenHeight(double value) {
    if (screenHeight == value) return;
    _screenHeight = value;
  }

  set screenWidth(double value) {
    if (_screenWidth == value) return;
    _screenWidth = value;
  }

  static const primaryColor = Color(0xFF7C3AED); // Roxo vibrante
}
