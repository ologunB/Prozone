import 'package:reliance_app/model/provider_model.dart';

List<StatesModel> nigeriaStates;
List<ProviderType> allProviderTypes;

String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning';
  }
  if (hour < 17) {
    return 'Good Afternoon';
  }
  return 'Good Evening';
}

String plurals(String val) {
  if (val == "All") {
    return "Providers";
  } else if (val == "Pharmacy") {
    return "Pharmacies";
  } else if (val == "Laboratory") {
    return "Laboratories";
  }
  return val + "s";
}
