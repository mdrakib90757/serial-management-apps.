import 'dart:convert';
import '../../core/api_client.dart';
import '../../request_model/auth_request/update_password_request.dart';

class PasswordApi {
  //Password Api
  Future<dynamic> updatePassWord(UpdatePasswordRequest passwordRequest) async {
    String body = jsonEncode(passwordRequest.toJson());
    final response = await ApiClient().post("/me/password", body: body);
    return response;
  }
}
