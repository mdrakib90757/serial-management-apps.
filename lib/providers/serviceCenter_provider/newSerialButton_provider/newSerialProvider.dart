import 'package:flutter/material.dart';
import 'package:SerialMan/api/serviceCenter_api/newSerialButton_servicecenter/newSerialButton.dart';
import 'package:SerialMan/request_model/serviceCanter_request/newSerialButton_request/newSerialButton_request.dart';

class NewSerialButtonProvider with ChangeNotifier {
  final NewSerialButtonService _newSerialButtonService =
      NewSerialButtonService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> SerialButton(
    NewSerialButtonRequest request,
    String serviceCenterId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _newSerialButtonService.NewSerialButton(request, serviceCenterId);
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

//
