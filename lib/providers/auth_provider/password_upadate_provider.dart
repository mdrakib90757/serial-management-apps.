import 'package:flutter/cupertino.dart';
import 'package:SerialMan/api/auth_api/password_api.dart';
import 'package:SerialMan/request_model/auth_request/update_password_request.dart';

class PasswordUpdateProvider with ChangeNotifier {
  PasswordApi passwordApi = PasswordApi();

  String? _token;
  String? get Token => _token;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool isLoading = false;

  Future<bool> fetchUpdatePassword(
    UpdatePasswordRequest PasswordRequest,
  ) async {
    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await passwordApi.updatePassWord(PasswordRequest);

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "").trim();

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
