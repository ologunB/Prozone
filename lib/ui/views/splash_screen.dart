import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reliance_app/utils/base_view.dart';
import 'package:reliance_app/utils/spacing.dart';
import 'package:reliance_app/view_models/startup_vm.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<StartUpViewModel>(
      onModelReady: (model) => model.isLoggedIn(),
      builder: (context, model, _) => Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              child: SvgPicture.asset("images/logo.svg",
                  height: screenWidthFraction(context, dividedBy: 3))),
          verticalSpaceMedium,
          Text(
            "ProZone",
            style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      )),
    );
  }
}
