import 'package:dio/dio.dart';

class BaseAPI {
  var dio = Dio();
  String baseUrl = "https://pro-zone.herokuapp.com";
  Options defaultOptions =
      Options(contentType: 'application/json', validateStatus: (status) => status < 500);

  getIdToken() {
    String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEwNzI4MjAzLCJleHAiOjE2MTMzMjAyMDN9.7TKlfBKkf8jw9FPjo91z7gQxvLB21ycXphEkH6-_Cc0";
    return token;
  }
}
