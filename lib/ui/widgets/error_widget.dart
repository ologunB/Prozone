import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reliance_app/constants/styles.dart';
import 'package:reliance_app/utils/spacing.dart';

class ErrorOccurredWidget extends StatelessWidget {
  final String error;

  const ErrorOccurredWidget({Key key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error,
          size: 40,
          color: Styles.appCanvasYellow,
        ),
        verticalSpaceSmall,
        Text(error ?? "An error occurred",
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
                fontSize: 16, fontWeight: FontWeight.bold, color: Styles.appCanvasYellow)),
      ],
    ));
  }
}
