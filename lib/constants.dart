import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

String appToken = '';
//'buMt55pRam46AfHHC00O7RqyrnrZ6vMiEEs3gjTB3Pw80CU6d7O11TOfPmOzd4EjfhmFyH';
//b676yF4HQTAGtP9bYNM2kjAw3VZ6vd63Ar7dr7jQvhISokVKIK5K3Emr4tiPctOBgBlZhV';

const MaterialColor defaultColor = Colors.blueGrey;

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: HexColor('#333739'),
  appBarTheme: AppBarTheme(
    titleSpacing: 20,
    color: HexColor('#333739'),
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.white),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('#333739'),
      statusBarIconBrightness: Brightness.light,
    ),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    centerTitle: false,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 16,
    backgroundColor: HexColor('#333739'),
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: defaultColor,
  ),
  textTheme: const TextTheme(
    titleMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.green),
  ),
  primarySwatch: defaultColor,
  fontFamily: 'Janna',
);

ThemeData theme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    titleSpacing: 20,
    color: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    centerTitle: false,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 16,
    backgroundColor: Colors.white,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.black54,
    selectedLabelStyle: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: defaultColor,
  ),
  primarySwatch: defaultColor,
  fontFamily: 'Janna',
);
