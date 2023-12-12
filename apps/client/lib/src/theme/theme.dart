import 'package:client/src/theme/custom_palette.dart';
import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  fontFamily: "RedHatDisplay",
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: CustomPalette.white,
    elevation: 0,
  ),
  primarySwatch: CustomPalette.primary,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: CustomPalette.text,
      fontFamily: "RedHatDisplay",
      fontWeight: FontWeight.w700,
      fontSize: 24,
    ),
    bodyMedium: TextStyle(
      color: CustomPalette.text,
      fontFamily: "RedHatDisplay",
      fontWeight: FontWeight.normal,
      fontSize: 15,
    ),
    bodySmall: TextStyle(
      color: CustomPalette.text,
      fontFamily: "RedHatDisplay",
      fontWeight: FontWeight.normal,
      fontSize: 12,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: CustomPalette.white,
      textStyle: const TextStyle(
          fontFamily: "RedHatDisplay",
          fontWeight: FontWeight.w600,
          fontSize: 14),
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ).merge(ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return CustomPalette.inactive;
          }
          return CustomPalette.primary;
        },
      ),
    )),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    border:
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
    activeIndicatorBorder: BorderSide(color: CustomPalette.primary),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: CustomPalette.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(9999),
        topRight: Radius.circular(9999),
        bottomLeft: Radius.circular(9999),
        bottomRight: Radius.circular(9999),
      ),
    ),
    extendedPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(
          fontFamily: "RedHatDisplay",
          fontWeight: FontWeight.w600,
          fontSize: 14),
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ).merge(ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return CustomPalette.inactive;
          }
          return CustomPalette.primary;
        },
      ),
    )),
  ),
);

class MyTheme {
  static ThemeData get themeData => theme;
}
