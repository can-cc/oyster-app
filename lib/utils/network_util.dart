import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:osyter_app/auth.dart';

class ApiResult {
  dynamic body;
  Map<String, String> header;

  ApiResult(dynamic body, dynamic header) {
    this.body = body;
    this.header = header;
  }
}

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();
  final _authStateProvider = new AuthStateProvider();

  Future<dynamic> get(String url) {
    return http.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> getByAuth(String url) {
    final token = _authStateProvider.getAuthToken();
    return http.get(url, headers: {"Authorization": token}).then(
        (http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode == 401) {
        _authStateProvider.logout();
      }

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<ApiResult> postByAuth(String url, {Map body}) {
    final token = _authStateProvider.getAuthToken();
    return http.post(url, body: json.encode(body), headers: {
      "content-type": "application/json; charset=utf-8",
      "Authorization": token
    }).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return new ApiResult(
          res.isEmpty ? null : _decoder.convert(res), response.headers);
    });
  }
}
