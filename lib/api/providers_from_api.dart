import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:reliance_app/constants/messages.dart';
import 'package:reliance_app/model/provider_model.dart';
import 'package:reliance_app/utils/auth_exception.dart';
import 'package:reliance_app/utils/error_util.dart';

import 'base_api.dart';

class ProviderFromApi extends BaseAPI {
  //get all providers states
  Future getAllStatesFromApi() async {
    String token = getIdToken();
    try {
      var res = await dio.get("$baseUrl/states/",
          options: defaultOptions.merge(headers: {'Authorization': 'Bearer $token'}));

      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            List<StatesModel> list = [];
            res.data.forEach((v) {
              list.add(new StatesModel.fromJson(v));
            });
            return list;
          } catch (e) {
            throw new AuthException("Server is currently under maintenance, Try again later");
          }
          break;
        default:
          throw AuthException(res.data["message"]) ?? "Unknown Error";
      }
    } catch (e) {
      throw AuthException(DioErrorUtil.handleError(e));
    }
  }

  //get all providers types
  Future getAllProviderTypesFromApi() async {
    String token = getIdToken();
    try {
      var res = await dio.get("$baseUrl/provider-types/",
          options: defaultOptions.merge(headers: {'Authorization': 'Bearer $token'}));
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            List<ProviderType> list = [];
            res.data.forEach((v) {
              list.add(new ProviderType.fromJson(v));
            });
            return list;
          } catch (e) {
            throw new AuthException("Server is currently under maintenance, Try again later");
          }
          break;
        default:
          throw AuthException(res.data["message"]) ?? "Unknown Error";
      }
    } catch (e) {
      print(e);

      throw AuthException(DioErrorUtil.handleError(e));
    }
  }

  //get all providers
  Future getAllProvidersFromApi() async {
    String token = getIdToken();
    try {
      var res = await dio.get("$baseUrl/providers",
          options: defaultOptions.merge(headers: {'Authorization': 'Bearer $token'}));

      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            List<ProvidersModel> list = [];
            res.data.forEach((v) {
              list.add(new ProvidersModel.fromJson(v));
            });
            return list;
          } catch (e) {
            throw new AuthException("Server is currently under maintenance, Try again later");
          }
          break;
        default:
          throw AuthException(res.data["message"]) ?? "Unknown Error";
      }
    } catch (e) {
      throw AuthException(DioErrorUtil.handleError(e));
    }
  }

  //create a provider
  Future createFromApi(Map data) async {
    String token = getIdToken();
    try {
      var res = await dio.post("$baseUrl/providers",
          data: data, options: defaultOptions.merge(headers: {'Authorization': 'Bearer $token'}));
      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return "Success";
          } catch (e) {
            throw new AuthException("Server is currently under maintenance, Try again later");
          }
          break;
        default:
          throw AuthException(res.data["message"]) ?? "Unknown Error";
      }
    } catch (e) {
      throw AuthException(DioErrorUtil.handleError(e));
    }
  }

  //update all provider fields
  Future updateFromApi(Map data, int id) async {
    String token = getIdToken();
    try {
      var res = await dio.put("$baseUrl/providers/$id",
          data: data, options: defaultOptions.merge(headers: {'Authorization': 'Bearer $token'}));
      print(res.data);

      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return "Success";
          } catch (e) {
            throw new AuthException("Server is currently under maintenance, Try again later");
          }
          break;
        default:
          throw AuthException(res.data["message"]) ?? "Unknown Error";
      }
    } catch (e) {
      throw AuthException(DioErrorUtil.handleError(e));
    }
  }

  //upload image to the server
  Future uploadImage(List<File> images, int id) async {
    String token = getIdToken();

    var formData = FormData();
    if (images == null || images.isEmpty) {
      return;
    }
    for (File image in images) {
      formData.files.add(MapEntry("files",
          MultipartFile.fromFileSync("${image.path}", filename: image.path.split('/').last)));
    }
    //Add all fields to formData
    formData.fields.addAll([
      MapEntry("ref", "provider"),
      MapEntry("field", 'images'),
      MapEntry("refId", id.toString())
    ]);

    try {
      var res = await dio.post("$baseUrl/upload/",
          data: formData,
          options: Options(
              contentType: 'multipart/form-data',
              validateStatus: (status) => status < 500,
              headers: {'Authorization': 'Bearer $token'}));

      switch (res.statusCode) {
        case SERVER_OKAY:
          print("Images Uploaded");

          try {
            return "Success";
          } catch (e) {
            throw new AuthException("Server is currently under maintenance, Try again later");
          }
          break;
        default:
          throw AuthException(res.data["message"]) ?? "Unknown Error";
      }
    } catch (e) {
      throw AuthException(DioErrorUtil.handleError(e));
    }
  }
}
