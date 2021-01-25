import 'package:reliance_app/constants/routes.dart';

import 'base_vm.dart';

class StartUpViewModel extends BaseModel {
  Future<void> isLoggedIn() async {
    Future.delayed(Duration(seconds: 3))
        .then((value) => navigate.navigateToReplacing(MainLayoutView));
    notifyListeners();
  }
}
