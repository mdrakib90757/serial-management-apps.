import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceCenter_api/addUser_serviceCenter/addUser_serviceCenter.dart';
import 'package:SerialMan/request_model/serviceCanter_request/addUser_serviceCenterRequest/addUser_ServiceCenter_request.dart';

class AddUserServiceCenterProvider with ChangeNotifier {
  final AddUserServiceCenter _addUserServiceCenter = AddUserServiceCenter();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> addUserButtonProvider(
    AddUserRequest userRequest,
    String companyId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _addUserServiceCenter.AddUserButton(userRequest, companyId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "").trim();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
