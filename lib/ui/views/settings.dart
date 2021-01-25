import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reliance_app/constants/styles.dart';
import 'package:reliance_app/utils/spacing.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Settings",
            style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 2),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("images/building.svg",
                  height: screenWidthFraction(context, dividedBy: 4)),
              verticalSpaceMedium,
              Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Styles.colorBlue)),
                  child: Text(
                    "WE WILL GO LIVE SOON ENOUGH",
                    style: GoogleFonts.nunito(
                        fontSize: 14, color: Styles.colorBlue, fontWeight: FontWeight.w600),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
