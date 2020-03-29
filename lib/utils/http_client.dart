import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:oyster/auth.dart';

class ApiResult {
  dynamic body;
  Map<String, String> header;

  ApiResult(dynamic body, dynamic header) {
    this.body = body;
    this.header = header;
  }
}

class HttpClient {
  // next three lines makes this class a Singleton
  static HttpClient _instance = new HttpClient.internal();
  HttpClient.internal();
  factory HttpClient() => _instance;

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

  Future<dynamic> deleteByAuth(String url) {
    final token = _authStateProvider.getAuthToken();
    return http.delete(url, headers: {"Authorization": token}).then(
        (http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode == 401) {
        _authStateProvider.logout();
      }

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
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

      if (statusCode == 401) {
        // TODO 如果不是登陆请求就不用提示这个，提示重新登陆
        throw new Exception("username or passowrd incorrectly");
      }
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return new ApiResult(
          res.isEmpty ? null : _decoder.convert(res), response.headers);
    });
  }
}
