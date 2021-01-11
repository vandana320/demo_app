import 'dart:async';
import 'dart:io';
import 'package:demo_app/model/LoginResponse.dart';
import 'package:demo_app/model/ServerResponse.dart';
import 'package:demo_app/net/network_util.dart';

class RestServerApi {
  NetworkUtil _netUtil = new NetworkUtil();

  void _setStatusMessageFromJson(
      ServerResponse serverResponse, Map<String, dynamic> res) {
    serverResponse.Message = res["message"];
    serverResponse.Status = res["status"];
  }

  Future<ServerResponse<LoginResponse>> login(
      String methodName, String email, String password) async {
    var param = {
      "username": email,
      "password": password,
    };
    return _loginApi(methodName, param);
  }

  Future<ServerResponse<LoginResponse>> _loginApi(
      String methodName, dynamic request) async {
    ServerResponse<LoginResponse> serverResponse =
        new ServerResponse<LoginResponse>();
    request['deviceName'] = Platform.isIOS ? 'iOS' : 'Android';
    Map<String, dynamic> res = await _netUtil.post(methodName, body: request);
    _setStatusMessageFromJson(serverResponse, res);
    Map<String, dynamic> data = res["data"];
    if (data != null) {
      LoginResponse user = LoginResponse.fromJson(data);
      serverResponse.Data = user;
    }
    return serverResponse;
  }
}
