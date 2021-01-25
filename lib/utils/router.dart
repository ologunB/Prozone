import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reliance_app/constants/routes.dart';
import 'package:reliance_app/ui/views/layout_screen.dart';
import 'package:reliance_app/ui/views/pro_details_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case MainLayoutView:
      return _getPageRoute(
        routeName: settings.name,
        view: LayoutScreen(),
      );
    case DetailsView:
      return _getPageRoute(
        routeName: settings.name,
        view: ProDetailsScreen(),
      );

    default:
      return Platform.isIOS
          ? CupertinoPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text("No route defined for ${settings.name}"),
                ),
              ),
            )
          : MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text("No route defined for ${settings.name}"),
                ),
              ),
            );
  }
}

PageRoute _getPageRoute({String routeName, Widget view, Object args}) {
  return Platform.isIOS
      ? CupertinoPageRoute(
          settings: RouteSettings(name: routeName, arguments: args), builder: (_) => view)
      : MaterialPageRoute(
          settings: RouteSettings(name: routeName, arguments: args), builder: (_) => view);
}

moveTo(BuildContext context, Widget view, {bool dialog = false}) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => view, fullscreenDialog: dialog));
}
