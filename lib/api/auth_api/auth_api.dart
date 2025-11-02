import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:SerialMan/core/api_client.dart';
import 'package:SerialMan/model/user_model.dart';
import 'package:SerialMan/request_model/auth_request/register_requset.dart';
import 'package:SerialMan/request_model/auth_request/serviceTaker_register.dart';
import 'package:SerialMan/request_model/auth_request/update_password_request.dart';
import '../../request_model/auth_request/login_request.dart';

class AuthApi {
  //Login
  Future<dynamic> login(LoginRequest requestData) async {
    String body = jsonEncode(requestData.toJson());
    final response = await ApiClient().post("/auth/login", body: body);
    return response;
  }

  //register
  Future<dynamic> register(RegisterRequest requestData) async {
    String body = jsonEncode(requestData.toJson());
    final response = await ApiClient().post(
      "/serial-no/register-service-center",
      body: body,
    );
    return response;
  }

  //serviceTakerRegister
  Future<dynamic> serviceTakerRegister(ServiceTakerRequest requestData) async {
    String body = jsonEncode(requestData.toJson());
    final response = await ApiClient().post(
      "/serial-no/register-service-taker",
      body: body,
    );
    return response;
  }

  //BusinessType
  Future<List<Businesstype>> fetchBusinessType() async {
    try {
      var response = await ApiClient().get("/business-types") as List;
      List<Businesstype> types = response
          .map((item) => Businesstype.fromJson(item as Map<String, dynamic>))
          .toList();

      return types;
    } catch (e) {
      print("Error fetching or parsing business types: $e");
      return [];
    }
  }
}
