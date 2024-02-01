import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String? WeatherType;
String? WeatherDescription;
double? degree;
// COLORS

Color mainColor = const Color(0xff22092C);

// TEXTSTYLES

TextStyle buttonFontstyle =
    GoogleFonts.nunito(color: Colors.white, fontSize: 20);
TextStyle timetextStyle(Color color) {
  return GoogleFonts.nunito(
      fontSize: 20, color: color, fontWeight: FontWeight.bold);
}
