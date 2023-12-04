import 'package:flutter/material.dart';

const appGreen = Color(0xFF0F9632);
const appSoftGreen = Color.fromARGB(255, 124, 223, 150);
const appOrange = Color.fromARGB(255, 235, 82, 12);
const appWhite = Color.fromARGB(255, 255, 255, 255);
const appBlack = Color.fromARGB(255, 0, 0, 0);
const appPurple = Color.fromARGB(255, 49, 0, 95);
const appSoftPurple = Color.fromARGB(255, 132, 0, 255);

ThemeData themeLight = ThemeData(
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: appGreen),
  brightness: Brightness.light,
  primaryColor: appSoftGreen,
  scaffoldBackgroundColor: appWhite,
  appBarTheme: const AppBarTheme(elevation: 4, backgroundColor: appGreen),
  textTheme: const TextTheme(
      bodyLarge: TextStyle(color: appGreen),
      bodyMedium: TextStyle(color: appGreen)),
  listTileTheme: const ListTileThemeData(textColor: appGreen),
);

ThemeData themeDark = ThemeData(
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: appWhite),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: appPurple,
  primaryColor: appPurple,
  appBarTheme: const AppBarTheme(elevation: 0, backgroundColor: appPurple),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: appWhite),
    bodyMedium: TextStyle(color: appWhite),
  ),
  listTileTheme: const ListTileThemeData(textColor: appGreen),
);
