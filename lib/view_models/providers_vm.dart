import 'package:reliance_app/api/providers_from_api.dart';
import 'package:reliance_app/model/provider_model.dart';
import 'package:reliance_app/utils/auth_exception.dart';

import '../locator.dart';
import 'base_vm.dart';
import 'dart:io';

class ProvidersViewModel extends BaseModel {
  final ProviderFromApi _providerFromApi = locator<ProviderFromApi>();
  List<ProvidersModel> providersList;
  ProvidersModel providerData;
  String error;

  Future getOneProvider(int id) async {
    setBusy(true);
    try {
      var result = await _providerFromApi.getOneFromApi(id);
      if (result is ProvidersModel) {
        providerData = result;
        setBusy(false);
        notifyListeners();
      }
    } on AuthException catch (e) {
      setBusy(false);
      error = e.message;
       await dialog.showDialog(title: "Error!", description: e.message, buttonTitle: "Close");
      notifyListeners();
    }
  }

  Future getAllProviders() async {
    setBusy(true);
    try {
      var result = await _providerFromApi.getAllFromApi();
      if (result is List) {
        providersList = result;
        setBusy(false);
        notifyListeners();
      }
    } on AuthException catch (e) {
      setBusy(false);
      error = e.message;
    //  await dialog.showDialog(title: "Error!", description: e.message, buttonTitle: "Close");
      notifyListeners();
    }
  }

  Future createProvider(Map data) async {
    setBusy(true);
    try {
      var result = await _providerFromApi.createFromApi(data);
      if (result == "Success") {
        setBusy(false);
        await dialog.showDialog(
            title: "Success", description: "Provider has been created!", buttonTitle: "Close");
        notifyListeners();
        return "Success";
      }
    } on AuthException catch (e) {
      setBusy(false);
      await dialog.showDialog(title: "Error!", description: e.message, buttonTitle: "Close");
      notifyListeners();
    }
  }

  Future updateDetails(Map data, List<File> selectedPictures, int id) async {
    setBusy(true);

    try {
      //if no image , then proceed to update the text fields
      if (selectedPictures.isEmpty) {
        var updateResult = await _providerFromApi.updateFromApi(data, id);
        if (updateResult == "Success") {
          setBusy(false);
          notifyListeners();
          await dialog.showDialog(
              title: "Success", description: "The details have been updated", buttonTitle: "Close");
          return "Success";
        }
      } else {
        //if image is true, then proceed to upload the images first

        var imageResult = await _providerFromApi.uploadImage(selectedPictures, id);
        if (imageResult == "Success") {
          // if upload is success, then proceed to update the texts
          try {
            var updateResult = await _providerFromApi.updateFromApi(data, id);
            if (updateResult == "Success") {
              setBusy(false);
              notifyListeners();
              await dialog.showDialog(
                  title: "Success",
                  description: "The details have been updated",
                  buttonTitle: "Close");
              return "Success";
            }
          } on AuthException catch (e) {
            //  update the texts fails

            setBusy(false);
            await dialog.showDialog(title: "Error!", description: e.message, buttonTitle: "Close");
            notifyListeners();
          }
        }
      }
    } on AuthException catch (e) {
      setBusy(false);
      await dialog.showDialog(title: "Error!", description: e.message, buttonTitle: "Close");
      notifyListeners();
    }
  }
}
