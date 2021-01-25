import 'package:get_it/get_it.dart';

import 'package:reliance_app/utils/dialog_service.dart';
import 'package:reliance_app/utils/navigator.dart';
import 'package:reliance_app/view_models/providers_vm.dart';
import 'package:reliance_app/view_models/startup_vm.dart';

import 'api/providers_from_api.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerFactory(() => StartUpViewModel());

  locator.registerLazySingleton(() => ProviderFromApi());
  locator.registerFactory(() => ProvidersViewModel());
}
