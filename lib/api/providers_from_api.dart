import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:reliance_app/constants/messages.dart';
import 'package:reliance_app/model/provider_model.dart';
import 'package:reliance_app/utils/auth_exception.dart';
import 'package:reliance_app/utils/error_util.dart';
import 'base_api.dart';

class ProviderFromApi extends BaseAPI {
  Future getOneFromApi(int id) async {
    String token = getIdToken();
    try {
      var res = await dio.get("$baseUrl/providers/$id",
          options: defaultOptions.merge(headers: {'Authorization': 'Bearer $token'}));

      switch (res.statusCode) {
        case SERVER_OKAY:
          try {
            return ProvidersModel.fromJson(res.data);
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

  Future getAllFromApi() async {
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

  Future createFromApi(Map data) async {
    String token = getIdToken();
    try {
      var res = await dio.post("$baseUrl/providers",
          data: data, options: defaultOptions.merge(headers: {'Authorization': 'Bearer $token'}));
      print(res.statusCode);
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

  Future updateFromApi(Map data, int id) async {
    String token = getIdToken();
    try {
      var res = await dio.put("$baseUrl/providers/$id",
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

  Future uploadImage(List<File> images, int id) async {
    var data = [];
    images.forEach((element) {
      String fileName = element.path.split('/').last;
      data.add(MultipartFile.fromFile(element.path, filename: fileName));
    });
    String token = getIdToken();
    FormData formData = FormData.fromMap(
        {"ref": "provider", "field": "images", "refId": id.toString(), "files": data});
    try {
      var res = await dio.post("$baseUrl/upload/",
          data: formData,
          options: Options(
              contentType: 'multipart/form-data',
              validateStatus: (status) => status < 500,
              headers: {'Authorization': 'Bearer $token'}));

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
}
