// providers/profile_update_provider.dart
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:SerialMan/request_model/serviceCanter_request/update_service_center_service_type_request/update_service_center_service_type_request.dart';

import '../../../api/serviceCenter_api/service_center_service_type_service/service_center_service_type_service.dart';
import '../../../core/api_client.dart';

class UpdateServiceCenterServiceTypeProvider with ChangeNotifier {
  final service_center_service_type_service
  _service_center_service_type_service = service_center_service_type_service();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Your method to call the API
  Future<bool> update_service_center_service_typ(
    update_service_center_service_type_request requestData,
    String serviceCenterId,
  ) async {
    _isLoading = true;
    _errorMessage = null; // Clear previous errors
    notifyListeners();

    try {
      await _service_center_service_type_service
          .update_service_center_service_type_service(
            requestData,
            serviceCenterId,
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
