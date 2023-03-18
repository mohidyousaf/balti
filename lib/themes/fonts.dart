import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont {
  // Logo

  static TextStyle logo(color) => GoogleFonts.getFont('Bubblegum Sans',
      fontSize: 30, color: color, fontWeight: FontWeight.w200);
  // Headings
  static TextStyle h1(color) => TextStyle(
        color: color,
        fontFamily: 'Roboto',
        fontSize: 96,
        letterSpacing: -1.5,
        fontWeight: FontWeight.w300,
      );
  static TextStyle h2(color) => TextStyle(
        color: color,
        fontFamily: 'Roboto',
        fontSize: 60,
        letterSpacing: -0.5,
        fontWeight: FontWeight.w300,
      );
  static TextStyle h3(color) => TextStyle(
        color: color,
        fontFamily: 'Roboto',
        fontSize: 50,
        letterSpacing: 0.25,
        fontWeight: FontWeight.normal,
      );
  static TextStyle h4(color) => TextStyle(
        color: color,
        fontFamily: 'Lato',
        fontSize: 30,
        letterSpacing: 0.75,
        fontWeight: FontWeight.normal,
      );
  static TextStyle h4Light(color) => TextStyle(
        color: color,
        fontFamily: 'Lato',
        fontSize: 30,
        letterSpacing: 0.75,
        fontWeight: FontWeight.w300,
      );
  static TextStyle h5(color) => TextStyle(
        color: color,
        fontFamily: 'Lato',
        fontSize: 24,
        letterSpacing: 0.75,
        fontWeight: FontWeight.normal,
      );

  // Body
  static TextStyle bodySmall(color) => TextStyle(
        color: color,
        fontFamily: 'Lato',
        fontSize: 15,
        letterSpacing: 0.5,
        fontWeight: FontWeight.normal,
      );
  static TextStyle bodyLarge(color) => TextStyle(
        color: color,
        fontFamily: 'Lato',
        fontSize: 20,
        letterSpacing: 0.5,
        fontWeight: FontWeight.normal,
      );

  // Others
  static TextStyle subtitle(color) => TextStyle(
        color: color,
        fontFamily: 'Lato',
        fontSize: 16,
        letterSpacing: 0.15,
        fontWeight: FontWeight.normal,
      );
  static TextStyle caption(color) => TextStyle(
        color: color,
        fontFamily: 'Lato',
        fontSize: 12,
        letterSpacing: 0.4,
        fontWeight: FontWeight.normal,
      );
  static TextStyle button(color) => TextStyle(
        color: color,
        fontFamily: 'Lato',
        fontSize: 15,
        letterSpacing: 1.25,
        fontWeight: FontWeight.w500,
      );
  static TextStyle overLine(color) => TextStyle(
        color: color,
        fontFamily: 'Lato',
        fontSize: 10,
        letterSpacing: 1.5,
        fontWeight: FontWeight.normal,
      );
}
