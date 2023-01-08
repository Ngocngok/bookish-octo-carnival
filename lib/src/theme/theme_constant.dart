import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData mainTheme() {
  return ThemeData(primarySwatch: Colors.teal,
    brightness: Brightness.light,
    primaryColor: Colors.lightBlue[800],
    backgroundColor: Colors.red,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: GoogleFonts.nunito().fontFamily,
    textTheme: textTheme(),
  );
}

TextTheme textTheme() {
  return const TextTheme(
    // bodyText1: TextStyle(color: Colors.red),
    // bodyText2: TextStyle(color: Colors.black),
    // headline1: TextStyle(color: Colors.amber),
    displaySmall: TextStyle(color: Colors.amber),
  );
}
