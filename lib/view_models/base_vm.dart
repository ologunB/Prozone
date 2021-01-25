import 'package:flutter/material.dart';
import 'package:reliance_app/utils/dialog_service.dart';
import 'package:reliance_app/utils/navigator.dart';

import '../locator.dart';

class BaseModel extends ChangeNotifier {
  bool _busy = false;

  bool get busy => _busy;

  DialogService dialog = locator<DialogService>();
  NavigationService navigate = locator<NavigationService>();

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
