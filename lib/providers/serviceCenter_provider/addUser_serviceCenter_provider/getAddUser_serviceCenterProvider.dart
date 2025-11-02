import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceCenter_api/addUser_serviceCenter/addUser_serviceCenter.dart';
import 'package:SerialMan/model/AddUser_serviceCenterModel.dart';

class GetAdduserServiceCenterProvider with ChangeNotifier {
  final AddUserServiceCenter _addUserServiceCenter = AddUserServiceCenter();

  List<AddUserModel> _users = [];
  List<AddUserModel> get users => _users;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers(String companyId) async {
    _users = await _addUserServiceCenter.fetchAddUser(companyId);
    notifyListeners();
  }
}
