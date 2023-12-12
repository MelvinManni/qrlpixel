import 'package:flutter/material.dart';

class CustomPalette {
  static const int _primaryColor = 0xFF3A405A;
  static const int _secondaryColor = 0xFFF9DEC9;
  static const Color inactive = Color(0xFF828282);
  static const Color error = Color(0xFFEB5757);
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF2C94C);
  static const Color info = Color(0xFF2F80ED);
  static const int _white = 0xFFFFFFFF;
  static const Color text = Color(0xFF333333);

  static const MaterialColor primary = MaterialColor(
    _primaryColor,
    <int, Color>{
      50: Color(0xFF898C9C),
      100: Color(0xFF75798C),
      200: Color(0xFF61667B),
      300: Color(0xFF4E536B),
      400: Color(0xFF3A405A),
      500: Color(_primaryColor),
      600: Color(0xFF171A24),
      700: Color(0xFF11131B),
      800: Color(0xFF0C0D12),
      900: Color(0xFF060609),
      950: Color(0xFF000000),
    },
  );
  static const MaterialColor secondary = MaterialColor(
    _primaryColor,
    <int, Color>{
      50: Color(0xFFFBEBDF),
      100: Color(0xFFFBE8D9),
      200: Color(0xFFFAE5D4),
      300: Color(0xFFFAE1CE),
      400: Color(0xFFF9DEC9),
      500: Color(_secondaryColor),
      600: Color(0xFFC7B2A1),
      700: Color(0xFFAE9B8D),
      800: Color(0xFF958579),
      900: Color(0xFF7D6F65),
      950: Color(0xFF645950),
    },
  );

  static const MaterialColor white = MaterialColor(_white, <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFF7F9F7),
    900: Color(0xFFF4F4F4),
  });
}
