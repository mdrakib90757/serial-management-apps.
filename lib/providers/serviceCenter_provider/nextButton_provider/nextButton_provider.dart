import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceCenter_api/nextButton_serviceCenter/nextButton_service.dart';
import 'package:SerialMan/request_model/serviceCanter_request/next_button_request/next_button_request.dart';

class nextButtonProvider with ChangeNotifier {
  final NextButtonService _nextButtonService = NextButtonService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _serviceData;
  Map<String, dynamic>? get serviceData => _serviceData;

  Future<bool> NextButton(
    NextButtonRequest request,
    String serviceCenterId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    _serviceData = null;
    notifyListeners();

    try {
      await _nextButtonService.nextButton(serviceCenterId, request);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      final errorMessageString = e.toString();

      if (errorMessageString.contains("No Content")) {
        print(" Received 204 No Content. Treating as success.");
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
