

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const colorSeed = Color(0xff39A900);
const scaffoldBackgroundColor = Color(0xffFFFFFF);

class AppTheme {

  final bool isDarkMode;
  AppTheme({required this.isDarkMode});

  ThemeData getTheme() => ThemeData(
    colorSchemeSeed: colorSeed,
    brightness: isDarkMode ? Brightness.dark : Brightness.light,

    scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.white,

    drawerTheme: DrawerThemeData(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
    ),

    appBarTheme: AppBarTheme(
      color: isDarkMode ? Colors.black : Colors.white,
      titleTextStyle: GoogleFonts.inter().copyWith(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    ),

    textTheme: TextTheme(
      titleLarge: GoogleFonts.inter()
          .copyWith( fontSize: 40, fontWeight: FontWeight.bold ),
      titleMedium: GoogleFonts.inter()
          .copyWith( fontSize: 30, fontWeight: FontWeight.bold ),
      titleSmall: GoogleFonts.inter()
          .copyWith( fontSize: 20 ),
    ),

    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      insetPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10)
    )

  );
}