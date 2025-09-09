

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

    textTheme: TextTheme(
      titleLarge: GoogleFonts.inter()
        .copyWith( fontSize: 40, fontWeight: FontWeight.bold ),
      titleMedium: GoogleFonts.inter()
        .copyWith( fontSize: 30, fontWeight: FontWeight.bold ),
      titleSmall: GoogleFonts.inter()
        .copyWith( fontSize: 20 ),
    ),

    scaffoldBackgroundColor: scaffoldBackgroundColor,

    drawerTheme: DrawerThemeData(
      backgroundColor: scaffoldBackgroundColor
    ),

    appBarTheme: AppBarTheme(
      color: scaffoldBackgroundColor,
      titleTextStyle: GoogleFonts.inter()
        .copyWith( fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black ),
    )

  );
}