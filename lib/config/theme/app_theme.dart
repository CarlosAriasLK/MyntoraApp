

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const colorSeed = Color(0xff39A900);
const scaffoldBackgroundColor = Color(0xffFFFFFF);

class AppTheme {

  ThemeData getTheme() => ThemeData(
    colorSchemeSeed: colorSeed,

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

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(
          GoogleFonts.inter()
            .copyWith(fontWeight: FontWeight.w700)
        )
      )
    ),

    appBarTheme: AppBarTheme(
      color: scaffoldBackgroundColor,
      titleTextStyle: GoogleFonts.inter()
        .copyWith( fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black ),
    )

  );
}