import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceCenter_api/statusButton_serviceCenter/status_updateButton_service.dart';
import 'package:SerialMan/request_model/serviceCanter_request/status_UpdateButtonRequest/status_updateButtonRequest.dart';

class statusUpdateButton_provder with ChangeNotifier {
  final StatusUpdateButtonService _statusUpdateButtonService =
      StatusUpdateButtonService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> updateStatus(
    StatusButtonRequest buttonRequest,
    String serviceCenterId,
    String serviceId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _statusUpdateButtonService.statusButton(
        buttonRequest,
        serviceCenterId,
        serviceId,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      final errorMessageString = e.toString();
      if (errorMessageString.contains("No Content")) {
        print("Received 204 No Content. Treating as success.");
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = errorMessageString.replaceAll("Exception: ", "").trim();
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }
  }
}
