import 'package:flutter/material.dart';

import '../../../api/serviceCenter_api/service_center_service_type_service/service_center_service_type_service.dart';
import '../../../request_model/serviceCanter_request/add_service_center_service_type_request/service_center_service_type_request.dart';

class add_service_center_service_type_provider with ChangeNotifier {
  final service_center_service_type_service _repository =
      service_center_service_type_service();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> postServiceType(
    String serviceCenterId,
    add_service_center_service_type_request request,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.add_service_center_service_type(
        serviceCenterId,
        request,
      );
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
