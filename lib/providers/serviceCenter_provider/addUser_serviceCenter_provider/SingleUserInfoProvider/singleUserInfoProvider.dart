import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceCenter_api/addUser_serviceCenter/addUser_serviceCenter.dart';
import 'package:SerialMan/model/AddUser_serviceCenterModel.dart';

class SingleUserInfoProvider with ChangeNotifier {
  final AddUserServiceCenter _api = AddUserServiceCenter();

  AddUserModel? _userInfo;
  bool _isLoading = false;
  String? _errorMessage;

  AddUserModel? get userInfo => _userInfo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserInfo(String companyId, String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userInfo = await _api.fetchSingleUserInfo(companyId, userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
