import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceCenter_api/addUser_serviceCenter/addUser_serviceCenter.dart';

import '../../../api/serviceCenter_api/service_center_service_type_service/service_center_service_type_service.dart';

class DeleteServiceTypeServiceTypeProvider with ChangeNotifier {
  final service_center_service_type_service _serviceCenter_servicetype =
      service_center_service_type_service();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> delete_ServiceCenter_serviceType(
    String serviceCenterId,
    String serviceTypeId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _serviceCenter_servicetype.deleteServiceCenter_serviceType(
        serviceCenterId,
        serviceTypeId,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
