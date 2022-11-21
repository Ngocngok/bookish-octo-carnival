import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData mainTheme() {
  return ThemeData(
    brightness: Brightness.light,
    backgroundColor: Colors.red,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: GoogleFonts.nunito().fontFamily,
    textTheme: textTheme(),
  );
}

TextTheme textTheme() {
  return const TextTheme(
    bodyText1: TextStyle(color: Colors.red),
    bodyText2: TextStyle(color: Colors.black),
  );
}
