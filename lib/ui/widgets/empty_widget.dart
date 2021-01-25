import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reliance_app/constants/styles.dart';

class EmptyWidget extends StatelessWidget {
  final String text;

  const EmptyWidget({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.hourglass_empty,
          size: 30,
          color: Styles.appCanvasYellow,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
              fontSize: 16, fontWeight: FontWeight.w600, color: Styles.colorGrey),
        ),
      ],
    ));
  }
}
