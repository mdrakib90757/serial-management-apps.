import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/api/serviceCenter_api/roles_service_center/roles_service_center.dart';
import 'package:SerialMan/model/roles_model.dart';

class RolesProvider with ChangeNotifier {
  final RolesApi _rolesApi = RolesApi();

  List<Data> _rolesList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Data> get roles => _rolesList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRoles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _rolesList = await _rolesApi.RolesInfo();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("Failed to load Roles details: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
