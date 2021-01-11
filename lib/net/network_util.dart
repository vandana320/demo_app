import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:demo_app/util/CommonUtil.dart';
import 'package:demo_app/util/SessionManager.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;
  ///
  /// send POST request
  ///
  Future<Map<String, dynamic>> post(String methodName,
      {Map<String, dynamic> body}) async {
    String url = CommonUtil.baseUrl + methodName;
    body = await setCommonParam(body);
    String headers;
    if (await new SessionManager().isLoginUser()) {
      headers = await _getBasicAuthorizationString();
    }
    return http.post(url, body: json.encode(body), headers: {
      "Content-Type": "application/json",
      'authorization': headers
    }).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        print(
            "Post request '$methodName' fail with status code $statusCode and response $res ");
        throw new Exception("Error while fetching data");
      }
      print('thre POST response of api $methodName is : $res');
      return json.decode(res);
    });
  }

  Future<String> _getBasicAuthorizationString() async {
    String username = await new SessionManager().getLoginUserEmail();
    String loginToken = "some api token";
    if (loginToken != null) {
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$loginToken'));
      print(basicAuth);
      return basicAuth;
    }
    return null;
  }

  Future<Map<String, dynamic>> setCommonParam(Map<String, dynamic> body) async {
    String userID = await SessionManager().getLoginUserEmail();
    if (await new SessionManager().isLoginUser()) {
      body["companyID"] = userID;
    }
    return body;
  }
}
