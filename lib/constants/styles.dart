import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static Color appCanvasYellow = Color(0xffFFA400);
  static Color appCanvasGreen = Color(0xff024F24);
  static Color colorWhite = Colors.white;
  static Color colorBlack = Color(0xff222222);
  static Color colorBlue = Color(0xff5354FE);
  static Color colorPurple = Color(0xff082485);
  static Color colorGrey = Color(0xff797979);
  static Color errorColor = Colors.red;

  static InputDecoration inputDec1 = InputDecoration(
    contentPadding: EdgeInsets.all(8),
    fillColor: Styles.colorGrey.withOpacity(0.05),
    filled: true,
    labelStyle:
        GoogleFonts.nunito(color: Styles.colorGrey, fontWeight: FontWeight.w600, fontSize: 16),
    errorStyle: TextStyle(
      color: Color(0xff222222),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff082485), width: 1.7),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Styles.colorBlack.withOpacity(0.2), width: 2),
    ),
    border: OutlineInputBorder(),
    counterText: '',
  );
}
