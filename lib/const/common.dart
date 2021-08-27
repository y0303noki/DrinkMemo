import 'package:flutter/material.dart';

class Common {
  static const int _lightPrimaryValue = 0xFFFFFFFF;
  static const int _darkPrimaryValue = 0xFF888888;
  static const MaterialColor lightPrimaryColor = MaterialColor(
    _lightPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(_lightPrimaryValue),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );

  static const MaterialColor darkPrimaryColor = MaterialColor(
    _darkPrimaryValue,
    <int, Color>{
      50: Color(0xFFCCCCCC),
      100: Color(0xFFB8B8B8),
      200: Color(0xFF9B9B9B),
      300: Color(0xFF818181),
      400: Color(0xFF6E6E6E),
      500: Color(_darkPrimaryValue),
      600: Color(0xFF575757),
      700: Color(0xFF1D1D1D),
      800: Color(0xFF3B3B3B),
      900: Color(0xFF3B3B3B),
    },
  );
}
