import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reliance_app/ui/views/splash_screen.dart';
import 'package:reliance_app/utils/dialog_manager.dart';
import 'package:reliance_app/utils/dialog_service.dart';
import 'package:reliance_app/utils/navigator.dart';
import 'package:reliance_app/utils/router.dart';

import 'constants/styles.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Styles.colorWhite));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.nunitoTextTheme(
            Theme.of(context).textTheme,
          ),
          primaryColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        builder: (context, child) => Navigator(
              key: locator<DialogService>().dialogNavigationKey,
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => DialogManager(child: child),
              ),
            ),
        navigatorKey: locator<NavigationService>().navigationKey,
        onGenerateRoute: generateRoute);
  }
}
